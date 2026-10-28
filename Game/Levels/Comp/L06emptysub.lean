import Game.Levels.Comp.L05compsubiff

open Set

namespace STG4

variable {U : Type}

World "Complement"
Level 6
Title "The empty set"

Introduction
"
The *empty set*, written `∅`, is the set that has no elements at all.  (You can enter the
symbol `∅` by typing `\\empty`.)  Lean will recognize `mem_empty_iff_false x` as a proof of the
statement `x ∈ ∅ ↔ False`, where `False` is a statement that is never true.

In this level you'll prove that `∅` is a subset of every set.  The tricky part is the end of the
proof: once you know that `x ∈ ∅`, how can you prove that `x ∈ A`?  The answer is a principle
of logic sometimes called *ex falso*: from a contradiction, anything follows.  In Lean, the
tactic `exfalso` changes any goal to `False`.  That's useful when you have an assumption
`h : False`, because then `exact h` will close the goal.
"

/-- `∅` is the empty set: the set that has no elements.  You can enter the symbol `∅` by
typing `\empty`. -/
DefinitionDoc empty as "∅"

NewDefinition empty

/-- If your assumptions are contradictory, `exfalso` changes the goal to `False`.  That means you
can prove any goal from contradictory assumptions: first use `exfalso`, and then prove `False`.
For example, if you have `h : False`, then `exact h` will prove `False`, and if you have
`h1 : P` and `h2 : ¬P`, then `exact h2 h1` will prove `False`.

In a written proof, `exfalso` reads "It suffices to derive a contradiction." -/
TacticDoc exfalso

NewTactic exfalso

/-- For any `x`, `mem_empty_iff_false x` is a proof of the statement `x ∈ ∅ ↔ False`.  In
Mathlib, the name of this theorem is `Set.mem_empty_iff_false`. -/
TheoremDoc Set.mem_empty_iff_false as "mem_empty_iff_false" in "ᶜ"

NewTheorem Set.mem_empty_iff_false

TheoremTab "ᶜ"

/-- For any set `A`, `empty_subset A` is a proof of `∅ ⊆ A`.  In Mathlib, the name of this
theorem is `Set.empty_subset`. -/
TheoremDoc STG4.empty_subset as "empty_subset" in "ᶜ"

/-- For any set $A$, $\emptyset \subseteq A$. -/
Statement empty_subset (A : Set U) : ∅ ⊆ A := by
  Hint (hidden := true) "As with any subset statement, start with `intro x h`."
  intro x h
  Hint "Now write out what `{h}` means, using `rewrite [mem_empty_iff_false] at {h}`."
  rewrite [mem_empty_iff_false] at h
  Hint "Now `{h}` is a proof of `False`.  Use `exfalso` to change the goal to `False`."
  exfalso
  exact h

Conclusion
"
Since `∅` has no elements, the statement \"every element of `∅` is an element of `A`\" can't
fail.  Mathematicians say that a statement like this is *vacuously true*.
"
