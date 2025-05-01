local Kr7Hub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local AutoFarmButton = Instance.new("TextButton")
local ESPButton = Instance.new("TextButton")
local RedeemCodesButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

Kr7Hub.Name = "Kr7Hub"
Kr7Hub.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = Kr7Hub
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = Kr7Hub
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.Position = UDim2.new(0, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Text = "≡"

local AutoFarm = false
local ESPActive = false

local function FastAttack()
    local VirtualUser = game:GetService('VirtualUser')
    spawn(function()
        while AutoFarm do
            pcall(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                    local enemy = GetNearestEnemy()
                    if enemy then
                        char.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    end
                end
            end)
            wait(0.1)
        end
    end)
end

function GetNearestEnemy()
    local nearest
    local dist = math.huge
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).magnitude
            if magnitude < dist then
                dist = magnitude
                nearest = v
            end
        end
    end
    return nearest
end

function StartAutoFarm()
    spawn(function()
        while AutoFarm do
            pcall(function()
                local player = game.Players.LocalPlayer
                local level = player.Data.Level.Value
                -- Aqui você define suas missões/ilhas baseadas no level
                local quest = GetQuestForLevel(level)
                if quest then
                    -- Teleportar até a ilha da missão
                    player.Character.HumanoidRootPart.CFrame = quest.Position
                    wait(1)
                    -- Pegar missão
                    fireclickdetector(quest.NPC.ClickDetector)
                end
            end)
            wait(5)
        end
    end)
end

function GetQuestForLevel(level)
    -- Você pode estender com as ilhas/missões reais aqui:
    local quests = {
        {Level = 1, Position = CFrame.new(0, 10, 0), NPC = workspace:FindFirstChild("BanditQuestGiver")},
        {Level = 700, Position = CFrame.new(1000, 10, 1000), NPC = workspace:FindFirstChild("NewWorldQuestGiver")},
        -- Adicione outras missões conforme sua lógica!
    }
    local selected
    for _, q in pairs(quests) do
        if level >= q.Level then
            selected = q
        end
    end
    return selected
end

function EnableESP()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            local color = v.Team.Name == "Pirates" and BrickColor.new("Bright red") or BrickColor.new("Bright blue")
            local highlight = Instance.new("Highlight", v.Character)
            highlight.Name = "Kr7ESP"
            highlight.FillColor = color.Color
            highlight.OutlineColor = Color3.new(1,1,1)
        end
    end
end

function DisableESP()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Kr7ESP") then
            v.Character:FindFirstChild("Kr7ESP"):Destroy()
        end
    end
end

AutoFarmButton.Name = "AutoFarmButton"
AutoFarmButton.Parent = MainFrame
AutoFarmButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoFarmButton.Position = UDim2.new(0.1, 0, 0.2, 0)
AutoFarmButton.Size = UDim2.new(0, 200, 0, 40)
AutoFarmButton.Text = "Toggle Auto Farm"

ESPButton.Name = "ESPButton"
ESPButton.Parent = MainFrame
ESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ESPButton.Size = UDim2.new(0, 200, 0, 40)
ESPButton.Text = "Toggle ESP"

RedeemCodesButton.Name = "RedeemCodesButton"
RedeemCodesButton.Parent = MainFrame
RedeemCodesButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RedeemCodesButton.Position = UDim2.new(0.1, 0, 0.6, 0)
RedeemCodesButton.Size = UDim2.new(0, 200, 0, 40)
RedeemCodesButton.Text = "Redeem All Codes"

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

AutoFarmButton.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    if AutoFarm then
        StartAutoFarm()
        FastAttack()
    end
end)

ESPButton.MouseButton1Click:Connect(function()
    ESPActive = not ESPActive
    if ESPActive then
        EnableESP()
    else
        DisableESP()
    end
end)

RedeemCodesButton.MouseButton1Click:Connect(function()
    local codes = {"EXPBoost", "1BVisits", "SubToCaptainMaui"} -- coloque os códigos reais aqui
    for _, code in pairs(codes) do
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
    end
end)
