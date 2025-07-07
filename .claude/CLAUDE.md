## Package Management

- prefer pnpm over npm
- use fnm to manage node versions
- to approve pnpm builds, add "{"pnpm": {"neverBuiltDependencies": []}}" to package.json

## Docker

- always use "docker compose" over "docker-compose", as the latter is the V1 of the former
- don't execute docker commands with the "-it" (interactive) flag as the shell you use is not interactive

## Communication

- always reply in english

## Task Management

- keep a memory "PROGRESS.md" file updated when completing a task. the markdown memory file should include the original task, and todo, in progress and finished tasks with a little of depth to allow new iterations of models to have enough context to properly continue with the original task
- try to read the "PROGRESS.md" file before starting a new task
