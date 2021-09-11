
local PLUGIN = PLUGIN
PLUGIN.name = "XP System"
PLUGIN.author = "Bilwin"
PLUGIN.description = "Adds XP whitelisted system"
PLUGIN.schema = "any"
PLUGIN.version = 1
PLUGIN.license = --[[
    This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.
    In jurisdictions that recognize copyright laws, the author or authors
    of this software dedicate any and all copyright interest in the
    software to the public domain. We make this dedication for the benefit
    of the public at large and to the detriment of our heirs and
    successors. We intend this dedication to be an overt act of
    relinquishment in perpetuity of all present and future rights to this
    software under copyright law.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
    OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.
    For more information, please refer to <http://unlicense.org/>
]]
PLUGIN.readme = --[[
    This plugin adds the XP system to the server, if it is enabled.
    If used correctly, you can make it so that you need to have some XP to select a class.
    The table ix.XPSystem.whitelists contains fractions and classes for it, and XP need (Classes are necessary!)
]]

do
    ix.char.RegisterVar("XP", {
        field = "XP",
        fieldType = ix.type.number,
        isLocal = true,
        bNoDisplay = true,
        default = 0
    })
end

ix.XPSystem = {}
ix.XPSystem.whitelists = {
    [FACTION_CITIZEN] = {
        [CLASS_CITIZEN] = 0,
        [CLASS_CWU]     = 15
    },
    [FACTION_MPF] = {
        [CLASS_I4]     = 50,
        [CLASS_I4JURY]     = 50,
        [CLASS_I4GRID]     = 50,
		[CLASS_I3]     = 100,
        [CLASS_I3JURY]     = 100,
        [CLASS_I3GRID]     = 100,
		[CLASS_I2]     = 400,
        [CLASS_I2JURY]     = 400,
        [CLASS_I2GRID]     = 400,
		[CLASS_I1]     = 800,
        [CLASS_I1JURY]     = 800,
        [CLASS_I1GRID]     = 800,
		[CLASS_OFC]     = 1600,
        [CLASS_OFCJURY]     = 1600,
        [CLASS_OFCGRID]     = 1600,
		[CLASS_SQLVICE]     = 2400,
        [CLASS_KINGSQL]     = 2400,
		[CLASS_JURYSQL]     = 2400,
        [CLASS_SQL]     = 2400,
        [CLASS_GRIDSQL]     = 2400,
		[CLASS_VICEDVL]     = 4800,
        [CLASS_KINGDVL]     = 4800,
		[CLASS_JURYDVL]     = 4800,
        [CLASS_DVL]     = 4800,
        [CLASS_GRIDDVL]     = 4800
    }
    --[FACTION_OTA] = {
    --    [CLASS_OWS]     = 200,
    --    [CLASS_EOW]     = 300
    --},
    --[FACTION_ADMIN] = {
    --    [CLASS_ADMIN]   = 600
    --}
}

ix.util.Include("sh_config.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_language.lua")