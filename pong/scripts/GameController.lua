---@class GameController : RivetScript
---@field playerScore number
---@field botScore number
local GameController = {
    -- Editable per instance in the inspector.
    properties = {
        playerScore = 0,
        botScore = 0,
    },
}

function GameController:onStart()
    self.scoreLabel = Scene.findByPath("CanvasLayer/ScoreLabel")

    self:setScore(0, 0)
end

function GameController:setScore(pScore, bScore)
    self.playerScore = pScore
    self.botScore = bScore
    self.scoreLabel:send("applyScore", { self.playerScore, self.botScore })
end

function GameController:addBotScore()
    self.botScore = self.botScore + 1
    self.scoreLabel:send("applyScore", { self.playerScore, self.botScore })
end

function GameController:addPlayerScore()
    self.playerScore = self.playerScore + 1
    self.scoreLabel:send("applyScore", { self.playerScore, self.botScore })
end

return GameController
