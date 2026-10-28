import Game.Levels.Diff.L02diffsub

open Set

namespace STG4

variable {U : Type}

World "Difference"
Level 3
Title "Difference and complement"

Introduction
"
Removing the elements of `B` from `A` is the same as intersecting `A` with the complement of
`B`.  In this level you'll prove that.
"

TheoremTab "\\"

/-- For any sets `A` and `B`, `diff_eq A B` is a proof of `A \ B = A ∩ Bᶜ`.  In Mathlib, the name
of this theorem is `Set.sdiff_eq`. -/
TheoremDoc STG4.diff_eq as "diff_eq" in "\\"

/-- For any sets $A$ and $B$, $A \setminus B = A \cap B^c$. -/
Statement diff_eq (A B : Set U) : A \ B = A ∩ Bᶜ := by
  ext x
  Hint (hidden := true) "Write out the definitions of difference, intersection, and complement."
  rewrite [mem_diff, mem_inter_iff, mem_compl_iff]
  Hint "Now both sides of the `↔` are the same statement."
  rfl

Conclusion
"
So differences can always be written in terms of intersections and complements.  But the
notation `A \\ B` is often more convenient.
"
