CLASS.name = "UNION i2"
CLASS.faction = FACTION_MPF
CLASS.isDefault = false

function CLASS:OnSet(client)
  local character = client:GetCharacter()
	character:SetModel("models/dpfilms/metropolice/hdpolice.mdl")
end

CLASS_I2 = CLASS.index
