## 0.5.2
- Added German (deDE) and Spanish (esES/esMX) translations for categories, settings, and tooltips.
- Added automatic locale selection and manual language choices.

## 0.5.0
- Preserve each category’s expanded/collapsed state through /reload and future logins using EUB_DB.collapsed.
- Initialize new categories without resetting existing saved states.

## 0.4.8
- Add a separate Camping (야영) item category, including localization for all supported languages.
- Detect camping-related usable items by their item names, with conservative matching to avoid moving unrelated items.
- Camping can be enabled or disabled in settings and participates in unified mode.

## 0.4.7
- Expand class utility recognition for future level-cap increases, using learned spellbook entries rather than a level cutoff.
- Add recovery, travel, exploration, pet care, conjuration and support skills.
- Keep forms/stances separate; exclude unlearned and passive skills.
- Preserve existing interface and settings.

## 0.4.6
- 직업 스킬에 은신, 질주, 추적, 소환, 축복, 창조, 자물쇠 따기 및 야수 관련 스킬 복원.
- 부활, 환생, 귀환, 포탈, 순간이동은 유지하며 변신/태세는 별도 분류.

## 0.4.5
- 직업 스킬 분류를 부활, 환생, 되살리기, 귀환, 포탈 열기, 순간이동 계열로 제한.
- 전문기술 및 변신·태세 분류는 유지.

## 0.4.4
- Ctrl + right-button title dragging works whether toolbar is locked or unlocked.
- Updated multilingual title tooltip to explain lock-independent movement.
- Lock still prevents resizing.

## 0.3.9 - 설정 창 디자인 및 드래그
- 던전길잡이 스타일의 설정 창, 금색 강조선과 2열 분류 선택.
- 설정 창 상단 제목을 왼쪽 드래그로 이동.
- 설정 버튼의 현재 값 및 상태 표시, 마우스 오버 강조.

## 0.3.8
- 이동 아이콘 제거, 잠금 해제 상태에서 애드온 이름 Ctrl+왼쪽 드래그로 이동.
- 마우스 오버 툴바 및 크기 조절 유지.

## 0.3.5 - Secure item actions and on-use trinkets
- Pass item tokens as strings to secure action buttons to prevent C_Item.IsEquippableItem argument errors.
- Use inventory slot actions for equipped on-use trinkets.
- Exclude passive/proc-only trinkets by inspecting equipped item tooltip Use: lines.

## 0.3.3 Preview
- Item and spell cooldown swipes/countdowns.
- Unusable or resource-limited icons are dimmed separately from cooldowns.
- Refresh on state events and every 0.25 seconds.
- Retain 0.3.2 dungeon-guide styling.

## 0.3.2 - Dungeon-guide-inspired UI
- Dark charcoal panels, restrained gold highlights and slim section accents.
- Compact section headers and improved hover feedback.
- Preserved transparent locked mode, icons, controls and grouping.
- Visual styling is inspired by the requested aesthetic, not an exact copy.

## 0.2.7-preview
- 직업별 변신·태세 전용 그룹 추가
- 드루이드 변신, 전사 태세, 도적 은신, 사냥꾼 상, 성기사 오라, 주술사 늑대 정령, 사제 어둠의 형상 분리
- 마법사 변이 같은 대상 변신 주문은 제외
- 설정 분류 체크박스와 접기/펼치기 연동
- 설정 창 높이 조정

## 0.5.5
- Category headings can be toggled only when the toolbar outline is revealed via title hover.
- Empty transparent toolbar space passes mouse clicks to the game world.
