--[[
TheNexusAvenger

Plays tweens on the client.
--]]
--!strict

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local ModelTween = require(script:WaitForChild("ModelTween"))
local LocalTween = {}
LocalTween.CurrentTweens = {}



--Create or get the event.
--It is set up on the client when SetUp is called.
local StartTweenEvent = nil
if not RunService:IsClient() then
    StartTweenEvent = script:FindFirstChild("StartTween") or Instance.new("RemoteEvent")
    StartTweenEvent.Name = "StartTween"
    StartTweenEvent.Parent = script
end



--[[
Plays a tween.
--]]
function LocalTween:Play(Target: Instance, Info: TweenInfo | number, Properties: {[string]: any}): ()
    --Convert the tween info if it is just a number.
    if typeof(Info) == "number" then
        Info = TweenInfo.new(Info)
    end
    local Tween = Info :: TweenInfo

    if RunService:IsServer() then
        --Warn if there are unsupported properties.
        if Tween.RepeatCount ~= 0 then
            warn("TweenInfo.RepeatCount is not supported by LocalTween.")
        end
        if Tween.Reverses ~= false then
            warn("TweenInfo.Reverses is not supported by LocalTween.")
        end
        if Tween.DelayTime ~= 0 then
            warn("TweenInfo.DelayTime is not supported by LocalTween.")
        end

        --Message the clients to start the tween.
        StartTweenEvent:FireAllClients(Target, {
            Tween.Time,
            Tween.EasingStyle,
            Tween.EasingDirection,
        } :: {any}, Properties)

        --Store the properties being tweened.
        local CurrentTime = tick()
        if not self.CurrentTweens[Target] then
            self.CurrentTweens[Target] = {}
        end
        local TweenPropertyTimes = self.CurrentTweens[Target]
        for Name, _ in pairs(Properties) do
            TweenPropertyTimes[Name] = CurrentTime
        end

        --Wait for the tween to finish.
        task.delay(Tween.Time, function()
            --Set the properties.
            for Name, Value in pairs(Properties) do
                if TweenPropertyTimes[Name] == CurrentTime then
                    if Name == "CFrame" and Target:IsA("Model") then
                        Target:PivotTo(Value)
                    else
                        (Target :: any)[Name] = Value --TODO: Table indexing for instances results in typing errors - https://github.com/Roblox/luau/issues/586
                    end
                    TweenPropertyTimes[Name] = nil
                end
            end
            if next(TweenPropertyTimes) == nil then
                self.CurrentTweens[Target] = nil
            end
        end)
    else
        --Start the model tween.
        if Target:IsA("Model") and Properties.CFrame then
            task.spawn(function()
                ModelTween(Target, Tween, Properties.CFrame)
            end)
            Properties.CFrame = nil
        end

        --Start the tween.
        if next(Properties) ~= nil then
            TweenService:Create(Target, Tween, Properties):Play()
        end
    end
end

--[[
Wrapper for moving a model to a CFrame or part.
--]]
function LocalTween:TweenModel(Model: Model, Info: TweenInfo | number, Target: CFrame | BasePart): ()
    if typeof(Target) == "Instance" then
        Target = Target.CFrame
    end
    self:Play(Model, Info, {
        CFrame = Target,
    })
end

--[[
Wrapper for tweening the speed of a Motor6D.
--]]
function LocalTween:TweenMotorSpeed(Motor6D: Motor6D, Speed: number, Info: TweenInfo | number): ()
    self:Play(Motor6D, Info, {
        MaxVelocity = Speed,
    })
end

--[[
Sets up the LocalTween module on the client.
--]]
function LocalTween:SetUp(): ()
	StartTweenEvent = script:WaitForChild("StartTween")
    StartTweenEvent.OnClientEvent:Connect(function(Target: Instance?, Info: {any}, Properties: {[string]: any})
        if Target == nil then return end
        self:Play(Target, TweenInfo.new(unpack(Info)), Properties)
    end)
end



return LocalTween