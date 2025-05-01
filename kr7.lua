-- Kr7 Hub | Auto Defesa com Painel Movível e Fechável
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local defendKey = "F" -- tecla para defesa, ajuste se necessário
local defenseDistance = 20 -- distância para ativar a defesa

-- Variável para controlar o estado
local autoDefendEnabled = false

-- Função para buscar a bola
local function getBall()
    for _, obj in pairs(game:GetService("Workspace"):GetChildren()) do
        if obj:IsA("BasePart") and obj.Name == "Ball" then
            return obj
        end
    end
    return nil
end

-- Função de Auto Defesa
local function autoDefend()
    local ball = getBall()
    if ball and character and character:FindFirstChild("HumanoidRootPart") then
        local distance = (ball.Position - character.HumanoidRootPart.Position).magnitude
        if distance <= defenseDistance then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, defendKey, false, game)
            wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, defendKey, false, game)
        end
    end
end

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Kr7HubGui"
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Kr7 Hub - Auto Defesa"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0, 40)
toggleButton.Position = UDim2.new(0.1, 0, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleButton.Text = "Ativar Auto Defesa"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.2, 0, 0.2, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

local reopenButton = Instance.new("TextButton")
reopenButton.Size = UDim2.new(0.2, 0, 0.2, 0)
reopenButton.Position = UDim2.new(0.5, -40, 0.5, -40)
reopenButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
reopenButton.Text = "Reabrir"
reopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenButton.Font = Enum.Font.SourceSansBold
reopenButton.TextSize = 18
reopenButton.Visible = false
reopenButton.Parent = screenGui

-- Função para alternar o estado de defesa
toggleButton.MouseButton1Click:Connect(function()
    autoDefendEnabled = not autoDefendEnabled
    if autoDefendEnabled then
        toggleButton.Text = "Desativar Auto Defesa"
    else
        toggleButton.Text = "Ativar Auto Defesa"
    end
end)

-- Função para mover o painel
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if dragging then
        local delta = game:GetService("UserInputService"):GetMouseLocation() - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, delta.X, startPos.Y.Scale, delta.Y)
    end
end)

-- Função para fechar o painel
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    reopenButton.Visible = true
end)

-- Função para reabrir o painel
reopenButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    reopenButton.Visible = false
end)

-- Loop principal
while true do
    if autoDefendEnabled then
        pcall(autoDefend)
    end
    wait(0.05)
end
