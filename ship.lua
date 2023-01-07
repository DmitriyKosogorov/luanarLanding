Ship = {}
Ship.__index = Ship

function Ship:create(position)
    local ship = {}
    setmetatable(ship, Ship)
    ship.position=position
    ship.acceleration=Vector:create(0.001,0.001)
    ship.velocity=Vector:create(0,0)
    ship.hitBoxRadius=10
    ship.status="flying"
    ship.angle=4.7
    ship.makeFire=false
    ship.rotatingSpeed=0.1
    ship.particles=Particles:create(position)
    ship.texture=love.graphics.newImage("assets/shipW.png")
    ship.texture_fire=love.graphics.newImage("assets/Fire.png")
    return ship
end

function Ship:update()
    if(self.status=="flying") then
        self.velocity:add(self.acceleration)
        self.position:add(self.velocity)
        self.acceleration.x=0
        self.acceleration.y=0.001
    end
    if(self.position.x>width) then
        self.position.x=0
    end
    if(self.position.x<0) then
        self.position.x=width
    end
end

function Ship:removeFire()
    self.makeFire=false
end

function Ship:draw()
    r,g,b,a=love.graphics.getColor()
    if(ship.status=="landed") then
        love.graphics.setColor(0,1,0,1)
    end
    if(ship.status=="flying") then
        love.graphics.setColor(1,1,1,0.5)    
    end
    if(ship.status=="crashed") then
        love.graphics.setColor(1,0,0,1)    
    end
    
    love.graphics.circle("line", self.position.x, self.position.y, self.hitBoxRadius)
    love.graphics.setColor(r,g,b,a)
    if(self.makeFire==true) then
        love.graphics.draw(self.texture_fire, self.position.x, self.position.y, self.angle, 0.5, 0.5, self.texture_fire:getWidth()/2,self.texture_fire:getHeight()/2)
    else
        love.graphics.draw(self.texture, self.position.x, self.position.y, self.angle, 0.5, 0.5, self.texture:getWidth()/2,self.texture:getHeight()/2)
    end
    
    --love.graphics.draw(self.texture,self.position.x-self.texture:getWidth()/4, self.position.y-self.texture:getHeight()/4,self.angle,0.5,0.5)
end

function Ship:applyForce()
    if(self.status=="flying") then
        self.makeFire=true
        self.acceleration:add(Vector:create(math.sin(self.angle)*0.01,-math.cos(self.angle)*0.01))
        if(self.acceleration.x>0.1) then
            self.acceleration.x=0.1
        end
        if(self.acceleration.x<-0.1) then
            self.acceleration.x=-0.1
        end
        if(self.acceleration.y>0.1) then
            self.acceleration.y=0.01
        end
        if(self.acceleration.y<-0.1) then
            self.acceleration.y=-0.1
        end
    end
end

function Ship:rotateLeft()
    if(self.angle<7.8 and self.status=="flying") then
        self.angle=self.angle+self.rotatingSpeed
    end
end

function Ship:rotateRight()
    if(self.angle>4.8 and self.status=="flying") then
        self.angle=self.angle-self.rotatingSpeed
    end
end

function Ship:moveUp()
    self.position.y=self.position.y-5
end

function Ship:moveDown()
    self.position.y=self.position.y+5
end

function Ship:moveLeft()
    self.position.x=self.position.x-5
end

function Ship:moveRight()
    self.position.x=self.position.x+5
end