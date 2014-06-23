
local updateShadowVolumes = function( e )
    if e.oldpos == e:getPos() then
        return
    end
    local allverticies = {}
    e.oldpos = e:getPos()
    local ents = game.entities:getNearby( e:getPos(), e.radius )
    for i,v in pairs( ents ) do
        if v:hasComponent( compo.blockslight ) then
            local verts = v:getShadowVolume( e:getPos(), e.radius )
            for j,w in pairs( verts ) do
                table.insert( allverticies, w )
            end
        end
    end
    if table.maxn( allverticies ) > 1 then
        e.shadowmeshdraw = love.graphics.newMesh( allverticies, nil, "triangles" )
    end
end

local update = function( e, dt )
    if type( e.lightflickermap ) ~= "table" then
        error( "Please use setFlickerMap() to set flicker maps!" )
    end
    -- Goes at 10 values a second
    e.lighttime = e.lighttime + ( dt * 10 )
    local pos = math.floor( e.lighttime % #e.lightflickermap ) + 1
    local npos = pos + 1
    if npos > #e.lightflickermap then
        npos = 1
    end
    local flickera = e.lightflickermap[ pos ]
    local flickerb = e.lightflickermap[ npos ]
    -- Just uses a simple linear function to interpolate the flickermap values
    local func = e.lighttime - math.floor( e.lighttime )
    local flicker =  flickera * (1-func) + flickerb * func
    e.lightintensity = e.baselightintensity * flicker
    -- Clamp between 0 and 1
    e.lightintensity = math.clamp( e.lightintensity, 0, 1 )
end

local init = function( e )
    e.lightrot = math.random()*math.pi*2
    e.lightoriginoffset = game.vector( e.lightdrawable:getWidth() / 2, e.lightdrawable:getHeight() / 2 )
    -- ONLY SCALE WIDTH, so we can have some light shafts and shit.
    e.lightscale = game.vector( e.radius*2/e.lightdrawable:getWidth(), e.radius*2/e.lightdrawable:getWidth() )

    e.baselightintensity = e.lightintensity
    -- Set the flicker time to a random value, this way if we create
    -- a ton of lights at once they'll flicker at different times
    e.lighttime = math.random() * #e.lightflickermap
    -- Convert the lightflickermap to more efficient values
    e:setFlickerMap( e.lightflickermap )
    game.renderer:addLight( e )
end

-- Converts a valve-style flickermap into floats
-- See https://developer.valvesoftware.com/wiki/Light#Appearances
local setFlickerMap = function( e, flickermapstring )
    local flickermap = {}
    -- For each character
    for char in string.gmatch( flickermapstring, "." ) do
        -- 0 = a, 1 = z, m = 0.48
        local val = ( string.byte( char ) - 97 ) / 25
        table.insert( flickermap, val )
    end
    e.lightflickermap = flickermap
end

local setLightIntensity = function( e, lightintensity )
    e.lightintensity = lightintensity
    e.baselightintensity = e.lightintensity
end

local getLightIntensity = function( e )
    return e.baselightintensity
end

local deinit = function( e )
    game.renderer:removeLight( e )
end

local EmitsLight = {
    __name = "EmitsLight",
    shadowmeshdraw = nil,
    oldpos = nil,
    radius = 256,
    lightsize = 32,
    lightdrawable = love.graphics.newImage( "data/textures/point.png" ),
    lightrot = 0,
    lightoriginoffset = game.vector( 0, 0 ),
    lightscale = game.vector( 1, 1 ),
    -- I set the light intensity to overflow due to the flickermap
    -- nearly halving it in all parts of the flicker
    lightintensity = 1.35,
    -- Uses "Flicker B" by default.
    lightflickermap = "nmonqnmomnmomomno",
    setFlickerMap = setFlickerMap,
    setLightIntensity = setLightIntensity,
    getLightIntensity = getLightIntensity,
    updateShadowVolumes = updateShadowVolumes,
    update = update,
    init = init,
    deinit = deinit
}

return EmitsLight
