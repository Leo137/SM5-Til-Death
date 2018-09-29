return LoadActor("_bg") .. {
  InitCommand=function(self)
    self:Center():zoomto(SCREEN_WIDTH+256,SCREEN_HEIGHT);
  end;
};