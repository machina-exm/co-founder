---
name: help
description: >-
  Which /co-founder skill fits the current situation. Run when the user asks "which skill",
  "what should I use", "how does co-founder work", or describes a task without knowing where it
  goes.
---

# help: route to the right skill

## Step 0: Preflight

Read `${CLAUDE_SKILL_DIR}/../../CONVENTIONS.md` and apply its Help exception. A Ready system
reads the "When you say X, I run Y" table in the founder's charter (AGENTS.md / CLAUDE.md).
Answer from it: name the ONE skill that fits what they described, say why in a sentence, and
give them the exact phrase to say. Two skills genuinely fit: name the order to run them in.

Resolve the two loaded collisions by intent. "Whether should we do/build/change this?" routes
to the gauntlet; "how do we execute the decision already made?" routes to plan. For pricing, "should
we change the price?" routes to the gauntlet; "how do we structure the approved price or offer?"
routes to offer. State the distinction in one sentence when the wording is ambiguous.

Complete the whole routing hop before naming the skill. For any offer, price, spend, or other
money move, inspect `wiki/business/offer.md` and matching initiatives. An unresolved whether-call,
an unapproved price/offer, or a BIG move without a current SURVIVES verdict routes directly to
the gauntlet. Offer is the destination only when the exact move is already approved and the founder is
asking how to structure it. Never send the founder offer → gauntlet for a gate help could see now.

Resolve parked prerequisites before the owner skill. If the exact initiative says `PARKED:
internal receipt missing`, route first to the named measurement or recall action, then the gauntlet, then
offer after SURVIVES. If it says `PARKED: external receipt missing`, route `research → gauntlet`, then
offer after SURVIVES. An `idea` with no verdict routes to the gauntlet; a current SURVIVES verdict routes
to offer. Return the complete chain in three lines: `Now`, `Then`, `After the gate`.

Help answers the current prompt and stops. A new prompt replaces the prior routing task; help does
not start steward, review, or any unrelated audit before returning the route. For "I want to charge
1,500. Set it up" against a price initiative parked on delivery evidence, the answer starts with
that measurement, continues to the gauntlet, and reaches offer only after the gate survives.

Any Fresh, Partial, or Wrong-folder result points to `/co-founder:co-founder-setup` (re-sync for Partial)
and stops there.

**Ask before you assert:** never present a quantity, duration, sample size, date, or causal motive
in prose before asking the founder for it or citing a receipt for it.
