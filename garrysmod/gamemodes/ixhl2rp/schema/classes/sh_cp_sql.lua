CLASS.name = "UNION SqL"
CLASS.faction = FACTION_MPF
CLASS.isDefault = false

function CLASS:OnSet(client)
  	local character = client:GetCharacter()
		character:SetModel("models/dpfilms/metropolice/hdpolice.mdl")
	local inventory = character:GetInventory()
	local item = inventory:HasItem("mp7")
	if (item) then
		return
	else
		inventory:Add("mp7", 1)
		inventory:Add("division", 1)
	end
end

CLASS_SQL = CLASS.index
