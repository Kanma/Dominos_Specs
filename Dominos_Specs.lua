local f = CreateFrame("Frame")
f.text = f:CreateFontString(nil, "BORDER", "GameFontNormal")
f.l = 0
local function OnPlayerTalentUpdate()
	if f.l == 0 then
		f.l = 1
		--Whenever "PLAYER_TALENT_UPDATE" occurs, 
		--it actually fires twice in a row, 
		--so we want to skip it every other time.
		--it also skips the very first uccurence which 
		--fires off BEFORE "PLAYER_ENTERING_WORLD" and
		--because it fires so early, would cause bad bugs.
	elseif f.l == 1 then
	
		f.text:SetText(Dominos.db:GetCurrentProfile());
		local current = f.text:GetText();
		
		if DominosSpecs == nil then
			DominosSpecs = {};
		end
	
		local player = GetUnitName("player");
		local tree = select(2, GetTalentTabInfo(GetPrimaryTalentTree()));
		local Ptree = player..":"..tree;
	
		if not DominosSpecs[player] then
			DominosSpecs[player] = {};
		end

		if not DominosSpecs[player][tree] then
			Dominos:SaveProfile(Ptree);
			DominosSpecs[player][tree] = 1;
		end
	
		if current ~= Ptree then
			Dominos:SetProfile(Ptree);
		end
		f.l = 0
	end
end

f:RegisterEvent("PLAYER_TALENT_UPDATE")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(event) OnPlayerTalentUpdate() end)
