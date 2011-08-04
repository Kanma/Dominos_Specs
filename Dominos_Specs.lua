local Dominos_Specs = {}
local player = GetUnitName('player');

function Dominos_Specs:OnLoad()
	if DominosSpecs == nil then
		DominosSpecs = {};
	end
	
	if not DominosSpecs[player] then
		DominosSpecs[player] = {};
	end
	
	Dominos_Specs.player = DominosSpecs[player]
	
	Dominos_Specs.Toggle = Dominos_Specs:AddToggleToDominosOptions()
	
	local f = CreateFrame('Frame')
	local e = CreateFrame('Frame')
	f:RegisterEvent('PLAYER_TALENT_UPDATE')
	e:RegisterEvent('PLAYER_TALENT_UPDATE')
	f.text = f:CreateFontString(nil, 'BORDER', 'GameFontNormal')
	
	Dominos_Specs.ProfileManager = f
	Dominos_Specs.SpecProfileManager = e

	Dominos_Specs.menu = {}
	Dominos_Specs.menuItems = { 'None',}

	for _,k in ipairs(Dominos.db:GetProfiles()) do
		table.insert(Dominos_Specs.menuItems, k)
	end
	for i= 1, 3 do
		Dominos_Specs.menu[i] = Dominos_Specs:NewMenu(GetSpellTabInfo(i+1), i)
	end
	Dominos_Specs.Specmenu = {}
	Dominos_Specs.Specmenu[1] = Dominos_Specs:NewSpecMenu("Main Spec", 1)
	Dominos_Specs.Specmenu[2] = Dominos_Specs:NewSpecMenu("Secondary Spec", 2)
	if not Dominos_Specs.player.on then
		Dominos_Specs.player.enable = nil
		Dominos_Specs.player.Specenable = nil
	end
	Dominos_Specs:Activate()	
	Dominos_Specs:SpecActivate()

	Dominos_Specs:TurnOn()
end

function Dominos_Specs:OnSpecChanged()
	Dominos_Specs.ProfileManager.text:SetText(Dominos.db:GetCurrentProfile());
	local current = Dominos_Specs.ProfileManager.text:GetText();
	local spec = DominosSpecs[player]["1"][GetActiveTalentGroup()];
	
	if (current ~= spec) and (spec ~= 'None') then
		Dominos:SetProfile(spec);
	end
end

function Dominos_Specs:OnPlayerTalentUpdate()
	Dominos_Specs.ProfileManager.text:SetText(Dominos.db:GetCurrentProfile());
	local current = Dominos_Specs.ProfileManager.text:GetText();
	local tree = DominosSpecs[player]["2"][GetPrimaryTalentTree()];
	
	if (current ~= tree) and (tree ~= 'None') then
		Dominos:SetProfile(tree);
	end
end

function Dominos_Specs:TurnOn()
	if Dominos_Specs.player.on then
		Dominos_Specs.Toggle.toggle:Show()
		Dominos_Specs.Toggle.subtoggle:Show()
	else 
		Dominos_Specs.Toggle.toggle:Hide()
		Dominos_Specs.Toggle.subtoggle:Hide()

	end
end

function Dominos_Specs:Activate()
	if Dominos_Specs.player.enable then
		Dominos_Specs.ProfileManager:SetScript('OnEvent', Dominos_Specs.OnPlayerTalentUpdate)
		for i= 1, #Dominos_Specs.menu do
			Dominos_Specs.menu[i]:Show()
		end
	else
		Dominos_Specs.ProfileManager:SetScript('OnEvent', nil)
		for i= 1, #Dominos_Specs.menu do
			Dominos_Specs.menu[i]:Hide()
		end
	end
end

function Dominos_Specs:SpecActivate()
	if Dominos_Specs.player.Specenable then
		Dominos_Specs.SpecProfileManager:SetScript('OnEvent', Dominos_Specs.OnSpecChanged)
		for i= 1, #Dominos_Specs.Specmenu do
			Dominos_Specs.Specmenu[i]:Show()
		end
	else
		Dominos_Specs.SpecProfileManager:SetScript('OnEvent', nil)
		for i= 1, #Dominos_Specs.Specmenu do
			Dominos_Specs.Specmenu[i]:Hide()
		end
	end
end

function Dominos_Specs:On(enable)
	Dominos_Specs.player.on = enable or nil
	Dominos_Specs:TurnOn()
end

function Dominos_Specs:Enable(enable)
	Dominos_Specs.player.enable = enable or nil
	Dominos_Specs:Activate()
end

function Dominos_Specs:SpecEnable(enable)
	Dominos_Specs.player.Specenable = enable or nil
	Dominos_Specs:SpecActivate()
end

