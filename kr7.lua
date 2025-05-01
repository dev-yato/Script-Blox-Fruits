-- Kr7 Hub - Auto Farm + Code Redeem + UI Toggle Script

local Kr7Hub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local RedeemButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local IconButton = Instance.new("ImageButton")
local farming = false

-- GUI setup
Kr7Hub.Name = "Kr7Hub"
Kr7Hub.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Kr7Hub.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = Kr7Hub
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false  -- starts hidden

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Kr7 Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.2, 0)
ToggleButton.Text = "Start Auto Farm"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.TextSize = 16

RedeemButton.Name = "RedeemButton"
RedeemButton.Parent = MainFrame
RedeemButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RedeemButton.Position = UDim2.new(0.1, 0, 0.7, 0)
RedeemButton.Size = UDim2.new(0.8, 0, 0.2, 0)
RedeemButton.Text = "Redeem All Codes"
RedeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RedeemButton.Font = Enum.Font.SourceSans
RedeemButton.TextSize = 16

IconButton.Name = "IconButton"
IconButton.Parent = Kr7Hub
IconButton.BackgroundTransparency = 1
IconButton.Position = UDim2.new(0, 10, 0, 10)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Image = "rbxassetid://YOUR_ICON_ID_HERE"

-- Toggle panel visibility
IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Start/Stop farming
ToggleButton.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        ToggleButton.Text = "Stop Auto Farm"
        startAutoFarm()
    else
        ToggleButton.Text = "Start Auto Farm"
    end
end)

-- Redeem all codes
RedeemButton.MouseButton1Click:Connect(function()
    local codes = {"Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "fudd10", "BIGNEWS"}
    for _, code in pairs(codes) do
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
    end
end)

-- Auto Farm logic
function startAutoFarm()
    spawn(function()
        while farming do
            pcall(function()
                local player = game.Players.LocalPlayer
                local level = player.Data.Level.Value
                local questInfo = getQuestByLevel(level)
                if questInfo then
                    -- Move to island
                    if (player.Character.HumanoidRootPart.Position - questInfo.Position).Magnitude > 100 then
                        toTarget(questInfo.Position)
                    end
                    -- Get quest
                    getQuest(questInfo)
                    -- Attack
                    attackNPCs(questInfo)
                end
            end)
            wait(1)
        end
    end)
end

function getQuestByLevel(level)
    -- Example for low level, expand this
    if level >= 1 and level < 10 then
        return {
            Position = Vector3.new(1060, 16, 1427),
            QuestName = "BanditQuest1",
            NpcName = "Bandit"
        }
    end
    -- Add more levels/islands here
    return nil
end

function toTarget(pos)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Anchored = false
        local tween_s = game:GetService("TweenService")
        local info = TweenInfo.new(
            (char.HumanoidRootPart.Position - pos).Magnitude / 300,
            Enum.EasingStyle.Linear
        )
        local tween = tween_s:Create(char.HumanoidRootPart, info, {CFrame = CFrame.new(pos)})
        tween:Play()
    end
end

function getQuest(questInfo)
    local player = game.Players.LocalPlayer
    local npc = workspace:FindFirstChild(questInfo.QuestName)
    if npc then
        repeat
            wait(0.5)
            player.Character.HumanoidRootPart.CFrame = npc.Head.CFrame + Vector3.new(0, 0, 2)
            fireproximityprompt(npc.Head.ProximityPrompt)
        until player.PlayerGui:FindFirstChild("QuestGUI") or not farming
    end
end

function attackNPCs(questInfo)
    local player = game.Players.LocalPlayer
    local npcs = workspace.Enemies:GetChildren()
    for _, npc in pairs(npcs) do
        if npc.Name == questInfo.NpcName and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            repeat
                wait(0.1)
                if not farming then break end
                player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                game:GetService("VirtualUser"):ClickButton1(Vector2.new())
            until npc.Humanoid.Health <= 0 or not farming
        end
    end
end

-- Hotkey to toggle panel (PC)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
