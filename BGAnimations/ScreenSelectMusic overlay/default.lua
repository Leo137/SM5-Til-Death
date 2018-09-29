local function input(event)
	local top = SCREENMAN:GetTopScreen()
	if event.DeviceInput.button == 'DeviceButton_left mouse button' then
		if event.type == "InputEventType_Release" then
			if not SCREENMAN:get_input_redirected(PLAYER_1) then
				if isOver(top:GetChild("Overlay"):GetChild("PlayerAvatar"):GetChild("Avatar"..PLAYER_1):GetChild("Image")) then
					SCREENMAN:AddNewScreenToTop("ScreenAvatarSwitch")
				end
			end
		end
	end
	if event.DeviceInput.button == "DeviceButton_left mouse button" and event.type == "InputEventType_Release" then
		MESSAGEMAN:Broadcast("MouseLeftClick")
	elseif event.DeviceInput.button == "DeviceButton_right mouse button" and event.type == "InputEventType_Release" then
		MESSAGEMAN:Broadcast("MouseRightClick")
	end
return false
end

local t = Def.ActorFrame{
	BeginCommand=function(self) 
		local s = SCREENMAN:GetTopScreen()
		s:AddInputCallback(input) 
		if s:GetName() == "ScreenNetSelectMusic" then
			s:UsersVisible(false) 
		end
	end
}

t[#t+1] = Def.Actor{
	CodeMessageCommand=function(self,params)
		if params.Name == "AvatarShow" and getTabIndex() == 0 and not SCREENMAN:get_input_redirected(PLAYER_1) then
			SCREENMAN:AddNewScreenToTop("ScreenAvatarSwitch")
		end
	end
}

t[#t+1] = LoadActor("../_frame")
t[#t+1] = LoadActor("../_PlayerInfo")
-- t[#t+1] = LoadActor("currentsort")
t[#t+1] = LoadFont("Common Large")..{
	InitCommand=function(self)
		self:xy(5,32):halign(0):valign(1):zoom(0.55):diffuse(getMainColor('positive')):settext("Select Music:")
	end;
}

t[#t+1] = LoadActor("../searchbar")
t[#t+1] = LoadActor("../_cursor")
t[#t+1] = LoadActor("../_halppls")
t[#t+1] = LoadActor("currenttime")

-- CDtitle, need to figure out a better place for this later. -mina
--Gonna move the cdtitle right next to selected song similar to ultralight. -Misterkister
t[#t+1] = Def.Sprite {
	InitCommand=function(self)
		self:xy(capWideScale(get43size(344),364),capWideScale(get43size(345),255) - 50):halign(0.5):valign(1)
	end,
	SetCommand=function(self)
		self:finishtweening()
		if GAMESTATE:GetCurrentSong() then
			local song = GAMESTATE:GetCurrentSong()	
			if song then
				if song:HasCDTitle() then
					self:visible(true)
					self:Load(song:GetCDTitlePath())
				else
					self:visible(false)
				end
			else
				self:visible(false)
			end
			local height = self:GetHeight()
			local width = self:GetWidth()
			
			if height >= 60 and width >= 75 then
				if height*(75/60) >= width then
				self:zoom(60/height)
				else
				self:zoom(75/width)
				end
			elseif height >= 60 then
				self:zoom(60/height)
			elseif width >= 75 then
				self:zoom(75/width)
			else
				self:zoom(1)
			end
		else
		self:visible(false)
		end
	end,
	BeginCommand=function(self)
		self:queuecommand("Set")
	end,
	RefreshChartInfoMessageCommand=function(self)
		self:queuecommand("Set")
	end,
}


GAMESTATE:UpdateDiscordMenu(GetPlayerOrMachineProfile(PLAYER_1):GetDisplayName() .. ": " .. string.format("%5.2f", GetPlayerOrMachineProfile(PLAYER_1):GetPlayerRating()))

return t
