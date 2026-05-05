# Valon Day 1 Hypotheses

Private mental model for entering the Performing Servicing PM role. These are designed to be wrong in useful ways — the value is having a point of view that forces better questions in first conversations.

**Source**: Derived from single intro call with Dan Chen (2026-04-17) + independent domain research.

---

## Bet 1: Configuration is the product, not a feature

**The hypothesis**: Valon's biggest constraint to scaling isn't building new features — it's that each customer deployment requires bespoke configuration work because the system was built with hardcoded logic. The trigger/action migration Dan mentioned isn't a tech debt cleanup, it's *the core product problem*. Until servicers can configure escrow rules, insurance workflows, and tax disbursement logic themselves (or at least without eng involvement), every new customer adds linear cost.

**Why this might be right**: Dan called it out explicitly as the big technical challenge. Founder-led sales + small deployment team + ~20 target customers = each deal is high-touch. If you're selling a "system of record replacement," configuration flexibility is table stakes — that's what legacy systems like Black Knight already offer (badly, but they offer it).

**Why this might be wrong**: Maybe the configuration problem is already mostly solved and Dan was describing the final 20%. Or maybe customers don't actually want self-serve configuration — they want Valon to handle it as part of the service.

**What it would mean for you**: Your first PM job isn't feature roadmapping — it's understanding the configuration gap across all four verticals, sequencing which areas to make configurable first, and defining what "configurable" even means (admin UI? rules engine? API?).

**First question to ask**: "What percentage of a new customer deployment is configuration work vs. integration work vs. data migration?"

---

## Bet 2: The four verticals aren't equally valuable — one is the wedge

**The hypothesis**: Insurance, taxes, PMI, and escrow management aren't equal priorities. One of them is where Valon either wins or loses deals — probably **property insurance** (tracking, force-placing) because it has the most operational complexity, the highest variance across servicers, and the most acute pain when it goes wrong (uninsured property = catastrophic loss exposure). Your job isn't to treat all four verticals equally — it's to figure out which one is the current battleground and over-invest there.

**Why this might be right**: Dan described four verticals but didn't signal they're all equally urgent. In enterprise sales with ~20 targets, deals often hinge on one capability gap. Insurance has the most moving parts (policies lapse, carriers change, force-placement is regulated differently by state) and the highest downside risk for servicers.

**Why this might be wrong**: Maybe taxes are the real pain point (tax liens are existential). Or maybe the horizontal escrow management layer is what actually differentiates because it's customer-facing (statements, analysis). Or maybe all four are genuinely equally important right now.

**What it would mean for you**: Instead of trying to learn all four verticals evenly in week 1, identify which one the team and customers talk about most — and go deep there first.

**First question to ask**: "Which of the four verticals comes up most in customer conversations and sales cycles?"

---

## Bet 3: AI's first job isn't new capabilities — it's eliminating manual review queues

**The hypothesis**: The strongest near-term AI opportunity in performing servicing isn't building flashy new features — it's automating the human review steps that currently sit between triggers and actions. Escrow analysis probably generates exceptions that a person reviews before disbursement. Insurance monitoring probably flags policies for manual verification. Tax tracking probably queues items for human confirmation. These review queues are where 95% of the portfolio creates linear operational cost. AI that confidently auto-resolves 80% of queue items is worth more than any net-new feature.

**Why this might be right**: Dan said AI opportunities are strongest in performing servicing. The 95% performing portfolio stat suggests most loans are routine — meaning most exceptions are probably routine too, just requiring a human to confirm the obvious. This is exactly where LLMs/ML shine: high-volume, pattern-recognizable decisions that currently need a person in the loop. And it ties directly to the operations-business-being-sold narrative — Valon needs to prove the software handles this without an ops team.

**Why this might be wrong**: Maybe there aren't significant manual review queues — maybe the system is already highly automated and the AI opportunity is elsewhere (document processing, customer communication, compliance checking). Or maybe the regulatory environment makes auto-resolution risky without human sign-off regardless of confidence.

**What it would mean for you**: Your AI roadmap isn't "add AI to the product" — it's "find every place a human reviews a routine decision, measure the volume, and figure out which ones AI can safely auto-close." That's a measurable, scoped problem.

**First question to ask**: "Where do operations teams spend the most time on routine decisions that rarely result in a different outcome than the system already suggests?"
