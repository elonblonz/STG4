import Game.Levels.FamInter.L05subinter

open Set

namespace STG4

variable {U : Type}

World "FamInter"
Level 6
Title "Intersection of a family of unions"

Introduction
"
In this level you'll need a new kind of proof by cases.  For any statement `P`, the
tactic `by_cases h : P` will break the proof into two cases.  In the first case, the new
assumption `h : P` is added to the list of assumptions, and in the second, the new
assumption `h : ¬P` is added.  Since `P` must be either true or false, these two cases cover
all possibilities.
"

/-- The tactic `by_cases h : P` breaks the proof into two cases.  In the first case, the
assumption `h : P` is added to the list of assumptions, and in the second case, the
assumption `h : ¬P` is added.

In a written proof, `by_cases h : P` reads "Either `P` is true or it isn't.  *Case 1:* `P` … *Case 2:* `¬P` …". -/
TacticDoc by_cases

NewTactic by_cases

/-- Suppose $A$ is a set, $F$ and $G$ are families of sets, and for every set $s$ in $F$,
$A \cup s \in G$.  Then $\bigcap G \subseteq A \cup (\bigcap F)$.-/
Statement (A : Set U) (F G : Set (Set U)) (h1 : ∀ s ∈ F, A ∪ s ∈ G) : ⋂₀ G ⊆ A ∪ (⋂₀ F) := by
  intro x h2
  Hint "Writing out the meaning of the goal will make the proof easier to understand."
  rewrite [mem_union]
  Hint (strict := true) "If `{x} ∈ A`, then the goal is easy to prove.  This suggests breaking
  the proof into cases depending on whether or not `{x} ∈ A`.  You can do this with the tactic
  `by_cases hA : {x} ∈ A`."
  by_cases hA : x ∈ A
  Hint "The first case is the easy one."
  exact Or.inl hA
  Hint "For the second case, which half of the goal do you think you should try to prove?
  You can use `apply Or.inl` or `apply Or.inr` (or the equivalent tactics `left` or `right`)
  to specify what goal you're going to prove."
  apply Or.inr
  rewrite [mem_sInter]
  intro t h4
  Hint (strict := true) (hidden := true) "Now use `h1`."
  have h5 : A ∪ t ∈ G := h1 t h4
  Hint (strict := true) (hidden := true) "You haven't used `{h2}` yet.  If you don't see how to use it,
  write out its definition."
  rewrite [mem_sInter] at h2
  Hint (strict := true) (hidden := true) "Note that you can apply `{h2}` to `(A ∪ {t})`.
  You'll need to include the parentheses around `A ∪ {t}` when you do that."
  have h6 : x ∈ A ∪ t := h2 (A ∪ t) h5
  rewrite [mem_union] at h6
  rcases h6 with hA2 | ht
  Hint (hidden := true) "Notice that you have contradictory assumptions.  You can prove anything
  from contradictory assumptions.  Do you see how?"
  by_contra h6
  exact hA hA2
  exact ht

Conclusion
"
**The proof, written out.**

> Let `x` be an arbitrary element of `⋂₀ G`.  We must show that `x ∈ A` or `x ∈ ⋂₀ F`.  If
> `x ∈ A`, we are done, so suppose `x ∉ A`; we show that `x ∈ ⋂₀ F`.  Let `t` be an arbitrary
> set in `F`.  By assumption `A ∪ t ∈ G`, and since `x` belongs to every set in `G`,
> `x ∈ A ∪ t`.  As `x ∉ A`, it follows that `x ∈ t`.  Since `t` was arbitrary, `x ∈ ⋂₀ F`.

This shows a useful strategy for proving an \"or\" statement: consider whether the first part is
true (that is what `by_cases` does).  If it is, you're done; if not, you have an extra assumption
to help you prove the second part.

You've finished Family Intersection World!  As you might guess, you can also take the union of
a family of sets.  Can you guess how to define it?  Continue on to Family Union World to see
if your guess is right.
"
