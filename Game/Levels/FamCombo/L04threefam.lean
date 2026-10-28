import Game.Levels.FamCombo.L03commonelt

open Set

namespace STG4

variable {U : Type}

World "FamCombo"
Level 4
Title "A theorem about three families"

Introduction
"
Here's a theorem about three related families of sets.
"

/-- Suppose $F$, $G$, and $H$ are families of sets, and for every $s \in F$ there is some $u \in G$ such that $s \cap u \in H$.
Then $(\bigcup F) \cap (\bigcap G) \subseteq \bigcup H$. -/
Statement (F G H : Set (Set U)) (h1 : ∀ s ∈ F, ∃ u ∈ G, s ∩ u ∈ H) : (⋃₀ F) ∩ (⋂₀ G) ⊆ ⋃₀ H := by
  Hint "Start by introducing `x` and the assumption `x ∈ (⋃₀ F) ∩ (⋂₀ G)`, and then separate
  that assumption into its left and right halves."
  intro x h2
  rewrite [mem_inter_iff] at h2
  have h2l := h2.left
  have h2r := h2.right
  rewrite [mem_sUnion] at h2l
  obtain ⟨t, ht⟩ := h2l
  Hint (hidden := true) "Now you have `{ht} : {t} ∈ F ∧ {x} ∈ {t}`.  What do you get if you apply `{h1}` to `{t}` and
  `{ht}.left`?"
  have h3 := h1 t ht.left
  obtain ⟨u, hu⟩ := h3
  rewrite [mem_sInter] at h2r
  have h3 := h2r u hu.left
  Hint (hidden := true) "Which set in `H` contains `{x}`?  Look at `{hu}.right`."
  rewrite [mem_sUnion]
  use t ∩ u
  apply And.intro hu.right
  rewrite [mem_inter_iff]
  exact And.intro ht.right h3

Conclusion
"
Choosing the right witness, `t ∩ u`, was the key step in this proof.
"
