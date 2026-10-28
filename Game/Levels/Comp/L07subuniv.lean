import Game.Levels.Comp.L06emptysub

open Set

namespace STG4

variable {U : Type}

World "Complement"
Level 7
Title "The universe"

Introduction
"
At the other extreme from `∅` is the set of *all* objects in the universe `U`.  Lean calls this
set `univ`.  Every object `x : U` is an element of `univ`: Lean will recognize `mem_univ x` as a
proof of `x ∈ univ`.
"

/-- `univ` is the set of all objects in the universe `U`.  Every object `x : U` is an element
of `univ`. -/
DefinitionDoc univ as "univ"

NewDefinition univ

/-- For any `x`, `mem_univ x` is a proof of `x ∈ univ`.  In Mathlib, the name of this theorem is
`Set.mem_univ`. -/
TheoremDoc Set.mem_univ as "mem_univ" in "ᶜ"

NewTheorem Set.mem_univ

TheoremTab "ᶜ"

/-- For any set `A`, `subset_univ A` is a proof of `A ⊆ univ`.  In Mathlib, the name of this
theorem is `Set.subset_univ`. -/
TheoremDoc STG4.subset_univ as "subset_univ" in "ᶜ"

/-- For any set $A$, $A \subseteq U$. -/
Statement subset_univ (A : Set U) : A ⊆ univ := by
  intro x h
  Hint (hidden := true) "You don't need the assumption `{h}`: `mem_univ {x}` proves the goal."
  exact mem_univ x

Conclusion
"
So every set is a subset of `univ`, and `∅` is a subset of every set.  In the next level you'll
see how `∅` and `univ` are related by complements.
"
