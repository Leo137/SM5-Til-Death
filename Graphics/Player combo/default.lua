local c;
local cf;
local player = Var "Player";
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt");
local Pulse = THEME:GetMetric("Combo", "PulseCommand");
local PulseLabel = THEME:GetMetric("Combo", "PulseLabelCommand");

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom");
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom");
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt");

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom");
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom");

local ShowFlashyCombo = false

local t = Def.ActorFrame {
	InitCommand=function(self) self:vertalign(bottom) end;
	-- flashy combo elements:
 	LoadActor(THEME:GetPathG("Combo","100Milestone")) .. {
		Name="OneHundredMilestone";
		InitCommand=function(self) self:visible(ShowFlashyCombo) end;
		FiftyMilestoneCommand=function(self) self:playcommand("Milestone") end;
	};
	LoadActor(THEME:GetPathG("Combo","1000Milestone")) .. {
		Name="OneThousandMilestone";
		InitCommand=function(self) self:visible(ShowFlashyCombo) end;
		ToastyAchievedMessageCommand=function(self) self:playcommand("Milestone") end;
	};
	-- normal combo elements:
	Def.ActorFrame {
		Name="ComboFrame";
		LoadFont( "Combo", "numbers" ) .. {
			Name="Number";
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand");
		};
		LoadFont("Common Normal") .. {
			Name="Label";
			OnCommand = THEME:GetMetric("Combo", "LabelOnCommand");
		};
	};
	InitCommand = function(self)
		c = self:GetChildren();
		cf = c.ComboFrame:GetChildren();
		cf.Number:visible(false);
		cf.Label:visible(false);
	end;
	-- Milestones:
	-- 25,50,100,250,600 Multiples;
--[[ 		if (iCombo % 100) == 0 then
			c.OneHundredMilestone:playcommand("Milestone");
		elseif (iCombo % 250) == 0 then
			-- It should really be 1000 but thats slightly unattainable, since
			-- combo doesnt save over now.
			c.OneThousandMilestone:playcommand("Milestone");
		else
			return
		end; --]]
 	TwentyFiveMilestoneCommand=function(self,parent)
		if ShowFlashyCombo then
			self:skewy(-0.125):decelerate(0.325):skewy(0)
		end;
	end;
	--]]
	--[[
	ToastyAchievedMessageCommand=function(self,params)
		if params.PlayerNumber == player then
			(function(self) self:thump,2;effectclock,'beat'))(c.ComboFrame) end;
		end;
	end;
	ToastyDroppedMessageCommand=function(self,params)
		if params.PlayerNumber == player then
			(function(self) self:stopeffect))(c.ComboFrame) end;
		end;
	end; --]]
	ComboCommand=function(self, param)
		local iCombo = param.Misses or param.Combo;
		if not iCombo or iCombo < ShowComboAt then
			cf.Number:visible(false);
			cf.Label:visible(false);
			return;
		end

		local labeltext = "";
		if param.Combo then
			labeltext = "COMBO";
-- 			c.Number:playcommand("Reset");
		else
			labeltext = "MISSES";
-- 			c.Number:playcommand("Miss");
		end
		cf.Label:settext( labeltext );
		cf.Label:visible(false);

		param.Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom );
		param.Zoom = clamp( param.Zoom, NumberMinZoom, NumberMaxZoom );

		param.LabelZoom = scale( iCombo, 0, NumberMaxZoomAt, LabelMinZoom, LabelMaxZoom );
		param.LabelZoom = clamp( param.LabelZoom, LabelMinZoom, LabelMaxZoom );

		cf.Number:visible(true);
		cf.Label:visible(true);
		cf.Number:settext( string.format("%i", iCombo) );
		-- FullCombo Rewards
		if param.FullComboW1 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W1"] );
			cf.Number:glowshift();
		elseif param.FullComboW2 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W2"] );
			cf.Number:glowshift();
		elseif param.FullComboW3 then
			cf.Number:diffuse( GameColor.Judgment["JudgmentLine_W3"] );
			cf.Number:stopeffect();
		elseif param.Combo then
			-- Player 1's color is Red, which conflicts with the miss combo.
			-- instead, just diffuse to white for now. -aj
			--c.Number:diffuse(PlayerColor(player));
			cf.Number:diffuse(Color("White"));
			cf.Number:stopeffect();
			cf.Label:diffuse(Color("White")):diffusebottomedge(color("0.5,0.5,0.5,1"))
		else
			cf.Number:diffuse(color("#ff0000"));
			cf.Number:stopeffect();
			cf.Label:diffuse(Color("Red")):diffusebottomedge(color("0.5,0,0,1"))
		end
		-- Pulse
		Pulse( cf.Number, param );
		PulseLabel( cf.Label, param );
		-- Milestone Logic
	end;
--[[ 	ScoreChangedMessageCommand=function(self,param)
		local iToastyCombo = param.ToastyCombo;
		if iToastyCombo and (iToastyCombo > 0) then
-- 			(function(self) self:thump;effectmagnitude,1,1.2,1;effectclock,'beat'))(c.Number end;
-- 			(function(self) self:thump;effectmagnitude,1,1.2,1;effectclock,'beat'))(c.Number end;
		else
-- 			c.Number:stopeffect();
		end;
	end; --]]
};

return t;
