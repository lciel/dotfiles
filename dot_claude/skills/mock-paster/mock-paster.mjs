#!/usr/bin/env node
// Mock Paster CLI — uploads an HTML mock and prints its shareable URL.
// Auth is browser-based (Google login via the web app); a per-user token is
// cached at ~/.config/mock-paster/token. No manual token handling.
//
// Usage:
//   node mock-paster.mjs login
//   node mock-paster.mjs upload <file.html|file.zip> [title...]
//   node mock-paster.mjs update <slug> <file.html|file.zip> [title...]
//
// Env:
//   MOCK_PASTER_URL  override the site (default: production). For local dev set
//                    MOCK_PASTER_URL=http://localhost:3000

import { createServer } from "node:http";
import { readFile, writeFile, mkdir } from "node:fs/promises";
import { homedir, platform } from "node:os";
import { join, basename, extname } from "node:path";
import { randomBytes } from "node:crypto";
import { spawn } from "node:child_process";

const SITE = (
  process.env.MOCK_PASTER_URL || "https://timetree-mock-paster.vercel.app"
).replace(/\/+$/, "");
const CONFIG_DIR = join(homedir(), ".config", "mock-paster");
const TOKEN_FILE = join(CONFIG_DIR, "token");

const MIME = {
  html: "text/html; charset=utf-8",
  htm: "text/html; charset=utf-8",
  zip: "application/zip",
};

async function loadToken() {
  try {
    const t = (await readFile(TOKEN_FILE, "utf8")).trim();
    return t || null;
  } catch {
    return null;
  }
}

async function saveToken(token) {
  await mkdir(CONFIG_DIR, { recursive: true });
  await writeFile(TOKEN_FILE, token + "\n", { mode: 0o600 });
}

function openBrowser(url) {
  const p = platform();
  const [cmd, args] =
    p === "darwin"
      ? ["open", [url]]
      : p === "win32"
        ? ["cmd", ["/c", "start", "", url]]
        : ["xdg-open", [url]];
  try {
    spawn(cmd, args, { stdio: "ignore", detached: true }).unref();
  } catch {
    /* user can open the URL manually */
  }
}

function login() {
  return new Promise((resolve, reject) => {
    const state = randomBytes(16).toString("hex");
    const server = createServer((req, res) => {
      const u = new URL(req.url, "http://localhost");
      const token = u.searchParams.get("token");
      const st = u.searchParams.get("state");
      res.setHeader("content-type", "text/html; charset=utf-8");
      if (token && st === state) {
        res.end(
          "<html><body style='font-family:sans-serif;text-align:center;padding:3rem'>" +
            "<h2>ログイン完了</h2><p>このタブを閉じてターミナルに戻ってください。</p></body></html>"
        );
        server.close();
        resolve(token);
      } else {
        res.statusCode = 400;
        res.end("<html><body>Invalid callback</body></html>");
      }
    });
    server.listen(0, "127.0.0.1", () => {
      const { port } = server.address();
      const url = `${SITE}/cli-login?port=${port}&state=${state}`;
      process.stderr.write(`\nブラウザでログインしてください:\n${url}\n\n`);
      openBrowser(url);
    });
    setTimeout(
      () => {
        server.close();
        reject(new Error("ログインがタイムアウトしました"));
      },
      3 * 60 * 1000
    );
  });
}

async function ensureToken(forceLogin = false) {
  if (!forceLogin) {
    const existing = await loadToken();
    if (existing) return existing;
  }
  const token = await login();
  await saveToken(token);
  return token;
}

function apiPost(path, token, body) {
  return fetch(`${SITE}${path}`, {
    method: "POST",
    headers: {
      authorization: `Bearer ${token}`,
      "content-type": "application/json",
    },
    body: JSON.stringify(body),
  });
}

// Upload `file` as a new mock, or overwrite an existing one when `slug` is set
// (the server verifies you own that slug). Returns the shareable URL.
async function upload(file, title, slug) {
  let token = await ensureToken();
  const filename = basename(file);
  const ext = extname(filename).slice(1).toLowerCase();
  const data = await readFile(file);

  // 1) signed URL (retry once after re-login if the token was revoked)
  let signRes = await apiPost("/api/upload/sign-raw", token, { filename });
  if (signRes.status === 401) {
    token = await ensureToken(true);
    signRes = await apiPost("/api/upload/sign-raw", token, { filename });
  }
  const sign = await signRes.json();
  if (!sign.ok) throw new Error(sign.error || "署名付き URL の取得に失敗");

  // 2) PUT the raw file straight to Supabase Storage
  const putRes = await fetch(sign.signedUrl, {
    method: "PUT",
    headers: {
      "content-type": MIME[ext] || "application/octet-stream",
      "cache-control": "max-age=3600",
      "x-upsert": "false",
    },
    body: data,
  });
  if (!putRes.ok) {
    throw new Error(`ストレージへのアップロード失敗: ${putRes.status}`);
  }

  // 3) finalize (server extracts + registers it)
  const finRes = await apiPost("/api/upload", token, {
    rawKey: sign.key,
    filename,
    title,
    slug,
  });
  const fin = await finRes.json();
  if (!fin.ok) throw new Error(fin.error || "アップロードに失敗");
  return fin.url;
}

const [cmd, ...rest] = process.argv.slice(2);
try {
  if (cmd === "login") {
    await ensureToken(true);
    process.stdout.write("ログインしました。\n");
  } else if (cmd === "upload") {
    const file = rest[0];
    if (!file) throw new Error("usage: upload <file> [title]");
    const title = rest.slice(1).join(" ") || undefined;
    const url = await upload(file, title);
    process.stdout.write(url + "\n");
  } else if (cmd === "update") {
    const slug = rest[0];
    const file = rest[1];
    if (!slug || !file) throw new Error("usage: update <slug> <file> [title]");
    const title = rest.slice(2).join(" ") || undefined;
    const url = await upload(file, title, slug);
    process.stdout.write(url + "\n");
  } else {
    process.stderr.write(
      "usage: mock-paster.mjs login | upload <file> [title] | update <slug> <file> [title]\n"
    );
    process.exit(2);
  }
} catch (e) {
  process.stderr.write(`error: ${e.message}\n`);
  process.exit(1);
}
