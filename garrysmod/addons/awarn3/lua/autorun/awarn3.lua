AddCSLuaFile()

AWarn = AWarn or {}

AWarn.Version = "1.2.2"

AWARN3_WHITE 	= Color(255,255,255)
AWARN3_SERVER 	= Color(0,200,255)
AWARN3_CLIENT 	= Color(255,136,0)
AWARN3_WARNING	= Color(128,0,0)
AWARN3_CHATTAG	= Color(255,0,0)

if SERVER then
	AWARN3_STATECOLOR = AWARN3_SERVER
	include( "includes/sv_awarn3.lua")
end

if CLIENT then
	AWARN3_STATECOLOR = AWARN3_CLIENT
	include( "includes/cl_awarn3.lua")
end