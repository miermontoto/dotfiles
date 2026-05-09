I'm reporting a bug: $ARGUMENTS

Execute this autonomous workflow without asking me follow-up questions until you're done:

1. **Reproduce** — read the relevant code, then write a NEW failing test that captures the exact bug (unit or integration as appropriate). Run it and confirm it fails for the right reason.
2. **Hypothesize root cause** — investigate beyond the obvious; specifically rule out misdiagnoses like z-index when it's display:none, or expired-API-key when it's actually working. State your root cause hypothesis with evidence.
3. **Fix minimally** — apply the smallest change that makes the new test pass.
4. **Regression guard** — run the FULL test suite. If anything breaks, do NOT relax the new test; instead refine the fix until both the new test and all existing tests pass.
5. **Loop** step 4 up to 5 times. If still failing, output a structured report of what you tried and stop.
6. **On success** — commit with a message describing the bug, root cause, and fix, then output a one-paragraph summary.
