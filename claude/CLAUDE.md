# User Preferences

## Version Control

- Use `jj` (Jujutsu) instead of git when possible
- Fetch with `jj f`, commit with `jj commit`, create bookmarks with `jj bookmark create`
- Push with `jj p-` (pushes `@-`)
- Use `jj squash` to amend changes into the previous commit

## Code Style

- Only add non-trivial code comments that genuinely help understanding
- Avoid comments that merely restate what the code does (e.g., "// Capture config values for use in the closure")
- Good comments explain *why*, not *what*

## PR Reviews

- Before addressing comments from AI reviewers (almanax-ai, etc.), ask whether they are relevant
- This gives the user a chance to dismiss false positives at the PR before making unnecessary changes
