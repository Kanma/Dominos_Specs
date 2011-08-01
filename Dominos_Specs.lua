local function OnPlayerTalentUpdate(event)
	if DominosSpecs == nil then
		DominosSpecs = {};
	end

	local spec = GetSpellTabInfo(GetPrimaryTalentTree()+1);
	local player = GetUnitName("player")

	if not DominosSpecs[player] then
		DominosSpecs[player] = {};
	end

	if not DominosSpecs[player][spec] then
		Dominos:SaveProfile(player..":"..spec);
		DominosSpecs[player][spec] = 1;
	end

	Dominos:SetProfile(player..":"..spec);
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_TALENT_UPDATE")
f:SetScript("OnEvent", function(event) OnPlayerTalentUpdate(event) end)