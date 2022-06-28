# LocalTween
LocalTween is a module developed for the [Innovation Inc Thermal Power Plant on Roblox](https://www.roblox.com/games/2337178805/Innovation-Inc-Thermal-Power-Plant)
to coordinate property tweens (transitions to new states) from
the server while still having the smoothness of being run on
the client. In addition, the module supports tweening models.

The module is fairly simple in design and does not support
a bunch of features, including:
- Pausing or canceling tweens.
- `TweenInfo` with non-default `repeatCount`, `reverses`, or `delayTime`.
- Guaranteeing order and overriding of tweens. Currently, this can be unpredictable.
- Throttling model tweens depending on conditions like distance.

# Setup
## Project
This project uses [Rojo](https://github.com/rojo-rbx/rojo) for the project
structure. Two project files in included in the repository.
* `default.project.json` - Structure for just the module. Intended for use
  with `rojo build` and to be included in Rojo project structures as a
  dependency.
* `demo.project.json` - Full Roblox place that can be synced into Roblox
  studio and ran with demo models.

## Game
LocalTween is not self-contained and requires additional setup to use.
On the server, the module only needs to be `require`d. On the client,
it needs to be `require`d **and** `SetUp()` needs to be invoked.
[LocalTweenSetup.client.lua](src/../demo/StarterPlayerScripts/LocalTweenSetup.client.lua)
is an example if LocalTween is directly under `ReplicatedStorage`.

```lua
require(game:GetService("ReplicatedStorage"):WaitForChild("LocalTween")):SetUp()
```

The specific location of LocalTween does not matter as long as `SetUp`
is called on the client.

# API
## Base API
### `LocalTween:Play(Target: Instance, Info: TweenInfo | number, Properties: table): nil`
Creates a plays a tween on the client. The `Info` parameter can be a `TweenInfo` or
a number similar to `TweenInfo.new(Duration)`. Compared to the `TweenService`:

```lua
local TweenService = game:GetService("TweenService")
TweenService:Create(SomePart, TweenInfo.new(5), {
    Transparency = 1,
}):Play()
```

and LocalTween:
```lua
local LocalTween = require(game:GetService("ReplicatedStorage"):WaitForChild("LocalTween"))

--Option 1
LocalTween:Play(SomePart, TweenInfo.new(5), {
    Transparency = 1,
})

--Option 2 (no TweenInfo.new)
LocalTween:Play(SomePart, 5, {
    Transparency = 1,
})
```

For models, use the `CFrame` property or use the `TweenModel` helper function.
```lua
local LocalTween = require(game:GetService("ReplicatedStorage"):WaitForChild("LocalTween"))
LocalTween:Play(SomeModel, TweenInfo.new(5), {
    CFrame = CFrame.new(0, 5, 0),
})
```

### `LocalTween:SetUp(): nil`
Sets up the LocalTween replication on the client. Calling it more than once
is unsupported and can lead to unexpected behavior.

## Helper API
### `LocalTween:TweenModel(Model: Model, Info: TweenInfo | number, Target: CFrame | BasePart): nil`
Tweens a model to a given CFrame or part. If a part is specified, the CFrame
will be `Part.CFrame`.

### `LocalTween:TweenMotorSpeed(Motor6D: Motor6D, Speed: number, Info: TweenInfo | number): nil`
Tweens the `DesiredSpeed` of a `Motor6D` to a given speed. This is included due
to how many `Motor6D`s are used in the Innovation Inc Thermal Power Plant.

# License
This project is available under the terms of the MIT License. See [LICENSE](LICENSE) for details.