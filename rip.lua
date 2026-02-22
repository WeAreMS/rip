local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local lp = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Window = Fluent:CreateWindow({
    Title = "RİP HUB",
    SubTitle = "The Ultimate Execution",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "zap" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" })
}

-- Settings Variables
local AimbotEnabled = false
local HitboxEnabled = false
local ESPEnabled = false
local InfJumpEnabled = false
local LoopSpeedEnabled = false
local HeadSize = 50
local SpeedValue = 16

-- Closest Player Logic
local function GetClosestPlayer()
    local closest, dist = nil, math.huge
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos = v.Character.Head.Position
            local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
            if onScreen then
                local d = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if d < dist then closest = v dist = d end
            end
        end
    end
    return closest
end

-- Infinite Jump Request
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Main Execution Loop
RunService.RenderStepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if LoopSpeedEnabled then lp.Character.Humanoid.WalkSpeed = SpeedValue end
        lp.Character.Humanoid.UseJumpPower = true
    end

    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= lp and v.Character then
            -- HITBOX (Blue Neon Aggressive)
            local root = v.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if HitboxEnabled then
                    root.Size = Vector3.new(HeadSize, HeadSize, HeadSize)
                    root.Transparency = 0.7
                    root.BrickColor = BrickColor.new("Really blue")
                    root.Material = Enum.Material.Neon
                    root.CanCollide = false
                    root.Massless = true
                else
                    -- Sadece hitbox kapalıyken eski boyuta dön (Performans için pcall)
                    pcall(function() 
                        root.Size = Vector3.new(2, 2, 1)
                        root.Transparency = 1 
                    end)
                end
            end

            -- WALLHACK (Always On Top Fix)
            local highlight = v.Character:FindFirstChild("RIP_Highlight")
            if ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "RIP_Highlight"
                    highlight.Parent = v.Character
                end
                highlight.Enabled = true
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Duvar arkası için kritik
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            elseif highlight then
                highlight.Enabled = false
            end
        end
    end

    -- AIMBOT
    if AimbotEnabled then
        local target = GetClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- UI CONTROLS
Tabs.Combat:AddToggle("AimT", {Title = "Aimbot", Default = false}):OnChanged(function(v) AimbotEnabled = v end)
Tabs.Combat:AddToggle("HitT", {Title = "Blue Neon Hitbox", Default = false}):OnChanged(function(v) HitboxEnabled = v end)
Tabs.Combat:AddSlider("HitS", {Title = "Hitbox Size", Default = 50, Min = 2, Max = 100, Rounding = 1, Callback = function(v) HeadSize = v end})

Tabs.Movement:AddSlider("WS", {Title = "Walk Speed", Default = 16, Min = 16, Max = 300, Rounding = 1, Callback = function(v) SpeedValue = v end})
Tabs.Movement:AddToggle("LS", {Title = "Loop Speed", Default = false}):OnChanged(function(v) LoopSpeedEnabled = v end)
Tabs.Movement:AddToggle("IJ", {Title = "Infinite Jump", Default = false}):OnChanged(function(v) InfJumpEnabled = v end)

Tabs.Visuals:AddToggle("ESPT", {Title = "ESP (Wallhack)", Default = false}):OnChanged(function(v) ESPEnabled = v end)

Window:SelectTab(1)
Fluent:Notify({Title = "RİP HUB", Content = "Final Version Loaded!", Duration = 3})
