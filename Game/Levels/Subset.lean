import Game.Levels.Subset.L01exact
import Game.Levels.Subset.L02subhyp
import Game.Levels.Subset.L03have
import Game.Levels.Subset.L04imp
import Game.Levels.Subset.L05subref
import Game.Levels.Subset.L06subtrans
/-!

# Subset world

This file defines Subset World. Like all worlds, this world
has a name, a title, an introduction, and most importantly
a finite set of levels (imported above). Each level has a
level number defined within it, and that's what determines
the order of the levels.
-/
World "Subset"
Title "Subset World"
Image "images/world-subset.svg"

Introduction
"Welcome to Subset World! In this world you will learn about sets and
subsets, and you will also learn the basics of proving theorems in Lean.

The elements of the sets in this world will come from a universe called `U`:
the collection of all the objects we are talking about.

Two kinds of notation look alike but mean different things:

* `x : U` says what *kind* of thing `x` is: `x` is an object in the universe `U`.
Similarly, `A : Set U` says that `A` is a set of objects from `U`.  (Lean's
terminology is that `x` has *type* `U` and `A` has *type* `Set U`.)
These are declarations, not statements: there is nothing to prove about them.
* `x ∈ A` is a *statement*: it says that `x` is an element of the set `A`.
Like any statement, it may be true or false, so it can be assumed or proved.
(You can enter the symbol `∈` by typing `\\mem` or `\\in`, followed by a space.)

You will prove theorems in this game by using tools called *tactics*.
The aim is to prove the theorem by applying tactics
in the right order.

Let's learn some basic tactics. Click on \"Start\" below
to get started.
"
