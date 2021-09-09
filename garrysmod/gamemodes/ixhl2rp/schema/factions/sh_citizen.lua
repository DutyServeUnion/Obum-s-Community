FACTION.name = "Citizens"
FACTION.description = "You are a normal citizen oppressed by the combine"
FACTION.color = Color(150, 125, 100, 255)
FACTION.pay = 5
FACTION.models = {
	"models/player/zelpa/male_01.mdl",
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
	"models/player/zelpa/female_07.mdl"
}

FACTION.isDefault = true
function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	character:SetData("cid", id)
	--initCitizenData(character)
	
	inventory:Add("suitcase", 1)
	inventory:Add("flashlight", 1)
	inventory:Add("cid", 1, {
		name = character:GetName(),
		id = id
	})
end

function FACTION:OnTransferred(character)
	local client = character:GetPlayer()
	restorePlayerSettings(character, client)
end

function FACTION:OnSpawn(client)
	local character = client:GetCharacter()
	restorePlayerSettings(character, client)
end

function restorePlayerSettings(character, client)
	local civmodel = character:GetData("citizen-model")
	local civname = character:GetData("citizen-name")
	local civbodygroup = character:GetData("citizen-bodygroup")
	if civmodel == nil or civmodel == "" then character:SetModel("models/player/zelpa/male_07.mdl") return end
	
	character:SetFaction(3)
	character:SetModel(civmodel)
	character:SetName(civname)
	if civbodygroup ~= nil or civbodygroup ~= {} or civbodygroup ~= "" then
		client:SetBodyGroups(civbodygroup)
	end
end

FACTION_CITIZEN = FACTION.index
