local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "RİP HUB",
    SubTitle = "Premium Execution",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "zap" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" })
}

-- Variables
local AimbotEnabled = false
local HitboxEnabled = false
local InfJumpEnabled = false
local ESPEnabled = false
local LoopSpeedEnabled = false
local HeadSize = 20
local SpeedValue = 16
local JumpValue = 50

-- Functions
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            local magnitude = (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude
            if magnitude < shortestDistance then
                closestPlayer = player
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end

-- Input Listeners
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then
        local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState("Jumping") end
    end
end)

-- Main Loop
game:GetService("RunService").RenderStepped:Connect(function()
    local lp = game:GetService("Players").LocalPlayer
    if not lp.Character then return end

    -- Loop Speed
    if LoopSpeedEnabled then
        lp.Character.Humanoid.WalkSpeed = SpeedValue
    end

    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= lp and player.Character then
            -- Hitbox Extender
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if HitboxEnabled then
                    root.Size = Vector3.new(HeadSize, HeadSize, HeadSize)
                    root.Transparency = 0.7
                    root.BrickColor = BrickColor.new("Really blue")
                    root.CanCollide = false
                else
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 1
                end
            end
            -- ESP
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight", player.Character)
                    highlight.Name = "ESPHighlight"
                end
            elseif highlight then
                highlight:Destroy()
            end
        end
    end

    -- Aimbot
    if AimbotEnabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- UI Controls
Tabs.Combat:AddToggle("AimbotT", {Title = "Aimbot", Default = false}):OnChanged(function(Value) AimbotEnabled = Value end)
Tabs.Combat:AddToggle("HitboxT", {Title = "Hitbox Extender", Default = false}):OnChanged(function(Value) HitboxEnabled = Value end)
Tabs.Combat:AddSlider("HitboxS", {Title = "Hitbox Size", Default = 20, Min = 2, Max = 100, Rounding = 1, Callback = function(V) HeadSize = V end})

Tabs.Movement:AddSlider("WS", {Title = "Walk Speed", Default = 16, Min = 16, Max = 500, Rounding = 1, Callback = function(V) SpeedValue = V game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = V end})
Tabs.Movement:AddToggle("LS", {Title = "Loop Speed", Default = false}):OnChanged(function(Value) LoopSpeedEnabled = Value end)
Tabs.Movement:AddSlider("JP", {Title = "Jump Power", Default = 50, Min = 50, Max = 500, Rounding = 1, Callback = function(V) game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = V end})
Tabs.Movement:AddToggle("IJ", {Title = "Infinite Jump", Default = false}):OnChanged(function(Value) InfJumpEnabled = Value end)

Tabs.Visuals:AddToggle("ESPT", {Title = "ESP (Wallhack)", Default = false}):OnChanged(function(Value) ESPEnabled = Value end)

Window:SelectTab(1)
