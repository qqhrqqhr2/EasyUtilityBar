## 0.5.6
- Fix: engineering devices are now recognized (tooltip "Requires Engineering" or Devices subtype); explosives go to Bombs.
- Fix: no Lua errors when the client returns protected (secret) cooldown or usability values in combat; the cooldown swipe is drawn from them directly.
- Fix: item counts show the total of all stacks, and update live (also in combat).
- Fix: equippable items in bags are no longer listed (clicking them would equip them).
- Fix: items whose info was not cached at login are re-sorted once the info arrives.
- Fix: Korean/Chinese blessings such as "왕의 축복" and "Greater Blessing of Kings" are recognized.
- Fix: Russian text matching (spell names, "Использование:" lines) is now case-insensitive.
- New: hide individual icons — reveal the outline via the title, then click the small x on an icon (unlocked bar). Restore them in settings.
- New: opacity setting (30–100%) and "Show only on mouseover" fade.
- New: the Equipped Items group now includes every worn slot with a Use effect (engineering helms, boots, gloves...), not only trinkets.
- Design: hover glow and pressed state on icons, item quality border colors, more compact settings window.
- Settings panel, chat messages and slash replies follow the selected language; version is read from the TOC.

## 0.5.5
- Category headings can be toggled only when the toolbar outline is revealed via title hover.
- Empty transparent toolbar space passes mouse clicks to the game world.

## 0.5.2
- Added German (deDE) and Spanish (esES/esMX) translations for categories, settings, and tooltips.
- Added automatic locale selection and manual language choices.

## 0.5.0
- Preserve each category's expanded/collapsed state through /reload and future logins using EUB_DB.collapsed.
- Initialize new categories without resetting existing saved states.

## 0.4.8
- Add a separate Camping item category, including localization for all supported languages.
- Detect camping-related usable items by their item names, with conservative matching to avoid moving unrelated items.
- Camping can be enabled or disabled in settings and participates in unified mode.

## 0.4.7
- Expand class utility recognition for future level-cap increases, using learned spellbook entries rather than a level cutoff.
- Add recovery, travel, exploration, pet care, conjuration and support skills.
- Keep forms/stances separate; exclude unlearned and passive skills.

## 0.4.6
- Restore stealth, sprint, tracking, summoning, blessing, conjuration, lockpicking and pet skills to class skills.
- Keep resurrection, recall, portal and teleport skills; forms/stances stay in their own group.

## 0.4.5
- Limit class skills to resurrection, recall, portal and teleport families.

## 0.4.4
- Ctrl + left-drag on the title moves the toolbar whether it is locked or unlocked.
- Lock still prevents resizing.

## 0.3.9
- New settings window design with gold accents and a two-column category list; drag the title to move it.

## 0.3.8
- Removed the move icon; move the toolbar by Ctrl + dragging the addon name.

## 0.3.5
- Pass item tokens as strings to secure action buttons to prevent C_Item.IsEquippableItem argument errors.
- Use inventory slot actions for equipped on-use trinkets; exclude passive/proc-only trinkets.

## 0.3.3
- Item and spell cooldown swipes/countdowns; unusable or resource-limited icons are dimmed.

## 0.3.2
- Dark charcoal panels, restrained gold highlights and slim section accents.

## 0.2.7
- Separate group for class forms and stances (druid forms, warrior stances, stealth, hunter aspects, paladin auras, ghost wolf, shadowform).

## 0.2.4
- Gear button opens settings; position is saved; AddOns settings entry; /eub and /fub commands.

## 0.2.1
- Rewritten for WoW Forever (Interface 16001) with C_Container / C_SpellBook APIs.
