## Package Management

- prefer pnpm over npm
- use fnm to manage node versions
- to approve pnpm builds, add "{"pnpm": {"neverBuiltDependencies": []}}" to package.json

## Docker

- always use "docker compose" over "docker-compose", as the latter is the v1 of the former
- don't execute docker commands with the "-it" (interactive) flag as the shell you use is not interactive