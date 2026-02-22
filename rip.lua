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
    Visuals = Window:AddTab({ Title = "Visuals (ESP)", Icon = "eye" })
}

-- Variables
local AimbotEnabled = false
local HitboxEnabled = false
local InfJumpEnabled = false
local ESPEnabled = false
local HeadSize = 20

-- Get Closest Player Function
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

-- Infinite Jump Support
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Main Loop
game:GetService("RunService").RenderStepped:Connect(function()
    local lp = game:GetService("Players").LocalPlayer
    
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= lp and player.Character then
            -- Hitbox Extender
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if HitboxEnabled then
                    root.Size = Vector3.new(HeadSize, HeadSize, HeadSize)
                    root.Transparency = 0.7
                    root.BrickColor = BrickColor.new("Really blue")
                    root.Material = Enum.Material.Neon
                    root.CanCollide = false
                else
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 1
                end
            end
            
            -- ESP (Highlight)
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight", player.Character)
                    highlight.Name = "ESPHighlight"
                end
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
            elseif highlight then
                highlight:Destroy()
            end
        end
    end

    -- Aimbot Logic
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
Tabs.Movement:AddToggle("InfJumpT", {Title = "Infinite Jump", Default = false}):OnChanged(function(Value) InfJumpEnabled = Value end)
Tabs.Visuals:AddToggle("ESPT", {Title = "ESP (Wallhack)", Default = false}):OnChanged(function(Value) ESPEnabled = Value end)

Window:SelectTab(1)
