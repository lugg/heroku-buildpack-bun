# heroku-buildpack-bun

Heroku buildpack for [Bun](https://bun.sh) runtime.

## Usage

```bash
heroku buildpacks:set https://github.com/lugg/heroku-buildpack-bun
```

Your app must have a `bun.lock` or `bun.lockb` file in the root directory.

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `BUN_VERSION` | Pin Bun version (e.g., `1.1.38`) | latest |
| `BUN_APP_PATH` | Subdirectory for monorepo builds | `.` |
| `BUN_FROZEN_LOCKFILE` | Use `--frozen-lockfile` | `true` |
| `BUN_PRUNE_DEVDEPENDENCIES` | Remove devDeps after build | `false` |

## Version Pinning

Pin the Bun version using either:

1. `BUN_VERSION` environment variable
2. `.bun-version` file in your repo root

```bash
# Via config var
heroku config:set BUN_VERSION=1.1.38

# Or via file
echo "1.1.38" > .bun-version
```

## Monorepo Support

For monorepos with Bun workspaces, you need to configure both **build-time** and **runtime** paths.

### Build-time: `BUN_APP_PATH`

`BUN_APP_PATH` controls where lifecycle scripts run during the build:

```bash
heroku config:set BUN_APP_PATH=apps/server
```

The buildpack will:
1. Run `bun install` from repo root (resolves all workspace dependencies)
2. Run `heroku-prebuild`, `build`, `heroku-postbuild` from `apps/server/`

### Runtime: Procfile with `--cwd`

Heroku always starts dynos from the repo root. Use `--cwd` in your Procfile:

```
web: bun run --cwd apps/server src/index.ts
worker: bun run --cwd apps/server src/worker.ts
release: bun run --cwd apps/server db:migrate
```

The Procfile must be at the repo root.

### Example monorepo structure

```
my-monorepo/
├── apps/
│   └── server/
│       ├── src/index.ts
│       └── package.json    # may have build script
├── packages/
│   └── shared/
├── package.json            # workspaces: ["apps/*", "packages/*"]
├── bun.lock
└── Procfile                # web: bun run --cwd apps/server src/index.ts
```

## Lifecycle Scripts

The buildpack runs these scripts if present in your `package.json` (or `BUN_APP_PATH/package.json` for monorepos):

1. `bun install --frozen-lockfile`
2. `bun run heroku-prebuild`
3. `bun run build`
4. `bun run heroku-postbuild`

## Procfile

Create a `Procfile` at your repo root to define process types:

```
web: bun run src/index.ts
worker: bun run src/worker.ts
release: bun run db:migrate
```

For monorepos, use `--cwd` to run from a subdirectory (see above).

## License

MIT
