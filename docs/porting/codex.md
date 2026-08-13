# Codex CLI
Surface: `.agents/skills` (13 portable skills) + `.codex-plugin/plugin.json` + `.agents/plugins/marketplace.json`
(Codex also reads the legacy `.claude-plugin/marketplace.json`).
Install: `codex plugin marketplace add machina-exm/co-founder` → `/plugins` → install → new session.
Invocation: description auto-trigger or `$skill-name`. Codex metadata lives in per-skill `agents/openai.yaml`
(never in SKILL.md frontmatter).
Gotchas: skills root naming is in transition (`.agents/skills` canonical, `~/.codex/skills` legacy);
catalog trims long descriptions — keep trigger signal front-loaded.
