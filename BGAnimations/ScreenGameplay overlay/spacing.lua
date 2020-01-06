-- This actor belongs in ScreenGameplay.
-- Look for "BGAnimations/ScreenGameplay overlay.lua" 
-- or "BGAnimations/ScreenGameplay overlay/default.lua"
-- and add it to the list of actors returned by the file.
local t = Def.Actor{
  OnCommand= function(self)
    -- This position table only works for dance single, because supporting
    -- all styles would make this example too big.
    local custom_column_positions= {
      -- Swap up and down for player 1.
      [PLAYER_1]= {-196, -32, 32, 196},
      -- Separate the two sides and swap up and down for player 2.
      [PLAYER_2]= {-128, 64, -64, 128},
    }
    local screen= SCREENMAN:GetTopScreen()
    for i, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do

      local positions= custom_column_positions[pn]
      local player= screen:GetChild("Player" .. ToEnumShortString(pn))
      local notefield= player:GetChild("NoteField")
      -- Some modes like routine might have a player exist without a notefield.
      if notefield then
        -- Version checking.  5.0.12 and 5.1.-3 have different functions.
        if notefield.get_column_actors then
          -- 5.0.12 fights back with hardcoded positions.
          -- To end up in the position we want, we have to set a position
          -- relative to the engine position.
          local engine_positions= {-96, -32, 32, 96}
          local columns= notefield:get_column_actors()
          -- Only move columns if there is a position for each column.
          if #columns == #positions then
            for cid, col in ipairs(columns) do
              col:x(positions[cid] - engine_positions[cid])
            end
          end
          -- Side note: If the theme makes the background behind a column
          -- flash on misses or similar, moving columns this way in 5.0.12
          -- ensures that flash will *not* be lined up with the column it's
          -- meant for.  5.0.12 didn't have any support for putting something
          -- from the theme into the background for a column.
        elseif notefield.get_columns then
          -- 5.1.-3
          local columns= notefield:get_columns()
          -- Only move columns if there is a position for each column.
          if #columns == #positions then
            for cid, col in ipairs(columns) do
              col:get_column_pos_x():set_value(positions[cid])
            end
          end
          -- Colunn flashes side note continued:
          -- The notefield in 5.1.-3 has a specific place for themes to put
          -- stuff like column flashes, so the column flashes will show up in
          -- the right place in 5.1.-3.
        end
      end
    end
  end,
}

return t