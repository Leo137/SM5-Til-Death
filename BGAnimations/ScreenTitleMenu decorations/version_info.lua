return Def.ActorFrame {
	LoadActor(THEME:GetPathG("ScreenTitleMenu","PreferenceFrame")) .. {
		OnCommand=function(self)
		 self:diffuse(color("#f7941d")):diffusetopedge(color("#fff200")):diffusealpha(0.25)
		end;
	};
	LoadFont("Common Normal") .. {
		Text=ProductFamily();
		AltText="StepMania";
		InitCommand=function(self)
		 self:xy(10, SCREEN_BOTTOM -25):zoom(0.6):halign(0):diffuse(color("#b87cf0"))
		end;
		OnCommand=function(self)
		 self:shadowlength(1)
		end;
	};
	LoadFont("Common Normal") .. {
		Text=ProductVersion() .. " (".. VersionDate() ..")";
		AltText="";
		InitCommand=function(self)
		 self:xy(10, SCREEN_BOTTOM - 10):zoom(0.45):halign(0):diffuse(color("#b87cf0"))
		end;
		OnCommand=function(self)
		 self:shadowlength(1):skewx(-0.125)
		end;
	};
};