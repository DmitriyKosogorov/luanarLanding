require("vector")
require("land")
require("ship")
require("particles")


function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    fuel=300
    distance=1000
    xcenter=0
    ycenter=0
    islanding=false
    land=Land:create(height, width,10)
    ship=Ship:create(Vector:create(40,100))
    --print(#ship.particles.positions)
end

function love.update(dt)

    if(love.keyboard.isDown('space') and fuel>0) then
        ship:applyForce()
        fuel=fuel-1
    else
        ship:removeFire()
    end
    if(love.keyboard.isDown('a')) then
        ship:rotateLeft()
    end
    if(love.keyboard.isDown('d')) then
        ship:rotateRight()
    end
    if(ship.status=="flying") then
        ship:update()
        print(ship.velocity.y)
        distance, minx, miny, maxx, maxy,islanding=land:getDistance(ship.position)
        if(distance<=10) then
            if(ship.position.x>=minx-5 and ship.position.x<=maxx+5 and
                ship.position.y>=miny-5 and ship.position.y<=maxy+5)then
                    if(ship.angle>6.1 and ship.angle<6.5 and islanding and ship.velocity.y<0.5)then
                        ship.status="landed"
                    else
                        ship.status="crashed"
                        ship.particles:setPosition(ship.position)
                    end
            end
            if(ship.position.x>=minx and ship.position.x<=maxx and ship.position.y>miny) then
                ship.status="crashed"
                ship.particles:setPosition(ship.position)           
            end
        end
    end
    if(ship.status=="crashed") then
        ship.particles:update()
    end
end

function love.draw()
    if(ship.status=="crashed") then
        love.graphics.push()
        love.graphics.scale(2, 2)
        love.graphics.translate(xcenter, ycenter)
        land:draw()
        ship.particles:draw()
        love.graphics.pop()
    end
    if(ship.status=="landed") then
        love.graphics.push()
        love.graphics.scale(2, 2)
        love.graphics.translate(xcenter, ycenter)
        land:draw()
        ship:draw()
        love.graphics.pop()
    end
    if(ship.status=="flying") then
        if(distance<=20 and ship.position.y-maxy>-360) then
            love.graphics.push()
            love.graphics.scale(2, 2)
            xcenter=width/2-ship.position.x-width/4
            ycenter=height/2-ship.position.y-height/4
            if(xcenter>0)then
                xcenter=0
            end
            if(xcenter<-500)then
                xcenter=-500
            end
            love.graphics.translate(xcenter, ycenter)
            land:draw()
            ship:draw()
            love.graphics.pop()
        else
            land:draw()
            ship:draw()
        end
    end

    love.graphics.print("[a] - turn left, [d] - turn right, [space] - fly, [esc] - exit",0,0,0)
    love.graphics.print(fuel,0,10,0)

end

function love.keypressed(key)
    if(key=="escape") then
        love.event.quit()
    end

end
