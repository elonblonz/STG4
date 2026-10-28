import Game.Levels.Union

open Set

namespace STG4

variable {U : Type}

World "Combination"
Level 1
Title "Complement of a union"

Introduction
"
There is more than one way to do the proof in this level.  Since the proof involves complements of
sets, negative statements will arise in the course of the proof.  This suggests two possible techniques.
You may be able to use the `push_neg` tactic to reexpress some negative statements as equivalent
positive statements.  And you may find proof by contradiction useful.

![Diagram: (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ](images/combo-demorgan.svg)
"

TheoremTab "ᶜ"

/-- For any sets `A` and `B`, `compl_union A B` is a proof of the
statement `(A ∪ B)ᶜ = Aᶜ ∩ Bᶜ`.  In Mathlib, the name of this theorem is `Set.compl_union`. -/
TheoremDoc STG4.compl_union as "compl_union" in "ᶜ"

/-- For any sets $A$ and $B$, $(A \cup B)^c = A^c \cap B^c$. -/
Statement compl_union (A B : Set U) : (A ∪ B)ᶜ = Aᶜ ∩ Bᶜ := by
  Hint "To prove that two sets are equal, start with `ext x`.  The goal will then be an
  `↔` statement about `x`."
  ext x
  rewrite [mem_compl_iff, mem_union]
  rewrite [mem_inter_iff, mem_compl_iff, mem_compl_iff]
  Hint (hidden := true) "Prove the two directions of the `↔` separately, starting with
  `apply Iff.intro`."
  apply Iff.intro
  intro h
  Hint (hidden := true) "`{h}` is a negative statement.  Try `push_neg at {h}`."
  push_neg at h
  exact h
  intro h
  Hint (hidden := true) "This time the goal is a negative statement, so try `push_neg`."
  push_neg
  exact h

Conclusion
"
This theorem is one of *De Morgan's laws*.  In the next level you'll prove its mirror image, about the
complement of an intersection.
"
