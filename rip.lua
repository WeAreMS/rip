local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local lp = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [[ HYPER-BYPASS ENGINE ]]
local raw_mt = getrawmetatable(game)
local old_index = raw_mt.__index
local old_newindex = raw_mt.__newindex
local old_namecall = raw_mt.__namecall
setreadonly(raw_mt, false)

-- Metatable Spoofing (Hileyi Saklama)
raw_mt.__index = newcclosure(function(self, key)
    if not checkcaller() and lp.Character and self == lp.Character:FindFirstChildOfClass("Humanoid") then
        if key == "WalkSpeed" then return 16 end
        if key == "JumpPower" then return 50 end
    end
    return old_index(self, key)
end)

-- Anti-Change (Oyunun hızı sıfırlamasını engelleme)
raw_mt.__newindex = newcclosure(function(self, key, value)
    if not checkcaller() and lp.Character and self == lp.Character:FindFirstChildOfClass("Humanoid") then
        if key == "WalkSpeed" and value < 16 then return end -- Oyun hızı düşüremez
        if key == "JumpPower" and value < 50 then return end
    end
    return old_newindex(self, key, value)
end)

-- Anti-Kick (Atılmayı engelleme)
raw_mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "Kick" or method == "kick") then
        return nil 
    end
    return old_namecall(self, ...)
end)
setreadonly(raw_mt, true)

-- [[ UI SETUP ]]
local Window = Fluent:CreateWindow({
    Title = "RİP HUB",
    SubTitle = "HYPER-BYPASS V4 (STEALTH)",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = {
    Main = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Move = Window:AddTab({ Title = "Movement", Icon = "zap" }),
    Vis = Window:AddTab({ Title = "Visuals", Icon = "eye" })
}

local Config = { Hitbox = false, HSize = 15, ESP = false, Speed = 16, InfJump = false }

-- [[ CORE DÖNGÜ ]]
RunService.RenderStepped:Connect(function()
    pcall(function()
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local root = v.Character.HumanoidRootPart
                -- Smooth Hitbox
                if Config.Hitbox then
                    root.Size = Vector3.new(Config.HSize, Config.HSize, Config.HSize)
                    root.Transparency = 0.75
                    root.BrickColor = BrickColor.new("Really blue")
                    root.Material = Enum.Material.Neon
                    root.CanCollide = false
                    root.Massless = true
                else
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 1
                end

                -- ESP (Wallhack)
                local hl = v.Character:FindFirstChild("V4_ESP")
                if Config.ESP then
                    if not hl then
                        hl = Instance.new("Highlight", v.Character)
                        hl.Name = "V4_ESP"
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    hl.Enabled = true
                elseif hl then
                    hl.Enabled = false
                end
            end
        end
    end)
end)

-- [[ CONTROLS ]]
Tabs.Main:AddToggle("HitT", {Title = "Hyper Hitbox", Default = false}):OnChanged(function(v) Config.Hitbox = v end)
Tabs.Main:AddSlider("HitS", {Title = "Hitbox Size", Default = 15, Min = 2, Max = 45, Rounding = 1, Callback = function(v) Config.HSize = v end})

Tabs.Move:AddSlider("WS", {Title = "Spoofed Speed", Default = 16, Min = 16, Max = 100, Rounding = 1, Callback = function(v) 
    if lp.Character then lp.Character.Humanoid.WalkSpeed = v end 
end})
Tabs.Move:AddToggle("IJ", {Title = "Infinite Jump", Default = false}):OnChanged(function(v) Config.InfJump = v end)

Tabs.Vis:AddToggle("ESPT", {Title = "Anti-Detection ESP", Default = false}):OnChanged(function(v) Config.ESP = v end)

-- Jump Request
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState("Jumping")
    end
end)

Window:SelectTab(1)
Fluent:Notify({Title = "RİP HUB", Content = "Hyper-Bypass Active. Be careful with speed!", Duration = 5})
