CLASS.name = "UNION i4"
CLASS.faction = FACTION_MPF
CLASS.isDefault = true

function CLASS:OnSet(client)
  local character = client:GetCharacter()
	character:SetModel("models/dpfilms/metropolice/hdpolice.mdl")
end

CLASS_I4 = CLASS.index
