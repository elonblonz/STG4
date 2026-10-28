import Game.Levels.FamUnion.L08powerset

open Set

namespace STG4

variable {U : Type}

World "FamUnion"
Level 9
Title "Power set of an intersection"

Introduction
"
How is the power set of `A ∩ B` related to the power sets of `A` and `B`?
"

TheoremTab "⋂₀⋃₀"

/-- For any sets `A` and `B`, `powerset_inter A B` is a proof of `𝒫 (A ∩ B) = 𝒫 A ∩ 𝒫 B`.  In
Mathlib, the name of this theorem is `Set.powerset_inter`. -/
TheoremDoc STG4.powerset_inter as "powerset_inter" in "⋂₀⋃₀"

/-- For any sets $A$ and $B$, $\mathscr{P}(A \cap B) = \mathscr{P}(A) \cap \mathscr{P}(B)$. -/
Statement powerset_inter (A B : Set U) : 𝒫 (A ∩ B) = 𝒫 A ∩ 𝒫 B := by
  Hint (hidden := true) "The elements of these families are sets, so start with `ext S`."
  ext S
  rewrite [mem_inter_iff, mem_powerset_iff, mem_powerset_iff, mem_powerset_iff]
  apply Iff.intro
  intro h
  apply And.intro
  intro x h2
  have h3 := h h2
  rewrite [mem_inter_iff] at h3
  exact h3.left
  intro x h2
  have h3 := h h2
  rewrite [mem_inter_iff] at h3
  exact h3.right
  intro h
  intro x h2
  rewrite [mem_inter_iff]
  Hint (hidden := true) "Apply `{h}.left` and `{h}.right` to `{h2}`."
  have hA : x ∈ A := h.left h2
  have hB : x ∈ B := h.right h2
  exact And.intro hA hB

Conclusion
"
In other words, a set is a subset of `A ∩ B` exactly when it is a subset of both `A` and `B`.
Is the corresponding statement about `𝒫 (A ∪ B)` true?  (Hint: think about `A ∪ B` itself.)
"
