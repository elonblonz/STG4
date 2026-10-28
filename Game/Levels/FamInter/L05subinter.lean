import Game.Levels.FamInter.L04interunion

open Set

namespace STG4

variable {U : Type}

World "FamInter"
Level 5
Title "Subset of a family intersection"

Introduction
"
If `A` is a set and `F` is a family of sets, under what circumstances is it the case
that `A ⊆ ⋂₀ F`?  In this level you'll discover the answer to that question.
"

/-- If `A` is a set and `F` is a family of sets, then `subset_sInter_iff A F` is a proof of
`A ⊆ ⋂₀ F ↔ ∀ s ∈ F, A ⊆ s`.  In Mathlib, the name of this theorem is `Set.subset_sInter_iff`. -/
TheoremDoc STG4.subset_sInter_iff as "subset_sInter_iff" in "⋂₀⋃₀"

/-- Suppose $A$ is a set and $F$ is a family of sets.  Then $A$ is a subset of $\bigcap F$ if
and only if $A$ is a subset of every element of $F$.-/
Statement subset_sInter_iff (A : Set U) (F : Set (Set U)) : A ⊆ ⋂₀ F ↔ ∀ s ∈ F, A ⊆ s := by
  apply Iff.intro
  intro h1
  Hint (hidden := true) "The goal starts with `∀ s ∈ F`, so `intro s h2` will introduce a set `s` and the assumption
  `h2 : s ∈ F`."
  intro s h2
  intro x h3
  have h4 : x ∈ ⋂₀ F := h1 h3
  rewrite [mem_sInter] at h4
  exact h4 s h2
  Hint "Notice that the parentheses in the next goal are necessary, to indicate that the universal
  quantifier applies only to `A ⊆ s`, and not to `A ⊆ ⋂₀ F`.  Without the parentheses, Lean would interpret
  the universal quantifier as applying to the entire rest of the statement."
  intro h1
  intro x h2
  rewrite [mem_sInter]
  intro t h3
  Hint (hidden := true) "Applying `{h1}` to `{t}` and `{h3}` will give you `A ⊆ {t}`."
  have h4 : A ⊆ t := h1 t h3
  exact h4 h2

Conclusion
"
This theorem says that `⋂₀ F` is the *largest* set that is a subset of every element of `F`.  Look
out for its mirror image, about `⋃₀`, in Family Union World.
"
