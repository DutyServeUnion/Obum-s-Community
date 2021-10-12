-- =======================SETTINGS=======================

ulx = true              --Ulx/Ulib

ModerationGroups = { -- Who can see the moderation panel ?
        [ 'superadmin' ] = true,
        [ 'admin' ] = true
    }

GroupsColors = {
    [ 'superadmin' ] = { color = Color( 240, 52, 52, 230 ) },
    [ 'admin' ] = { color = Color( 240, 52, 52, 230 ) },
    [ 'moderator' ] = { color = Color( 240, 52, 52, 230 ) },
    [ 'user' ] = { color = Color( 83, 51, 237, 230 ) },
    [ 'other' ] = { color = Color( 83, 51, 237, 230 ) }
}
-- ======================================================
