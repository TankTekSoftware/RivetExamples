---@class BotPaddle : RivetScript
---@field speed number
---@field boundX number
---@field halfLength number
---@field deadZone number
local BotPaddle = {
    -- Editable per instance in the inspector.
    properties = {
        speed = 10.0,
        boundX = 12.0,
        halfLength = 6.0,
        deadZone = 1.0,
    },
}

function BotPaddle:onStart()
    self.ball = Scene.findByPath("Actors/Ball")

    -- Direction from this paddle toward the middle of the court: +1 on the left, -1 on the right.
    self.facing = (self.entity.position.x < 0) and 1 or -1

    self.chasing = false

    if self.ball then
        self.lastBallX = self.ball.position.x
    end
end

function BotPaddle:onUpdate(dt)
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

    -- Chase the ball at the full `speed` units per second. Start once the ball drifts
    -- past `deadZone`, and stop once lined up (within one step) so it never overshoots.
    local diff = ballPos.z - pos.z
    local step = self.speed * dt
    if math.abs(diff) > self.deadZone then
        self.chasing = true
    end
    if self.chasing then
        if math.abs(diff) <= step then
            self.chasing = false
        else
            pos.z = pos.z + ((diff < 0) and -step or step)
        end
    end

    -- keep the paddle inside the play area.
    local limit = self.boundX - self.halfLength
    pos.z = math.max(-limit, math.min(limit, pos.z))

    self.entity.position = pos
end

return BotPaddle
