import { randomBytes } from "node:crypto";
import { existsSync, mkdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = dirname(fileURLToPath(import.meta.url));
const configPath = join(root, "config.yaml");
const keyPath = join(root, "api-key.txt");
if (existsSync(configPath) || existsSync(keyPath)) {
  throw new Error("Existing configuration found; refusing to replace it.");
}

const authDir = join(root, "auths").replaceAll("\\", "/");
const apiKey = `sk-${randomBytes(32).toString("hex")}`;
mkdirSync(join(root, "auths"), { recursive: true });
mkdirSync(join(root, "logs"), { recursive: true });

writeFileSync(configPath, `config-version: 8
server:
  host: "127.0.0.1"
  port: 8317
management:
  allow-remote: false
  secret-key: ""
  disable-control-panel: true
access:
  api-keys:
    - "${apiKey}"
oauth:
  auth-dir: "${authDir}"
`, { mode: 0o600, flag: "wx" });
writeFileSync(keyPath, `${apiKey}\n`, { mode: 0o600, flag: "wx" });
console.log("Created config.yaml and api-key.txt. Keep both private.");
