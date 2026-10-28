import Game.Levels.Combo

open Set

namespace STG4

variable {U : Type}

World "Difference"
Level 1
Title "The definition of difference"

Introduction
"
If `A` and `B` are sets, then `A \\ B` is the set of objects that are elements of `A` but not
elements of `B`.  So for any `x`, the statements `x ∈ A \\ B` and `x ∈ A ∧ x ∉ B` mean the same
thing.  As with complements, that means the theorem in this level can be proven with `rfl`.
"

/-- If `A` and `B` are sets, then `A \ B` is the set of objects that are elements of `A` but
not elements of `B`.  To enter the backslash in `A \ B`, type `\setminus` (or two backslashes). -/
DefinitionDoc diff as "\\"

NewDefinition diff

TheoremTab "\\"

/-- If you have `x : U`, `A : Set U`, and `B : Set U`, then `mem_diff x A B` is a proof of the
statement `x ∈ A \ B ↔ x ∈ A ∧ x ∉ B`.  In Mathlib, the name of this theorem is `Set.mem_sdiff`. -/
TheoremDoc STG4.mem_diff as "mem_diff" in "\\"

/-- Let $x$ be an object in the universe $U$, and let $A$ and $B$ be sets whose elements come
from $U$.  Then $x \in A \setminus B \leftrightarrow x \in A \wedge x \notin B$. -/
Statement mem_diff (x : U) (A B : Set U) : x ∈ A \ B ↔ x ∈ A ∧ x ∉ B := by
  Hint "The two sides of the `↔` mean the same thing by definition, so `rfl` will close the goal."
  rfl

Conclusion
"
Now you can use `rewrite [mem_diff]` to write out the definition of `x ∈ A \\ B`.
"
