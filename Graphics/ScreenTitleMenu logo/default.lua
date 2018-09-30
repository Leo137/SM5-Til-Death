local t = Def.ActorFrame{
	InitCommand=function(self)
	 self:fov(70)
	end;
	LoadActor("_arrow")..{
		InitCommand=function(self)
		 self:x(225)
		end;
		OnCommand=function(self)
		 self:wag():effectmagnitude(0,0,16):effectperiod(2.5)
		end;
	};
	LoadActor("_text");
	LoadActor("_text")..{
		Name="TextGlow";
		InitCommand=function(self)
		 self:blend(Blend.Add):diffusealpha(0.05)
		end;
		OnCommand=function(self)
		 self:glowshift():effectperiod(2.5):effectcolor1(color("1,1,1,0.25")):effectcolor2(color("1,1,1,1"))
		end;
	};
	LoadActor("_author")..{
		InitCommand=function(self)
		 self:x(129):y(30):zoom(0.5)
		end;
	};
	
};

return t;
