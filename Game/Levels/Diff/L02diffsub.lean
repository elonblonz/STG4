import Game.Levels.Diff.L01diffdef

open Set

namespace STG4

variable {U : Type}

World "Difference"
Level 2
Title "A difference is a subset"

Introduction
"
Here's a first theorem about differences.
"

TheoremTab "\\"

/-- For any sets `A` and `B`, `diff_subset A B` is a proof of `A \ B ⊆ A`.  In Mathlib, the name
of this theorem is `Set.sdiff_subset`. -/
TheoremDoc STG4.diff_subset as "diff_subset" in "\\"

/-- For any sets $A$ and $B$, $A \setminus B \subseteq A$. -/
Statement diff_subset (A B : Set U) : A \ B ⊆ A := by
  intro x h
  Hint (hidden := true) "Write out the definition of difference in `{h}`."
  rewrite [mem_diff] at h
  exact h.left
