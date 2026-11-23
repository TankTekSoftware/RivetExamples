---@class PlayerPaddle : RivetScript
---@field speed number
---@field boundX number
---@field halfLength number
local PlayerPaddle = {
    -- Editable per instance in the inspector.
    properties = {
        speed = 10.0,
        boundX = 12.0,
        halfLength = 2.0,
    },
}

function PlayerPaddle:onUpdate(dt)
    local direction = 0

    if Input.isKeyDown("W") then
        direction = direction - 1
    end

    if Input.isKeyDown("S") then
        direction = direction + 1
    end
  
    if direction == 0 then
        return
    end

    local pos = self.entity.position + Vec3(0.0, 0.0, direction * self.speed * dt)

    -- keep the paddle inside the play area.
    local limit = self.boundX - self.halfLength
    pos.z = math.max(-limit, math.min(limit, pos.z))

    self.entity.position = pos
end

return PlayerPaddle
