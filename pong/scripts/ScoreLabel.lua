-- Lua script. Attach it with a LuaScript component; see AGENTS.md for the API.
---@class ScoreLabel : RivetScript
---@field speed number
local ScoreLabel = {
    -- Editable per instance in the inspector.
    properties = {},
}

function ScoreLabel:onStart()
    self.label = self.entity:getComponent("UiText")
end

function ScoreLabel:applyScore(scores)
    self.label.text = scores[1] .. " : " .. scores[2]
end

return ScoreLabel
