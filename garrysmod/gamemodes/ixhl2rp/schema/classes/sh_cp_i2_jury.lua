CLASS.name = "JURY i2"
CLASS.faction = FACTION_MPF
CLASS.isDefault = false

function CLASS:OnSet(client)
  local character = client:GetCharacter()
	character:SetModel("models/dpfilms/metropolice/policetrench.mdl")
end

CLASS_I2JURY = CLASS.index
