local PLUGIN = PLUGIN


function PLUGIN:SaveCPpos()

    for _, v in ipairs(ents.FindByClass("ix_cprankvendor")) do
        local data = {}

        data[#data + 1] = {
        v:GetPos(),
        v:GetAngles()
        }
    end
  
    ix.data.Set("rankSelectors", data)
end

function PLUGIN:LoadCPpos()

    for _, v in ipairs(ix.data.Get("rankSelectors") or {} ) do
        local atm = ents.Create("ix_cprankvendor")

        atm:SetPos(v[1])
        atm:SetAngles(v[2])
        atm:Spawn()
    end
end