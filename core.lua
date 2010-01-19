-- Settings

local bar_height = 5
local bar_width  = 100
local texture 	 = [=[Interface\AddOns\oUF_Nifty\textures\statusbar]=]

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local colors = {
	[1] = {0, 1, 0},
	[2] = {1, 1, 0},
	[3] = {1, 0, 0},
}

-- Addon
local ThreatBar = CreateFrame('StatusBar', 'ThreatBar')

ThreatBar:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
ThreatBar:RegisterEvent('UNIT_THREAT_LIST_UPDATE')
ThreatBar:RegisterEvent('ADDON_LOADED')

function ThreatBar:ADDON_LOADED (addon)
	if addon:lower() ~= 'threatbar' then return end
	
	self:SetPoint('CENTER', UIParent, 'CENTER', 0, -250)
	self:SetHeight(bar_height)
	self:SetWidth(bar_width)

	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0, .5)
	
	self:SetStatusBarTexture(texture)
	self:SetMinMaxValues(0, 100)
		
	self:UnregisterEvent('ADDON_LOADED')
end

function ThreatBar:UNIT_THREAT_LIST_UPDATE () 
	local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation('player', 'target')
	
	local threat = threatpct or 0
	
	if status == nil or rawthreatpct == 0 then
		self:Hide()
		return
	end
	
	self:Show()
	self:SetValue(threat)
		
	if threat < 30 then 
		self:SetStatusBarColor(unpack(colors[1]))
	elseif threat >= 30 and threat < 70 then
		self:SetStatusBarColor(unpack(colors[2]))
	else
		self:SetStatusBarColor(unpack(colors[3]))
	end
	
end