# heroku-buildpack-bun

Heroku buildpack for [Bun](https://bun.sh) runtime. Used in production at [Lugg](https://lugg.com).

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

For monorepos with Bun workspaces, use `--cwd` in your Procfile to run from a subdirectory.

### Procfile with `--cwd`

Heroku starts dynos from the repo root. Use `--cwd` to run from your app directory:

```
web: bun run --cwd apps/server src/index.ts
worker: bun run --cwd apps/server src/worker.ts
release: bun run --cwd apps/server db:migrate
```

That's it! The buildpack runs `bun install` from root, which resolves all workspace dependencies.

### Example monorepo structure

```
my-monorepo/
├── apps/
│   └── server/
│       ├── src/index.ts
│       ├── src/worker.ts
│       └── package.json
├── packages/
│   └── shared/
│       └── package.json
├── package.json            # workspaces: ["apps/*", "packages/*"]
├── bun.lock
└── Procfile                # at root, uses --cwd
```

### Optional: `BUN_APP_PATH` for build scripts

Only needed if your app subdirectory has `build`, `heroku-prebuild`, or `heroku-postbuild` scripts:

```bash
heroku config:set BUN_APP_PATH=apps/server
```

This runs those lifecycle scripts from `apps/server/` instead of root.

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
