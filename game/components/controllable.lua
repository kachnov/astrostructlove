
local update = function( e, dt, id, tick )
    if e.active then
        local direction = 0
        local rotdir = 0

        -- Id will be specified if we're updating a specific player's
        -- entity, otherwise we're just updating ourselves
        local up, down, left, right, rotl, rotr
        if id == nil then
            local up, down, left, right = control.current.up, control.current.down, control.current.left, control.current.right
            local rotl, rotr = control.current.leanl, control.current.leanr
        else
            -- We use tick to get the correct instance of the controls
            local up, down, left, right = game.network:getControls( id, tick ).up, game.network:getControls( id, tick ).down, game.network:getControls( id, tick ).left, game.network:getControls( id, tick ).right
            local rotl, rotr = game.network:getControls( id, tick ).leanl, game.network:getControls( id, tick ).leanr
        end

        if up - down == 0 and right - left == 0 then
            direction = game.vector( 0, 0 )
        else
            direction = game.vector( right - left, down - up ):normalized()
        end
        local rotdir = rotr - rotl

    -- TODO: Gamepad controls
        e:setRotVel( e:getRotVel() + rotdir * e:getRotSpeed() * dt )

        e:setVel( e:getVel() + direction:rotated( e:getRot() ) * e:getSpeed() * dt )
    end
    e:setPos( e:getPos() + e:getVel() * dt )
    e:setRot( e:getRot() + e:getRotVel() * dt )

    -- TODO: Ground-specific friction
    e:setVel( e:getVel() * math.pow( e.friction, dt ) )
    e:setRotVel( e:getRotVel() * math.pow( e.rotfriction, dt ) )

    -- FIXME: Need proper friction calculations
    if e:getVel():len() < 1 then
        e:setVel( game.vector( 0, 0 ) )
    end
end


local setSpeed = function( e, speed )
    e.speed = speed
end

local getSpeed = function( e )
    return e.speed
end

local setVel = function( e, velocity )
    e.velocity = velocity
end

local getVel = function( e )
    return e.velocity
end

local setRotSpeed = function( e, rotspeed )
    e.rotspeed = rotspeed
end

local getRotSpeed = function( e )
    return e.rotspeed
end

local setRotVel = function( e, rotvelocity )
    e.rotvelocity = rotvelocity
end

local setActive = function( e, active )
    e.active = active
end

local getRotVel = function( e )
    return e.rotvelocity
end

local Controllable = {
    __name = "Controllable",
    speed = 2048,
    rotspeed = math.pi*3,
    velocity = game.vector( 0, 0 ),
    rotvelocity = 0,
    friction = 0.01,
    rotfriction = 0.01,
    --init = init,
    --deinit = deinit,
    update = update,
    setActive = setActive,
    setVel = setVel,
    getVel = getVel,
    setSpeed = setSpeed,
    getSpeed = getSpeed,
    setRotVel = setRotVel,
    getRotVel = getRotVel,
    networkedvars = { "active" },
    networkedfunctions = { "setActive" },
    setRotSpeed = setRotSpeed,
    getRotSpeed = getRotSpeed
}

return Controllable
