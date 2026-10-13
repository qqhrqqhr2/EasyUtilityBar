# EasyUtilityBar

A compact, multilingual utility bar addon for WoW Forever (Interface 16001).

## Features
- Groups usable bag items: bombs, engineering, potions, food, bandages, camping, quest items, equipped on-use items and more.
- Profession skills, class utility spells and shapeshifting/stances.
- Collapsible categories with persistent state; icon size, column count, opacity and mouseover fade.
- Hide individual icons (reveal the outline via the title, then click an icon's x while unlocked).
- Korean, English, Simplified/Traditional Chinese, Russian, German and Spanish.
- Move with Ctrl + left-drag; `/eub` or `/fub` for options.

## Installation
Extract the release ZIP into your WoW Forever `Interface/AddOns/` directory, so that `EasyUtilityBar/EasyUtilityBar.toc` exists.

## Publishing
This repository targets CurseForge project **1741884**. The `.github/workflows/release.yml` workflow runs for tags matching `v*` and uses the GitHub Actions secret `CF_API_KEY` (the project ID is set in the workflow).

Source files must be at repository root (e.g. `EasyUtilityBar.toc`, `Core.lua`, `Locales/`, `Media/`); the packager makes the `EasyUtilityBar` addon directory in the ZIP.

**Do not create a release tag until the addon source is present and the secrets are configured.** CurseForge may require separate project/file approval.

Support: https://buymeacoffee.com/qqhrqqhr2
