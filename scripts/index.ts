import { resolve } from "path";

type Platform = "linux" | "win32";
type OSData = {
  projectDir: string;
  binaryPath: string;
  buildPreset: string;
  extension: string;
  url: string;
};

export function getOSData(_platform?: string): OSData {
  const platform = (_platform || process.platform) as Platform;
  const baseUrl = "https://github.com/godotengine/godot/releases/download";
  const urls = {
    linux: `${baseUrl}/4.4-stable/Godot_v4.4-stable_linux.x86_64.zip`,
    win32: `${baseUrl}/4.4-stable/Godot_v4.4-stable_win64.exe.zip`,
  };
  const extensions = {
    linux: "x86_64",
    win32: "exe",
  };
  const profiles = {
    linux: "linux",
    win32: "windows",
  };
  return {
    projectDir: resolve(import.meta.dir, ".."),
    binaryPath: resolve(import.meta.dir, `bin/godot.${extensions[platform]}`),
    buildPreset: profiles[platform],
    extension: extensions[platform],
    url: urls[platform],
  };
}
