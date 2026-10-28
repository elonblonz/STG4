import Game.Levels.FamUnion.L07eltwiseinter

open Set

namespace STG4

variable {U : Type}

World "FamUnion"
Level 8
Title "Power sets"

Introduction
"
If `A` is a set, then the *power set* of `A`, written `𝒫 A`, is the family of all subsets of `A`.
(You can enter the symbol `𝒫` by typing `\\powerset`.)  So if `S` is a set, then `S ∈ 𝒫 A` means
the same thing as `S ⊆ A`.  Lean will recognize `mem_powerset_iff S A` as a proof of the
statement `S ∈ 𝒫 A ↔ S ⊆ A`.

Notice that if `A : Set U`, then `𝒫 A : Set (Set U)`: a power set is a family of sets.
"

/-- If `A` is a set, then `𝒫 A` is the *power set* of `A`: the family of all subsets of `A`.
You can enter the symbol `𝒫` by typing `\powerset`. -/
DefinitionDoc powerset as "𝒫"

NewDefinition powerset

/-- If `S` and `A` are sets, then `mem_powerset_iff S A` is a proof of the statement
`S ∈ 𝒫 A ↔ S ⊆ A`.  In Mathlib, the name of this theorem is `Set.mem_powerset_iff`. -/
TheoremDoc Set.mem_powerset_iff as "mem_powerset_iff" in "⋂₀⋃₀"

NewTheorem Set.mem_powerset_iff

TheoremTab "⋂₀⋃₀"

/-- Suppose $A \subseteq B$.  Then $\mathscr{P}(A) \subseteq \mathscr{P}(B)$. -/
Statement (A B : Set U) (h1 : A ⊆ B) : 𝒫 A ⊆ 𝒫 B := by
  Hint (hidden := true) "The elements of `𝒫 A` are sets, so start with `intro S h2`."
  intro S h2
  Hint (hidden := true) "Write out what `{h2}` and the goal mean, using `mem_powerset_iff`."
  rewrite [mem_powerset_iff] at h2
  rewrite [mem_powerset_iff]
  intro x h3
  have h4 : x ∈ A := h2 h3
  exact h1 h4

Conclusion
"
The converse is also true: if `𝒫 A ⊆ 𝒫 B`, then `A ⊆ B`.  Can you see why?  (Hint: `A ∈ 𝒫 A`.)

How big is a power set?  If `A` has `n` elements, then `𝒫 A` has `2ⁿ` elements: a subset of
`A` is determined by deciding, for each of the `n` elements of `A`, whether it is in or out.
"