function Dominos_Specs:AddToggleToDominosOptions()
	local name = 'Enable Dominos Specs'
	local Maintoggle  = Dominos.Options:NewCheckButton(name)
		Maintoggle.toggle = Dominos.Options:NewSmallCheckButton("Talent Tree Based Profiles")
	Maintoggle.subtoggle = Dominos.Options:NewSmallCheckButton("Spec Based Profiles")
	
	
	
	Maintoggle.tooltipText = 'Click to Activate Dominos Specs.'
	Maintoggle:SetScript('OnClick', function(self)
		Dominos_Specs:On(self:GetChecked())
		
		
		if self:GetChecked() ~= 1 then
			Maintoggle.subtoggle:SetChecked(nil)
			Dominos_Specs:SpecEnable(Maintoggle.subtoggle:GetChecked())
			Maintoggle.toggle:SetChecked(nil)
			Dominos_Specs:Enable(Maintoggle.toggle:GetChecked())
		end
	end)
	Maintoggle:SetScript('OnShow', function(self) self:SetChecked(Dominos_Specs.player.on) end)
	Maintoggle:SetPoint('TOP', _G['DominosOptionsShow Tooltips in Combat'], 'BOTTOM', -8, -10)


	Maintoggle.toggle.tooltipText = 'Click to allow Dominos Specs to automatically change your Dominos Profile when you swap active talent trees.'
	Maintoggle.toggle:SetScript('OnClick', function(self)
		Dominos_Specs:Enable(self:GetChecked())
		
		Maintoggle.subtoggle:SetChecked(nil)
		Dominos_Specs:SpecEnable(Maintoggle.subtoggle:GetChecked())
	end)
	Maintoggle.toggle:SetScript('OnShow', function(self) self:SetChecked(Dominos_Specs.player.enable)  end)
	Maintoggle.toggle:SetPoint('CENTER', Dominos.Options)
	Maintoggle.toggle:SetPoint('TOP', Maintoggle, 'BOTTOM', 8, -2)


	Maintoggle.subtoggle.tooltipText = 'Click to allow Dominos Specs to automatically change your Dominos Profile when you change Specializations.'
	Maintoggle.subtoggle:SetScript('OnClick', function(self)
		Dominos_Specs:SpecEnable(self:GetChecked())
		
		Maintoggle.toggle:SetChecked(nil)
		Dominos_Specs:Enable(Maintoggle.toggle:GetChecked())		
	end)
	Maintoggle.subtoggle:SetScript('OnShow', function(self) self:SetChecked(Dominos_Specs.player.Specenable)  end)
	Maintoggle.subtoggle:SetPoint('CENTER', Dominos.Options)
	Maintoggle.subtoggle:SetPoint('TOP', Maintoggle.toggle, 'BOTTOM', 0, -2)
	
	
	return Maintoggle
end

function Dominos_Specs:NewSpecMenu(name, x)
local parent = Dominos.Options
	local name = name..' Profile'
	local frame = Dominos.Options:NewDropdown(name)

	local r = DominosSpecs[player]
	if not r["1"] then
		r["1"] = {}
	end
	if not r["1"][x] then
		r["1"][x] = 'None'
	end
	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(frame, self:GetID())
		frame.id =  UIDropDownMenu_GetValue(self:GetID())
		r["1"][x] = Dominos_Specs.menuItems[self:GetID()]
		frame.text = r["1"][x]
	end
 
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(Dominos_Specs.menuItems) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	
	frame:SetScript('OnShow', function(self)
		UIDropDownMenu_SetWidth(self, 110)
		UIDropDownMenu_Initialize(self, initialize)
		UIDropDownMenu_SetSelectedValue(self, r["1"][x] or 'NONE')
	end)
	
	UIDropDownMenu_JustifyText(frame, 'LEFT')

	local prev = Dominos_Specs.menuFrame2
	if prev then
		frame:SetPoint('TOP', prev, 'BOTTOM', 0, -16)
	else
		frame:SetPoint('TOPRIGHT', _G['DominosOptionsVehicle/Possess ActionsButton'], 'BOTTOMRIGHT', 16, -20)
	end
	Dominos_Specs.menuFrame2 = frame
	
	return frame
end

function Dominos_Specs:NewMenu(name, i)
local parent = Dominos.Options
	local name = name..' Profile'
	local frame = Dominos.Options:NewDropdown(name)

	local r = DominosSpecs[player]
	if not r["2"] then
		r["2"] = {}
	end
	if not r["2"][i] then
		r["2"][i] = 'None'
	end
	local f = r["2"][i]

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(frame, self:GetID())
		frame.id =  UIDropDownMenu_GetValue(self:GetID())
		 r["2"][i] = Dominos_Specs.menuItems[self:GetID()]
		frame.text =  r["2"][i]
	end
 
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(Dominos_Specs.menuItems) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
		end
	end
	
	frame:SetScript('OnShow', function(self)
		UIDropDownMenu_SetWidth(self, 110)
		UIDropDownMenu_Initialize(self, initialize)
		UIDropDownMenu_SetSelectedValue(self, r["2"][i] or 'NONE')
	end)
	
	UIDropDownMenu_JustifyText(frame, 'LEFT')

	local prev = Dominos_Specs.menuFrame
	if prev then
		frame:SetPoint('TOP', prev, 'BOTTOM', 0, -16)
	else
		frame:SetPoint('TOPRIGHT', _G['DominosOptionsVehicle/Possess ActionsButton'], 'BOTTOMRIGHT', 16, -20)
	end
	Dominos_Specs.menuFrame = frame
	
	return frame
end

Dominos_Specs.Loader = CreateFrame('Frame')
Dominos_Specs.Loader:RegisterEvent('PLAYER_ENTERING_WORLD')
Dominos_Specs.Loader:SetScript('OnEvent', function(event) Dominos_Specs:OnLoad()end)
