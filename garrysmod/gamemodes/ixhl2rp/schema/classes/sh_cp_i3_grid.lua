CLASS.name = "GRID i3"
CLASS.faction = FACTION_MPF
CLASS.isDefault = false

function CLASS:OnSet(client)
  local character = client:GetCharacter()
	character:SetModel("models/dpfilms/metropolice/hl2concept.mdl")
end

CLASS_I3GRID = CLASS.index
