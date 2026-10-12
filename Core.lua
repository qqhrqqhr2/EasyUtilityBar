local ADDON = ...
local frame = CreateFrame("Frame", "EasyUtilityBarFrame", UIParent, "BackdropTemplate")
frame:SetSize(280, 62)
frame:SetClampedToScreen(true)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, -180)
frame:SetMovable(true)
-- Background is decorative: clicks on empty/transparent space pass to the game.
frame:EnableMouse(false)
frame:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="Interface\\Buttons\\WHITE8X8", tile=false, edgeSize=1, insets={left=1,right=1,top=1,bottom=1}})
frame:SetBackdropBorderColor(0.28,0.36,0.43,0.85)
frame:SetBackdropColor(0.025,0.035,0.047,0.93)
local title=frame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
title:SetPoint("TOPLEFT",12,-8)
title:SetTextColor(0.94,0.80,0.49)
title:SetText("EasyUtilityBar")
local buttons, headers, config, pending = {}, {}, nil, false
local updateVisuals -- forward declaration
local optionsCategory, optionsPanel
local order={"bomb","engineering","potion","food","bandage","camping","quest","trinket","other","profession","forms","classskill"}
local defaults={size=36,columns=8,locked=false,visible=true,opacity=1,categories={},collapsed={},language="auto",position=nil,manualWidth=nil,manualHeight=nil,unified=false,spellRanks="highest"}
local groupNames={
 koKR={bomb="폭탄",engineering="기계공학",potion="물약",food="음식·음료",bandage="붕대",camping="야영",quest="퀘스트",trinket="장신구",other="기타",profession="전문기술",forms="변신·태세",classskill="직업 스킬"},
 enUS={bomb="Bombs",engineering="Engineering",potion="Potions",food="Food & Drink",bandage="Bandages",camping="Camping",quest="Quest Items",trinket="Trinkets",other="Other",profession="Professions",forms="Forms & Stances",classskill="Class Skills"},
 zhCN={bomb="炸弹",engineering="工程学",potion="药水",food="食物与饮料",bandage="绷带",camping="露营",quest="任务",trinket="饰品",other="其他",profession="专业技能",forms="形态与姿态",classskill="职业技能"},
 zhTW={bomb="炸彈",engineering="工程學",potion="藥水",food="食物與飲料",bandage="繃帶",camping="露營",quest="任務",trinket="飾品",other="其他",profession="專業技能",forms="形態與姿態",classskill="職業技能"},
 ruRU={bomb="Бомбы",engineering="Инженерия",potion="Зелья",food="Еда и напитки",bandage="Бинты",camping="Лагерь",quest="Задания",trinket="Аксессуары",other="Прочее",profession="Профессии",forms="Облики и стойки",classskill="Умения класса"},
 deDE={bomb="Bomben",engineering="Ingenieurskunst",potion="Tränke",food="Essen & Trinken",bandage="Verbände",camping="Lager",quest="Questgegenstände",trinket="Schmuckstücke",other="Sonstiges",profession="Berufe",forms="Gestalten & Haltungen",classskill="Klassenfähigkeiten"},
 esES={bomb="Bombas",engineering="Ingeniería",potion="Pociones",food="Comida y bebida",bandage="Vendas",camping="Campamento",quest="Objetos de misión",trinket="Abalorios",other="Otros",profession="Profesiones",forms="Formas y actitudes",classskill="Habilidades de clase"}}
local languageOptions={{"auto","Auto"},{"koKR","한국어"},{"enUS","English"},{"zhCN","简体中文"},{"zhTW","繁體中文"},{"ruRU","Русский"},{"deDE","Deutsch"},{"esES","Español"}}
local uiStrings={
 koKR={subtitle="설정 · 제목 드래그로 이동",categories="표시할 분류",layout="아이콘 배치",unified="분류 없이 모든 아이콘 한곳에 표시",language="언어",controls="단축바 조절",size="아이콘 크기",columns="한 줄 개수",unlock="잠금 해제",lock="단축바 잠금",hide="단축바 숨김",show="단축바 표시",expand="전체 펼치기",collapse="전체 접기",refresh="새로고침",donate="후원하기 · 주소 복사",copy="후원 주소 · Ctrl + C로 복사",hint="단축바 이동: Ctrl + 제목 좌클릭 드래그  |  크기: 오른쪽 아래",spellRanks="스킬 단계",allRanks="모든 단계",highestRank="최고 단계",foldTip="전체 분류 접기 / 펼치기",gearTip="설정 열기",lockTip="단축바 잠금 / 해제"},
 enUS={subtitle="Settings · Drag title to move",categories="Visible categories",layout="Icon layout",unified="Show all icons without categories",language="Language",controls="Toolbar controls",size="Icon size",columns="Icons per row",unlock="Unlock toolbar",lock="Lock toolbar",hide="Hide toolbar",show="Show toolbar",expand="Expand all",collapse="Collapse all",refresh="Refresh",donate="Support · Copy link",copy="Support link · Ctrl + C to copy",hint="Move: Ctrl + left-drag title  |  Resize: bottom right",spellRanks="Spell ranks",allRanks="All ranks",highestRank="Highest rank",foldTip="Collapse / expand all groups",gearTip="Open settings",lockTip="Lock / unlock toolbar"},
 zhCN={subtitle="设置 · 拖动标题移动",categories="显示分类",layout="图标排列",unified="所有图标合并显示",language="语言",controls="工具栏设置",size="图标大小",columns="每行数量",unlock="解锁工具栏",lock="锁定工具栏",hide="隐藏工具栏",show="显示工具栏",expand="全部展开",collapse="全部收起",refresh="刷新",donate="赞助 · 复制链接",copy="赞助链接 · Ctrl + C 复制",hint="移动：Ctrl + 左键拖动标题  |  缩放：右下角",spellRanks="技能等级",allRanks="全部等级",highestRank="最高等级",foldTip="收起 / 展开所有分类",gearTip="打开设置",lockTip="锁定 / 解锁工具栏"},
 zhTW={subtitle="設定 · 拖動標題移動",categories="顯示分類",layout="圖示排列",unified="所有圖示合併顯示",language="語言",controls="工具列設定",size="圖示大小",columns="每行數量",unlock="解鎖工具列",lock="鎖定工具列",hide="隱藏工具列",show="顯示工具列",expand="全部展開",collapse="全部收合",refresh="重新整理",donate="贊助 · 複製連結",copy="贊助連結 · Ctrl + C 複製",hint="移動：Ctrl + 左鍵拖曳標題  |  調整大小：右下角",spellRanks="技能等級",allRanks="全部等級",highestRank="最高等級",foldTip="收合 / 展開所有分類",gearTip="開啟設定",lockTip="鎖定 / 解鎖工具列"},
 ruRU={subtitle="Настройки · Перетащите заголовок",categories="Категории",layout="Расположение значков",unified="Все значки в одной группе",language="Язык",controls="Панель действий",size="Размер значков",columns="Значков в строке",unlock="Разблокировать",lock="Заблокировать",hide="Скрыть панель",show="Показать панель",expand="Развернуть всё",collapse="Свернуть всё",refresh="Обновить",donate="Поддержать · Копировать",copy="Ссылка · Ctrl + C",hint="Перемещение: Ctrl + левая кнопка  |  Размер: снизу справа",spellRanks="Ранги умений",allRanks="Все ранги",highestRank="Высший ранг",foldTip="Свернуть / развернуть группы",gearTip="Открыть настройки",lockTip="Закрепить / открепить панель"},
 deDE={subtitle="Einstellungen · Titel zum Verschieben ziehen",categories="Sichtbare Kategorien",layout="Symbolanordnung",unified="Alle Symbole ohne Kategorien anzeigen",language="Sprache",controls="Leistensteuerung",size="Symbolgröße",columns="Symbole pro Zeile",unlock="Leiste entsperren",lock="Leiste sperren",hide="Leiste ausblenden",show="Leiste anzeigen",expand="Alle aufklappen",collapse="Alle zuklappen",refresh="Aktualisieren",donate="Unterstützen · Link kopieren",copy="Unterstützungslink · Strg + C",hint="Verschieben: Strg + Titel mit linker Maustaste ziehen  |  Größe: unten rechts",spellRanks="Zauberränge",allRanks="Alle Ränge",highestRank="Höchster Rang",foldTip="Alle Gruppen ein- / ausklappen",gearTip="Einstellungen öffnen",lockTip="Leiste sperren / entsperren"},
 esES={subtitle="Opciones · Arrastra el título para mover",categories="Categorías visibles",layout="Distribución de iconos",unified="Mostrar todos los iconos sin categorías",language="Idioma",controls="Controles de la barra",size="Tamaño de iconos",columns="Iconos por fila",unlock="Desbloquear barra",lock="Bloquear barra",hide="Ocultar barra",show="Mostrar barra",expand="Expandir todo",collapse="Contraer todo",refresh="Actualizar",donate="Apoyar · Copiar enlace",copy="Enlace de apoyo · Ctrl + C",hint="Mover: Ctrl + arrastrar título con botón izquierdo  |  Tamaño: esquina inferior derecha",spellRanks="Rangos de hechizos",allRanks="Todos los rangos",highestRank="Rango máximo",foldTip="Contraer / expandir todos los grupos",gearTip="Abrir opciones",lockTip="Bloquear / desbloquear barra"}
}
local function currentLang()
 local lang=(EUB_DB and EUB_DB.language) or "auto"
 if lang=="auto" then lang=GetLocale() end
 if lang=="esMX" then lang="esES" end
 return uiStrings[lang] and lang or "enUS"
