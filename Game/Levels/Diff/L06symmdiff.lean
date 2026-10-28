import Game.Levels.Diff.L05diffinter

open Set

namespace STG4

variable {U : Type}

World "Difference"
Level 6
Title "Symmetric difference"

Introduction
"
The *symmetric difference* of `A` and `B`, written `A ∆ B`, is the set of objects that are in
exactly one of `A` and `B`.  (You can enter the symbol `∆` by typing `\\symmdiff`.)  Lean will
recognize `mem_symmDiff` as a proof of any statement of the form
`x ∈ A ∆ B ↔ x ∈ A ∧ x ∉ B ∨ x ∈ B ∧ x ∉ A`.

In this final level of Difference World, you'll show that `A ∆ B` can also be described as the
objects that are in `A ∪ B` but not in `A ∩ B`.
"

/-- `A ∆ B` is the *symmetric difference* of `A` and `B`: the set of objects that are in
exactly one of `A` and `B`.  You can enter the symbol `∆` by typing `\symmdiff`. -/
DefinitionDoc symmdiff as "∆"

NewDefinition symmdiff

/-- Lean will recognize `mem_symmDiff` as a proof of any statement of the form
`x ∈ A ∆ B ↔ x ∈ A ∧ x ∉ B ∨ x ∈ B ∧ x ∉ A`.  In Mathlib, the name of this theorem is
`Set.mem_symmDiff`. -/
TheoremDoc Set.mem_symmDiff as "mem_symmDiff" in "\\"

NewTheorem Set.mem_symmDiff

TheoremTab "\\"

/-- For any sets $A$ and $B$, $A \mathbin{\triangle} B = (A \cup B) \setminus (A \cap B)$. -/
Statement (A B : Set U) : A ∆ B = (A ∪ B) \ (A ∩ B) := by
  ext x
  Hint (hidden := true) "Start by writing out all of the definitions."
  rewrite [mem_symmDiff, mem_diff, mem_union, mem_inter_iff]
  apply Iff.intro
  intro h
  Hint (hidden := true) "`{h}` is an \"or\" statement, so break the proof into cases."
  rcases h with hA | hB
  apply And.intro
  exact Or.inl hA.left
  push_neg
  intro h2
  exact hA.right
  apply And.intro
  exact Or.inr hB.left
  push_neg
  intro h2
  exfalso
  exact hB.right h2
  intro h
  have h2 := h.right
  push_neg at h2
  Hint (hidden := true) "`{h}.left` says that `{x}` is in `A` or in `B`.  Consider the two cases."
  rcases h.left with hA | hB
  left
  exact And.intro hA (h2 hA)
  right
  apply And.intro
  exact hB
  by_contra h3
  exact h2 h3 hB

Conclusion
"
Congratulations!  You've completed Difference World.
"
