import Game.Levels.Diff.L04diffunion

open Set

namespace STG4

variable {U : Type}

World "Difference"
Level 5
Title "Nothing left"

Introduction
"
If you remove the elements of `B` from `A`, then nothing in what's left can be an element of `B`.
In this level you'll express that as an equation involving `∅`.
"

TheoremTab "\\"

/-- For any sets `A` and `B`, `diff_inter_self A B` is a proof of `(A \ B) ∩ B = ∅`.  In Mathlib,
the name of this theorem is `Set.sdiff_inter_self`. -/
TheoremDoc STG4.diff_inter_self as "diff_inter_self" in "\\"

/-- For any sets $A$ and $B$, $(A \setminus B) \cap B = \emptyset$. -/
Statement diff_inter_self (A B : Set U) : (A \ B) ∩ B = ∅ := by
  ext x
  apply Iff.intro
  intro h
  rewrite [mem_inter_iff, mem_diff] at h
  Hint (hidden := true) "Your assumptions are contradictory.  Write out the meaning of the goal,
  and then use them to prove `False`."
  rewrite [mem_empty_iff_false]
  exact h.left.right h.right
  intro h
  Hint (hidden := true) "There's nothing in `∅`, so `{h}` is a contradictory assumption."
  rewrite [mem_empty_iff_false] at h
  exfalso
  exact h

Conclusion
"
To prove that a set is empty, you showed that being an element of it is equivalent to `False`.
"