end
local function ui(k) return (uiStrings[currentLang()] or uiStrings.enUS)[k] or uiStrings.enUS[k] or k end
local function groupLabel(k)
 local lang=(EUB_DB and EUB_DB.language) or "auto"
 if lang=="auto" then lang=GetLocale() end
 if lang=="esMX" then lang="esES" end
 return (groupNames[lang] or groupNames.enUS)[k] or k
end
local function say(s) print("|cff55ccffEasyUtilityBar:|r "..s) end
local function setup()
 EUB_DB=EUB_DB or {}
 for k,v in pairs(defaults) do if EUB_DB[k]==nil then EUB_DB[k]=v end end
 EUB_DB.categories=EUB_DB.categories or {}
 -- Per-category collapse state is stored in SavedVariables (EUB_DB).
 -- Initialize each category only once; never overwrite a previously saved state.
 if type(EUB_DB.collapsed)~="table" then EUB_DB.collapsed={} end
 for _,k in ipairs(order) do
  if EUB_DB.categories[k]==nil then EUB_DB.categories[k]=true end
  if EUB_DB.collapsed[k]==nil then EUB_DB.collapsed[k]=false end
 end
end
local function classify(name,typ,sub,tooltip)
 local s=(name or ""):lower(); local t=(typ or ""):lower(); local u=(sub or ""):lower(); local tip=(tooltip or ""):lower()
 if s:find("폭탄",1,true) or s:find("다이너마이트",1,true) or s:find("수류탄",1,true) or s:find("grenade",1,true) or s:find("bomb",1,true) or s:find("grenade",1,true) or s:find("dynamite",1,true) then return "bomb" end
 -- Camping utilities: classify by explicit item name, not a broad tooltip keyword.
 -- Avoid capturing ordinary food, potions or unrelated engineering devices.
 if s:find("야영",1,true) or s:find("모닥불",1,true) or s:find("캠프파이어",1,true)
  or s:find("camping",1,true) or s:find("campfire",1,true)
  or s:find("camp fire",1,true) or s:find("campsite",1,true)
  or s:find("camp tent",1,true) or s:find("露营",1,true)
  or s:find("露營",1,true) or s:find("篝火",1,true)
  or s:find("палатка",1,true) or s:find("костёр",1,true) then return "camping" end
 if s:find("붕대",1,true) or s:find("bandage",1,true) then return "bandage" end
 if s:find("물약",1,true) or s:find("potion",1,true) or s:find("비약",1,true) or s:find("elixir",1,true) or s:find("flask",1,true) then return "potion" end
 if u:find("food",1,true) or u:find("음식",1,true) or s:find("빵",1,true) or s:find("음료",1,true) then return "food" end
 if t:find("quest",1,true) or t:find("퀘스트",1,true) then return "quest" end
 if tip:find("engineering",1,true) or tip:find("기계공학",1,true) then return "engineering" end
 return "other"
end
local scanner=CreateFrame("GameTooltip","EUBScanTooltip",UIParent,"GameTooltipTemplate")
scanner:SetOwner(UIParent,"ANCHOR_NONE")
local function usable(bag,slot)
 scanner:ClearLines(); scanner:SetBagItem(bag,slot)
 for i=1,scanner:NumLines() do
  local fs=_G["EUBScanTooltipTextLeft"..i]
  local s=fs and fs:GetText()
  if type(s)=="string" and (s:find("Use:",1,true) or s:find("사용 효과",1,true) or s:find("사용:",1,true) or s:find("使用:",1,true) or s:find("Использование:",1,true)) then return true end
 end
 return false
end
-- Only equipped trinkets with an actual on-use effect belong in the bar.
-- Do not confuse equip/proc text (Equip:) with an activated effect (Use:).
local function trinketHasUse(slot)
 scanner:ClearLines()
 local ok=pcall(scanner.SetInventoryItem,scanner,"player",slot)
 if not ok then return false end
 for i=2,scanner:NumLines() do
  local line=_G["EUBScanTooltipTextLeft"..i]
  local value=line and line:GetText()
  if type(value)=="string" then
   local text=value:lower():gsub("^%s+","")
   if text:find("use:",1,true)==1 or text:find("사용 효과:",1,true)==1
    or text:find("사용:",1,true)==1 or text:find("使用:",1,true)==1
    or text:find("使用：",1,true)==1 or text:find("использование:",1,true)==1 then
    return true
   end
  end
 end
 return false
end
-- Some Forever builds expose item information through C_Item only.
-- A protected call also handles uncached or unsupported item queries.
local function itemInfo(id)
 if type(GetItemInfo)=="function" then
  local ok,name,link,quality,level,minLevel,itemType,itemSubType=pcall(GetItemInfo,id)
  if ok then return name,itemType,itemSubType end
 end
 if C_Item and type(C_Item.GetItemInfo)=="function" then
  local ok,name,link,quality,level,minLevel,itemType,itemSubType=pcall(C_Item.GetItemInfo,id)
  if ok then return name,itemType,itemSubType end
 end
 return nil,nil,nil
end
-- Class-aware stance/form grouping. Avoid broad terms like "변신" or "aura"
-- that may accidentally include unrelated spells (e.g. Polymorph).
local formPatterns={
 DRUID={"곰 변신","광포한 곰 변신","표범 변신","날쌘 동물 변신","여행 변신","수중 동물 변신","치타 변신","달빛야수 변신","나무정령 변신","bear form","dire bear form","cat form","travel form","aquatic form","moonkin form","tree of life","flight form"},
 WARRIOR={"전투 태세","방어 태세","광폭 태세","battle stance","defensive stance","berserker stance"},
 ROGUE={"은신","stealth"},
 HUNTER={"치타의 상","매의 상","원숭이의 상","야수의 상","독사의 상","치타 무리의 상","야생의 상","용매의 상","aspect of"},
 PALADIN={"기원의 오라","응보의 오라","집중의 오라","성전사의 오라","저항의 오라","헌신의 오라","devotion aura","retribution aura","concentration aura","crusader aura","resistance aura","shadow resistance aura","frost resistance aura","fire resistance aura","sanctity aura"},
 SHAMAN={"늑대 정령","ghost wolf"},
 PRIEST={"어둠의 형상","shadowform"},
 WARLOCK={"악마의 형상","metamorphosis"},
}
-- Only actionable, learned player spells should appear in the utility bar.
-- Temporary restrictions (cooldown, insufficient power, wrong form) are visual states,
-- not grounds for removing a button from the layout.
local function actionableSpell(info,id)
 if not id or not info then return false end
 local kind=info.itemType
 if kind and Enum and Enum.SpellBookItemType then
  local spellKind=Enum.SpellBookItemType.Spell
  if spellKind and kind~=spellKind then return false end
 end
 if C_Spell and type(C_Spell.IsSpellPassive)=="function" then
  local ok,passive=pcall(C_Spell.IsSpellPassive,id)
  if ok and passive then return false end
 elseif type(IsPassiveSpell)=="function" then
  local ok,passive=pcall(IsPassiveSpell,id)
  if ok and passive then return false end
 end
 if C_SpellBook and type(C_SpellBook.IsSpellKnown)=="function" then
  local ok,known=pcall(C_SpellBook.IsSpellKnown,id)
  if ok and known==false then return false end
 elseif type(IsSpellKnown)=="function" then
  local ok,known=pcall(IsSpellKnown,id)
  if ok and known==false then return false end
 end
 return true
