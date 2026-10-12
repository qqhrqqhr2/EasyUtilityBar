# EasyUtilityBar

A compact, multilingual utility bar addon for WoW Forever (Interface 16001).

## Features
- Groups usable bag items: bombs, engineering, potions, food, bandages, camping, quest items, trinkets and more.
- Profession skills, class utility spells and shapeshifting/stances.
- Collapsible categories with persistent state; icon size and column count.
- Korean, English, Simplified/Traditional Chinese, Russian, German and Spanish.
- Move with Ctrl + left-drag; `/eub` or `/fub` for options.

## Installation
Extract the release ZIP to `World of Warcraft/_classic_/Interface/AddOns/` so that `EasyUtilityBar/EasyUtilityBar.toc` exists.

## Publishing
A tag `vX.Y.Z` triggers GitHub Actions / BigWigs packager to publish GitHub Releases and CurseForge.
Set repository secrets `CF_API_KEY` and `CF_PROJECT_ID` after creating the CurseForge project. The first CurseForge project submission must be approved separately.
Source files should be at repository root (e.g. `EasyUtilityBar.toc`, `Core.lua`, `Locales/`, `Media/`), not nested in an `EasyUtilityBar` folder. The packager creates that folder in the ZIP.

Support: https://buymeacoffee.com/qqhrqqhr2
