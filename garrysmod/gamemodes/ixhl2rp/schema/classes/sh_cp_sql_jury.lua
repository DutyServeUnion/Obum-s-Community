CLASS.name = "JURY SqL"
CLASS.faction = FACTION_MPF
CLASS.isDefault = false

function CLASS:OnSet(client)
  	local character = client:GetCharacter()
		character:SetModel("models/dpfilms/metropolice/policetrench.mdl")
	local inventory = character:GetInventory()
	local item = inventory:HasItem("mp7")
	if (item) then
		return
	else
		inventory:Add("mp7", 1)
		inventory:Add("division", 1)
	end
end

CLASS_JURYSQL = CLASS.index
