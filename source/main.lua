import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx<const> = playdate.graphics

local playerSprite = nil
local wall = nill
local wall2 = nill
local map = nill

local playerSpeed = 10
local velX = 0
local velY = 0

local timer = nil
local playTime = 30e3

local function resetTimer()
    timer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

local function init()
    math.randomseed(playdate.getSecondsSinceEpoch())

    -- Player sprite
    local playerImage = gfx.image.new("images/player")
    playerSprite = gfx.sprite.new(playerImage)
    playerSprite:moveTo(200, 120)
    playerSprite:add()
    playerSprite:setCollideRect(0, 0, playerSprite:getSize())

    -- Map
    local mapImage = gfx.image.new("images/map")
    map = gfx.sprite.new(mapImage)
    -- playerSprite:moveTo(200, 120)
    map:moveTo(200, 120)
    map:add()
    map:setCollideRect(0, 0, map:getSize())

    -- Wall
    -- local wallImage = gfx.image.new("images/wall")
    -- wall = gfx.sprite.new(wallImage)
    -- wall:moveTo(300, 120)
    -- wall:add()
    -- wall:setCollideRect(0, 0, wall:getSize())
    
    -- wall2 = gfx.sprite.new(wallImage)
    -- wall2:moveTo(30, 120)
    -- wall2:add()
    -- wall2:setCollideRect(0, 0, wall:getSize())


    -- Background
    local backgroundImage = gfx.image.new("images/background")
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setClipRect(x, y, width, height)
            backgroundImage:draw(0, 0)
            gfx.clearClipRect()
        end
    )

    resetTimer()
end

init()

function playdate.update()

    if playdate.buttonJustPressed(playdate.kButtonA) then
        resetTimer()
    end

    local playerAcc = 0.3

    if(playdate.buttonIsPressed(playdate.kButtonUp)) then

        velY = velY - playerAcc
    end
    if(playdate.buttonIsPressed(playdate.kButtonDown)) then
        velY = velY + playerAcc
    end

    if(playdate.buttonIsPressed(playdate.kButtonLeft)) then
        velX = velX - playerAcc
    end
    if(playdate.buttonIsPressed(playdate.kButtonRight)) then
        velX = velX + playerAcc
    end

    if playerSprite:alphaCollision(map) then
        local l = 1
        velX = velX * -0.7
        velY = velY * -0.7
    end

    if velX > playerSpeed then velX = playerSpeed end
    if velX < -playerSpeed then velX = -playerSpeed end

    if velY > playerSpeed then velY = playerSpeed end
    if velY < -playerSpeed then velY = -playerSpeed end

    playerSprite:moveBy(velX, velY)

    
    gfx.sprite.update()
    playdate.timer.updateTimers()
    
    gfx.drawText(
        "Time: " .. math.ceil(timer.value / 1000) .. "s",
        10, 10
    )
end