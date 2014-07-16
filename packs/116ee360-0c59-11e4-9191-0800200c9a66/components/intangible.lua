local init = function( e, dt )
    e.body.ent = e
    e.velocity = Vector( e.velocity.x, e.velocity.y )
    e.accel = Vector( e.accel.x, e.accel.y )
end

local update = function( e, dt )
    e.rotv = e.rotv + e.rota
    e.rota = 0
    e:setRot( e:getRot() + e.rotv * dt )
    e.rotv = e.rotv * 0.99
    e.velocity = e.velocity + e.accel
    e.velocity = e.velocity * 0.99
    e.accel = Vector( 0, 0 )
    e:setPos( e:getPos() + e.velocity * dt )
end

local setLinearVelocity = function( e, t )
end

local setFixedRotation = function( e, b )
end

local getMass = function( body )
    return body.ent.mass
end

local getLinearVelocity = function( body )
    return body.ent.velocity.x, body.ent.velocity.y
end

local getAngularVelocity = function( body )
    return body.ent.rotv
end

local applyForce = function( body, fx, fy, x, y )
    -- FIXME: I'm just trying to copy the love.physics.body api
    -- but I was too lazy to do it "right"
    -- If a y is supplied it just rotates everything based on fx
    if x or y then
        body.ent.rota = body.ent.rota + ( fx / body.ent.mass )
        return
    end
    body.ent.accel = body.ent.accel + ( Vector( fx, fy ) / body.ent.mass )
end

-- Simulate physical's attributes
local body = {
    getAngularVelocity = getAngularVelocity,
    getLinearVelocity = getLinearVelocity,
    setLinearVelocity = setLinearVelocity,
    setFixedRotation = setFixedRotation,
    getMass = getMass,
    applyForce = applyForce
}

local Intangible = {
    __name = "Intangible",
    rota = 0,
    rotv = 0,
    mass = 70,
    accel = Vector( 0, 0 ),
    velocity = Vector( 0, 0 ),
    init = init,
    body = body,
    update = update
}

return Intangible
