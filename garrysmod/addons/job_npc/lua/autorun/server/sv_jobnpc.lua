local addXPdelay = 300 -- each 5 mins
local addXP = 5 -- add 5 xp
------------------------------------------------------------------------------------------------------------------------

local unitIDs = {}

util.AddNetworkString("darkrpChangeTeam")
net.Receive("darkrpChangeTeam", function(_, ply)
	local tm = net.ReadUInt(16)
	if not tm then return end

	tm = RPExtraTeams[tm]
	if not tm then return end

	-- so here we're making some sort of a "anti-exploit".
	-- It prevents from becoming any job from any place except nearby needed npc
	for i, ent in ipairs(ents.FindInSphere(ply:GetPos(), 100)) do
		-- so here we're searching for npc
		if ent.Base and ent.Base == "npc_jobs_base" then
			if ent.Categories[tm.category] then -- and here we're making sure that this npc can provide you by needed team (tm)
				ply:changeTeam(tm.team, true)

				return
			end
		end
	end
	-- otherwise, do nothing?
end)

hook.Add("PlayerChangedTeam", "SetNewPlayerName", function(ply, old, new)
	timer.Simple(0, function()
		if not IsValid(ply) or ply:Team() ~= new then return end

		if ply:isCP() then
			local tm = RPExtraTeams[new]

			local rand = ply.CPnum or math.random(1, 9999)
			if not ply.CPnum then
				while unitIDs[rand] do
					if IsValid(unitIDs[rand]) and unitIDs[rand]:isCP() then
						rand = math.random(1, 9999)
					else
						break
					end
				end
			end

			unitIDs[rand] = ply
			ply.CPnum = rand

			ply:SetNWString("CPName", "CP-C17-" .. tm.category .. "-" .. tm.name .. "-" .. rand)
		else
			ply:SetNWString("CPName", "")
			ply.CPnum = nil
		end
	end)
end)

local meta = FindMetaTable("Player")

function meta:AddXP(amount)
	self:SetXP((self.xp or 0) + amount)
end

function meta:SetXP(amount)
	self.xp = amount

	self:SetNWInt("xp", amount)

	self:SaveXP() -- Not sure if it's a good idea to save XP after each "Set", but, it shouldn't be called that often so it's not a big deal, ig?
end

file.CreateDir("playerxp/")
function meta:SaveXP()
	file.Write("playerxp/" .. self:SteamID64() .. ".dat", tostring(self.xp or 0))
end

hook.Add("PlayerInitialSpawn", "LoadPlayerXPData", function(ply)
	local xp = file.Read("playerxp/" .. ply:SteamID64() .. ".dat")

	ply.xp = xp or 0
end)

timer.Create("AddXPToPlayers", addXPdelay, 0, function()
	for i, ply in ipairs(player.GetAll()) do
		ply:AddXP(addXP)
	end
end)

hook.Add("playerCanChangeTeam", "checkTeamXP", function(ply, tm, force)
	local TEAM = RPExtraTeams[tm]
	if TEAM then
		if TEAM.xp and ply.xp < TEAM.xp then
			return false, "You don't have enough xp! (".. string.COmma(TEAM.xp) ..")"
		end

		if TEAM.isCP and not force then
			return false, "You must use NPC for becoming CP!"
		end
	end
end)

hook.Add("PlayerDisconnected", "SaveXPonDisconnect", function(ply)
	if not ply:SteamID64() then return end -- https://wiki.facepunch.com/gmod/GM:PlayerDisconnected

	ply:SaveXP()
end)