return Def.ActorFrame {
	InitCommand=function(self)
		self:xy(SCREEN_WIDTH - 80, SCREEN_BOTTOM - 50)
	end;

	LoadActor(THEME:GetPathG("_icon","Health")) .. {
		InitCommand=function(self)
		 self:x(-80):shadowlength(1):diffuse(color("#b87cf0"))
		end;
	};
	LoadFont("Common Normal") .. {
		Text=GetLifeDifficulty();
		AltText="";
		InitCommand=function(self)
		 self:x(-72+10):horizalign(left):zoom(0.5)
		end;
		OnCommand=function(self)
		 self:shadowlength(1)
		end;
		BeginCommand=function(self)
			self:settextf( Screen.String("LifeDifficulty"), "" ):diffuse(color("#b87cf0"));
		end
	};
	LoadFont("Common Normal") .. {
		Text=GetLifeDifficulty();
		AltText="";
		InitCommand=function(self)
		 self:x(72*0.75+8):zoom(0.875)
		end;
		OnCommand=function(self)
		 self:shadowlength(1):skewx(-0.125):diffuse(color("#b87cf0"))
		end;
	};
};