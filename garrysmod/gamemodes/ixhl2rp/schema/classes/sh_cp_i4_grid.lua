CLASS.name = "GRID i4"
CLASS.faction = FACTION_MPF
CLASS.isDefault = false

function CLASS:OnSet(client)
  local character = client:GetCharacter()
	character:SetModel("models/dpfilms/metropolice/hl2concept.mdl")
end

CLASS_I4GRID = CLASS.index
