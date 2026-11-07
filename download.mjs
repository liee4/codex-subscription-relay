import { createHash } from "node:crypto";
import { createWriteStream } from "node:fs";
import { pipeline } from "node:stream/promises";
import { Readable } from "node:stream";

const version = "8.0.59";
const filename = `CLIProxyAPI_${version}_windows_amd64.zip`;
const expectedSha256 = "5b8ea21e119c9d5cc746abe82a4a3fe65543946c5ef1f5ee12554a3b21bd5099";
const url = `https://github.com/router-for-me/CLIProxyAPI/releases/download/v${version}/${filename}`;

const response = await fetch(url);
if (!response.ok || !response.body) {
  throw new Error(`Download failed: HTTP ${response.status}`);
}

const hash = createHash("sha256");
const stream = Readable.fromWeb(response.body);
stream.on("data", (chunk) => hash.update(chunk));
await pipeline(stream, createWriteStream(new URL(filename, import.meta.url)));

const actualSha256 = hash.digest("hex");
if (actualSha256 !== expectedSha256) {
  throw new Error(`SHA-256 mismatch: ${actualSha256}`);
}

console.log(`${filename}: SHA-256 OK`);
