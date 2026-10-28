import Game.Levels.FamUnion.L04unionpair

open Set

namespace STG4

variable {U : Type}

World "FamUnion"
Level 5
Title "Union of a union"

Introduction
"
In this level, `F` and `G` are families of sets, and you'll work out how `⋃₀ (F ∪ G)` is related
to `⋃₀ F` and `⋃₀ G`.
"

/-- Suppose $F$ and $G$ are families of sets.  Then $\bigcup (F \cup G) =
(\bigcup F) \cup (\bigcup G)$. -/
Statement (F G : Set (Set U)) : ⋃₀ (F ∪ G) = (⋃₀ F) ∪ (⋃₀ G) := by
  ext x
  apply Iff.intro
  intro h1
  rewrite [mem_sUnion] at h1
  obtain ⟨t, h1⟩ := h1
  Hint "`{h1}.left` says `{t} ∈ F ∪ G`.  Writing out what that means will tell you how to split
  the proof into cases."
  rewrite [mem_union]
  rewrite [mem_union] at h1
  rcases h1.left with hF | hG
  left
  Hint (hidden := true) "Now `{t}` is a set in `F` that contains `{x}`."
  rewrite [mem_sUnion]
  use t
  exact And.intro hF h1.right
  right
  use t
  exact And.intro hG h1.right
  intro h1
  rewrite [mem_union] at h1
  rewrite [mem_sUnion]
  rcases h1 with hF | hG
  Hint (hidden := true) "In each case, `obtain` will give you a set `t` that you can use as the witness for the goal."
  obtain ⟨t, h1⟩ := hF
  use t
  apply And.intro
  exact Or.inl h1.left
  exact h1.right
  obtain ⟨t, h1⟩ := hG
  use t
  apply And.intro
  exact Or.inr h1.left
  exact h1.right

Conclusion
"
Compare this with the theorem `⋂₀ (F ∪ G) = (⋂₀ F) ∩ (⋂₀ G)` from Family Intersection World.  The two
theorems are mirror images of each other.
"
