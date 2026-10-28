import Game.Levels.Diff.L03diffeq

open Set

namespace STG4

variable {U : Type}

World "Difference"
Level 4
Title "Difference from a union"

Introduction
"
What do you get if you remove from `A` all the elements of `B ∪ C`?
"

TheoremTab "\\"

/-- For any sets `A`, `B`, and `C`, `diff_union A B C` is a proof of
`A \ (B ∪ C) = (A \ B) ∩ (A \ C)`.  In Mathlib, the reverse of this equation is called
`Set.sdiff_inter_sdiff`. -/
TheoremDoc STG4.diff_union as "diff_union" in "\\"

/-- For any sets $A$, $B$, and $C$, $A \setminus (B \cup C) = (A \setminus B) \cap (A \setminus C)$. -/
Statement diff_union (A B C : Set U) : A \ (B ∪ C) = (A \ B) ∩ (A \ C) := by
  ext x
  Hint (hidden := true) "Start by writing out all of the definitions."
  rewrite [mem_diff, mem_union, mem_inter_iff, mem_diff, mem_diff]
  apply Iff.intro
  intro h
  have h2 := h.right
  Hint (hidden := true) "`{h2}` is a negative statement.  Can you make it a positive one?"
  push_neg at h2
  exact And.intro (And.intro h.left h2.left) (And.intro h.left h2.right)
  intro h
  apply And.intro
  exact h.left.left
  push_neg
  exact And.intro h.left.right h.right.right

Conclusion
"
This theorem is a version of De Morgan's law for differences.
"
