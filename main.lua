function love.load()
    -- sprites --
    sprites = {
        background = love.graphics.newImage('sprites/background.png'),
        target = love.graphics.newImage('sprites/target.png'),
        crosshair = love.graphics.newImage('sprites/crosshair.png'),
    }

    -- target --
    target = {
        x = 400,
        y = 300,
        radius = 45,
    }

    -- gameplay variables --
    score = 0
    timer = 0
    clicks = 0
    gameState = 'menu' -- menu / game

    -- fonts --
    mainFont = love.graphics.newFont(60)
    subFont = love.graphics.newFont(40)
    smallFont = love.graphics.newFont(16)
    menuFont = love.graphics.newFont(30)

    -- config --
    love.mouse.setVisible(false)
end

function love.update(dt)
    -- start timer when game begins --
    if timer > 0 and gameState == 'game' then
        timer = timer - dt
    end

    -- keep timer from going negative --
    if timer < 0 then
        timer = 0
        gameState = 'menu'
    end
end

function love.draw()
    -- background --
    love.graphics.draw(sprites.background, 0, 0)
    
    if gameState == 'game' then
        -- target --
        love.graphics.draw(sprites.target, target.x - 45, target.y - 45)
    end

    -- HUD --
    love.graphics.setColor(0.89, 0.65, 0.45)
    love.graphics.setFont(smallFont)

    love.graphics.printf('score', -100, 12, love.graphics.getWidth(), 'center')
    love.graphics.printf('timer', 0, 12, love.graphics.getWidth(), 'center')
    love.graphics.printf('clicks', 100, 12, love.graphics.getWidth(), 'center')

    love.graphics.setColor(1, 1, 1)

    love.graphics.setFont(mainFont)
    love.graphics.printf(math.ceil(timer), 0, 30, love.graphics.getWidth(), 'center')

    love.graphics.setFont(subFont)
    love.graphics.printf(score, -100, 30, love.graphics.getWidth(), 'center')
    love.graphics.printf(clicks, 100, 30, love.graphics.getWidth(), 'center')

    -- menu text --
    if gameState == 'menu' then
        love.graphics.setFont(menuFont)
        love.graphics.printf('[spacebar] to start', 0, love.graphics.getHeight()/2, love.graphics.getWidth(), 'center')
    end

    -- crosshair --
    love.graphics.draw(sprites.crosshair, love.mouse.getX() - 34, love.mouse.getY() - 34)
end

function love.keyreleased(key)
    -- start game when you release spacebar and reset variables --
    if key == 'space' and gameState == 'menu' then
        score = 0
        clicks = 0
        timer = 10
        gameState = 'game'
    end

    if key == 'escape' then
        love.event.quit()
     end
 end

function love.mousepressed(x, y, button, istouch, pressed)
    -- clicked target logic --
    if gameState == 'game' then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)

        -- add too clicks if you don't click on a target --
        if mouseToTarget > target.radius then
            if gameState == 'game' and button == 1 or button == 2 then
                clicks = clicks + 1
            end
        end

        -- events when you do click on a target --
        if mouseToTarget < target.radius then
            if button == 1 then
                score = score + 1
                clicks = clicks + 1
            elseif button == 2 then
                clicks = clicks + 1
                score = score + 2
            end
            
            -- randomize targets position --
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        end

        timer = timer - 1
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end