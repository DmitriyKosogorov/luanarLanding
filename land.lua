Land = {}
Land.__index = Land

function Land:create(height,width,landNumbers)
    local land = {}
    setmetatable(land, Land)
    --love.math.setRandomSeed(love.timer.getTime())
    math.randomseed(os.time())
    land.landings={}
    land.points={}
    land.landNumbers=landNumbers
    land.xs={}

    for i=0,width/10 do
        land.xs[0]=i*10
    end

    local partWidth=math.floor(width/land.landNumbers)

    local y=0
    local minlength=20

    for i=0,land.landNumbers do
        local xstart=i*partWidth
        local xend=(i+1)*partWidth
        if(xend>width)then
            xend=width-20
        end
        
        local x1=math.random(xstart,xend-minlength)
        x1=math.floor(x1/10)*10
        local x2=math.random(x1+minlength,xend)
        x2=math.floor(x2/10)*10
        local y=math.random(height, height/2)
        table.insert(land.landings, {[0]=x1,[1]=y,[2]=x2,[3]=y})
    end

    local prevY=height/2
    local inLand=-1
    for i=0,math.floor(width/10) do
        inLand=-1
        for j=1,#land.landings do
            if(i*10>=land.landings[j][0] and i*10<=land.landings[j][2]) then
                inLand=j
            end
        end
        if(inLand~=-1) then
            table.insert(land.points,{[0]=i*10,[1]=land.landings[inLand][1], [2]=0})
            prevY=land.landings[inLand][1]
        else
            local y1=math.random(-30,30)+prevY
            if(y1>=height) then
                y1=height-120
            end
            if(y1<=height/2) then
                y1=height/2+120
            end
            table.insert(land.points,{[0]=i*10,[1]=y1})
            prevY=y1
        end
        print(#land.points[i+1])
    end

    -- for i=1,#land.points do
    --     print(land.points[i][1])
    -- end
    return land
end

function Land:getDistance(position)
    local distance=1000
    local mindistance=1000
    local minx=-1
    local miny=-1
    local maxx=-1
    local maxy=-1
    local islanding=false
    for i=2,#self.points do
        if(position.x>=self.points[i-1][0] and position.x<=self.points[i][0]) then
            for j=i-1,i+1 do
                if(j>1 and j<=#self.points)then
                    local x0=position.x
                    local y0=position.y
                    local x1=self.points[j-1][0]
                    local y1=self.points[j-1][1]
                    local x2=self.points[j][0]
                    local y2=self.points[j][1]
                    local a=y1-y2
                    local b=x2-x1
                    local c=x1*y2-x2*y1
                    distance=(math.abs(a*x0+b*y0+c))/(math.sqrt(a*a+b*b))
                    if(distance<mindistance) then
                        mindistance=distance
                        minx=math.min(x1,x2)
                        miny=math.min(y1,y2)
                        maxx=math.max(x1,x2)
                        maxy=math.max(y1,y2)
                        if(#self.points[j]>1 and #self.points[j-1]>1) then
                            islanding=true
                        end
                    end
                    --local distance=(math.abs((y2-y2)*x0-(x2-x1)*y0+x2*y1-y2*x1))/(math.sqrt((y2-y1)*(y2-y1)+(x2-x1)*(x2-x1)))
                    
                end
            end
        end
    end
    return mindistance, minx,miny,maxx,maxy,islanding
end

function Land:draw()
    r,g,b,a=love.graphics.getColor()
    love.graphics.setLineWidth(2)
    for i=2,#self.points do
        love.graphics.line(self.points[i-1][0],self.points[i-1][1],self.points[i][0],self.points[i][1])
    end
    love.graphics.setColor(0,1,0,1)
    for i=1,self.landNumbers do
        love.graphics.line(self.landings[i][0],self.landings[i][1],self.landings[i][2],self.landings[i][3])
    end
    love.graphics.setColor(r,g,b,a)
end
