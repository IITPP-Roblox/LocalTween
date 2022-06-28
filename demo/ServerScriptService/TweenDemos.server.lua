--[[
TheNexusAvenger

Runs the LocalTween demos on the server.
--]]

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalTween = require(ReplicatedStorage:WaitForChild("LocalTween"))

local TestModels = Workspace:WaitForChild("TestModels")
local TestPlatform = TestModels:WaitForChild("TestPlatform")
local TestSpinner = TestModels:WaitForChild("TestSpinner")
local TestSpinnerPart = TestSpinner:WaitForChild("Spinner")
local TestMotor6D = TestSpinner:WaitForChild("Base"):WaitForChild("Motor6D")
TestMotor6D.DesiredAngle = 10 ^ 99



--Tween the components.
while true do
    LocalTween:Play(TestSpinnerPart, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { --TweenInfo with easing type and direction (can just do type)
        Transparency = 0.5,
        Color = Color3.new(0, 1, 0),
    })
    LocalTween:TweenModel(TestPlatform, 1, CFrame.new(-15, 10.5, -8)) --Only number instead of full TweenInfo
    LocalTween:TweenMotorSpeed(TestMotor6D, 0.25, TweenInfo.new(3))
    task.wait(3)

    LocalTween:Play(TestSpinnerPart, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Transparency = 0,
        Color = Color3.new(1, 1, 1),
    })
    LocalTween:TweenModel(TestPlatform, 1, CFrame.new(-15, 0.5, -8))
    LocalTween:TweenMotorSpeed(TestMotor6D, 0, TweenInfo.new(3))
    task.wait(3)
end