FACTION.name = "Civil Protection"
FACTION.description = "Civil Protection units employed by an unkown larger group know as MPF."
FACTION.color = Color(50, 100, 150)
FACTION.models = {"models/dpfilms/metropolice/hdpolice.mdl"}
FACTION.isDefault = false
FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}

FACTION.channels = {
	["union"] = true
}
FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true


 function FACTION:OnCharacterCreated(client, character)
 	local inventory = character:GetInventory()
	
 	inventory:Add("flashlight", 1)
 	inventory:Add("stunstick", 1)
 end

function FACTION:OnNameChanged(client, oldValue, value)
	local character = client:GetCharacter()

	if (!Schema:IsCombineRank(oldValue, "UNION-i4") and Schema:IsCombineRank(value, "UNION-i4")) then
		character:JoinClass(CLASS_I4)
	elseif (!Schema:IsCombineRank(oldValue, "GRID-i4") and Schema:IsCombineRank(value, "GRID-i4")) then
		character:JoinClass(CLASS_I4GRID)
	elseif (!Schema:IsCombineRank(oldValue, "JURY-i4") and Schema:IsCombineRank(value, "JURY-i4")) then
		character:JoinClass(CLASS_I4JURY)
	end
end

function FACTION:OnTransferred(character)
	local client = character:GetPlayer()
	local citizenBodyGroup = client:GetBodyGroups()
	local citizenModel = character:GetModel()
	local citizenName = character:GetName()
	character:SetData("citizen-model", citizenModel)
	character:SetData("citizen-name", citizenName)
	character:SetData("citizen-bodygroup", citizenBodyGroup)

	--timer.Simple(0.5, function()	
		character:SetModel(self.models[1])
		character:AddCombineDisplayMessage("@cCombineLoaded")
	--end)
end

FACTION_MPF = FACTION.index
