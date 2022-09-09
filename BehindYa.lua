BehindYa = {}
BehindYa.enabled = true

local windowName 	= "BehindYa"
local throttleTimer = 0
local throttleMax 	= 0.5
local iconNum 		= 2620
local Base 			= 0
local Print 		= EA_ChatWindow.Print
local SpikedSquig	= 1844
local critRate 		= 0
local bigCritThrot 	= 0
local bigCritMax 	= 1

local function CheckCareer()
	if GameData.Player.career.id == 27 then
		return true
	else
		return false
	end
end

function BehindYa.onInit()
	if not CheckCareer() then
		Print(L"<icon2620> BehindYa not active!")
		return
	end
	if LibSlash then
		LibSlash.RegisterSlashCmd("behindya", function(input) BehindYa.SlashHandler(input) end)
	end
	BehindYa.drawSpell()
	RegisterEventHandler(SystemData.Events.UPDATE_PROCESSED, 				"BehindYa.onUpdate")
	Print(L"<icon2620> BehindYa: active! /behindya for help :)")
end

function BehindYa.SlashHandler(args)
	local opt, val = args:match("(%w+)[ ]?(.*)")
	if opt == "on" then
		BehindYa.enabled = true
		Print(L"<icon2620> BehindYa sound is ON.")
	elseif opt == "off" then
		BehindYa.enabled = false
		Print(L"<icon2620> BehindYa sound is OFF.")
	else
		Print(L"<icon2620> To turn off the alert when at 100%+ crit type  '/behindya on' or '/behindya off'")
	end
end

function BehindYa.tacticExists()
	local tactics = GetActiveTactics()

	for k, v in pairs(tactics) do
		if v == 1875 then
			--yeah, you got it.
			return true
		end
	end
	return false
end

function BehindYa.drawSpell()
	CreateWindow(windowName, true)
	LayoutEditor.RegisterWindow("BehindYa", L"BehindYa", L"BehindYa", false, false, true, nil)
	local texture, x, y = GetIconData(iconNum)
	DynamicImageSetTexture(windowName.."SpellIcon", texture, x, y)
	WindowSetScale(windowName, .75)
	WindowSetScale(windowName.."SpellIcon", 1.25)
end

function BehindYa.updateCrit()
	local targetHP
	local tacticStat
	local petBuff

	TargetInfo:UpdateFromClient()
	if TargetInfo:UnitEntityId("selfhostiletarget") ~= 0 then
		targetHP = 100 - TargetInfo:UnitHealth("selfhostiletarget")
	else
		targetHP = 0
	end

	if BehindYa.tacticExists() == true then
		tacticStat = 15
	else
		tacticStat = 0
	end

	if BehindYa.spikedSquig() == true then
		petBuff = 5
	else
		petBuff = 0
	end

	critRate = GetBonus(GameData.BonusTypes.EBONUS_CRITICAL_HIT_RATE_RANGED, Base) + targetHP + tacticStat + petBuff
	BehindYa.updateTexts(critRate)
end

function BehindYa.spikedSquig()
	local buffs = GetBuffs (GameData.BuffTargetType.SELF)
	for k, v in pairs(buffs) do
		if v.abilityId == 1844 then
			--yeah, you got it.
			return true
		end
	end

	return false
end
function BehindYa.updateTexts(critRate)
	LabelSetText(windowName.."Label", towstring(critRate)..L"%")
	LabelSetText(windowName.."Shadow", towstring(critRate)..L"%")
end

function BehindYa.onUpdate(elapsed)
	-- get and update the crit rate
	throttleTimer = throttleTimer + elapsed
	if throttleTimer > throttleMax then
		BehindYa.updateCrit()
		throttleTimer = 0
		if critRate >= 100 then
		bigCritThrot = bigCritThrot + 0.5
			if bigCritThrot >= bigCritMax and TargetInfo:UnitHealth("selfhostiletarget") ~= 0 then
				PlaySound(GameData.Sound.AUCTION_HOUSE_CREATE_AUCTION)
				bigCritThrot = 0
			end
		end
	end
end