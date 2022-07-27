local playerGUID = UnitGUID("player")
local lastTwistTime = time()
local lastSealTime = time()

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event)
  self:COMBAT_LOG_EVENT_UNFILTERED(CombatLogGetCurrentEventInfo())
end)

function f:COMBAT_LOG_EVENT_UNFILTERED(...)
  local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
  local spellId, spellName, spellSchool
  local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

  if subevent == "SWING_DAMAGE" then
    amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
  elseif subevent == "SPELL_DAMAGE" then
    spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
  elseif subevent == "SPELL_HEAL" then
    spellId, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
  end

  if sourceGUID == playerGUID and spellName ~= nil and string.match(spellName, "Seal") then
    local currentTime = time()
    if (lastSealTime + 0.1 >= currentTime) and (lastTwistTime + 1 <= currentTime) then
      if (2 >= math.random(1,100)) then
        PlaySoundFile("Interface\\AddOns\\WowITwisted\\sounds\\gtsmate.mp3","master")
      else
        PlaySoundFile("Interface\\AddOns\\WowITwisted\\sounds\\"..tostring(math.random(1,17))..".mp3","master")
      end
      lastTwistTime = currentTime
    end
    lastSealTime = currentTime
  end
end