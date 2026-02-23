Run a full branch validation against the specified (or default) branch using parallel agents, then fix everything found:

## Phase 1: Parallel Validation (spawn 5 agents)

- **Build Agent**: Run all build commands, report any failures with exact errors
- **Test Agent**: Run full test suite, capture all failures with stack traces
- **Security Agent**: Scan for hardcoded secrets, env leaks (especially process.env in frontend builds), exposed credentials, SQL injection
- **Code Quality Agent**: Check for unused imports, dead code, missing types, lint violations
- **Architecture Agent**: Review new files against existing patterns, flag inconsistencies with project conventions

## Phase 2: Consolidated Report

Merge all findings into a prioritized list: Critical (blocks merge) → High → Medium → Low

## Phase 3: Autonomous Fixes

For each Critical and High issue:

1. Fix the issue
2. Run relevant tests
3. Verify the fix doesn't break anything else
4. Move to next issue

Give me the final report with: issues found per agent, issues fixed, issues remaining with justification for why they were left.
