import { $ } from "bun";
import { getOSData } from ".";
import { resolve, dirname } from "path";
import { mkdir } from "fs/promises";

// Builds client and server projects for chosen platforms

type ProjectChoice = "client" | "server" | "web" | "all";
const project: ProjectChoice = (Bun.argv[2] || "all") as ProjectChoice;

const {
  projectDir,
  binaryPath,
  buildPreset,
  extension: ext,
} = getOSData(Bun.argv[3]);

const clientDir = resolve(projectDir, "client");
const clientSrc = resolve(clientDir, "src");
const clientOut = resolve(clientDir, "dist", buildPreset, `DeltaSiege.${ext}`);

const serverDir = resolve(projectDir, "server");
const serverSrc = resolve(serverDir, "src");
const serverOut = resolve(serverDir, "dist", buildPreset, `DeltaSiege.${ext}`);

const webOut = resolve(clientDir, "dist/web/DeltaSiege");

async function build(
  srcPath: string,
  outPath: string,
  preset: string = buildPreset
) {
  console.log(`-> Exporting to ${outPath}`);
  await mkdir(dirname(outPath), { recursive: true });
  await $`${binaryPath} --path ${srcPath} --export-release ${preset} ${outPath} --windowed --resolution 64x64 --position 0,0`.nothrow();
}

const promises =
  project === "all"
    ? [
        build(clientSrc, clientOut),
        build(serverSrc, serverOut),
        build(clientSrc, webOut, "web"),
      ]
    : project === "client"
    ? [build(clientSrc, clientOut)]
    : project === "server"
    ? [build(serverSrc, serverOut)]
    : project === "web"
    ? [build(clientSrc, webOut, "web")]
    : [];

await Promise.all(promises);
console.log("-> Done!");
