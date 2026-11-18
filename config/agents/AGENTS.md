# User-level agent notes

On machines where it is set up, the user's L0 map (their repos,
infrastructure and conventions) comes from a private context store: a
`SessionStart` hook adds it to the session (`ctx l0`). Which store depends
on the machine's active profile (`ctx use`), e.g. personal or work.

- If an L0 is in your context, follow it; it says how to read and write
  the store (`ctx ls`, `ctx get`, `ctx put`).
- If none is, ctx is off or not set up here. Work without it: don't run
  `ctx` and don't ask to set it up.

Never copy what `ctx` returns into a repo, a commit message or this file.
This file is in a public repo.
