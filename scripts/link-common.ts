import { symlink } from "node:fs";
import { readdir } from "node:fs/promises";
import { resolve } from "path";
import { mkdir } from "node:fs/promises";
import { getOSData } from ".";

// Creates symbolic links in /project/src/common directories pointing to /common

const { projectDir } = getOSData(Bun.argv[3]);
const clientDir = resolve(`${projectDir}/client/src`);
const serverDir = resolve(`${projectDir}/server/src`);
const targetCommon = resolve(`${projectDir}/common/common`);
const targetAddons = resolve(`${projectDir}/common/addons`);
const addonDirs = await readdir(targetAddons);

const clientAddonsDir = resolve(clientDir, "addons");
const serverAddonsDir = resolve(serverDir, "addons");
await mkdir(clientAddonsDir, { recursive: true });
await mkdir(serverAddonsDir, { recursive: true });

async function createSymlink(from: string, to: string) {
  console.log("Creating symlink from", from, "to", to);
  await symlink(from, to, "dir", () => {});
}

const promises = [
  createSymlink(targetCommon, resolve(clientDir, "common")),
  createSymlink(targetCommon, resolve(serverDir, "common")),
  ...addonDirs.map((addon) =>
    createSymlink(
      resolve(targetAddons, addon),
      resolve(clientDir, "addons", addon)
    )
  ),
  ...addonDirs.map((addon) =>
    createSymlink(
      resolve(targetAddons, addon),
      resolve(serverDir, "addons", addon)
    )
  ),
];

await Promise.all(promises);
