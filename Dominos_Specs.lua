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



	local toggle = Dominos_Specs:AddToggleToDominosOptions()
	toggle:Show()
	
	local f = CreateFrame('Frame')
	f:RegisterEvent('PLAYER_TALENT_UPDATE')
	f.text = f:CreateFontString(nil, 'BORDER', 'GameFontNormal')
	
	Dominos_Specs.ProfileManager = f

	Dominos_Specs.menu = {}
	Dominos_Specs.menuItems = { 'None',}

	for _,k in ipairs(Dominos.db:GetProfiles()) do
		table.insert(Dominos_Specs.menuItems, k)
	end
	for i= 1, 3 do
		Dominos_Specs.menu[i] = Dominos_Specs:NewMenu(UIParent, GetSpellTabInfo(i+1), i)
	end
	
	Dominos_Specs:Activate()		
end

function Dominos_Specs:OnPlayerTalentUpdate()
	Dominos_Specs.ProfileManager.text:SetText(Dominos.db:GetCurrentProfile());
	local current = Dominos_Specs.ProfileManager.text:GetText();
	local tree = select(2, GetTalentTabInfo(GetPrimaryTalentTree()));
	local Ptree = player..':'..tree;
	
	if (current ~= Ptree) and (Ptree ~= 'None') then
		Dominos:SetProfile(DominosSpecs[player][tree]);
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

function Dominos_Specs:Enable(enable)
	Dominos_Specs.player.enable = enable or nil
	Dominos_Specs:Activate()
end

function Dominos_Specs:AddToggleToDominosOptions()

	local name = 'Enable Dominos Specs'
	local toggle = Dominos.Options:NewSmallCheckButton(name)
	toggle.tooltipText = 'Click to allow Dominos Specs to automatically change your Dominos Profile when you swap active talent trees.'
	toggle:SetScript('OnClick', function(self) Dominos_Specs:Enable(self:GetChecked()) end)
	toggle:SetScript('OnShow', function(self) self:SetChecked(Dominos_Specs.player.enable)  end)
	toggle:SetPoint('CENTER', Dominos.Options)
	toggle:SetPoint('TOP', _G['DominosOptionsShow Tooltips in Combat'], 'BOTTOM', -8, -10)
	toggle:Hide()
	return toggle
end

function Dominos_Specs:NewMenu(pfr, name, i)
local parent = Dominos.Options
	local name = name..' Profile'
	local frame = Dominos.Options:NewDropdown(name)

	local r = DominosSpecs[player]
	if not r[name] then
		r[name] = 'None'
	end

	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(frame, self:GetID())
		frame.id =  UIDropDownMenu_GetValue(self:GetID())
		r[name] = Dominos_Specs.menuItems[self:GetID()]
		frame.text = r[name]
	end
 
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for k,v in pairs(Dominos_Specs.menuItems) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			UIDropDownMenu_AddButton(info, level)
			frame.text = r[i]
		end
	end
	
		frame:SetScript('OnShow', function(self)
			UIDropDownMenu_SetWidth(self, 110)
			UIDropDownMenu_Initialize(self, initialize)
			UIDropDownMenu_SetSelectedValue(self, r[name] or 'NONE')
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