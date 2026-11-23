---@class Ball : RivetScript
---@field speed number
---@field boundX number
---@field boundZ number
---@field halfSize number
local Ball = {
    -- Editable per instance in the inspector.
    properties = {
        speed = 10.0,
        boundX = 12.0,
        boundZ = 7.0,
        halfSize = 0.5,
    },
}

function Ball:onStart()
    self.velocityX = 0.7
    self.velocityZ = 0.3

    -- Paddles the ball bounces off; any that are missing from the scene are skipped.
    self.paddles = {}
    for _, path in ipairs({ "Actors/PlayerPaddle", "Actors/BotPaddle" }) do
        local paddle = Scene.findByPath(path)
        if paddle then
            self.paddles[#self.paddles + 1] = paddle
        end
    end

    local len = math.sqrt(self.velocityX^2 + self.velocityZ^2)
    self.velocityX = self.velocityX / len
    self.velocityZ = self.velocityZ / len
end

function Ball:onUpdate(dt)
    local pos = self.entity.position

    pos.x = pos.x + self.velocityX * self.speed * dt
    pos.z = pos.z + self.velocityZ * self.speed * dt

    -- Apply wall bounces
    pos.x, self.velocityX = self:applyBounce(pos.x, self.velocityX, self.boundX)
    pos.z, self.velocityZ = self:applyBounce(pos.z, self.velocityZ, self.boundZ)

    -- Apply paddle bounces.
    for _, paddle in ipairs(self.paddles) do
        self:applyPaddleBounce(pos, paddle)
    end

    self.entity.position = pos
end

function Ball:applyBounce(p, v, limit)
    if p >= limit then
        return limit, -math.abs(v)
    elseif p <= -limit then
        return -limit, math.abs(v)
    end

    return p, v
end

function Ball:applyPaddleBounce(pos, paddle)
    local paddlePos = paddle.position
    local half = paddle.scale * 0.5

    local reachX = self.halfSize + half.x
    local reachZ = self.halfSize + half.z

    -- AABB overlap on the XZ plane
    if math.abs(pos.x - paddlePos.x) >= reachX or math.abs(pos.z - paddlePos.z) >= reachZ then
        return
    end

    -- Only bounce if moving toward the paddle (prevents re-flipping while still overlapping)
    local side = (pos.x < paddlePos.x) and -1 or 1      -- which side of the paddle the ball is on
    if self.velocityX * side >= 0 then
        return 
    end

    -- Increase the speed after a paddle hit.
    self.speed = self.speed + 0.25

    -- Push the ball out so it does not stay inside the paddle
    pos.x = paddlePos.x + side * reachX

    -- Reflect, and angle the shot by where it hit the paddle (-1 bottom .. 1 top)
    local offset = math.max(-1, math.min(1, (pos.z - paddlePos.z) / reachZ))
    self.velocityX = side
    self.velocityZ = offset * 0.75
    local len = math.sqrt(self.velocityX^2 + self.velocityZ^2)
    self.velocityX = self.velocityX / len
    self.velocityZ = self.velocityZ / len
end

return Ball
