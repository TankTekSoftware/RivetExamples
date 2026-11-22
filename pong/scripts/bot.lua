---@class Bot : RivetScript
---@field speed number
---@field boundX number
---@field halfLength number
local Bot = {
    -- Editable per instance in the inspector.
    properties = {
        speed = 5.0,
        boundX = 12.0,
        halfLength = 6.0,
    },
}

function Bot:onStart()
    self.ball = Scene.findByPath("Actors/Ball")

    -- Direction from this paddle toward the middle of the court: +1 on the left, -1 on the right.
    self.facing = (self.entity.position.x < 0) and 1 or -1

    if self.ball then
        self.lastBallX = self.ball.position.x
    end
end

function Bot:onUpdate(dt)
    if not self.ball then
        return
    end

    local ballPos = self.ball.position
    local movedX = ballPos.x - self.lastBallX
    self.lastBallX = ballPos.x

    local pos = self.entity.position

    -- Only move once the ball has been received.
    local inFront = (ballPos.x - pos.x) * self.facing > 0
    local approaching = movedX * self.facing < 0
    if not (inFront and approaching) then
        return
    end

    -- Follow the ball, at most `speed` units per second, without overshooting it.
    local diff = ballPos.z - pos.z
    local step = math.min(math.abs(diff), self.speed * dt)
    pos.z = pos.z + ((diff < 0) and -step or step)

    -- keep the paddle inside the play area.
    local limit = self.boundX - self.halfLength
    pos.z = math.max(-limit, math.min(limit, pos.z))

    self.entity.position = pos
end

return Bot
