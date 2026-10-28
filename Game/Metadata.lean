import GameServer
import Mathlib.Tactic.Common
import Mathlib.Tactic.Have
import Mathlib.Data.Set.Basic
import Mathlib.Data.Set.Lattice.Bounded
import Mathlib.Data.Set.Lattice.Disjoint
import Mathlib.Data.Set.Lattice.Image
import Mathlib.Data.Set.Lattice.Indexed
import Mathlib.Data.Set.Lattice.Order
import Mathlib.Order.SymmDiff

attribute [default_instance] Set.instSingletonSet

-- Mathlib's `∆` notation is scoped, but the game engine elaborates levels outside the level
-- file's scope, so a scoped notation fails at play time. Make it global instead.
infixl:100 " ∆ " => symmDiff

-- Mathlib deprecated `push_neg` in favour of `push Not`. The game teaches `push_neg`, so
-- run `push Not` directly (taking precedence over Mathlib's version) to spare players the
-- warning. This must never throw: if it did, Lean would fall back to Mathlib's deprecated
-- version, so errors are logged instead.
open Lean Elab Tactic Parser.Tactic in
elab_rules : tactic
  | `(tactic| push_neg $cfg:optConfig $[$loc:location]?) => do
    try evalTactic (← `(tactic| push $cfg:optConfig Not $[$loc]?))
    catch e =>
      -- Players know this tactic as `push_neg`, not `push Not`.
      let msg := (← e.toMessageData.toString).replace "`push Not`" "`push_neg`"
      logErrorAt e.getRef msg

/-! Imports and settings shared by every level.

The `default_instance` attribute makes `{a}` elaborate as a singleton `Set` (used in
FamInter and FamCombo) without needing a type ascription.

Note: the game engine misbehaves if levels of different worlds are imported in an arbitrary
order, so keep the structure of one file per world (`Game/Levels/<World>.lean`) that imports
all of that world's levels, with each world's first level importing the previous world.
-/
