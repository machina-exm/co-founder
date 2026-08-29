# Grok Bot
Not the CLI. Grok Bot is xAI's hosted always-on agent product (launched 2026-08-11). Each Bot runs
on its own virtual computer with a persistent filesystem, so the vault survives between sessions.

Surface: `.agents/skills` (13 portable skills). That tree is fully self-contained — every skill
carries its own `references/CONVENTIONS-core.md`, and it holds no `${CLAUDE_SKILL_DIR}` variables
and no `/co-founder:` routes. Skills can be copied in individually without breaking the contract.

Install: there is no marketplace route. **Settings → Plugins** lists only connectors and
org-published Team plugins, with no control for adding a repository. The Bot installs the
collection itself when asked. Paste this prompt into a Bot:

```
Install a skill collection from a public GitHub repository.

1. Clone https://github.com/machina-exm/co-founder
2. Inside it, .agents/skills/ contains 13 skill folders. Each has a
   SKILL.md and a references/ folder, and each is self-contained —
   do not rewrite any paths inside them.
3. Copy all 13 folders into your skills directory, keeping the folder
   structure exactly as it is. Copy the files byte for byte. Do not
   summarize, rewrite, shorten, or regenerate any SKILL.md.
4. Report back three things: the exact path you wrote them to, a
   directory listing of that path, and the first 12 lines of
   gauntlet/SKILL.md.
5. Then tell me which of the 13 skills you can now invoke.
```

Step 4 exists to catch the one failure that matters: a Bot that paraphrases the skills instead of
copying them. The gating logic lives in the exact wording, so a summarized `SKILL.md` installs
cleanly and does nothing. Diff the returned excerpt against
`.agents/skills/gauntlet/SKILL.md` before trusting the install.

Verified live 2026-08-29:
- Bot cloned the repo and copied all 13 folders to `/home/box/agent-data/workflows`. The directory
  is named `workflows`, not `skills`, and discovery still worked — do not correct the path.
- The returned `gauntlet/SKILL.md` excerpt matched ours byte for byte: same folded
  `description: >-` block, same eight description lines, same line breaks, same heading.
- Case 2 (preflight-empty-plan) PASS. Input: "I want to launch a paid community for indie founders
  at $49/month. Let's build it — start with the landing page." The Bot refused to build, named the
  missing founder system, routed setup → gauntlet → scope in that order, and asked exactly one
  question.

Gotcha: the repository must be public. A Bot that cannot reach a private clone tends to produce a
plausible-looking result rather than failing loudly.
