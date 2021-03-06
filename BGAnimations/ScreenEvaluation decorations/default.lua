local t = Def.ActorFrame{}

local enabledCustomWindows = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).CustomEvaluationWindowTimings

local customWindows = timingWindowConfig:get_data().customWindows

local scoreType = themeConfig:get_data().global.DefaultScoreType

if GAMESTATE:GetNumPlayersEnabled() == 1 and themeConfig:get_data().eval.ScoreBoardEnabled then
	t[#t+1] = LoadActor("scoreboard")
end






local function GraphDisplay( pn )
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)

	local t = Def.ActorFrame {
		Def.GraphDisplay {
			InitCommand=function(self)
				self:Load("GraphDisplay")
			end,
			BeginCommand=function(self)
				local ss = SCREENMAN:GetTopScreen():GetStageStats()
				self:Set( ss, ss:GetPlayerStageStats(pn) )
				self:diffusealpha(0.7)
				self:GetChild("Line"):diffusealpha(0)
				self:zoom(0.8)
				self:xy(-40, 270) -- self:xy(-22,8)
			end
		}
	}
	return t
end

local function ComboGraph( pn )
	local t = Def.ActorFrame {
		Def.ComboGraph {
			InitCommand=function(self)
				self:Load("ComboGraph"..ToEnumShortString(pn))
			end,
			BeginCommand=function(self)
				local ss = SCREENMAN:GetTopScreen():GetStageStats()
				self:Set( ss, ss:GetPlayerStageStats(pn) )
				self:zoom(0.8)
				self:xy(-40, 240) --self:xy(-22, -2)
			end
		}
	}
	return t
end

--ScoreBoard
local judges = {'TapNoteScore_W1','TapNoteScore_W2','TapNoteScore_W3','TapNoteScore_W4','TapNoteScore_W5','TapNoteScore_Miss'}

local pssP1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1)

local frameX = 20
local frameY = 140
local frameWidth = SCREEN_CENTER_X-120

