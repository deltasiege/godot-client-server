import decompress from "decompress"; // https://github.com/kevva/decompress
import { getOSData } from ".";

// Downloads and unzips Godot binary for the current / provided platform

const { url } = getOSData(Bun.argv[2]);
if (!url) throw new Error("Download URL for OS could not be determined");
const file = url.split("/").pop();
const name = file?.replaceAll(".zip", "");
const dir = `${import.meta.dir}/bin`;
const zip = `${dir}/${file}`;
const bin = `${dir}/${name}`;
const ext = name?.split(".").pop();
const dest = `${dir}/godot.${ext}`;

async function download() {
  if (!url) return;
  console.log(`Downloading Godot to ${zip}`);
  const response = await fetch(url);
  await Bun.write(zip, await response.arrayBuffer());
}

async function unzip() {
  if (!file) return;
  console.log(`Unzipping Godot to ${bin}`);
  await decompress(zip, dir);
  const dirty = Bun.file(bin);
  if (!dirty) throw new Error("Godot binary not found in zip");
  await Bun.write(dest, dirty);
}

async function prepare() {
  const isDownloaded = await Bun.file(zip).exists();
  const isUnzipped = await Bun.file(dest).exists();

  if (isUnzipped) return console.log(`${dest} binary already present`);
  if (!isDownloaded) await download();
  else console.log(`${zip} already downloaded`);
  if (!isUnzipped) await unzip();
}

prepare();
