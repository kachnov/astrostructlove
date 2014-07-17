local Singleplayer = {}

function Singleplayer:enter()
    MapSystem:load( Gamemode.map )
    -- Spawn ourselves in
    Gamemode:spawnPlayer( 0 )
end

function Singleplayer:leave()
end

function Singleplayer:draw()
    Renderer:draw()
    loveframes.draw()
end

function Singleplayer:update( dt )
    BindSystem:update( dt )
    Physics:update( dt )
    World:update( dt )
    DemoSystem:update( dt )
    loveframes.update( dt )
end

function Singleplayer:mousepressed( x, y, button )
    loveframes.mousepressed( x, y, button )
end

function Singleplayer:mousereleased( x, y, button )
    loveframes.mousereleased( x, y, button )
end

function Singleplayer:keypressed( key, unicode )
    loveframes.keypressed( key, unicode )
end

function Singleplayer:keyreleased( key )
    loveframes.keyreleased( key )
end

function Singleplayer:textinput( text )
    loveframes.textinput( text )
end

function Singleplayer:resize( w, h )
    Renderer:resize( w, h )
    World:resize( w, h )
end

return Singleplayer