function scoreBoard(pn,position)
	
	local customWindow
	local judge = enabledCustomWindows and 0 or GetTimingDifficulty()
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
	local score = SCOREMAN:GetMostRecentScore()
	local dvt = pss:GetOffsetVector()
	local totalTaps = pss:GetTotalTaps()
	
	local t = Def.ActorFrame{
		BeginCommand=function(self)
			if position == 1 then
				self:x(SCREEN_WIDTH-(frameX*2)-frameWidth)
			end
		end,
		UpdateNetEvalStatsMessageCommand = function(self)
			local s = SCREENMAN:GetTopScreen():GetHighScore()
			if s then
				score = s
			end
			dvt = score:GetOffsetVector()
			MESSAGEMAN:Broadcast("ScoreChanged")
		end,
	}



  t[#t + 1] =
		Def.Quad {
		InitCommand = function(self)
			self:xy(frameX-20, frameY - 140):zoomto(frameWidth - 90, 440):halign(0):valign(0):diffuse(color("0,0,0,0.6")) --333333CC frameY + 230
		end
	}

	t[#t + 1] =
		Def.Quad {
		InitCommand = function(self)
			self:xy(219, 0):zoomto(SCREEN_WIDTH, 30):halign(0):valign(0):diffuse(color("0,0,0,0.6")) --333333CC frameY + 230
		end
	}

	t[#t + 1] =
	  Def.Sprite {  
	  Name = "Banner",
	  OnCommand = function(self)
	    self:x(SCREEN_CENTER_X-320):y(SCREEN_TOP+30):valign(0)
	    self:scaletoclipped(capWideScale(get43size(199 * 1.11), 199 * 1.11), capWideScale(get43size(60 * 1.11), 60 * 1.11))
	    local bnpath = GAMESTATE:GetCurrentSong():GetBannerPath()
	    if not bnpath then
	      bnpath = THEME:GetPathG("Common", "fallback banner")
	    end
	    self:LoadBackground(bnpath)
	  end
	}

	t[#t + 1] =
		Def.Quad {
		InitCommand = function(self)
			self:xy(frameWidth - 90, frameY - 140):zoomto(2, 430):halign(0):valign(0):diffuse(getMainColor('positive')):diffusealpha(0.5) --333333CC frameY + 230
		end
	}

	t[#t + 1] =
		Def.Quad {
		InitCommand = function(self)
			self:xy(0, SCREEN_HEIGHT):zoomto(SCREEN_WIDTH, 52):halign(0):valign(1):diffuse(color("0,0,0,0.9")) --333333CC frameY + 230
		end
	}

	t[#t+1] = LoadFont("Common Large")..{
		InitCommand=function(self)
			self:xy(frameX - 12, frameY -13):zoom(0.53):halign(0):valign(0):maxwidth(200)
		end,
		BeginCommand=function(self)
			self:queuecommand("Set")
		end,
		SetCommand=function(self)
			local meter = GAMESTATE:GetCurrentSteps(PLAYER_1):GetMSD(getCurRateValue(), 1)
			self:settextf("%05.2f /", meter)
			self:diffuse(byMSD(meter))
		end,
	};
	t[#t+1] = LoadFont("Common Large")..{
		InitCommand=function(self)
			self:xy(frameWidth + frameX-165, frameY -13):zoom(0.53):halign(1):valign(0):maxwidth(200)
		end,
		BeginCommand=function(self)
			self:queuecommand("Set")
		end,
		ScoreChangedMessageCommand = function(self) self:queuecommand("Set"); end,
		SetCommand=function(self)
			local meter = score:GetSkillsetSSR("Overall")
			self:settextf("%05.2f", meter)
			self:diffuse(byMSD(meter))
		end,
	};
	t[#t+1] = LoadFont("Common Large") .. {
		InitCommand=function(self)
			self:xy(188, frameY - 36):zoom(0.5):halign(0.5):valign(0):maxwidth(200)
		end,
		BeginCommand=function(self)
			self:queuecommand("Set")
		end,
		SetCommand=function(self)
			local steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
			local diff = getDifficulty(steps:GetDifficulty())
			self:settext(getShortDifficulty(diff))
			self:diffuse(getDifficultyColor(GetCustomDifficulty(steps:GetStepsType(),steps:GetDifficulty())))
		end
	};

	-- Rate String
	t[#t+1] = LoadFont("Common normal")..{
		InitCommand=function(self)
			self:xy(188, 133):zoom(0.4):halign(0.5)
		end,
		BeginCommand=function(self)
			self:settext(string.format("%.2f", getCurRateValue()))
		end
	}
	
	-- Wife percent
	t[#t+1] = LoadFont("Common Large")..{
		InitCommand=function(self)
			self:xy(frameX-12,frameY-35):zoom(0.45):halign(0):valign(0):maxwidth(capWideScale(320,360))
		end,
		BeginCommand=function(self)
			self:queuecommand("Set")
		end,
		SetCommand=function(self) 
			self:diffuse(getGradeColor(score:GetWifeGrade()))
			self:settextf("%05.2f%% (%s)",notShit.floor(score:GetWifeScore()*10000)/100, "Wife")
		end,
		ScoreChangedMessageCommand = function(self) self:queuecommand("Set"); end,
		CodeMessageCommand=function(self,params)
			local totalHolds = pss:GetRadarPossible():GetValue("RadarCategory_Holds") + pss:GetRadarPossible():GetValue("RadarCategory_Rolls")
			local holdsHit = score:GetRadarValues():GetValue("RadarCategory_Holds") + score:GetRadarValues():GetValue("RadarCategory_Rolls")
			local minesHit = pss:GetRadarPossible():GetValue("RadarCategory_Mines") -  score:GetRadarValues():GetValue("RadarCategory_Mines")
			if enabledCustomWindows then
				if params.Name == "PrevJudge" then
					judge = judge < 2 and #customWindows or judge - 1
					customWindow = timingWindowConfig:get_data()[customWindows[judge]]
					self:settextf("%05.2f%% (%s)", getRescoredCustomPercentage(dvt, customWindow, totalHolds, holdsHit, minesHit, totalTaps), customWindow.name)
				elseif params.Name == "NextJudge" then
					judge = judge == #customWindows and 1 or judge + 1
					customWindow = timingWindowConfig:get_data()[customWindows[judge]]
					self:settextf("%05.2f%% (%s)", getRescoredCustomPercentage(dvt, customWindow, totalHolds, holdsHit, minesHit, totalTaps), customWindow.name)
				end
			elseif params.Name == "PrevJudge" and judge > 1 then
				judge = judge - 1
				self:settextf("%05.2f%% (%s)", getRescoredWifeJudge(dvt, judge, totalHolds - holdsHit, minesHit, totalTaps), "Wife J"..judge)
			elseif params.Name == "NextJudge" and judge < 9 then
				judge = judge + 1
				if judge == 9 then
					self:settextf("%05.2f%% (%s)", getRescoredWifeJudge(dvt, judge, (totalHolds - holdsHit), minesHit, totalTaps), "Wife Justice")
				else
					self:settextf("%05.2f%% (%s)", getRescoredWifeJudge(dvt, judge, (totalHolds - holdsHit), minesHit, totalTaps), "Wife J"..judge)
				end
			end
			if params.Name == "ResetJudge" then
				judge = enabledCustomWindows and 0 or GetTimingDifficulty()
				self:playcommand("Set")
			end
		end,
	};
	
	t[#t+1] = LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:xy(frameX - 12, frameY + 22):zoom(0.40):halign(0):maxwidth(500) --maxwidth(frameWidth / 0.4)
		end,
		BeginCommand=function(self)
			self:queuecommand("Set")
		end,
		SetCommand=function(self) 
			self:settext(GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptionsString('ModsLevel_Current'))
		end
	}

	for k,v in ipairs(judges) do
		t[#t+1] = Def.Quad{
			InitCommand=function(self)
				self:xy(frameX-13, frameY + 40 + ((k - 1) * 22)):zoomto(205, 18):halign(0):diffuse(byJudgment(v)):diffusealpha(0.6) --frameWidth
			end;
		};
		t[#t+1] = Def.Quad{
			InitCommand=function(self)
				self:xy(frameX-13, frameY + 40 + ((k - 1) * 22)):zoomto(0, 18):halign(0):diffuse(byJudgment(v)):diffusealpha(0.6)
			end,
			BeginCommand=function(self)
				self:glowshift():effectcolor1(color("1,1,1," .. tostring(pss:GetPercentageOfTaps(v) * 0.4))):effectcolor2(
					color("1,1,1,0")
				):sleep(0.5):decelerate(2):zoomx(204 * pss:GetPercentageOfTaps(v)) --frameWidth
			end,
			CodeMessageCommand=function(self,params)
				if params.Name == "PrevJudge" or params.Name == "NextJudge" then
					if enabledCustomWindows then
						self:finishtweening():decelerate(2):zoomx(205*getRescoredCustomJudge(dvt, customWindow.judgeWindows, k)/totalTaps)
					else
						local rescoreJudges = getRescoredJudge(dvt, judge, k)
						self:finishtweening():decelerate(2):zoomx(205*rescoreJudges/totalTaps)
					end
				end
				if params.Name == "ResetJudge" then
					self:finishtweening():decelerate(2):zoomx(205*pss:GetPercentageOfTaps(v))
				end
			end,
		};
		t[#t+1] = LoadFont("Common Large")..{
			InitCommand=function(self)
				self:xy(frameX - 10, frameY + 40 + ((k - 1) * 22)):zoom(0.25):halign(0):shadowcolor(color("#44444440")):shadowlength(2)
			end,
			BeginCommand=function(self)
				self:queuecommand("Set")
			end,
			SetCommand=function(self) 
				self:settext(getJudgeStrings(v))
			end,
			CodeMessageCommand=function(self,params)
				if enabledCustomWindows and (params.Name == "PrevJudge" or params.Name == "NextJudge") then
					self:settext(getCustomJudgeString(customWindow.judgeNames, k))
				end
				if params.Name == "ResetJudge" then
					self:playcommand("Set")
				end
			end,
		};
		t[#t+1] = LoadFont("Common Large")..{
			InitCommand=function(self)
				self:xy(frameX -160 + frameWidth, frameY + 40 + ((k - 1) * 22)):zoom(0.25):halign(1):shadowcolor(color("#44444440")):shadowlength(2)
			end,
			BeginCommand=function(self)
				self:queuecommand("Set")
			end,
			SetCommand=function(self) 
				self:settext(score:GetTapNoteScore(v))
			end,
			ScoreChangedMessageCommand = function(self) self:queuecommand("Set"); end,
			CodeMessageCommand=function(self,params)
				if params.Name == "PrevJudge" or params.Name == "NextJudge" then
					if enabledCustomWindows then
						self:settext(getRescoredCustomJudge(dvt, customWindow.judgeWindows, k))
					else
						self:settext(getRescoredJudge(dvt, judge, k))
					end
				end
				if params.Name == "ResetJudge" then
					self:playcommand("Set")
				end
			end,
		};
		t[#t+1] = LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:xy(frameX-120 + frameWidth - 38, frameY + 40 + ((k - 1) * 22)):zoom(0.3):halign(0):shadowcolor(color("#44444440")):shadowlength(2)
			end,
			BeginCommand=function(self)
				self:queuecommand("Set")
			end,
			SetCommand=function(self) 
				self:settextf("(%03.2f%%)",pss:GetPercentageOfTaps(v)*100)
			end,
			CodeMessageCommand=function(self,params)
				if params.Name == "PrevJudge" or params.Name == "NextJudge" then
					local rescoredJudge
					if enabledCustomWindows then
						rescoredJudge = getRescoredCustomJudge(dvt, customWindow.judgeWindows, k)
					else
						rescoredJudge = getRescoredJudge(dvt, judge, k)
					end
					self:settextf("(%03.2f%%)", rescoredJudge/totalTaps * 100)
				end
				if params.Name == "ResetJudge" then
					self:playcommand("Set")
				end
			end,
		};
	end
	
	t[#t+1] = LoadFont("Common Large")..{
			InitCommand=function(self)
				self:xy(frameX + 162, frameY + 165):zoom(0.2):halign(0)
				self:maxwidth(capWideScale(get43size(104), 164)/0.25)
			end,
			BeginCommand=function(self)
				self:queuecommand("Set")
			end,
			ScoreChangedMessageCommand = function(self) self:queuecommand("Set"); end,
			SetCommand=function(self) 
				if score:GetChordCohesion() == true then
					self:settext("CC On")
				else
					self:settext("CC Off")
				end
			end
	};

-- Ratio MA/PA 	
	local ratioText, maRatio, paRatio, marvelousTaps, perfectTaps, greatTaps
	t[#t + 1] =
	LoadFont("Common Large") ..
		{
			InitCommand = function(self)
				ratioText = self
				self:settext("MA/PA ratio:"):zoom(0.2):halign(1)
			end
		}
	t[#t + 1] =
	LoadFont("Common Large") ..
		{
			InitCommand = function(self)
				maRatio = self
				self:zoom(0.2):halign(1):diffuse(byJudgment(judges[1]))
			end
		}
	t[#t + 1] =
	LoadFont("Common Large") ..
		{
			InitCommand = function(self)
				paRatio = self
				self:xy(frameWidth + frameX-194, frameY + 165):zoom(0.2):halign(1):diffuse(byJudgment(judges[2]))
				marvelousTaps = score:GetTapNoteScore(judges[1])
				perfectTaps = score:GetTapNoteScore(judges[2])
				greatTaps = score:GetTapNoteScore(judges[3])
				self:playcommand("Set")
			end,
			SetCommand = function(self)
				-- Fill in maRatio and paRatio
				maRatio:settextf("%.1f:1", marvelousTaps / perfectTaps)
				paRatio:settextf("%.1f:1", perfectTaps / greatTaps)

				-- Align ratioText and maRatio to paRatio (self)
				maRatioX = paRatio:GetX() - paRatio:GetZoomedWidth() - 10
				maRatio:xy(maRatioX, paRatio:GetY())

				ratioTextX = maRatioX - maRatio:GetZoomedWidth() - 10
				ratioText:xy(ratioTextX, paRatio:GetY())
				if score:GetChordCohesion() == true then
					maRatio:maxwidth(maRatio:GetZoomedWidth()/0.25)
					self:maxwidth(self:GetZoomedWidth()/0.25)
					ratioText:maxwidth(capWideScale(get43size(65), 85)/0.27)
				end
			end,
			CodeMessageCommand = function(self, params)
				if params.Name == "PrevJudge" or params.Name == "NextJudge" then
					if enabledCustomWindows then
						marvelousTaps = getRescoredCustomJudge(dvt, customWindow.judgeWindows, 1)
						perfectTaps = getRescoredCustomJudge(dvt, customWindow.judgeWindows, 2)
						greatTaps = getRescoredCustomJudge(dvt, customWindow.judgeWindows, 3)
					else
						marvelousTaps = getRescoredJudge(dvt, judge, 1)
						perfectTaps = getRescoredJudge(dvt, judge, 2)
						greatTaps = getRescoredJudge(dvt, judge, 3)
					end
					self:playcommand("Set")
				end
				if params.Name == "ResetJudge" then
					marvelousTaps = score:GetTapNoteScore(judges[1])
					perfectTaps = score:GetTapNoteScore(judges[2])
					greatTaps = score:GetTapNoteScore(judges[3])
					self:playcommand("Set")
				end
			end
		}
--holds mines etc table
	local fart = {"Holds", "Mines", "Rolls", "Lifts", "Fakes"}

	for i = 1, #fart do
		t[#t + 1] =
			LoadFont("Common Normal") ..
			{
				InitCommand = function(self)
					self:xy(frameX-12, frameY + 225 + 10 * i):zoom(0.4):halign(0):settext(fart[i])
				end
			}
		t[#t + 1] =
			LoadFont("Common Normal") ..
			{
				InitCommand = function(self)
					self:xy(frameX+60, frameY + 225 + 10 * i):zoom(0.4):halign(1)
				end,
				BeginCommand = function(self)
					self:queuecommand("Set")
				end,
				SetCommand = function(self)
					self:settextf(
						"%03d/%03d",
						pss:GetRadarActual():GetValue("RadarCategory_" .. fart[i]),
						pss:GetRadarPossible():GetValue("RadarCategory_" .. fart[i])
					)
				end,
				ScoreChangedMessageCommand = function(self)
					self:queuecommand("Set")
				end
			}
	end
	
	-- stats stuff
	local tracks = pss:GetTrackVector()
	local devianceTable = pss:GetOffsetVector()
	local cbl = 0
	local cbr = 0
	
	-- basic per-hand stats to be expanded on later
	local tst = ms.JudgeScalers
	local tso = tst[judge]
	if enabledCustomWindows then
		tso = 1
	end
	
	for i=1,#devianceTable do
		if math.abs(devianceTable[i]) > tso * 90 then
			if tracks[i] == 0 or tracks[i] == 1 then
				cbl = cbl + 1
			else
				cbr = cbr + 1
			end
		end
	end
	

	local smallest,largest = wifeRange(devianceTable)
	local doot = {"Mean", "Mean(Abs)", "Sd", "Left cbs", "Right cbs"}
	local mcscoot = {
		wifeMean(devianceTable), 
		wifeAbsMean(devianceTable),
		wifeSd(devianceTable),
		cbl, 
		cbr
	}

	for i=1,#doot do
		t[#t+1] = LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:xy(frameX-80 + capWideScale(get43size(130), 160), frameY + 225 + 10 * i):zoom(0.4):halign(0):settext(doot[i])
			end,
		};
		t[#t+1] = LoadFont("Common Normal")..{
			InitCommand=function(self)
				if i < 4 then
					self:xy(frameWidth - 100 + 4, frameY + 225 + 10 * i):zoom(0.4):halign(1):settextf("%5.2fms", mcscoot[i])
				else
					self:xy(frameWidth - 100 + 4, frameY + 225 + 10 * i):zoom(0.4):halign(1):settext(mcscoot[i])
				end
			end,
		};
	end	
	
	return t
end;


if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	t[#t+1] = scoreBoard(PLAYER_1,0)
	if ShowStandardDecoration("GraphDisplay") then
		t[#t+1] = StandardDecorationFromTable( "GraphDisplay" .. ToEnumShortString(PLAYER_1), GraphDisplay(PLAYER_1) )
	end
	if ShowStandardDecoration("ComboGraph") then
		t[#t+1] = StandardDecorationFromTable( "ComboGraph" .. ToEnumShortString(PLAYER_1),ComboGraph(PLAYER_1) )
	end
end


t[#t+1] = LoadActor("../offsetplot")

-- Discord thingies
local largeImageTooltip = GetPlayerOrMachineProfile(PLAYER_1):GetDisplayName() .. ": " .. string.format("%5.2f", GetPlayerOrMachineProfile(PLAYER_1):GetPlayerRating())
local detail = GAMESTATE:GetCurrentSong():GetDisplayMainTitle() .. " " .. string.gsub(getCurRateDisplayString(), "Music", "") .. " [" .. GAMESTATE:GetCurrentSong():GetGroupName() .. "]"
-- truncated to 128 characters(discord hard limit)
detail = #detail < 128 and detail or string.sub(detail, 1, 124) .. "..."
local state = "MSD: " .. string.format("%05.2f", GAMESTATE:GetCurrentSteps(PLAYER_1):GetMSD(getCurRateValue(),1)) .. 
	" - " .. string.format("%05.2f%%",notShit.floor(pssP1:GetWifeScore()*10000)/100) .. 
	" " .. THEME:GetString("Grade",ToEnumShortString(SCOREMAN:GetMostRecentScore():GetWifeGrade()))
GAMESTATE:UpdateDiscordPresence(largeImageTooltip, detail, state, 0)

return t