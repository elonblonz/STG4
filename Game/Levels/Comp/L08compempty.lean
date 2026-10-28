import Game.Levels.Comp.L07subuniv

open Set

namespace STG4

variable {U : Type}

World "Complement"
Level 8
Title "The complement of the empty set"

Introduction
"
What is the complement of `∅`?  Since no object is an element of `∅`, every object is an element
of `∅ᶜ`.  In this last level of Complement World, you'll prove that `∅ᶜ = univ`.
"

/-- `compl_empty` is a proof of `∅ᶜ = univ`.  In Mathlib, the name of this theorem is
`Set.compl_empty`. -/
TheoremDoc STG4.compl_empty as "compl_empty" in "ᶜ"

/-- $\emptyset^c = U$. -/
Statement compl_empty : (∅ : Set U)ᶜ = univ := by
  Hint (hidden := true) "As in the earlier levels of this world, you can prove an equation
  between sets with `apply Subset.antisymm`."
  apply Subset.antisymm
  intro x h
  Hint (hidden := true) "Every object is an element of `univ`."
  exact mem_univ x
  intro x h
  rewrite [mem_compl_iff]
  Hint (hidden := true) "Your goal is a negative statement, so try proof by contradiction."
  by_contra h2
  rewrite [mem_empty_iff_false] at h2
  exact h2

Conclusion
"
In the same way, you could prove that `univᶜ = ∅`.
"
