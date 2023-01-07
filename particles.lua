Particles = {}
Particles.__index = Particles

function Particles:create(position)
    local particles = {}
    setmetatable(particles, Particles)
    particles.position=position
    particles.positions={}
    particles.accelerations={}
    particles.velocities={}
    particles.number=50

    for i=1,particles.number do
        particles.positions[i]=position
        particles.accelerations[i]=Vector:create(0,0.005)
        particles.velocities[i]=Vector:create(math.random(-5,5)/100,math.random(-5,5)/100)
    end
    return particles
end

function Particles:update()
    for i=1,self.number do
        self.velocities[i]:add(self.accelerations[i])
        self.positions[i]:add(self.velocities[i])
        --self.accelerations[i]=Vector:create(0,0.001)
    end
end

function Particles:draw()
    r,g,b,a=love.graphics.getColor()
    love.graphics.setColor(1,0,0,1)  
    for i=1,self.number do  
        love.graphics.circle("line", self.positions[i].x, self.positions[i].y, 1)
    end
    love.graphics.setColor(r,g,b,a)
end

function Particles:setPosition(position)
    for i=1,self.number do
        self.positions[i]=position+Vector:create(math.random(-5,5)/10,math.random(-5,5)/10)
    end
end