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

For monorepos, set `BUN_APP_PATH` to the app subdirectory:

```bash
heroku config:set BUN_APP_PATH=apps/server
```

The buildpack will:
1. Run `bun install` from the repo root (for workspace resolution)
2. Run lifecycle scripts from the app subdirectory

## Lifecycle Scripts

The buildpack runs these scripts from your `package.json` if present:

1. `bun install --frozen-lockfile`
2. `bun run heroku-prebuild`
3. `bun run build`
4. `bun run heroku-postbuild`

## Procfile

Create a `Procfile` to define your process types:

```
web: bun run src/index.ts
worker: bun run src/worker.ts
release: bun run db:migrate
```

## License

MIT
