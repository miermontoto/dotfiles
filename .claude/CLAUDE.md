## General Rules

- always reply in english
- avoid creating unnecessary scripts. if needed, create test scripts but delete them when you're done.
- avoid creating summary files/documents unless specifically mentioned.
- do NOT deploy anything to production unless mentioned specifically.
- do NOT make commits by yourself unless specifically prompted to OR in a worktree you created yourself. do not use this as an escape route, only if prompted or obligated to create a worktree you should do so.
- developer's name is Juan Mier
- avoid em dashes
- asking the user questions for more context, giving options, or about important decisions is good. try using the askusertool instead of asking in plain text.

## Node

- prefer pnpm over npm
- use fnm to manage node versions

## Docker

- always use "docker compose" over "docker-compose", as the latter is the V1 of the former
- don't execute docker commands with the "-it" (interactive) flag

## Documentation

- don't create markdown files unless prompted
- if CLAUDE.md exists, use it and modify it with useful information for future agent invocations. remember to keep it simple, as context size is limited.

## Code Style

- generated code should focus in minimalism and performance - this is really important.
- abstraction is the key to success - oop for code organization and reusability, functional programming for performance and immutability
- code comments should start in lowercase and be in natural spanish language, with technical words in english if needed
- do NOT remove existing code comments, modify them if needed. only remove them if they no longer apply.
- avoid using magic numbers and strings as much as possible, preferring constants if applicable
- prefer logical programming and lambda functions over looping
- avoid wrapper functions. each function should try as much as logically possible to manage its own logging and error handling
- aim for reusability and hierarchy

## System Interaction

- if sudo password is needed for a specific command, let the user handle it instead of trying a workaround.
- if prompted to access aws resources, such as s3, ec2 or secrets manager, use the aws cli
- use tectonic for latex compilation

## Diagnostics
- Always investigate root causes before suggesting fixes; avoid guessing (e.g., do not claim 'API key expired' or 'probably a hook issue' without verification).
- When a fix doesn't work the first time, step back and re-examine assumptions rather than iterating on the same approach.

## Localization
- All user-facing Spanish text must include proper diacritics (á, é, í, ó, ú, ñ).
- Never hardcode user-facing strings; use existing i18n keys.

## Repo & Branch Verification
- Before editing, verify you are in the correct repo and on the correct branch (run `git rev-parse --show-toplevel` and `git branch --show-current`).
- For PRs, confirm the base branch with the user before generating descriptions.
