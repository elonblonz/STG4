import Game.Levels.FamCombo.L01compunion

open Set

namespace STG4

variable {U : Type}

World "FamCombo"
Level 2
Title "Complement of a family intersection"

Introduction
"
Perhaps you have already guessed that there is a theorem about the complement
of an intersection of a family that is similar to the theorem in the last level.
"

/-- For any family of sets $F$, $(\bigcap F)^c = \bigcup \{s \mid s^c \in F\}$. -/
Statement (F : Set (Set U)) : (⋂₀ F)ᶜ = ⋃₀ {s | sᶜ ∈ F} := by
  ext x
  apply Iff.intro
  intro h1
  rewrite [mem_compl_iff] at h1
  Hint (hidden := true) "`{h1}` says that `{x}` is not in every set of `F`.  Write out `⋂₀` with
  `rewrite [mem_sInter] at {h1}` and use `push_neg at {h1}`: that gives you a set in `F` that
  doesn't contain `{x}`."
  Branch
    rewrite [mem_sUnion]
    by_contra h2
    Hint (strict := true) "What statement would you like to contradict to complete the proof?"
    apply h1
    rewrite [mem_sInter]
    intro t h3
    by_contra h4
    Hint "Now what statement would you like to contradict to complete the proof?"
  Branch
    by_contra h2
    Hint (strict := true) "What statement would you like to contradict to complete the proof?"
    apply h1
    rewrite [mem_sInter]
    intro t h3
    by_contra h4
    Hint "Now what statement would you like to contradict to complete the proof?"
  rewrite [mem_sInter] at h1
  push_neg at h1
  obtain ⟨t, ht⟩ := h1
  use tᶜ
  rewrite [mem_setOf, compl_compl, mem_compl_iff]
  exact ht
  intro h1
  rewrite [mem_compl_iff, mem_sInter]
  push_neg
  rewrite [mem_sUnion] at h1
  obtain ⟨u, hu⟩ := h1
  use uᶜ
  apply And.intro
  rewrite [mem_setOf] at hu
  exact hu.left
  rewrite [mem_compl_iff]
  push_neg
  exact hu.right

Conclusion
"
And this is the other De Morgan law for families.  Compare these two proofs with your proofs of
De Morgan's laws in Combination World.
"
