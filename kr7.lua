-- Kr7 Hub - Auto Farm Blox Fruits Script

local Kr7Hub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local dragging = false
local dragInput, mousePos, framePos

-- GUI setup
Kr7Hub.Name = "Kr7Hub"
Kr7Hub.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Kr7Hub.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = Kr7Hub
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 120)
MainFrame.Active = true
MainFrame.Draggable = true

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
ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleButton.Text = "Start Auto Farm"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.TextSize = 16

local farming = false

ToggleButton.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        ToggleButton.Text = "Stop Auto Farm"
        startAutoFarm()
    else
        ToggleButton.Text = "Start Auto Farm"
    end
end)

-- Function to handle Auto Farm logic
function startAutoFarm()
    spawn(function()
        while farming do
            pcall(function()
                local player = game.Players.LocalPlayer
                local level = player.Data.Level.Value
                -- Determine island and quest based on level (example logic)
                local questInfo = getQuestByLevel(level)
                if questInfo then
                    if (player.Character.HumanoidRootPart.Position - questInfo.Position).Magnitude > 100 then
                        toTarget(questInfo.Position)
                    end
                    getQuest(questInfo)
                    attackNPCs(questInfo)
                end
            end)
            wait(1)
        end
    end)
end

-- Placeholder for getQuestByLevel
function getQuestByLevel(level)
    -- Add full mapping here later
    return {
        Position = Vector3.new(0, 0, 0),
        QuestName = "BanditQuest",
        NpcName = "Bandit"
    }
end

-- Teleport logic
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

-- Quest getter (placeholder)
function getQuest(questInfo)
    -- You need to integrate quest accepting logic here
end

-- Attack NPCs logic
function attackNPCs(questInfo)
    local player = game.Players.LocalPlayer
    local npcs = workspace.Enemies:GetChildren()
    for _, npc in pairs(npcs) do
        if npc.Name == questInfo.NpcName and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            repeat
                wait(0.1)
                if not farming then break end
                player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                if game:GetService("UserInputService").TouchEnabled then
                    -- Mobile click simulation
                    local VirtualUser = game:GetService("VirtualUser")
                    VirtualUser:Button1Down(Vector2.new())
                    wait(0.05)
                    VirtualUser:Button1Up(Vector2.new())
                else
                    -- PC click
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                end
            until npc.Humanoid.Health <= 0 or not farming
        end
    end
end

-- Hotkey to toggle (PC)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Kr7Hub.Enabled = not Kr7Hub.Enabled
    end
end)
