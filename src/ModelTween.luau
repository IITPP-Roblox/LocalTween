--Helper for tweening models.
--!strict

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local CurrentTweeningModelTimes = {}



--[[
Tweens a model to a target CFrame.
--]]
return function(Model: Model, Info: TweenInfo, Target: CFrame): ()
    --Store the current time.
    local StartTime = tick()
    CurrentTweeningModelTimes[Model] = StartTime

    --Create a CFrameValue for tweening.
    local CFrameValue = Instance.new("CFrameValue")
    CFrameValue.Value = Model:GetPivot()
    TweenService:Create(CFrameValue, Info, {
        Value = Target,
    }):Play()

    --Update the pivot.
    local Bound = true
    local ModelTweenId = `ModelTween{HttpService:GenerateGUID()}`
    RunService:BindToRenderStep(ModelTweenId, 1, function()
        if CurrentTweeningModelTimes[Model] ~= StartTime then
            if Bound then
                RunService:UnbindFromRenderStep(ModelTweenId)
                Bound = false
            end
            return
        end
        Model:PivotTo(CFrameValue.Value)
        RunService.RenderStepped:Wait()
    end)

    --Finish the model.
    task.wait(Info.Time)
    if Bound then
        RunService:UnbindFromRenderStep(ModelTweenId)
        Bound = false
    end
    if CurrentTweeningModelTimes[Model] ~= StartTime then return end
    Model:PivotTo(Target)
    CurrentTweeningModelTimes[Model] = nil
end