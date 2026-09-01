# Agent instructions for lowframer

Read CONTRIBUTING.md first — it is the authoritative process document. The
rules below are the hard gates an agent must not cross on its own judgment.

## Hard gates

- **Never run `dart pub publish` (or any publish/upload) without an explicit,
  separate approval of that exact step.** "Cut the release" authorizes the
  runbook's preparatory steps (bump, changelog, PR, tag) — it does NOT
  authorize the upload. Run the dry-run, present its output, then stop and
  ask. Publishing is immutable; a wrong upload cannot be replaced.
- **Do not push branches or open PRs before the user validates the change**
  and approves, unless they explicitly ask for the push/PR. Commit locally
  and report "committed, not pushed".
- **Never put a version bump in a PR that changes anything else.** The bump is
  always its own `chore(release): bump to X.Y.Z` PR, opened only after the
  feature work has already landed on `main`. Squash-merge destroys the branch's
  commits, so a piggy-backed bump erases the release from history entirely.
  If you notice mid-branch that a release is due, finish and land the branch
  first, then start a fresh one for the bump. Verify with
  `tool/check_version_bump_is_alone.sh` before pushing; CI runs the same script
  as `version_bump_is_alone`. Do not rely on the gate to catch it: a red CI run
  on a branch that should never have existed has already cost a build.

## Release checklist pointers

- The version lives in **three** places (see CONTRIBUTING's table, including
  the README install snippet); `test/version_drift_test.dart` is the drift
  guard — run it after any bump.
- Bump first, changelog second; tag the merge commit; nothing lands on main
  between bump and tag.

## API invariants

- `LowframerScribble` is deterministic by contract: no `math.Random`, ever.
  Identical input must paint identical pixels.
