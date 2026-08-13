# Kimi Code CLI
Surface: `kimi.plugin.json` + `.kimi-plugin/plugin.json` (identical) + `.kimi-plugin/commands/<skill>.md`
(13 wrappers → `/co-founder:<skill>`), skills served from `.agents/skills`.
Install: TUI `/plugins install https://github.com/machina-exm/co-founder` → trust confirm → `/reload`.
The trust dialog is interactive-only; there is no headless install. Pin expectations to the tested
version (0.31.x) — Kimi is pre-1.0 and releases several times a week.
Verified: project-level `.agents/skills` discovery + case-2 behavior PASS on 0.31.1.
Note: paid Kimi membership required; current Kimi does NOT read `.claude/skills` (old blog posts claim
otherwise — that was the legacy Python CLI).
