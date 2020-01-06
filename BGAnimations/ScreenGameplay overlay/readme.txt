dejar spacing.lua en carpeta
Themes/Til Death/BGAnimations/ScreenGameplay overlay

editar default.lua de misma carpeta añadiendo linea antes de return t

local t = Def.ActorFrame{}
<...contenidos...>
t[#t+1] = LoadActor("spacing") -- añadir esto
return t

editar spacing.lua con posiciones de columna para player 1:

[PLAYER_1]= {-196, -32, 32, 196}