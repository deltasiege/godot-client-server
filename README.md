# Godot Client + Server Multiplayer

by Delta Siege Games

## Requirements

- [Bun](https://bun.sh/) (only if you want to run `/scripts` which help with project setup / development)

## Quickstart

### Download

```shell
degit deltasiege/godot-client-server my-project
cd my-project
```

### Preparing

1. Update the Godot version in `scripts/index.ts` to whatever you'd like
1. Download the Godot binary to `scripts/bin` by running:

```shell
cd scripts
bun install
bun prepare.ts # <OS>
```

`<OS>` = Operating system of the current machine [win32|linux] (defaults to `process.platform`)

### Symlinking

Create symbolic links for the `common` directory so that both projects can use the contents by running:

```shell
bun link-common.ts
```

### Run

Start both the server and client Godot projects locally by running:

```shell
bun dev.ts # <clients>
```

`<clients>` = number of clients to spin up (defaults to 1)

### Build

Build game executable(s) via Godot

```shell
bun build.ts # <project> <OS>
```

`<project>` = which projects to build [client|server|web|all] (defaults to all)
`<OS>` = Operating system of the current machine [win32|linux] (defaults to `process.platform`)
