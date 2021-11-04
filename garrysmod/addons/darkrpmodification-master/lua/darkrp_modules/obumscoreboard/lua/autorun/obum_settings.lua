-- =======================SETTINGS======================= --

-- really unsure about this so, I got the ranks from the file however the 'serverguard = true is 100% wrong

serverguard = true              --Ulx/Ulib/ServerGuard

ModerationGroups = { -- Who can see the moderation panel
        ['founder ] = true
        [ 'superadmin' ] = true,
        [ 'admin' ] = true
        [ 'moderator' ] = true 
    }

GroupsColors = {
    [ 'superadmin' ] = { color = Color( 255, 3, 36 ) },
    [ 'admin' ] = { color = Color( 240, 52, 52, 230 ) },
    [ 'moderator' ] = { color = Color( 240, 52, 52, 230 ) },
    [ 'user' ] = { color = Color( 83, 51, 237, 230 ) },
    [ 'other' ] = { color = Color( 83, 51, 237, 230 ) }
}
-- ======================================================
