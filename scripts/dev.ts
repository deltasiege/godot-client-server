import { $ } from "bun";
import { getOSData } from ".";
import { resolve } from "path";

// Starts a number of clients and a server simultaneously

const numClients = parseInt(Bun.argv[2]) || 1;
const { projectDir, binaryPath } = getOSData(Bun.argv[3]);
const clientDir = resolve(`${projectDir}/client/src`);
const serverDir = resolve(`${projectDir}/server/src`);

// Clients - https://bun.sh/docs/api/spawn
for (let i = 0; i < numClients; i++) {
  Bun.spawn([binaryPath, "--path", clientDir]);
}

// Server - https://bun.sh/docs/runtime/shell
await $`${binaryPath} --path ${serverDir} --headless`.nothrow();
