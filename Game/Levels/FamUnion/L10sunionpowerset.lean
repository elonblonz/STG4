import Game.Levels.FamUnion.L09powersetinter

open Set

namespace STG4

variable {U : Type}

World "FamUnion"
Level 10
Title "Union of a power set"

Introduction
"
In this last level of Family Union World, you'll find out what you get if you take the union
of all of the subsets of `A`.
"

/-- For any set $A$, $\bigcup \mathscr{P}(A) = A$. -/
Statement (A : Set U) : ⋃₀ (𝒫 A) = A := by
  ext x
  apply Iff.intro
  intro h
  rewrite [mem_sUnion] at h
  obtain ⟨S, hS⟩ := h
  have h2 := hS.left
  rewrite [mem_powerset_iff] at h2
  Hint (hidden := true) "`{h2}` says `{S} ⊆ A`, and `{hS}.right` says `{x} ∈ {S}`."
  exact h2 hS.right
  intro h
  rewrite [mem_sUnion]
  Hint "Which subset of `A` contains `{x}`?"
  apply Exists.intro A
  apply And.intro
  rewrite [mem_powerset_iff]
  exact Subset.refl A
  exact h

Conclusion
"
Every element of `A` belongs to some subset of `A` (for example, `A` itself), and every subset of
`A` only contains elements of `A`.  So the union of all the subsets of `A` is exactly `A`.
"
