Swap = {}
function Swap:OnEvent(event)
	local spec = GetSpellTabInfo(GetPrimaryTalentTree()+1)
	if event == "PLAYER_ENTERING_WORLD" then
		if DominosSpecs == nil then
			DominosSpecs = {}
		end
		local player = GetUnitName("player")
		if not DominosSpecs[player] then
			DominosSpecs[player] = {}
		end
		local s = DominosSpecs[player]


		if not s[GetSpellTabInfo(GetPrimaryTalentTree()+1)] then
			s[GetSpellTabInfo(GetPrimaryTalentTree()+1)] = 1
			Dominos:SaveProfile(GetUnitName("player")..":"..spec)
		end
	elseif event == "PLAYER_TALENT_UPDATE" then
		Dominos:SetProfile(  GetUnitName("player")..":"..spec)
	end
end


Swap.temp = CreateFrame("Frame")
Swap.temp:RegisterEvent("PLAYER_TALENT_UPDATE")
Swap.temp:RegisterEvent("PLAYER_ENTERING_WORLD")
Swap.temp:SetScript("OnEvent", function(event) Swap:OnEvent(event) end)
