local curGameName = GAMESTATE:GetCurrentGame():GetName();

local t = Def.ActorFrame{
	LoadFont("Common Normal") .. {
		InitCommand=function(self)
		 self:horizalign(left):zoom(0.5)
		end;
		BeginCommand=function(self)
			self:settextf( Screen.String("CurrentGametype"), curGameName );
		end;
	};
};
return t;