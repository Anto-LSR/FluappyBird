

function init()
    love.load()
end

function love.load()
    player = {}
    player.x = 200
    player.y = 100
    player.speed = 250

    player.sprite = love.graphics.newImage('sprites/flappySprite.png')
    player.width = player.sprite:getWidth() /2
    player.height = player.sprite:getHeight() /2
    player.collideUp = false
    player.collideDown = false
    player.points = 0

 -- -----------------------------------------
    upperPipe = {}
    upperPipe.height = 300
    upperPipe.width = 100
    upperPipe.x = 800
    upperPipe.y = 0

    lowerPipe = {}
    lowerPipe.height = 300
    lowerPipe.width = 100
    lowerPipe.x = 800
    lowerPipe.y = upperPipe.y + upperPipe.height + 150
 -- ------------------------------------------  
end

local jumping = false
local jumpingDelay = 0


function love.update(dt)
    upperPipe.x = upperPipe.x - (player.speed * dt)
    lowerPipe.x = lowerPipe.x - (player.speed * dt)
    jumpingDelay = jumpingDelay + dt

    --Etat du saut
    if jumping == true then
        jumpingDelay = jumpingDelay + 1
        player.y = player.y - 3.5
    end
    --Verif de l'état du saut
    if jumpingDelay > 30 then
        jumping = false
        jumpingDelay = jumpingDelay - 30
    end
     
    
    --Verif collision avec le plafond
    if player.y <= 0 then
        player.y = 0
    end

    --Verif collision avec le sol
        --TODO

    --Chûte du joueur
    player.y = player.y + 1

    player.collide = CheckCollisionUpperPipe(upperPipe.x, upperPipe.y, upperPipe.width, upperPipe.height, player.x, player.y, player.width, player.height) or CheckCollisionLowerPipe(lowerPipe.x, lowerPipe.y, lowerPipe.width, lowerPipe.height, player.x, player.y, player.width, player.height)

    --Generation des pipes
    if upperPipe.x < -100 then
        upperPipe.x = love.graphics.getWidth()
        upperPipe.y = 0
        upperPipe.height = math.random(100, 300)

        lowerPipe.x = upperPipe.x
        lowerPipe.y = upperPipe.y + upperPipe.height + 200
        lowerPipe.height = love.graphics.getHeight() - (upperPipe.height + 200)

        if not player.collide then
            player.points = player.points + 1
            player.speed = player.speed + 10
        end
    

    end

    
     if player.collide then
         init()
     end
    

    
end

function love.keypressed(key)
    if key == 'space' and jumping == false then
        jumping = true
    end    
end

function love.draw()
    --Player
    --love.graphics.circle("fill", player.x, player.y, 10)
    love.graphics.rectangle("line", player.x, player.y, player.width, player.height)
    love.graphics.draw(player.sprite, player.x, player.y, nil, 0.5)

    --Pipes
    
    love.graphics.rectangle('fill', upperPipe.x, upperPipe.y, upperPipe.width, upperPipe.height)
    love.graphics.rectangle('fill', lowerPipe.x, lowerPipe.y, lowerPipe.width, lowerPipe.height)

    love.graphics.print(tostring(player.points), 100, 100)

end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function CheckCollisionUpperPipe(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
  end

function CheckCollisionLowerPipe(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
    x2 < x1+w1 and
    y1 < y2+h2 and
    y2 < y1+h1
end




