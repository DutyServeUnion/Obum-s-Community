--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]

TEAM_CONSUL = DarkRP.createJob("Consul", {
    color = Color(36, 140, 112, 255),
    model = {"models/player/breen.mdl"},
    description = [[The Consul is the complete and overall commander of the humanoid Combine forces on Earth. They have direct direct influence over the many Civil Protection delegates and Overwatch units, they are rarely seen or even heard unless you are a member of Overwatch.]],
    weapons = {},
    command = "becomeconsul",
    max = 1,
    salary = 350,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Combine",
    mayor = true,
    PlayerDeath = function(ply, weapon, killer)
        ply:changeTeam(GAMEMODE.DefaultTeam, true)
    end
    customCheck = function(ply) return
        table.HasValue({"STEAM_0:1:74180635"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This position requires a whitelist!",
})

TEAM_CA = DarkRP.createJob("City Administrator", {
    color = Color(186, 46, 46, 255),
    model = {
        "models/player/hl2rp/female_01.mdl",
        "models/player/hl2rp/female_02.mdl",
        "models/player/hl2rp/female_03.mdl",
        "models/player/hl2rp/female_04.mdl",
        "models/player/hl2rp/female_06.mdl",
        "models/player/hl2rp/female_07.mdl",
        "models/player/hl2rp/male_01.mdl",
        "models/player/hl2rp/male_02.mdl",
        "models/player/hl2rp/male_03.mdl",
        "models/player/hl2rp/male_04.mdl",
        "models/player/hl2rp/male_05.mdl",
        "models/player/hl2rp/male_06.mdl",
        "models/player/hl2rp/male_07.mdl",
        "models/player/hl2rp/male_08.mdl",
        "models/player/hl2rp/male_09.mdl"
    },
    description = [[While they have little authority over Civil Protection, Overwatch and other Combine forces, City Administrators have a large amount of control over the broadcast system and civilian behaviour. Citizens are tricked into believing that the Administrators are the highest commanding rank in the Combine ranks]],
    weapons = {},
    command = "becomeca",
    max = 3,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Combine",
    mayor = true,
    PlayerSpawn = function(ply)
        ply:SetBodygroup(0, 40)
        ply:SetBodygroup(1, 18)
    end
    PlayerDeath = function(ply, weapon, killer)
        ply:changeTeam(GAMEMODE.DefaultTeam, true)
    end
})

TEAM_MPF = DarkRP.createJob("Civil Protection", {
    color = Color(0, 129, 191, 255),
    model = {"models/dpfilms/metropolice/playermodels/pm_hdpolice.mdl"},
    description = [[Civil Protection units are the backbone of the Combine Overwatch Forces, acting as Combine "Police", they roam the streets and keep people safe by beating them daily and killing hundreds a week. They have either betrayed humanity or had no other choice but to join the ranks of Civil Protection.]],
    weapons = {},
    command = "becomecp",
    max = 14,
    salary = 250,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Combine",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(50)
    end,
    PlayerDeath = function(ply, weapon, killer)
        ply:changeTeam(GAMEMODE.DefaultTeam, true)
    end
})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN
model = {	"models/player/zelpa/male_01.mdl",
	"models/player/zelpa/male_02.mdl",
	"models/player/zelpa/male_03.mdl",
	"models/player/zelpa/male_04.mdl",
	"models/player/zelpa/male_05.mdl",
	"models/player/zelpa/male_06.mdl",
	"models/player/zelpa/male_07.mdl",
	"models/player/zelpa/male_08.mdl",
	"models/player/zelpa/male_09.mdl",
	"models/player/zelpa/male_10.mdl",
	"models/player/zelpa/male_11.mdl",
	-- ## MALE MODELS ^^ ## --
	"models/player/zelpa/female_01.mdl",
	"models/player/zelpa/female_02.mdl",
	"models/player/zelpa/female_03.mdl",
	"models/player/zelpa/female_04.mdl",
	-- "models/player/zelpa/female_05.mdl",
	"models/player/zelpa/female_06.mdl",
	"models/player/zelpa/female_07.mdl"}
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_MPF] = true,
}

--[[[

ALLAH = ALLAH or }



ALLAH.
ALLAH.CONG
miALLAH.g.MainColor        = Color( 10,  132, 255 
