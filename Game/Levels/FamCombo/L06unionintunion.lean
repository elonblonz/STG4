import Game.Levels.FamCombo.L05unionintcompunion

open Set

namespace STG4

variable {U : Type}

World "FamCombo"
Level 6
Title "A subset of a union intersected with the complement of another"

Introduction
"
What happens if the subset statement in the last level is reversed?
"

/-- Suppose $F$ and $G$ are families of sets and $\bigcup (F \cap G^c) \subseteq (\bigcup F)
\cap (\bigcup G)^c$.  Then $(\bigcup F) \cap (\bigcup G) \subseteq \bigcup (F \cap G)$.-/
Statement (F G : Set (Set U)) (h1 : ⋃₀ (F ∩ Gᶜ) ⊆ (⋃₀ F) ∩ (⋃₀ G)ᶜ) :
    (⋃₀ F) ∩ (⋃₀ G) ⊆ ⋃₀ (F ∩ G) := by
  Hint (hidden := true) "**The idea.**  Take `x` in both unions, and choose a set `t ∈ F` with `x ∈ t`.  This
  `t` will be the witness, so you need to show that `t ∈ G`.  Suppose it isn't.  Then `t ∈ F ∩ Gᶜ`,
  so `x ∈ ⋃₀ (F ∩ Gᶜ)`, and by `h1`, `x ∉ ⋃₀ G`.  That contradicts `x ∈ ⋃₀ G`."
  intro x h2
  have h2l := h2.left
  have h2r := h2.right
  rewrite [mem_sUnion] at h2l
  obtain ⟨t, ht⟩ := h2l
  Hint "`{t}` is the natural witness for the goal.  The hard part will be showing that `{t} ∈ G`."
  use t
  apply And.intro
  apply And.intro
  exact ht.left
  by_contra h3
  Hint (hidden := true) "If `{t} ∉ G`, then `{x} ∈ ⋃₀ (F ∩ Gᶜ)`.  Use `have` to assert that, and then see what `{h1}`
  tells you."
  have h4 : x ∈ ⋃₀ (F ∩ Gᶜ)
  use t
  apply And.intro
  apply And.intro
  exact ht.left
  rewrite [mem_compl_iff]
  exact h3
  exact ht.right
  have h5 := h1 h4
  Hint (hidden := true) "`{h5}.right` says `{x} ∈ (⋃₀ G)ᶜ`.  Does that contradict anything you know?"
  have h5r := h5.right
  rewrite [mem_compl_iff] at h5r
  exact h5r h2r
  exact ht.right

Conclusion
"
The reverse of the subset statement from the last level is not true for all families `F` and `G`.
This level shows that when it does hold, every element of `(⋃₀ F) ∩ (⋃₀ G)` belongs to some set
that is in both `F` and `G`.
"
