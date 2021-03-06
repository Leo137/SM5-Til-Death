local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame {
  FOV=90;
  InitCommand=function(self)
   self:Center()
  end;
	Def.Quad {
		InitCommand=function(self)
		 self:scaletoclipped(SCREEN_WIDTH,SCREEN_HEIGHT)
		end;
		OnCommand=function(self)
		 self:diffuse(getMainColor('positive')):diffusebottomedge(getMainColor('positive')):diffusealpha(0.0)
		end;
	};
	Def.ActorFrame {
		LoadActor("_pattern") .. {
			InitCommand=function(self)
			 self:hide_if(hideFancyElements):rotationy(-12.25):rotationz(-30):rotationx(-20):zoomto(SCREEN_WIDTH*2,SCREEN_HEIGHT*2):customtexturerect(0,0,SCREEN_WIDTH*4/256,SCREEN_HEIGHT*4/256)
			end;
			OnCommand=function(self)
			 self:texcoordvelocity(0.125,0.5):diffuse(getMainColor('positive')):diffusealpha(0.045):bob():effectmagnitude(0,0,35):effectperiod(8):diffusealpha(0.025)
			end;
		};
	};
	LoadActor("_particleLoader") .. {
		InitCommand=function(self)
		 self:x(-SCREEN_CENTER_X):y(-SCREEN_CENTER_Y):hide_if(hideFancyElements)
		end;
	};
--[[ 	LoadActor("_particles") .. {
		InitCommand=function(self)
		 self:x(-SCREEN_CENTER_X):y(-SCREEN_CENTER_Y)
		end;
	}; --]]


--[[ 	LoadActor("_pattern") .. {
		InitCommand=function(self)
		 self:z(32):x(4):y(4):rotationy(-12.25):rotationz(-30):rotationx(-20):zoomto(SCREEN_WIDTH*2,SCREEN_HEIGHT*2):customtexturerect(0,0,SCREEN_WIDTH*4/256,SCREEN_HEIGHT*4/256)
		end;
		OnCommand=function(self)
		 self:texcoordvelocity(0.125,0.5):diffuse(Color("Black")):diffusealpha(0.5)
		end;
	}; --]]
--[[ 	LoadActor("_grid") .. {
		InitCommand=function(self)
		 self:customtexturerect(0,0,(SCREEN_WIDTH+1)/4,SCREEN_HEIGHT/4):SetTextureFiltering(true)
		end;
		OnCommand=function(self)
		 self:zoomto(SCREEN_WIDTH+1,SCREEN_HEIGHT):diffuse(Color("Orange")):diffuseshift():effecttiming((1/8)*2,0,(7/8)
		end;
		effectcolor2,Color("Orange");effectcolor1,Color.Alpha(Color("Orange"),0.45);fadebottom,0.25;fadetop,0.25;croptop,48/480;cropbottom,48/480);
	}; --]]
};

return t;