end
local function isFormSpell(name,class)
 local low=(name or ""):lower()
 for _,pattern in ipairs(formPatterns[class] or {}) do
  if low==pattern or (pattern=="aspect of" and low:find(pattern,1,true)==1) then return true end
 end
 -- Druid custom-form variants may contain a parenthetical suffix.
 if class=="DRUID" then
  for _,pattern in ipairs(formPatterns.DRUID) do
   if low:find(pattern.." (",1,true)==1 then return true end
  end
 end
 return false
end
local function collect()
 local out,seen={},{}
 if C_Container and C_Container.GetContainerNumSlots then
  for bag=0,4 do
   for slot=1,(C_Container.GetContainerNumSlots(bag) or 0) do
    local info=C_Container.GetContainerItemInfo(bag,slot)
    if info and info.itemID and usable(bag,slot) then
     local name,typ,sub=itemInfo(info.itemID)
     -- Item names may be uncached. The first tooltip line normally has the visible name.
     if not name then
      local first=_G["EUBScanTooltipTextLeft1"]
      name=first and first:GetText() or nil
     end
     local cat=classify(name,typ,sub)
     if EUB_DB.categories[cat] and not seen[info.itemID] then
      seen[info.itemID]=true
      out[#out+1]={type="item",id=info.itemID,icon=info.iconFileID,name=name or tostring(info.itemID),category=cat,count=info.stackCount or 1}
     end
    end
   end
  end
 end
 if EUB_DB.categories.trinket then
  for _,slot in ipairs({13,14}) do
   local id=GetInventoryItemID("player",slot)
   if id and trinketHasUse(slot) then out[#out+1]={type="item",id=id,inventorySlot=slot,icon=GetInventoryItemTexture("player",slot),name=itemInfo(id) or "Trinket",category="trinket"} end
  end
 end
 if C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines and C_SpellBook.GetSpellBookSkillLineInfo and C_SpellBook.GetSpellBookItemInfo then
  local profession={"disenchant","enchanting","engineering","leatherworking","alchemy","blacksmithing","tailoring","skinning","smelting","fishing","cooking","first aid","mining","find herbs","find minerals","마력 추출","마법부여","기계공학","가죽세공","연금술","대장기술","재봉술","무두질","제련","낚시","요리","응급치료","채광","광물 찾기","약초 찾기"}
  -- Level-cap independent: scan learned spellbook entries on every refresh.
  -- Whitelisted utility names are intentionally narrow to avoid combat abilities.
  -- Future expansions automatically appear once the character learns the spell.
  local utilityNames={
   -- Resurrection and recovery
   "부활","환생","되살리기","야수 되살리기","구원","선조의 영혼","부활의 기원",
   "resurrection","resurrect","redemption","rebirth","revive pet","ancestral spirit","reincarnation","resurrection prayer",
   -- Travel, portals, hearth-like spells
   "귀환","영혼의 귀환","달숲 순간이동","순간이동","차원문","포탈 열기","포탈열기","천상의 귀환",
   "astral recall","teleport:","portal:","teleport ","portal ","moonglade","divine intervention",
   -- Stealth, movement and exploration
   "은신","숨기","질주","전력 질주","저속 낙하","공중 부양","수면 걷기","수중 호흡",
   "천리안","독수리의 눈","정신의 시야","야수의 눈","킬로그의 눈","주의 분산","소매치기",
   "stealth","prowl","dash","sprint","slow fall","levitate","water walking","water breathing",
   "far sight","eagle eye","mind vision","eyes of the beast","eye of kilrogg","distract","pick pocket",
   -- Tracking, summoning and pet management
   "추적","야수 추적","인간형 추적","언데드 추적","악마 추적","용족 추적","정령 추적","거인 추적","은신 추적",
   "소환 의식","야수 부르기","야수 소환","야수 해제","야수 먹이주기","야수 치료","야수 되살리기",
   "track ","tracking ","detect ","ritual of summoning","call pet","dismiss pet","feed pet","mend pet",
   -- Creation and class support
   "음식 창조","물 창조","생명석 창조","영혼석 창조","화염석 창조","주문석 창조",
   "마법 증폭","마법 감쇠","저주 해제","독 해제","질병 치료","독 치료","정화","마법 무효화",
   "야생의 징표","가시","인내의 기원","축복","자유의 축복","보호의 축복",
   "자물쇠 따기","독 제조","무기 독 바르기",
   "conjure food","conjure water","create healthstone","create soulstone","create firestone","create spellstone",
   "amplify magic","dampen magic","remove curse","abolish poison","cure poison","cure disease",
   "abolish disease","purify","cleanse","dispel magic","mark of the wild","thorns","prayer of fortitude",
   "blessing of ","pick lock","apply poison",
   -- Locale-compatible broad categories for non-English clients
   "复活","复生","救赎","救贖","先祖之魂","星界传送","星界傳送","传送","傳送","传送门","傳送門",
   "潜行","潛行","疾跑","追踪","追蹤","召唤","召喚","祝福","隐形","隱形",
   "воскрешение","возрождение","оживление","астральное возвращение","телепортация","портал:",
   "незаметность","спринт","выслеживание","призыв","благословение"
  }
  local utilityExact={
   ["귀환"]=true,["환생"]=true,["되살리기"]=true,["부활"]=true,
   ["영혼의 귀환"]=true,["윤회"]=true,["구원"]=true,["야수 되살리기"]=true,
   ["revive pet"]=true,["reincarnation"]=true,["astral recall"]=true
  }
  local function isClassUtility(name)
   local low=(name or ""):lower()
   if utilityExact[low] then return true end
   for _,word in ipairs(utilityNames) do
    if low==word or low:sub(1,#word)==word then return true end
   end
   return false
  end
  local _,playerClass=UnitClass("player")
  local seenSpell={}
  local highestByName={}
  for tab=1,C_SpellBook.GetNumSpellBookSkillLines() do
   local line=C_SpellBook.GetSpellBookSkillLineInfo(tab)
   if line then
    for i=line.itemIndexOffset+1,line.itemIndexOffset+line.numSpellBookItems do
     local si=C_SpellBook.GetSpellBookItemInfo(i,Enum.SpellBookSpellBank.Player)
     if si and si.spellID and not seenSpell[si.spellID] and actionableSpell(si,si.spellID) then
      local spellID=si.spellID
      local name=C_Spell.GetSpellName(spellID)
      local low=(name or ""):lower()
      local cat=isFormSpell(name,playerClass) and "forms" or nil
      if not cat then for _,word in ipairs(profession) do if low:find(word,1,true) then cat="profession";break end end end
      if not cat and isClassUtility(name) then cat="classskill" end
      if cat and EUB_DB.categories[cat] then
       seenSpell[spellID]=true
       local entry={type="spell",id=spellID,icon=C_Spell.GetSpellTexture(spellID),name=name,category=cat}
       -- Spellbook entries are ordered by rank. Preserve all ranks when requested;
       -- otherwise replace earlier ranks of the same named spell in the same category.
       if EUB_DB.spellRanks=="all" then
        out[#out+1]=entry
       else
        local key=cat..":"..(name or ""):lower()
        local prior=highestByName[key]
        if prior then out[prior]=entry else
         out[#out+1]=entry
         highestByName[key]=#out
        end
       end
      end
     end
    end
   end
  end
 end
 table.sort(out,function(a,b) if a.category~=b.category then
  local ai,bi=99,99;for i,v in ipairs(order) do if v==a.category then ai=i end;if v==b.category then bi=i end end
  return ai<bi end return (a.name or "")<(b.name or "") end)
 return out
end
local function button(i)
 if buttons[i] then return buttons[i] end
 local b=CreateFrame("Button","EUBAction"..i,frame,"SecureActionButtonTemplate")
 b.icon=b:CreateTexture(nil,"ARTWORK");b.icon:SetTexCoord(.07,.93,.07,.93)
 b.border=b:CreateTexture(nil,"BACKGROUND");b.border:SetAllPoints();b.border:SetTexture("Interface\\Buttons\\WHITE8X8");b.border:SetVertexColor(0.17,0.22,0.26,0.90)
 b.border:SetDrawLayer("BACKGROUND",0)
 b.icon:SetPoint("TOPLEFT",2,-2);b.icon:SetPoint("BOTTOMRIGHT",-2,2)
 b.cooldown=CreateFrame("Cooldown",nil,b,"CooldownFrameTemplate")
 b.cooldown:SetAllPoints(b.icon)
 b.cooldown:SetFrameLevel(b:GetFrameLevel()+2)
 if b.cooldown.SetDrawEdge then b.cooldown:SetDrawEdge(false) end
 if b.cooldown.SetHideCountdownNumbers then b.cooldown:SetHideCountdownNumbers(false) end
 b.shade=b:CreateTexture(nil,"OVERLAY")
 b.shade:SetAllPoints(b.icon)
 b.shade:SetColorTexture(0,0,0,0.52)
 b.shade:Hide()
 -- Highlight the currently selected form/stance without covering the icon.
 b.activeEdges={}
 for edge=1,4 do
  local t=b:CreateTexture(nil,"OVERLAY")
  t:SetTexture("Interface\\Buttons\\WHITE8X8")
  t:SetVertexColor(0.95,0.76,0.33,1)
  if edge==1 then t:SetPoint("TOPLEFT",b,"TOPLEFT",0,0);t:SetPoint("TOPRIGHT",b,"TOPRIGHT",0,0);t:SetHeight(2)
  elseif edge==2 then t:SetPoint("BOTTOMLEFT",b,"BOTTOMLEFT",0,0);t:SetPoint("BOTTOMRIGHT",b,"BOTTOMRIGHT",0,0);t:SetHeight(2)
  elseif edge==3 then t:SetPoint("TOPLEFT",b,"TOPLEFT",0,0);t:SetPoint("BOTTOMLEFT",b,"BOTTOMLEFT",0,0);t:SetWidth(2)
  else t:SetPoint("TOPRIGHT",b,"TOPRIGHT",0,0);t:SetPoint("BOTTOMRIGHT",b,"BOTTOMRIGHT",0,0);t:SetWidth(2) end
  t:Hide();b.activeEdges[edge]=t
 end
 b.count=b:CreateFontString(nil,"OVERLAY","NumberFontNormalSmall");b.count:SetPoint("BOTTOMRIGHT",-2,2)
 b.count:SetDrawLayer("OVERLAY",6)
 b:RegisterForClicks("AnyUp","AnyDown")
 b:SetScript("OnEnter",function(self)
  if not self.entry then return end
  GameTooltip:SetOwner(self,"ANCHOR_RIGHT")
  if self.entry.type=="item" then
   if GameTooltip.SetItemByID then GameTooltip:SetItemByID(self.entry.id) end
  elseif GameTooltip.SetSpellByID then GameTooltip:SetSpellByID(self.entry.id) end
  GameTooltip:Show()
 end)
 b:SetScript("OnLeave",function() GameTooltip:Hide() end)
 buttons[i]=b;return b
end
-- Read item/spell cooldowns without assuming one specific Forever API generation.
local function cooldownInfo(d)
 local start,duration,enabled
 if d.type=="item" then
  if C_Item and type(C_Item.GetItemCooldown)=="function" then
   local ok,a,b,c=pcall(C_Item.GetItemCooldown,d.id)
   if ok then
    if type(a)=="table" then start,duration,enabled=a.startTime,a.duration,a.isEnabled
    else start,duration,enabled=a,b,c end
   end
  end
  if start==nil and type(GetItemCooldown)=="function" then
   local ok,a,b,c=pcall(GetItemCooldown,d.id)
   if ok then start,duration,enabled=a,b,c end
  end
 else
  if C_Spell and type(C_Spell.GetSpellCooldown)=="function" then
   local ok,a,b,c=pcall(C_Spell.GetSpellCooldown,d.id)
   if ok then
    if type(a)=="table" then start,duration,enabled=a.startTime,a.duration,a.isEnabled
    else start,duration,enabled=a,b,c end
   end
  end
  if start==nil and type(GetSpellCooldown)=="function" then
   local ok,a,b,c=pcall(GetSpellCooldown,d.id)
   if ok then start,duration,enabled=a,b,c end
  end
 end
 return tonumber(start) or 0,tonumber(duration) or 0,enabled
end
local function isUsable(d)
 if d.type=="spell" then
  if C_Spell and type(C_Spell.IsSpellUsable)=="function" then
   local ok,a,b=pcall(C_Spell.IsSpellUsable,d.id)
   if ok then return a==true or a==1,b==true or b==1 end
  end
  if type(IsUsableSpell)=="function" then
   local ok,a,b=pcall(IsUsableSpell,d.id)
   if ok then return a==true or a==1,b==true or b==1 end
  end
 else
  if C_Item and type(C_Item.IsUsableItem)=="function" then
   local ok,a,b=pcall(C_Item.IsUsableItem,d.id)
   if ok then return a==true or a==1,b==true or b==1 end
  end
  if type(IsUsableItem)=="function" then
   local ok,a,b=pcall(IsUsableItem,d.id)
   if ok then return a==true or a==1,b==true or b==1 end
  end
 end
 return true,false -- unknown API: avoid falsely dimming everything
end
-- Form APIs expose the selected stance even when IsUsableSpell reports false.
local function activeFormSpell(d)
 if d.type~="spell" or d.category~="forms" then return false end
 if type(GetShapeshiftForm)~="function" or type(GetShapeshiftFormInfo)~="function" then return false end
 local ok,idx=pcall(GetShapeshiftForm)
 if not ok or not idx or idx<=0 then return false end
 local success,texture,active,castable,spellID=pcall(GetShapeshiftFormInfo,idx)
 if not success then return false end
 if spellID and tonumber(spellID)==tonumber(d.id) then return true end
 -- Some client builds return a stance texture rather than a spell ID.
 if texture and d.icon and tostring(texture)==tostring(d.icon) then return true end
 return false
end
updateVisuals=function()
 if not EUB_DB then return end
 local now=GetTime()
 for _,b in ipairs(buttons) do
  if b:IsShown() and b.entry then
   local start,duration,enabled=cooldownInfo(b.entry)
   local onCD=start>0 and duration>0 and (start+duration)>now+0.05
   if onCD then
    if b.lastStart~=start or b.lastDuration~=duration then
     if CooldownFrame_Set then CooldownFrame_Set(b.cooldown,start,duration,1)
     elseif b.cooldown.SetCooldown then b.cooldown:SetCooldown(start,duration) end
     b.lastStart,b.lastDuration=start,duration
    end
    b.cooldown:Show()
   else
    b.cooldown:Hide();b.lastStart,b.lastDuration=nil,nil
   end
   local usable,noResource=isUsable(b.entry)
   local active=activeFormSpell(b.entry)
   local blocked=not usable and not onCD and not active
   -- Active stance: bright icon with a gold outline. Unavailable stances: muted.
   b.shade:SetAlpha(noResource and 0.75 or 0.52)
   b.shade:SetShown(blocked)
   b.icon:SetDesaturated(blocked)
   for _,edge in ipairs(b.activeEdges) do edge:SetShown(active) end
   b.icon:SetVertexColor(1,1,1,1)
  end
 end
end
local refresh
local hoverUIActive=false
local function header(k)
 if headers[k] then return headers[k] end
 local h=CreateFrame("Button",nil,frame)
 h:SetHeight(20)
 -- Category headings are clickable only while the bar outline is visible.
 h:EnableMouse(hoverUIActive)
 h.bg=h:CreateTexture(nil,"BACKGROUND");h.bg:SetAllPoints();h.bg:SetColorTexture(0.075,0.095,0.12,0.90)
 h.label=h:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
 h.label:SetPoint("LEFT",12,0);h.label:SetJustifyH("LEFT");h.label:SetTextColor(0.85,0.88,0.88)
 h.accent=h:CreateTexture(nil,"ARTWORK");h.accent:SetColorTexture(0.81,0.63,0.31,0.95)
 h.accent:SetPoint("TOPLEFT",h,"TOPLEFT",0,0);h.accent:SetPoint("BOTTOMLEFT",h,"BOTTOMLEFT",0,0);h.accent:SetWidth(2)
 h:SetScript("OnClick",function()
  if not hoverUIActive then return end
  EUB_DB.collapsed[k]=not EUB_DB.collapsed[k] -- persistent across reload / logout
  refresh()
 end)
 h:SetScript("OnEnter",function(self) self.bg:SetColorTexture(0.13,0.17,0.20,0.98) end)
 h:SetScript("OnLeave",function(self) self.bg:SetColorTexture(0.075,0.095,0.12,0.90) end)
 headers[k]=h
 return h
end
refresh=function()
 if not EUB_DB then return end
 if InCombatLockdown() then pending=true;return end
 pending=false
 local entries=collect();local size=EUB_DB.size or 36;local cols=math.max(1,EUB_DB.columns or 8)
 local grouped={}
 for _,d in ipairs(entries) do
  if not grouped[d.category] then grouped[d.category]={} end
  table.insert(grouped[d.category],d)
 end
 local width=math.max(190,EUB_DB.manualWidth or (16+cols*(size+4)))
 cols=math.max(1,math.floor((width-16)/(size+4)))
 local y=32;local index=0
 if EUB_DB.unified then
  for _,k in ipairs(order) do headers[k] = header(k);headers[k]:Hide() end
  local shown={}
  for _,d in ipairs(entries) do if EUB_DB.categories[d.category] then shown[#shown+1]=d end end
  for n,d in ipairs(shown) do
   index=index+1
   local b=button(index);b.entry=d;b:ClearAllPoints();b:SetSize(size,size)
   b:SetPoint("TOPLEFT",frame,"TOPLEFT",8+((n-1)%cols)*(size+4),-y-math.floor((n-1)/cols)*(size+4))
   b.icon:SetTexture(d.icon);b.icon:SetVertexColor(1,1,1,1);b:SetAlpha(1)
   b.count:SetText(d.count and d.count>1 and d.count or "")
   b:SetAttribute("type",d.type)
   if d.type=="item" then
    b:SetAttribute("item",d.inventorySlot and tostring(d.inventorySlot) or ("item:"..tostring(d.id)))
    b:SetAttribute("spell",nil)
   else
    b:SetAttribute("item",nil);b:SetAttribute("spell",d.id)
   end
   b.lastStart=nil;b.lastDuration=nil;b:Show()
  end
  y=y+math.ceil(#shown/cols)*(size+4)+5
 else
 for _,k in ipairs(order) do
  local group=grouped[k]
  local h=header(k)
  if EUB_DB.categories[k] and group and #group>0 then
   local collapsed=EUB_DB.collapsed[k]
   h:ClearAllPoints();h:SetPoint("TOPLEFT",frame,"TOPLEFT",8,-y)
   h:SetWidth(width-16)
   h.label:SetText((collapsed and ">  " or "v  ")..groupLabel(k).."  |  "..#group)
   h:Show();y=y+25
   if not collapsed then
    for n,d in ipairs(group) do
     index=index+1
     local b=button(index);b.entry=d;b:ClearAllPoints();b:SetSize(size,size)
     b:SetPoint("TOPLEFT",frame,"TOPLEFT",8+((n-1)%cols)*(size+4),-y-math.floor((n-1)/cols)*(size+4))
     b.icon:SetTexture(d.icon);b.icon:SetVertexColor(1,1,1,1);b:SetAlpha(1);b.count:SetText(d.count and d.count>1 and d.count or "")
     -- SecureActionButtonTemplate requires a valid item token (string), not a numeric item ID.
     -- Equipped trinkets are activated by their inventory slot, preserving the correct slot.
     b:SetAttribute("type",d.type)
     if d.type=="item" then
      b:SetAttribute("item",d.inventorySlot and tostring(d.inventorySlot) or ("item:"..tostring(d.id)))
      b:SetAttribute("spell",nil)
     else
      b:SetAttribute("item",nil)
      b:SetAttribute("spell",d.id)
     end
     b.lastStart=nil;b.lastDuration=nil;b:Show()
    end
    y=y+math.ceil(#group/cols)*(size+4)+5
   end
  else h:Hide() end
 end
 end -- unified layout
 for i=index+1,#buttons do buttons[i]:Hide();buttons[i]:SetAttribute("type",nil);buttons[i].entry=nil;buttons[i].cooldown:Hide();buttons[i].shade:Hide();for _,edge in ipairs(buttons[i].activeEdges) do edge:Hide() end end
 frame:SetSize(width,math.max(48,y+10,EUB_DB.manualHeight or 0))
 frame:SetAlpha(EUB_DB.opacity or 1)
 -- Locked mode is a transparent overlay: icons and labels remain visible.
 frame:SetBackdropColor(0.025,0.035,0.047,EUB_DB.locked and 0 or 0.93)
 frame:SetBackdropBorderColor(0.28,0.36,0.43,EUB_DB.locked and 0 or 0.85)
 for _,h in pairs(headers) do
  if h.bg then h.bg:SetAlpha(EUB_DB.locked and 0 or 1) end
  if h.accent then h.accent:SetAlpha(EUB_DB.locked and 0 or 1) end
 end
 if EUB_DB.visible then frame:Show() else frame:Hide() end
 updateVisuals()
end
local function options()
 if config then config:SetShown(not config:IsShown());return end
 config=CreateFrame("Frame","EUBConfig",UIParent,"BackdropTemplate")
 config:SetSize(420,750);config:SetPoint("CENTER",UIParent,"CENTER",0,0)
 config:SetFrameStrata("DIALOG");config:SetClampedToScreen(true)
 config:SetMovable(true);config:EnableMouse(true)
 config:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1,insets={left=1,right=1,top=1,bottom=1}})
 config:SetBackdropColor(0.035,0.045,0.055,0.98)
 config:SetBackdropBorderColor(0.63,0.50,0.28,0.95)
 local top=CreateFrame("Frame",nil,config,"BackdropTemplate")
 top:SetPoint("TOPLEFT",config,"TOPLEFT",1,-1);top:SetPoint("TOPRIGHT",config,"TOPRIGHT",-1,-1);top:SetHeight(58)
 top:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8"});top:SetBackdropColor(0.09,0.105,0.115,0.98)
 top:EnableMouse(true);top:RegisterForDrag("LeftButton")
 top:SetScript("OnDragStart",function() if not InCombatLockdown() then config:StartMoving() end end)
 top:SetScript("OnDragStop",function() config:StopMovingOrSizing() end)
 local accent=top:CreateTexture(nil,"ARTWORK");accent:SetColorTexture(0.76,0.60,0.32,1)
 accent:SetPoint("BOTTOMLEFT",top,"BOTTOMLEFT",0,0);accent:SetPoint("BOTTOMRIGHT",top,"BOTTOMRIGHT",0,0);accent:SetHeight(2)
 local heading=top:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
 heading:SetPoint("TOPLEFT",18,-11);heading:SetText("EasyUtilityBar");heading:SetTextColor(0.93,0.78,0.48)
 local sub=top:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
 sub:SetPoint("TOPLEFT",heading,"BOTTOMLEFT",0,-3);sub:SetWidth(345);sub:SetJustifyH("LEFT");sub:SetText(ui("subtitle"));sub:SetTextColor(0.62,0.69,0.73)
 local close=CreateFrame("Button",nil,config,"UIPanelCloseButton");close:SetPoint("TOPRIGHT",-8,-9);close:SetFrameLevel(top:GetFrameLevel()+3)
 local function section(text,y)
  local t=config:CreateFontString(nil,"OVERLAY","GameFontNormal")
  t:SetPoint("TOPLEFT",20,y);t:SetText(text);t:SetTextColor(0.89,0.73,0.43)
  local line=config:CreateTexture(nil,"ARTWORK");line:SetColorTexture(0.30,0.31,0.29,0.8)
  line:SetPoint("TOPLEFT",config,"TOPLEFT",20,y-20);line:SetPoint("TOPRIGHT",config,"TOPRIGHT",-20,y-20);line:SetHeight(1)
  return t
 end
 -- Fit translated strings to their actual available width without overlapping neighbors.
 local function fitText(fs, text, maxWidth, baseSize, minSize)
  fs:SetWordWrap(false)
  local font,_,flags=fs:GetFont()
  if not font then fs:SetText(text);return end
  fs:SetFont(font,baseSize,flags)
  fs:SetText(text)
  local size=baseSize
  while fs:GetStringWidth()>maxWidth and size>minSize do
   size=size-0.5
   fs:SetFont(font,size,flags)
  end
  if fs:GetStringWidth()>maxWidth then
   local original=text
   while #text>0 and fs:GetStringWidth()>maxWidth do
    text=text:sub(1,-2)
    while #text>0 and string.byte(text,#text)>=128 and string.byte(text,#text)<192 do text=text:sub(1,-2) end
    fs:SetText(text.."...")
    if text==original then break end
   end
  end
 end
 local categoryHeading=section(ui("categories"),-66)
 local categoryLabels={}
 for i,k in ipairs(order) do
  local col=(i-1)%2;local row=math.floor((i-1)/2)
  local x=20+col*195;local y=-96-row*30
  local c=CreateFrame("CheckButton",nil,config,"UICheckButtonTemplate")
  c:SetSize(26,26);c:SetPoint("TOPLEFT",x,y);c:SetChecked(EUB_DB.categories[k])
  local t=config:CreateFontString(nil,"OVERLAY","GameFontHighlight")
  t:SetPoint("LEFT",c,"RIGHT",4,0);t:SetWidth(155);t:SetJustifyH("LEFT");t:SetText(groupLabel(k));t:SetTextColor(0.85,0.88,0.90)
  c:SetScript("OnClick",function(self) EUB_DB.categories[k]=self:GetChecked();refresh() end)
  categoryLabels[k]=t
 end
 local layoutHeading=section(ui("layout"),-285)
 local mode=CreateFrame("CheckButton",nil,config,"UICheckButtonTemplate")
 mode:SetSize(26,26);mode:SetPoint("TOPLEFT",20,-313)
 mode:SetChecked(EUB_DB.unified)
 local modeText=config:CreateFontString(nil,"OVERLAY","GameFontHighlight")
 modeText:SetPoint("LEFT",mode,"RIGHT",5,0);modeText:SetWidth(345);modeText:SetJustifyH("LEFT")
 modeText:SetText(ui("unified"))
 modeText:SetTextColor(0.88,0.89,0.87)
 mode:SetScript("OnClick",function(self) EUB_DB.unified=not not self:GetChecked();refresh() end)
 local languageHeading=section(ui("language"),-352)
 local langBtn=CreateFrame("Button",nil,config,"BackdropTemplate")
 langBtn:SetPoint("TOPLEFT",20,-378);langBtn:SetSize(380,30)
 langBtn:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
 langBtn:SetBackdropColor(0.12,0.15,0.17,0.96);langBtn:SetBackdropBorderColor(0.55,0.46,0.29,0.9)
 local langText=langBtn:CreateFontString(nil,"OVERLAY","GameFontHighlight")
 langText:SetPoint("CENTER");langText:SetWidth(360)
 local function languageLabel()
  for _,v in ipairs(languageOptions) do if v[1]==EUB_DB.language then return v[2] end end
  return "Auto"
 end
 langBtn:SetScript("OnEnter",function(self) self:SetBackdropBorderColor(0.90,0.73,0.43,1) end)
 langBtn:SetScript("OnLeave",function(self) self:SetBackdropBorderColor(0.55,0.46,0.29,0.9) end)
 local rankHeading=section(ui("spellRanks"),-418)
 local rankBtn=CreateFrame("Button",nil,config,"BackdropTemplate")
 rankBtn:SetPoint("TOPLEFT",20,-445);rankBtn:SetSize(380,29)
 rankBtn:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
 rankBtn:SetBackdropColor(0.12,0.15,0.17,0.96);rankBtn:SetBackdropBorderColor(0.55,0.46,0.29,0.9)
 local rankText=rankBtn:CreateFontString(nil,"OVERLAY","GameFontHighlight")
 rankText:SetPoint("CENTER");rankText:SetWidth(360)
 rankBtn:SetScript("OnEnter",function(self) self:SetBackdropBorderColor(0.90,0.73,0.43,1) end)
 rankBtn:SetScript("OnLeave",function(self) self:SetBackdropBorderColor(0.55,0.46,0.29,0.9) end)
 local controlsHeading=section(ui("controls"),-482)
 local function action(text,x,y,fn)
  local b=CreateFrame("Button",nil,config,"BackdropTemplate")
  b:SetSize(181,31);b:SetPoint("TOPLEFT",x,y)
  b:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
  b:SetBackdropColor(0.12,0.15,0.17,0.96);b:SetBackdropBorderColor(0.29,0.35,0.36,0.9)
  local label=b:CreateFontString(nil,"OVERLAY","GameFontHighlight")
  label:SetPoint("CENTER");label:SetWidth(173);label:SetWordWrap(false);label:SetText(text);label:SetTextColor(0.87,0.90,0.90)
  b:SetScript("OnEnter",function(self) self:SetBackdropColor(0.22,0.20,0.15,1);self:SetBackdropBorderColor(0.69,0.54,0.30,1) end)
  b:SetScript("OnLeave",function(self) self:SetBackdropColor(0.12,0.15,0.17,0.96);self:SetBackdropBorderColor(0.29,0.35,0.36,0.9) end)
  b:SetScript("OnClick",fn)
  return b,label
 end
 -- Compact +/- steppers: separate controls prevent cycling values accidentally.
 local function stepper(x,y,key,minValue,maxValue,step)
  local label=config:CreateFontString(nil,"OVERLAY","GameFontHighlight")
  label:SetPoint("TOPLEFT",x,y-8);label:SetWidth(90);label:SetJustifyH("LEFT");label:SetWordWrap(false)
  local function smallButton(symbol,bx,delta)
   local btn=CreateFrame("Button",nil,config,"BackdropTemplate")
   btn:SetSize(27,29);btn:SetPoint("TOPLEFT",bx,y)
   btn:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
   btn:SetBackdropColor(0.12,0.15,0.17,0.96);btn:SetBackdropBorderColor(0.40,0.39,0.32,1)
   local txt=btn:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
   txt:SetPoint("CENTER",0,0);txt:SetText(symbol)
   btn:SetScript("OnEnter",function(self) self:SetBackdropBorderColor(0.89,0.70,0.36,1) end)
   btn:SetScript("OnLeave",function(self) self:SetBackdropBorderColor(0.40,0.39,0.32,1) end)
   btn:SetScript("OnClick",function()
    local nextValue=math.max(minValue,math.min(maxValue,(EUB_DB[key] or (key=="size" and 36 or 8))+delta))
    EUB_DB[key]=nextValue
    EUB_DB.manualWidth=nil -- Explicit columns/size settings override manually resized width.
    refresh()
    if config and config:IsShown() then config:Hide();config:Show() end
   end)
   return btn
  end
  local minus=smallButton("-",x+94,-step)
  local plus=smallButton("+",x+160,step)
  local value=config:CreateFontString(nil,"OVERLAY","GameFontHighlight")
  value:SetPoint("CENTER",minus,"CENTER",33,0);value:SetWidth(35);value:SetJustifyH("CENTER")
  return label,value
 end
 local sizeLabel,sizeValue=stepper(20,-512,"size",24,64,2)
 local colsLabel,colsValue=stepper(210,-512,"columns",4,16,1)
 local lockBtn,lockText=action(ui("lock"),20,-547,function() EUB_DB.locked=not EUB_DB.locked;refresh() end)
 local visBtn,visText=action(ui("show"),219,-547,function() EUB_DB.visible=not EUB_DB.visible;refresh() end)
 local expandBtn,expandText=action(ui("expand"),20,-582,function() for _,k in ipairs(order) do EUB_DB.collapsed[k]=false end;refresh() end)
 local collapseBtn,collapseText=action(ui("collapse"),219,-582,function() for _,k in ipairs(order) do EUB_DB.collapsed[k]=true end;refresh() end)
 local refreshBtn,refreshText=action(ui("refresh"),20,-617,refresh)
 local donate=CreateFrame("Button",nil,config,"BackdropTemplate")
 donate:SetPoint("BOTTOMLEFT",config,"BOTTOMLEFT",20,40)
 donate:SetPoint("BOTTOMRIGHT",config,"BOTTOMRIGHT",-20,40)
 donate:SetHeight(33)
 donate:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
 donate:SetBackdropColor(0.17,0.14,0.09,0.96);donate:SetBackdropBorderColor(0.72,0.56,0.31,0.9)
 local donateText=donate:CreateFontString(nil,"OVERLAY","GameFontHighlight")
 donateText:SetPoint("CENTER");donateText:SetWidth(365);donateText:SetText(ui("donate"))
 donateText:SetTextColor(0.94,0.80,0.53)
 donate:SetScript("OnEnter",function(self) self:SetBackdropColor(0.26,0.20,0.11,1) end)
 donate:SetScript("OnLeave",function(self) self:SetBackdropColor(0.17,0.14,0.09,0.96) end)
 local copyBox
 donate:SetScript("OnClick",function()
  if not copyBox then
   copyBox=CreateFrame("Frame",nil,UIParent,"BackdropTemplate")
   copyBox:SetSize(390,112);copyBox:SetPoint("CENTER",UIParent,"CENTER",0,120)
   copyBox:SetFrameStrata("FULLSCREEN_DIALOG")
   copyBox:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8",edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
   copyBox:SetBackdropColor(0.035,0.045,0.055,0.98)
   copyBox:SetBackdropBorderColor(0.72,0.56,0.31,1)
   local label=copyBox:CreateFontString(nil,"OVERLAY","GameFontNormal")
   label:SetPoint("TOP",0,-14);label:SetText(ui("copy"))
   local edit=CreateFrame("EditBox",nil,copyBox,"InputBoxTemplate")
   edit:SetSize(340,27);edit:SetPoint("TOP",0,-43)
   edit:SetAutoFocus(false);edit:SetText("https://buymeacoffee.com/qqhrqqhr2")
   edit:SetScript("OnEscapePressed",function() copyBox:Hide() end)
   copyBox.edit=edit
   local close=CreateFrame("Button",nil,copyBox,"UIPanelCloseButton")
   close:SetPoint("TOPRIGHT",-2,-2)
  end
  copyBox:Show();copyBox.edit:SetFocus();copyBox.edit:HighlightText()
 end)
 local hint=config:CreateFontString(nil,"OVERLAY","GameFontDisableSmall")
 hint:SetPoint("BOTTOMLEFT",20,87);hint:SetWidth(380);hint:SetJustifyH("LEFT");hint:SetText(ui("hint"))
 local foot=config:CreateFontString(nil,"OVERLAY","GameFontDisableSmall")
 foot:SetPoint("BOTTOM",0,12);foot:SetText("EasyUtilityBar 0.5.5  ·  /eub")
 local function updateLabels()
  -- Subtitle is fitted below.
  fitText(categoryHeading,ui("categories"),375,13,10);fitText(layoutHeading,ui("layout"),375,13,10)
  fitText(languageHeading,ui("language"),375,13,10);fitText(rankHeading,ui("spellRanks"),375,13,10);fitText(controlsHeading,ui("controls"),375,13,10)
  for _,k in ipairs(order) do fitText(categoryLabels[k],groupLabel(k),150,12,9) end
  fitText(modeText,ui("unified"),340,12,9)
  fitText(langText,ui("language").."  :  "..languageLabel().."  ▼",355,12,10)
  fitText(rankText,ui("spellRanks").."  :  "..ui(EUB_DB.spellRanks=="all" and "allRanks" or "highestRank").."  ▼",355,12,10)
  fitText(donateText,ui("donate"),365,12,10);fitText(hint,ui("hint"),375,10,8)
  fitText(sub,ui("subtitle"),345,10,8)
  fitText(expandText,ui("expand"),171,12,9);fitText(collapseText,ui("collapse"),171,12,9);fitText(refreshText,ui("refresh"),171,12,9)
  fitText(sizeLabel,ui("size"),88,12,9);sizeValue:SetText(tostring(EUB_DB.size or 36))
  fitText(colsLabel,ui("columns"),88,12,9);colsValue:SetText(tostring(EUB_DB.columns or 8))
  fitText(lockText,ui(EUB_DB.locked and "unlock" or "lock"),171,12,9)
  fitText(visText,ui(EUB_DB.visible and "hide" or "show"),171,12,9)
 end
 rankBtn:SetScript("OnClick",function()
  EUB_DB.spellRanks=(EUB_DB.spellRanks=="all") and "highest" or "all"
  updateLabels();refresh()
 end)
 langBtn:SetScript("OnClick",function()
  local index=1
  for i,v in ipairs(languageOptions) do if v[1]==EUB_DB.language then index=i;break end end
  EUB_DB.language=languageOptions[index%#languageOptions+1][1]
  updateLabels();refresh()
 end)
 for _,btn in ipairs({lockBtn,visBtn}) do
  btn:HookScript("OnClick",updateLabels)
 end
 config:SetScript("OnShow",updateLabels)
 updateLabels()
end
-- Title area supports Ctrl + left mouse drag regardless of toolbar lock.
local function savePosition()
 if not EUB_DB then return end
 local point, _, relativePoint, x, y = frame:GetPoint(1)
 EUB_DB.position = {point or "CENTER", relativePoint or "CENTER", x or 0, y or 0}
end
local function startMove(self)
 if EUB_DB and not InCombatLockdown() then frame:StartMoving() end
end
local function stopMove(self)
 frame:StopMovingOrSizing()
 savePosition()
end
-- All toolbar artwork is shipped locally to avoid missing client textures.
local function toolbarControl(name, iconName, offset, tip, click)
 local b=CreateFrame("Button",name,frame)
 b:SetSize(23,23)
 b:SetPoint("TOPRIGHT",frame,"TOPRIGHT",offset,-3)
 local bg=b:CreateTexture(nil,"BACKGROUND")
 bg:SetAllPoints();bg:SetColorTexture(0.09,0.11,0.13,0.65)
 local icon=b:CreateTexture(nil,"ARTWORK")
 b.icon=icon
 icon:SetPoint("TOPLEFT",3,-3);icon:SetPoint("BOTTOMRIGHT",-3,3)
 icon:SetTexture("Interface\\AddOns\\EasyUtilityBar\\Media\\"..iconName..".tga")
 b:SetScript("OnEnter",function(self)
  bg:SetColorTexture(0.24,0.21,0.15,0.95)
  GameTooltip:SetOwner(self,"ANCHOR_TOP");GameTooltip:SetText(ui(tip));GameTooltip:Show()
 end)
 b:SetScript("OnLeave",function()
  bg:SetColorTexture(0.09,0.11,0.13,0.65);GameTooltip:Hide()
 end)
 if click then b:SetScript("OnClick",click) end
 return b
end
local fold=toolbarControl("EUBFoldButton","fold",-57,"foldTip",function()
 if not EUB_DB then return end
 local all=true
 for _,k in ipairs(order) do if not EUB_DB.collapsed[k] then all=false;break end end
 for _,k in ipairs(order) do EUB_DB.collapsed[k]=not all end
 refresh()
end)
local gear=toolbarControl("EUBSettingsButton","gear",-6,"gearTip",function() options() end)
local lock=toolbarControl("EUBLockButton","unlock",-32,"lockTip",function()
 if not EUB_DB or InCombatLockdown() then return end
 EUB_DB.locked=not EUB_DB.locked
 refresh()
end)
local lockArt=lock.icon
local resize=CreateFrame("Button","EUBResizeHandle",frame)
resize:SetSize(19,19);resize:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",-1,1)
resize:SetFrameLevel(frame:GetFrameLevel()+10)
local resizeIcon=resize:CreateTexture(nil,"ARTWORK")
resizeIcon:SetAllPoints();resizeIcon:SetTexture("Interface\\AddOns\\EasyUtilityBar\\Media\\resize.tga")
frame:SetResizable(true)
if frame.SetResizeBounds then frame:SetResizeBounds(190,55,900,900) elseif frame.SetMinResize then frame:SetMinResize(190,55);frame:SetMaxResize(900,900) end
resize:RegisterForDrag("LeftButton")
resize:SetScript("OnDragStart",function()
 if EUB_DB and not EUB_DB.locked and not InCombatLockdown() then frame:StartSizing("BOTTOMRIGHT") end
end)
resize:SetScript("OnDragStop",function()
 frame:StopMovingOrSizing()
 if not EUB_DB then return end
 EUB_DB.manualWidth=math.floor(frame:GetWidth()+0.5)
 EUB_DB.manualHeight=math.floor(frame:GetHeight()+0.5)
 EUB_DB.columns=math.max(1,math.floor((EUB_DB.manualWidth-16)/((EUB_DB.size or 36)+4)))
 savePosition();refresh()
end)
local titleHover=CreateFrame("Frame",nil,frame,"BackdropTemplate")
titleHover:SetPoint("TOPLEFT",frame,"TOPLEFT",5,-3)
titleHover:SetSize(114,23)
titleHover:SetBackdrop({edgeFile="Interface\\Buttons\\WHITE8X8",edgeSize=1})
titleHover:SetBackdropBorderColor(0.81,0.63,0.31,0)
titleHover:EnableMouse(true)
titleHover:RegisterForDrag("LeftButton")
local draggingTitle=false
titleHover:SetScript("OnDragStart",function()
 if not EUB_DB or InCombatLockdown() or not IsControlKeyDown() then return end
 draggingTitle=true
 startMove()
end)
titleHover:SetScript("OnDragStop",function()
 if not draggingTitle then return end
 draggingTitle=false
 stopMove()
end)
-- The title is the only reveal trigger. Keep controls visible while the cursor
-- travels within the addon, including the toolbar and resize grip.
local hoverUI=false
local hoverExitElapsed=0
local function showHoverUI(show)
 hoverUI=show
 hoverUIActive=show
 for _,h in pairs(headers) do h:EnableMouse(show) end
 hoverExitElapsed=0
 if not EUB_DB then return end
 fold:SetShown(show)
 gear:SetShown(show)
 lock:SetShown(show)
 resize:SetShown(show and not EUB_DB.locked)
 titleHover:SetBackdropBorderColor(0.81,0.63,0.31,show and 0.9 or 0)
 frame:SetBackdropColor(0.025,0.035,0.047,show and 0.85 or 0)
 frame:SetBackdropBorderColor(0.70,0.56,0.32,show and 0.9 or 0)
end
titleHover:SetScript("OnEnter",function(self)
 showHoverUI(true)
 GameTooltip:SetOwner(self,"ANCHOR_TOPLEFT")
 local lang=EUB_DB and EUB_DB.language or "auto"
 if lang=="auto" then lang=GetLocale() end
 if lang=="esMX" then lang="esES" end
 local help={
  koKR={"이동: Ctrl + 마우스 왼쪽 드래그 (잠금 무관)","잠금 아이콘을 눌러 잠금/해제"},
  enUS={"Move: Ctrl + left-drag (even when locked)","Use the lock icon to lock / unlock"},
  zhCN={"移动：Ctrl + 鼠标左键拖动（锁定时也可）","点击锁图标锁定或解锁"},
  zhTW={"移動：Ctrl + 滑鼠左鍵拖曳（鎖定時也可）","點擊鎖頭圖示鎖定或解鎖"},
  ruRU={"Перемещение: Ctrl + левая кнопка (даже при блокировке)","Значок замка: блокировка / разблокировка"},
  deDE={"Verschieben: Strg + linke Maustaste ziehen (auch gesperrt)","Schlosssymbol: Leiste sperren / entsperren"},
  esES={"Mover: Ctrl + arrastrar con botón izquierdo (incluso bloqueada)","Icono de candado: bloquear / desbloquear la barra"},
 }
 local lines=help[lang] or help.enUS
 GameTooltip:SetText("EasyUtilityBar",0.94,0.80,0.49)
 GameTooltip:AddLine(lines[1],1,1,1,true)
 GameTooltip:AddLine(lines[2],0.70,0.75,0.79,true)
 GameTooltip:Show()
end)
titleHover:SetScript("OnLeave",function() GameTooltip:Hide() end)
-- Do not hide on title OnLeave: that would make toolbar controls disappear
-- before the mouse can reach them. The frame-wide hover check handles exit.
title:SetDrawLayer("OVERLAY",2)
local oldRefresh=refresh
refresh=function()
 oldRefresh()
 if not EUB_DB then return end
 if lockArt then lockArt:SetTexture("Interface\\AddOns\\EasyUtilityBar\\Media\\"..(EUB_DB.locked and "lock" or "unlock")..".tga") end
 showHoverUI(hoverUI)
end
frame:HookScript("OnUpdate",function(_,elapsed)
 if not hoverUI then return end
 if draggingTitle or frame:IsMouseOver() or (resize.IsMouseOver and resize:IsMouseOver()) then
  hoverExitElapsed=0
 else
  hoverExitElapsed=hoverExitElapsed+elapsed
  if hoverExitElapsed>=0.15 then showHoverUI(false) end
 end
end)
frame:SetScript("OnDragStart",nil)
frame:SetScript("OnDragStop",nil)

-- Register under the game's AddOns settings page (modern and legacy APIs).
local function registerOptions()
 if optionsPanel then return end
 optionsPanel=CreateFrame("Frame","EUBInterfaceOptionsPanel",UIParent)
 optionsPanel.name="EasyUtilityBar"
 local heading=optionsPanel:CreateFontString(nil,"ARTWORK","GameFontNormalLarge")
 heading:SetPoint("TOPLEFT",18,-20);heading:SetText("EasyUtilityBar")
 local desc=optionsPanel:CreateFontString(nil,"ARTWORK","GameFontHighlight")
 desc:SetPoint("TOPLEFT",heading,"BOTTOMLEFT",0,-14)
 desc:SetText("가방 아이템 / 전문기술 / 직업 스킬 단축바")
 local open=CreateFrame("Button",nil,optionsPanel,"UIPanelButtonTemplate")
 open:SetSize(180,28);open:SetPoint("TOPLEFT",desc,"BOTTOMLEFT",0,-20)
 open:SetText("EasyUtilityBar 설정 열기")
 open:SetScript("OnClick",function() options() end)
 local hint=optionsPanel:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall")
 hint:SetPoint("TOPLEFT",open,"BOTTOMLEFT",0,-16)
 hint:SetText("게임 화면의 톱니바퀴 버튼이나 /eub 명령어로도 열 수 있습니다.")
 if Settings and type(Settings.RegisterCanvasLayoutCategory)=="function" and type(Settings.RegisterAddOnCategory)=="function" then
  local ok,cat=pcall(Settings.RegisterCanvasLayoutCategory,optionsPanel,"EasyUtilityBar")
  if ok and cat then optionsCategory=cat;pcall(Settings.RegisterAddOnCategory,cat) end
 elseif type(InterfaceOptions_AddCategory)=="function" then
  pcall(InterfaceOptions_AddCategory,optionsPanel)
 end
end
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("BAG_UPDATE_DELAYED")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterEvent("SPELLS_CHANGED")
frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
frame:RegisterEvent("SPELL_UPDATE_USABLE")
frame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
frame:RegisterEvent("UNIT_POWER_UPDATE")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
frame:RegisterEvent("BAG_UPDATE_COOLDOWN")
frame:SetScript("OnEvent",function(self,event)
 if event=="PLAYER_LOGIN" then setup();
  if EUB_DB.position then frame:ClearAllPoints();frame:SetPoint(EUB_DB.position[1],UIParent,EUB_DB.position[2],EUB_DB.position[3],EUB_DB.position[4]) end
  registerOptions();refresh();say("로드 완료. /eub")
 elseif event=="PLAYER_REGEN_ENABLED" then if pending then refresh() end
 elseif event=="SPELL_UPDATE_COOLDOWN" or event=="SPELL_UPDATE_USABLE" or event=="ACTIONBAR_UPDATE_COOLDOWN" or event=="UNIT_POWER_UPDATE" or event=="PLAYER_TARGET_CHANGED" or event=="UPDATE_SHAPESHIFT_FORM" or event=="BAG_UPDATE_COOLDOWN" then
  if EUB_DB then updateVisuals() end
 elseif EUB_DB then refresh() end
end)
-- Some conditions change without a reliable event; lightweight periodic refresh.
local elapsedVisual=0
frame:HookScript("OnUpdate",function(_,elapsed)
 elapsedVisual=elapsedVisual+elapsed
 if elapsedVisual>=0.25 then elapsedVisual=0;updateVisuals() end
end)
SLASH_EASYUTILITYBAR1="/eub"
SLASH_EASYUTILITYBAR2="/fub"
SLASH_EASYUTILITYBAR3="/easyutilitybar"
SlashCmdList.EASYUTILITYBAR=function(msg)
 if not EUB_DB then say("초기화 대기 중");return end
 msg=(msg or ""):lower()
 if msg=="refresh" then refresh()
 elseif msg=="lock" then EUB_DB.locked=not EUB_DB.locked;refresh();say("잠금: "..tostring(EUB_DB.locked))
 elseif msg=="show" then EUB_DB.visible=true;refresh()
 elseif msg=="hide" then EUB_DB.visible=false;refresh()
 else options() end
end
