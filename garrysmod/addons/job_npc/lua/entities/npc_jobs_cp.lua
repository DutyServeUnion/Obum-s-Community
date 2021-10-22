AddCSLuaFile()

ENT.Type	= "ai"
ENT.Base	= "npc_jobs_base"
ENT.Category	= "Other"

-- name over NPC's head
ENT.PrintName	= "Civil Protection"
ENT.Model = "models/Eli.mdl" 

-- Lemme explain: In UI The left combobox has "ENT.Categories". So if you're making job npc for citizens,
-- I think that you'd name "ENT.CategoryUIReplace" as "Classes". With CP, it would be "Divisions"
-- 
-- If you haven't really understand what ENT.CategoryUIReplace is, then just change it to whatever you want and test by yourself

ENT.CategoryUIReplace = "Divisions"
-- list of DarkRP job categories
ENT.Categories = {
	["Civil Protection"] = true,
}

ENT.Spawnable = true
ENT.AdminOnly = true