local t = Def.ActorFrame{};
local topFrameHeight = 35
local bottomFrameHeight = 54
local borderWidth = 2

--Frames
-- t[#t+1] = Def.Quad{
-- 	InitCommand=function(self)
-- 		self:xy(0,0):halign(0):valign(0):zoomto(SCREEN_WIDTH,topFrameHeight):diffuse(getMainColor('frames'))
-- 	end;
-- };


t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:xy(0,SCREEN_HEIGHT):halign(0):valign(1):zoomto(SCREEN_WIDTH - 340,bottomFrameHeight):diffuse(getMainColor('frames')):diffusealpha(0.8)
	end;
};


--FrameBorders
-- t[#t+1] = Def.Quad{
-- 	InitCommand=function(self)
-- 		self:xy(0,topFrameHeight):halign(0):valign(1):zoomto(SCREEN_WIDTH,borderWidth):diffuse(getMainColor('highlight')):diffusealpha(0.5)
-- 	end;
-- };

t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:xy(0,SCREEN_HEIGHT-bottomFrameHeight):halign(0):valign(0):zoomto(SCREEN_WIDTH - 340,borderWidth):diffuse(getMainColor('highlight')):diffusealpha(1.0)
	end;
};

t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:xy(SCREEN_WIDTH - 340, SCREEN_HEIGHT-bottomFrameHeight):halign(0):valign(0):zoomto(borderWidth, bottomFrameHeight):diffuse(getMainColor('highlight')):diffusealpha(1.0)
	end;
};

if themeConfig:get_data().global.TipType == 2 or themeConfig:get_data().global.TipType == 3 then
	t[#t+1] = LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM-7):zoom(0.35):settext(getRandomQuotes(themeConfig:get_data().global.TipType)):diffuse(getMainColor('highlight')):diffusealpha(0):zoomy(0):maxwidth((SCREEN_WIDTH-350)/0.35)
		end;
		BeginCommand=function(self)
			self:sleep(2)
			self:smooth(1)
			self:diffusealpha(1)
			self:zoomy(0.35)
		end;
	};
end;

return t;