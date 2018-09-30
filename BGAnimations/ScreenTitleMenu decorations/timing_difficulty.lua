return Def.ActorFrame {
	InitCommand=function(self)
		self:xy(SCREEN_WIDTH - 80, SCREEN_BOTTOM - 20)
	end;

	LoadActor(THEME:GetPathG("_icon","Timing")) .. {
		InitCommand=function(self)
		 self:x(-80):shadowlength(1):diffuse(color("#b87cf0"))
		end;
	};
	LoadFont("Common Normal") .. {
		Text=GetTimingDifficulty();
		AltText="";
		InitCommand=function(self)
		 self:x(-72+10):horizalign(left):zoom(0.5)
		end;
		OnCommand=function(self)
		 self:shadowlength(1)
		end;
		BeginCommand=function(self)
			self:settextf( Screen.String("TimingDifficulty"), "" ):diffuse(color("#b87cf0"));
		end
	};
	LoadFont("Common Normal") .. {
		Text=GetTimingDifficulty();
		AltText="";
		InitCommand=function(self)
		 self:x(72*0.75+8):zoom(0.875)
		end;
		OnCommand=function(self)
			self:shadowlength(1):skewx(-0.125);
			if GetTimingDifficulty() == 9 then
				self:zoom(0.5):diffuse(ColorLightTone( Color("Orange")));
			else
				self:settext( GetTimingDifficulty() ):diffuse(color("#b87cf0"));
			end
		end;
	};
};