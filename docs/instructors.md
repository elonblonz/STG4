# Using the Set Theory Game in teaching

The Set Theory Game teaches students to write proofs about sets, one checked step at a time.
It follows the approach of Daniel J. Velleman's *How To Prove It* (HTPI): a proof is built
from the logical form of the goal and the givens, and every step has a standard English
phrasing. Lean checks each step, so students get immediate feedback and can't hand in a proof
with a gap.

The game runs in a browser and needs no installation or account. Progress is stored in the
student's browser (it can be downloaded and uploaded from the ≡ menu).

## How the game connects to written proofs

Every level presents a theorem as givens (*Objects* and *Assumptions*) and a *Goal*, as in
HTPI. Several features connect the Lean steps with ordinary mathematical writing:

- Each tactic's documentation (in the inventory) says how that step usually reads in a written
  proof, for example `intro x` reads "Let `x` be arbitrary" and `rcases` reads "Case 1 / Case 2".
- The 12 levels that introduce a new proof technique end with the proof written out in English,
  sentence by sentence, next to the tactics the student used.
- The hardest levels have a hidden "The idea." hint that gives the plan of the proof in English,
  without the Lean.

A good exercise after any level: ask students to write the proof they just found as a
paragraph, then compare it with the written-out proofs.

## Worlds, objectives and HTPI sections

Worlds unlock in order (Intersection and Union open Combination World; Combination opens
Difference World and, together with the family worlds, Family Combination World). Times are
rough guides for a student new to proofs.

| World | Levels | Students learn to… | Tactics introduced | HTPI |
|---|---|---|---|---|
| Subset | 6 | read a theorem as givens and goal; use assumptions; prove `A ⊆ B` by taking an arbitrary element | `exact`, `have`, `intro` | 1.3, 1.4, 3.1, 3.3 |
| Complement | 8 | prove negative statements by contradiction; unfold definitions; prove set equality by two inclusions; work with `∅` and the universe | `by_contra`, `rfl`, `rewrite`, `apply`, `push_neg`, `constructor`, `exfalso` | 1.4, 3.2, 3.4 |
| Intersection | 8 | use and prove "and" statements; prove set equality element by element | `ext` | 1.4, 3.4 |
| Union | 6 | use "or" statements by cases; prove "or" statements | `rcases`, `left`, `right` | 1.4, 3.5 |
| Combination | 5 | combine the techniques: De Morgan's laws, distributive laws, a multi-step subset proof | — | 1.4, 3.7 |
| Difference | 6 | work with `A \ B` and symmetric difference | — | 1.4, 3.5 |
| Family Intersection | 6 | intersections of families; universal statements; `by_cases` | `by_cases` | 2.1, 2.3, 3.3 |
| Family Union | 10 | prove and use existential statements; unions of families; power sets | `use`, `obtain` | 2.1, 2.3, 3.3, 3.6 |
| Family Combination | 8 | longer proofs mixing quantifiers, complements and families | — | 2.2, 2.3, 3.7 |

Approximate time: Subset to Union take about 2–4 hours together; each of the later worlds
takes about 1–2 hours.

## Suggested course use

- **Alongside HTPI chapters 1–3.** Assign each world after the matching sections (see the table).
  The game gives practice with instant feedback; written homework then asks for the same proofs
  in English.
- **As a first week of an intro-to-proofs course.** Subset, Complement, Intersection and Union
  World cover the core strategies (arbitrary elements, contradiction, cases, two inclusions).
- **For self-study.** Students can work through the game in order; the hints and written-out
  proofs are designed for learners without a tutor.

Lean itself is not the subject: students need no prior Lean or programming experience, and the
game only uses a small set of tactics, each introduced with an example.

## Rules setting

From the world map, the *Rules* menu sets how strict the game is:

- **regular** (default): levels unlock in order, and using a tactic or theorem that hasn't been
  introduced yet is an error.
- **relaxed**: all levels are open, and using a tactic or theorem that hasn't been introduced
  only gives a warning.
- **none**: all levels are open with no restrictions, which is useful for exploration or for
  students who already know Lean.

## Further reading

- Daniel J. Velleman, *How To Prove It: A Structured Approach*, Cambridge University Press.
- [How To Prove It with Lean](https://djvelleman.github.io/HTPIwL/): the same ideas, with Lean.
