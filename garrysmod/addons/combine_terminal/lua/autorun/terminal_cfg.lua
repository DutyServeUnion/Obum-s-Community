Terminal = Terminal or {}

Terminal.Model = "models/props_combine/combine_interface001.mdl"

Terminal.DispatchSounds = {
	-- ["Sound name in UI"] = "path/to/the/sound.mp3"

	["Stop dispatch"] = "", -- do not remove it. It's made for ability to stop current dispatch (if any)
	["Deploy"] = "sound/npc/overwatch/cityvoice/fcitadel_deploy.wav",
}

Terminal.Dispatch = {
	Position = Vector(),
	Volume = 35
}

Terminal.MapButtons = {
	-- ["Name of the button in UI"] = Vector position of the button on the map
	["Switch light"] = Vector(-2698, -2598, -208)
}

hook.Add("InitPostEntity", "Terminal_InitTeams", function()

	Terminal.CanUse = { -- Who can access terminal?
		[TEAM_POLICE] = true
	}

	Terminal.Citizens = { -- Teams which are "Citizens", so you can see them in "Citizen Index" tab
		[TEAM_CITIZEN] = true
	}

end)