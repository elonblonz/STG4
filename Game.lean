import Game.Levels.Subset
import Game.Levels.Comp
import Game.Levels.Inter
import Game.Levels.Union
import Game.Levels.Combo
import Game.Levels.Diff
import Game.Levels.FamInter
import Game.Levels.FamUnion
import Game.Levels.FamCombo

Title "Set Theory Game"
Introduction
"
# Welcome to the Set Theory Game
#### An introduction to mathematical proof.

In this game, you will solve a sequence of levels by proving theorems.

A *proof* is a chain of steps that leads from what you are given to what
you want to show, where every step is justified.  In each level the game
shows you the *givens* (the objects and assumptions you may use) and the
*goal* (the statement you must prove).  You make progress one step at a time,
and each step changes the givens or the goal, until nothing is left to prove.

Every step you take is checked by an interactive theorem prover called *Lean*.
Lean accepts a step only if it is fully justified, and it tells you at once
when something is wrong.  So you can experiment freely: a wrong step costs
nothing, and when Lean accepts your proof, you know it is correct.

The theorems in this game will be about sets.
A *set* is a collection of objects; the objects in the collection are
called *elements* of the set.  For example, the set of planets in our
solar system has eight elements:
Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, and Neptune.

# Read this.

Learning how to use an interactive theorem prover takes time.
You will get the most out of this game if you
read the help texts like this one.

To start, click on \"Subset World\".

## More

Open \"Game Info\" in the \"≡\" menu on the top right for resources,
links, and ways to interact with the Lean community.
"

Info
"
*Game version: 4.4*

## Progress saving

The game stores your progress in your local browser storage.
If you delete it, your progress will be lost!

Warning: In most browsers, deleting cookies will also clear the local storage
(or \"local site data\"). Make sure to download your game progress first!

## Credits

* **Creator:** Daniel J. Velleman; based on the Natural Numbers Game, by Kevin Buzzard
* **Game Engine:** Alexander Bentkamp, Jon Eugster, Patrick Massot
* **Spanish Translation:** Miguel Marco
* **Russian Translation:** Konstantin Belyanin

## Resources

* Daniel J. Velleman, *How To Prove It: A Structured Approach* (Cambridge University
Press): the proof techniques practised in this game, explained in depth.
* [How To Prove It with Lean](https://djvelleman.github.io/HTPIwL/): the same book's
ideas, written out in Lean.
* The [Lean Zulip chat](https://leanprover.zulipchat.com/) forum

## Problems?

Please ask any questions about this game in the
[Lean Zulip chat](https://leanprover.zulipchat.com/) forum, for example in
the stream \"New Members\". The community will happily help. Note that
the Lean Zulip chat is a professional research forum.
Please use your full real name there, stay on topic, and be nice. If you're
looking for somewhere less formal (e.g. you want to post set theory
game memes) then head on over to the [Lean Discord](https://discord.gg/WZ9bs9UCvx).

Alternatively, if you experience issues / bugs you can also open github issues:
* For issues with the game engine, please open an
[issue at the lean4game repo](https://github.com/leanprover-community/lean4game/issues).
* For issues about the game's content, please open an
[issue at the STG repo](https://github.com/djvelleman/STG4/issues).
"

Dependency Intersection → Union
Dependency FamInter → FamUnion
Dependency Combination → FamCombo
Dependency Combination → Difference

/-! Information to be displayed on the servers landing page. -/
Languages "en" "es" "ru"
CaptionShort "A game about set theory."
CaptionLong "In this game you will learn the basics of theorem proving in Lean by proving
theorems about unions, intersections, and complements of sets."
CoverImage "images/cover.png"

MakeGame
