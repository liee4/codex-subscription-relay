import { createWriteStream, mkdirSync } from "node:fs";
import { pipeline } from "node:stream/promises";
import { Readable } from "node:stream";

const version = "1.104.5";
const filename = process.argv[2] ?? `tailscale-setup-full-${version}.exe`;
if (!new RegExp(`^tailscale-setup-(?:full-)?${version}(?:-amd64\\.msi|\\.exe)$`).test(filename)) {
  throw new Error("Unexpected installer filename.");
}
const url = `https://pkgs.tailscale.com/stable/${filename}`;
mkdirSync(new URL("tools/", import.meta.url), { recursive: true });
const response = await fetch(url);
if (!response.ok || !response.body) {
  throw new Error(`Download failed: HTTP ${response.status}`);
}
await pipeline(Readable.fromWeb(response.body), createWriteStream(new URL(`tools/${filename}`, import.meta.url)));
console.log(`Downloaded ${filename}; verify its Windows signature before installing.`);
