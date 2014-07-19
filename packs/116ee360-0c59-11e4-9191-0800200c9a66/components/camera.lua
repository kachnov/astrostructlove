-- Camera component allows an entity to control the view

local setPos = function( e, t )
    e.camera:lookAt( t.x, t.y )
end

local setRot = function( e, rot )
    e.camera:rotateTo( -rot )
end

local setZoom = function( e, zoom )
    e.zoom = zoom
    e.camera:zoomTo( zoom )
end

local Zoom = function( e, zoom )
    e.zoom = e.zoom * zoom
    e.camera:zoom( zoom )
end

local getZoom = function( e )
    return e.zoom
end

local setLocalPlayer = function( e, bool )
    if bool then
        CameraSystem:setActive( e )
    end
end

local toWorld = function( e, pos )
    local x,y = e.camera:worldCoords( pos.x, pos.y )
    return Vector( x, y )
end

local init = function( e )
    e.camera = Camera()
    e.camera:lookAt( e:getPos().x, e:getPos().y )
    e.camera:zoomTo( e.zoom )
    e.camera:rotateTo( -e.rot )
    if e:hasComponent( Components.controllable ) then
        if e:isLocalPlayer() then
            CameraSystem:setActive( e )
        end
    end
end

local deinit = function( e )
end

local Camera = {
    __name = "Camera",
    camera = nil,
    zoom = 1,
    init = init,
    active = false,
    deinit = deinit,
    setPos = setPos,
    setLocalPlayer = setLocalPlayer,
    setRot = setRot,
    setZoom = setZoom,
    setActive = setActive,
    getZoom = getZoom,
    networkinfo = {
        setZoom = "zoom"
    },
    Zoom = Zoom,
    toWorld = toWorld
}

return Camera
