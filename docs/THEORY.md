# The Theory Behind skill-forge

## Overview

skill-forge applies software engineering rigor — specifically Test-Driven Development (TDD) and statistical validation — to the problem of improving AI agent skills.

## TDD-Based Skill Evolution

Traditional skill improvement relies on subjective human judgment: "Does this version feel better?" skill-forge replaces this with a measurable, repeatable process:

1. **Baseline Measurement**: Evaluate the current skill 3 times independently
2. **Improvement Attempt**: Make changes in an isolated Trial Branch
3. **Post-Improvement Measurement**: Evaluate the improved skill 3 times independently
4. **Statistical Validation**: Compare using 95% confidence intervals

### Why 3 Evaluations?

A single evaluation is unreliable — AI evaluators can vary significantly between runs. By collecting 3 independent scores, we can compute a confidence interval that accounts for this variance.

With n=3 and the t-distribution (t=4.303 for 95% CI), we get a meaningful range even with small samples. For higher precision, n=5 (t=2.776) narrows the interval further.

### Confidence Interval Separation

The key test: **baseline CI upper bound < improved CI lower bound**

```
Baseline: [69, 75]  ← upper = 75
Improved: [86, 91]  ← lower = 86

75 < 86 → PASS: Statistically significant improvement
```

If the intervals overlap, the improvement is not statistically significant, and the Trial Branch is discarded.

## Trial Branch Isolation

Every improvement attempt happens in a dedicated git branch:

```
main (clean) ──┐
               ├─ trial/skill-name (experiment)
               │   ├─ Modification
               │   ├─ Evaluation (×3)
               │   └─ Decision: merge or discard
               └─ main (unchanged if discarded)
```

### Safety Guarantees

- The original skill is **never modified** until improvement is statistically proven
- Failed experiments leave **zero trace** on the main branch
- Multiple experiments can run in **parallel** on separate trial branches
- Old trial branches are **automatically cleaned up** after 24 hours

## Evaluator/Executor Separation

A critical design principle borrowed from organizational theory:

- **Executor**: The agent that modifies the skill (makes improvements)
- **Evaluator**: A separate agent that scores the skill (judges quality)

These roles are **strictly separated** to prevent circular reasoning. If the same agent both improves and evaluates, it can unconsciously optimize for its own scoring criteria rather than actual quality.

The evaluator follows a rubric with 4 scoring dimensions (0-100 each):
1. Structural quality
2. Behavioral coverage
3. Edge case handling
4. Documentation clarity

## Dual Forging Paths

### TDD Forge (for skills with tests)
- Full statistical validation pipeline
- Trial Branch isolation
- 95% CI separation test
- **Best for**: Production skills where quality regression must be prevented

### Heuristic Forge (for skills without tests)
- Structural analysis based on usage data
- Quality scoring via checklist evaluation
- Improvement suggestions without statistical gating
- **Best for**: New or experimental skills that need rapid iteration

## Theoretical Foundation

skill-forge draws inspiration from **Gödel Machines** (Schmidhuber, 2006) — self-referential systems that can modify their own code, but only when the modification is provably beneficial.

In skill-forge's case, "provably beneficial" is operationalized as "statistically significant improvement with 95% confidence" — a practical approximation of formal proof that works in the noisy world of AI-generated evaluations.

## References

- Schmidhuber, J. (2006). "Gödel Machines: Fully Self-Referential Optimal Universal Self-Improvers"
- Student's t-distribution for small sample confidence intervals
- Test-Driven Development (Beck, 2002)
