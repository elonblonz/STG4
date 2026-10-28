import Game.Levels.FamUnion.L02subunion

open Set

namespace STG4

variable {U : Type}

World "FamUnion"
Level 3
Title "Union of larger family is larger"

Introduction
"
In this level we have two families of sets, `F` and `G`, with `F ⊆ G`.  In Family Intersection
World, you proved that in this situation, `⋂₀ G ⊆ ⋂₀ F`.  In this level, you'll prove that
with family unions, it works the other way: `⋃₀ F ⊆ ⋃₀ G`.

We'll need a new tactic for this proof.  An assumption of the form `h : ∃ x, P x` tells you that
an object with a certain property exists.  If you have such an assumption, then it is usually
helpful to introduce a name for such an object.  You can do this with the `obtain` tactic.  If
you write `obtain ⟨w, hw⟩ := h`, then Lean will introduce a new object `w` and a new assumption
`hw : P w`.  Thus, the object `w` is a witness for the existential assumption `h`.  Note that
in the `obtain` tactic, `w` and `hw` must be enclosed in angle brackets: `⟨ ⟩`.  You can
enter these by typing either `\\<` and `\\>` or `\\langle` and `\\rangle`.
"

/-- If you have an assumption `h : ∃ x, P x`, then the tactic `obtain ⟨w, hw⟩ := h` will
introduce a new object `w` and a new assumption `hw : P w` into the proof.  To enter the
angle brackets `⟨ ⟩`, type either `\<` and `\>` or `\langle` and `\rangle`.

In a written proof, `obtain ⟨w, hw⟩ := h` reads "Choose `w` such that …". -/
TacticDoc obtain

NewTactic obtain

/-- Suppose $F$ and $G$ are families of sets and $F \subseteq G$.
Then $\bigcup F \subseteq \bigcup G$. -/
Statement (F G : Set (Set U)) (h1 : F ⊆ G) : ⋃₀ F ⊆ ⋃₀ G := by
  intro x h2
  rewrite [mem_sUnion]
  rewrite [mem_sUnion] at h2
  Hint "The assumption `{h2}` is now an existential statement.  Thus, `obtain ⟨s, hs⟩ := {h2}`
  will introduce a new object `s` and a new assumption `hs : s ∈ F ∧ {x} ∈ s` into the proof.
  Once the witness `s` has been introduced, the assumption `{h2}` becomes redundant, so it is
  deleted."
  obtain ⟨s, hs⟩ := h2
  Hint (hidden := true) "Do you see why `{s}` is the value to use as a witness for `t` in the goal?
  Your next step can be either `apply Exists.intro {s}` or `use {s}`."
  apply Exists.intro s
  have h2 : s ∈ G := h1 hs.left
  exact And.intro h2 hs.right

Conclusion
"
**The proof, written out.**

> Suppose `F ⊆ G`, and let `x` be an arbitrary element of `⋃₀ F`.  Then there is some set in
> `F` that contains `x`; choose such a set `s`, so `s ∈ F` and `x ∈ s`.  Since `F ⊆ G`, `s ∈ G`.
> So `s` is a set in `G` that contains `x`, and therefore `x ∈ ⋃₀ G`.  Since `x` was arbitrary,
> `⋃₀ F ⊆ ⋃₀ G`.

`obtain ⟨s, hs⟩ := h2` is the sentence \"choose such a set `s`\": an assumption that something
exists lets you give a name to one example of it.

Compare this with Family Intersection World, where you showed that the intersection of a larger
family is *smaller*.
"
