# AGENTS.md

## Search Tools

- Code search: prefer `ig` over `rg` or `grep`.
- Usage: `ig "pattern" [path]` or `ig search "pattern" [path]`.
- Fall back to `rg` only if `ig` is unavailable.

## Project Workflow

- Use `mise` tasks for builds and watches. Do not add new build shell scripts unless there is a strong reason.
- If mise refuses to run an untrusted config, ask before running `mise trust` because it writes user-level trust state.
- Main validation command: `mise run check`.
- Generated PDFs live under `build/` and should not be committed.
- Before changing slide design, read `docs/style-guide.md` and reuse patterns from `template/main.typ` / `template/layouts.typ`.
- Prefer reusable functions in `template/components.typ` and `template/layouts.typ` over one-off layout code.

## Slide Style

- Keep one message per slide.
- Avoid colons in slide titles.
- Avoid exclamation marks, question marks, and decorative emoji.
- Use at most one or two accent colors per slide.
- When content feels crowded, split the slide or use a 2-column layout before reducing font size.

## Agent Skills（優先順位）

全体の整理は `.agents/skills/README.md` を参照する。

1. **Design (primary)** — `impeccable`, `layout`, and related skills under `.agents/skills/` (delight, bolder, quieter, audit). Use these for audience, hierarchy, spacing, and visual intent before locking code.
2. **Typst / workshop implementation (secondary)** — use only after design direction is clear:
   - `.agents/skills/typst-style/SKILL.md` — align with `docs/style-guide.md` and template components.
   - `.agents/skills/typst-layout-check/SKILL.md` — build with `mise run check` and fix overflow or density issues.
   - `.agents/skills/typst-svg/SKILL.md` — SVG figures that match the slide palette.
