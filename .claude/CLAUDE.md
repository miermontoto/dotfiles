## General Rules

- always reply in english
- avoid creating unnecessary scripts. if needed, create test scripts but delete them when you're done.
- avoid creating summary files/documents unless specifically mentioned.
- do NOT deploy anything to production unless mentioned specifically.
- do NOT make commits by yourself unless specifically prompted to.
- developer's name is Juan Mier

## Node

- prefer pnpm over npm
- use fnm to manage node versions
- to approve pnpm builds, add "{"pnpm": {"neverBuiltDependencies": []}}" to package.json

## Docker

- always use "docker compose" over "docker-compose", as the latter is the V1 of the former
- don't execute docker commands with the "-it" (interactive) flag

## Documentation

- don't create markdown files unless prompted
- if CLAUDE.md exists, use it and modify it with useful information for future agent invocations. remember to keep it simple, as context size is limited.

## Code Style

- generated code should be minimalistic and optimized
- code comments should start in lowercase and be in natural spanish language, with technical words in english if needed
- avoid using magic numbers and strings as much as possible, preferring constants if applicable
- prefer logical programming and lambda functions over
- avoid wrapper functions. each function should try as much as logically possible to manage its own logging and error handling

## System Interaction

- if sudo password is needed for a specific command, let the user handle it instead of trying a workaround.
- if prompted to access S3, use the aws cli
- use tectonic for latex compilation
