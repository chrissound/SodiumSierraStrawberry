# SodiumSierraStrawberry

Fighting path reading fatigue one path at a time! The revolution starts now!

![example](/.demo/example.png)

## What problem does this solve?
It makes it easier to read a long path. It'll save you approximately 6ms* each time you try to read a path with your eyes, and comprehend it with your brain.

It does this by applying two types of transformations:
- search and replace (these are set in `$XDG_CONFIG_HOME/sodiumSierraStrawberry/config.json` - aka `~/.config/sodiumSierraStrawberry`)
- intelligent(?) directory truncation (this can be adjusted with the `--limit` parameter) 

### Examples: 

From: `/home/sodium/Projects/Personal/Sierra`

To: `»Projects/Sierra`

---

From: `/home/sodium/Projects/Personal/Sierra/Super/Long/Path/HolyAvacado`

To: `»Projects/Sie…/Sup…/Lon…/Pat…/HolyAvacado/`

## What are the limitations?

You need to use the `»` char to 'prevent' that path segment from being truncated. It's hardcoded!

## Installation

Copy the static binary: `TODO!!! ???`

### Wtf no, I'll compile it myself.

You'll need to know how to compile Haskell projects:

`stack install`

**Terms and conditions apply*
