## Package Management

- prefer pnpm over npm
- use fnm to manage node versions
- to approve pnpm builds, add "{"pnpm": {"neverBuiltDependencies": []}}" to package.json

## Docker

- always use "docker compose" over "docker-compose", as the latter is the V1 of the former
- don't execute docker commands with the "-it" (interactive) flag

## Communication

- always reply in english

## Documentation

- don't create markdown files unless prompted

## Code Generation

- generated code should be minimalistic and optimized

## Code Style

- code comments should start in lowercase and be in natural spanish language, with technical words in english if needed

## AI Interaction

- never commit in the name of the user unless specifically prompted to

## Cloud Services

- if prompted to access S3, use the aws cli