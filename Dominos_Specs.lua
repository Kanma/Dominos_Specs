<<<<<<< HEAD
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
=======
local Dominos_Specs = CreateFrame("Frame")
Dominos_Specs:RegisterEvent("PLAYER_TALENT_UPDATE")

function Dominos_Specs:SwapProfiles()
	if DominosSpecs.Enable then
		if DominosSpecs.TreeBased then
			Dominos_Specs:SetScript("OnEvent", function() 
				local tree = GetPrimaryTalentTree();
				if (Dominos.db:GetCurrentProfile() ~= DominosSpecs.Tree[tree]) and (tree ~= 'None') then
					Dominos:SetProfile(DominosSpecs.Tree[tree]);
				end
			end)
		elseif DominosSpecs.SpecBased  then
			Dominos_Specs:SetScript("OnEvent", function() 
				local spec = GetActiveTalentGroup();
				if (Dominos.db:GetCurrentProfile() ~= DominosSpecs.Spec[spec]) and (spec ~= 'None') then
					Dominos:SetProfile(DominosSpecs.Spec[spec]);
				end
			end)			
		else
			Dominos_Specs:SetScript("OnEvent", nil)
		end
	else
		Dominos_Specs:SetScript("OnEvent", nil)
	end
end

function Dominos_Specs:Load()
	if not DominosSpecs.Tree then
		DominosSpecs.Tree = {}
	end
	if not DominosSpecs.Spec then
		DominosSpecs.Spec = {}
	end
	local panel = Dominos_Specs:NewOptionsPanel("Specs", Dominos.Options)
	local enable = Dominos_Specs:NewCheckButton("Enable", panel)
		enable.OnShow = function(self) self:SetChecked(DominosSpecs.Enable) end
		enable.OnClick = function(self)	Dominos_Specs:OnClick(self, "Enable", self:GetChecked())	end
		enable.kids = {}
		enable.kids[1] = Dominos_Specs:NewCheckButton("Specialization Based", panel)
		do
			enable.kids[1].kids = {}
			local f = enable.kids[1]
			f:SetScript("OnHide", function(self) for i = 1, #self.kids do self.kids[i]:Hide()end end)
			f.kids[1] = Dominos_Specs:NewMenu(panel, "Main Spec", Dominos.db:GetProfiles(),  DominosSpecs.Spec[1])
			f.kids[1].OnClick = function(val) Dominos_Specs:MenuClick(val, "Spec", 1) end
			f.kids[2] = Dominos_Specs:NewMenu(panel, "Secondary Spec", Dominos.db:GetProfiles(),  DominosSpecs.Spec[2])
			f.kids[2].OnClick = function(val) Dominos_Specs:MenuClick(val, "Spec", 2) end
			enable.kids[1].OnShow = function(self) self:SetChecked(DominosSpecs.SpecBased)  Dominos_Specs:Toggles(self, DominosSpecs.SpecBased) end
>>>>>>> Finished
		end

		enable.kids[2] = Dominos_Specs:NewCheckButton("Talent Tree Based", panel)
		do
			enable.kids[2].kids = {}
			local f = enable.kids[2]
			f:SetScript("OnHide", function(self) for i = 1, #self.kids do self.kids[i]:Hide()end end)
			f.kids[1] = Dominos_Specs:NewMenu(panel, "Tree One", Dominos.db:GetProfiles(), DominosSpecs.Tree[1])
			f.kids[1]:ClearAllPoints()
			f.kids[1]:SetPoint("TopRight", -50, - 30)
			f.kids[1].OnClick = function(val) Dominos_Specs:MenuClick(val, "Tree", 1) end
			f.kids[2] = Dominos_Specs:NewMenu(panel, "Tree Two", Dominos.db:GetProfiles(), DominosSpecs.Tree[2])
			f.kids[2].OnClick = function(val) Dominos_Specs:MenuClick(val, "Tree", 2) end
			f.kids[3] = Dominos_Specs:NewMenu(panel, "Tree Three", Dominos.db:GetProfiles(),  DominosSpecs.Tree[3])
			f.kids[3].OnClick = function(val) Dominos_Specs:MenuClick(val, "Tree", 3) end
			enable.kids[2].OnShow = function(self) self:SetChecked(DominosSpecs.TreeBased)   Dominos_Specs:Toggles(self, DominosSpecs.TreeBased) end
		end
		
		enable.kids[1].OnClick = function(self)
			Dominos_Specs:OnClick(self, "SpecBased", self:GetChecked())
			Dominos_Specs:OnClick(enable.kids[2], "TreeBased", nil)
			enable.kids[2]:SetChecked(nil)
		end
		enable.kids[2].OnClick = function(self)
			Dominos_Specs:OnClick(self, "TreeBased", self:GetChecked())
			Dominos_Specs:OnClick(enable.kids[1], "SpecBased", nil)
			enable.kids[1]:SetChecked(nil)
		end
		
		Dominos_Specs:Toggles(enable, "Enable", DominosSpecs.Enable)
		Dominos_Specs:SwapProfiles()
end

--Utilities
do
	function Dominos_Specs:NewMenu(parent, name, table, val)
 		local menu = CreateFrame('Button', parent:GetName()..name..'DropMenu', parent, 'UIDropDownMenuTemplate')
		menu.title = menu:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		menu.title:SetPoint('BOTTOMLEFT', menu, 'TOPLEFT',20,0)
		menu.title:SetText(name)
		menu:SetID(random(1, 1000))

		local function OnClick(self)
			UIDropDownMenu_SetSelectedID(menu, self:GetID())
			menu.id =  UIDropDownMenu_GetValue(self:GetID())
			menu.text = self:GetID()
			UIDropDownMenu_SetText(menu, menu.id)
			UIDropDownMenu_Initialize(menu, initialize)
			menu.OnClick(menu.id)
		end

<<<<<<< HEAD
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
=======
		local function initialize(self, level)
			local info = UIDropDownMenu_CreateInfo()
			for k,v in pairs(table) do
				info = UIDropDownMenu_CreateInfo()
				info.text = v
				info.value = v
				info.func  = OnClick
				UIDropDownMenu_AddButton(info, level)
				if val == v then
					UIDropDownMenu_SetText(menu, v)
				end
			end
		end

		UIDropDownMenu_Initialize(menu, initialize)
		UIDropDownMenu_SetWidth(menu, 180, 0)
		UIDropDownMenu_Initialize(menu, initialize)
		UIDropDownMenu_JustifyText(menu, 'LEFT')

		local prev = parent.PrevDrop
		if prev then
			menu :SetPoint("Top", prev, "Bottom",0, -20)
		else
			menu :SetPoint("TopRight", -50, - 30)
>>>>>>> Finished
		end
		parent.PrevDrop = menu
		return menu
	end
	
	function Dominos_Specs:NewOptionsPanel(name, parent)
		local panel = CreateFrame('FRAME', name.."-Options", UIParent)
		panel.name = name;
		panel.parent = parent.name
		InterfaceOptions_AddCategory(panel)
		panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		panel.title:SetPoint("TopLeft", 5 ,-5)
		panel.title:SetText(panel.name)
		return panel
	end
	
	function Dominos_Specs:NewCheckButton(title, parent)
		local check = CreateFrame("CheckButton", title..parent:GetName(), parent, "InterfaceOptionsCheckButtonTemplate")
		_G[check:GetName() .. 'Text']:SetText(title)
		check:SetScript("OnShow", function(self) check.OnShow(self) end)
		check:SetScript("OnClick", function(self) check.OnClick(self) end)

		local prev = parent.PrevCheck
		if prev then
			check :SetPoint("Top", prev, "Bottom",0, 0)
		else
			check :SetPoint("TopLeft", 15, - 30)
		end
		parent.PrevCheck = check
	
		return check
	end
	
	function Dominos_Specs:Toggles(self, enable)
		for i = 1, #self.kids do
			if enable then
				self.kids[i]:Show()
			else
				self.kids[i]:Hide()	
			end
		end
	end

	function Dominos_Specs:OnClick(self, val, enable)
		DominosSpecs[val] = enable or nil
		Dominos_Specs:Toggles(self, DominosSpecs[val])
		Dominos_Specs:SwapProfiles()
	end
<<<<<<< HEAD
 
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
=======
>>>>>>> Finished

	function Dominos_Specs:MenuClick(val, type, num)
	 	DominosSpecs[type][num] = val
	 	Dominos_Specs:SwapProfiles()
	end
end

<<<<<<< HEAD
Dominos_Specs.Loader = CreateFrame('Frame')
Dominos_Specs.Loader:RegisterEvent('PLAYER_ENTERING_WORLD')
Dominos_Specs.Loader:SetScript('OnEvent', function(event) Dominos_Specs:OnLoad()end)
=======
local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', function(event) Dominos_Specs:Load() f:SetScript('OnEvent',nil ) end)
>>>>>>> Finished
