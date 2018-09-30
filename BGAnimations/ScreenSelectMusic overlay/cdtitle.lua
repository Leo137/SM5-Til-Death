local t = Def.ActorFrame{
  BeginCommand=function(self)
    self:queuecommand("Set")
  end,
  OffCommand=function(self)
    self:bouncebegin(0.2):xy(-500,0):diffusealpha(0)
  end,
  OnCommand=function(self)
    self:bouncebegin(0.2):xy(0,0):diffusealpha(1)
  end,
  SetCommand=function(self)
    self:finishtweening()
    if getTabIndex() == 0 then
      self:queuecommand("On")
      update = true
    else 
      self:queuecommand("Off")
      update = false
    end
  end,
  TabChangedMessageCommand=function(self)
    self:queuecommand("Set")
  end,
}

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


return t;