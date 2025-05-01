-- Kr7 Hub Blox Fruits Script
local painel = Instance.new("ScreenGui")
local panelFrame = Instance.new("Frame")
local espToggle = Instance.new("TextButton")
local autoFarmToggle = Instance.new("TextButton")
local autoClickToggle = Instance.new("TextButton")
local aceitarMissaoToggle = Instance.new("TextButton")
local redeemerButton = Instance.new("TextButton")
local aimbotToggle = Instance.new("TextButton")

-- Configurações iniciais
local painelAtivo = false
local espAtivado = false
local autoFarmAtivado = false
local autoClickAtivado = false
local aimbotAtivado = false
local aceitandoMissao = false

-- Função para criar o painel
function criarPainel()
    painel.Name = "Kr7 Hub"
    painel.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    painel.ResetOnSpawn = false

    panelFrame.Parent = painel
    panelFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    panelFrame.BackgroundTransparency = 0.4
    panelFrame.Size = UDim2.new(0, 250, 0, 300)
    panelFrame.Position = UDim2.new(0, 10, 0, 10)

    -- Botão de ativar/desativar painel
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = panelFrame
    toggleButton.Size = UDim2.new(0, 40, 0, 40)
    toggleButton.Position = UDim2.new(1, -40, 0, 0)
    toggleButton.Text = "🛠️"
    toggleButton.TextSize = 20
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.BackgroundTransparency = 0.3
    toggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
    toggleButton.MouseButton1Click:Connect(function()
        if painelAtivo then
            painelAtivo = false
            painel.Enabled = false
        else
            painelAtivo = true
            painel.Enabled = true
        end
    end)
    
    -- Botão ESP
    espToggle.Parent = panelFrame
    espToggle.Size = UDim2.new(0, 230, 0, 40)
    espToggle.Position = UDim2.new(0, 10, 0, 50)
    espToggle.Text = "👀 Ativar ESP"
    espToggle.TextSize = 20
    espToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    espToggle.MouseButton1Click:Connect(function()
        espAtivado = not espAtivado
        if espAtivado then
            espToggle.Text = "👀 Desativar ESP"
            ativarESP()
        else
            espToggle.Text = "👀 Ativar ESP"
            desativarESP()
        end
    end)

    -- Botão Auto Farm
    autoFarmToggle.Parent = panelFrame
    autoFarmToggle.Size = UDim2.new(0, 230, 0, 40)
    autoFarmToggle.Position = UDim2.new(0, 10, 0, 100)
    autoFarmToggle.Text = "⚔️ Ativar Auto Farm"
    autoFarmToggle.TextSize = 20
    autoFarmToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    autoFarmToggle.MouseButton1Click:Connect(function()
        autoFarmAtivado = not autoFarmAtivado
        if autoFarmAtivado then
            autoFarmToggle.Text = "⚔️ Desativar Auto Farm"
            iniciarAutoFarm()
        else
            autoFarmToggle.Text = "⚔️ Ativar Auto Farm"
            pararAutoFarm()
        end
    end)

    -- Botão Auto Click
    autoClickToggle.Parent = panelFrame
    autoClickToggle.Size = UDim2.new(0, 230, 0, 40)
    autoClickToggle.Position = UDim2.new(0, 10, 0, 150)
    autoClickToggle.Text = "🖱️ Ativar Auto Click"
    autoClickToggle.TextSize = 20
    autoClickToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    autoClickToggle.MouseButton1Click:Connect(function()
        autoClickAtivado = not autoClickAtivado
        if autoClickAtivado then
            autoClickToggle.Text = "🖱️ Desativar Auto Click"
            ativarAutoClick()
        else
            autoClickToggle.Text = "🖱️ Ativar Auto Click"
            desativarAutoClick()
        end
    end)

    -- Botão Aceitar Missão
    aceitarMissaoToggle.Parent = panelFrame
    aceitarMissaoToggle.Size = UDim2.new(0, 230, 0, 40)
    aceitarMissaoToggle.Position = UDim2.new(0, 10, 0, 200)
    aceitarMissaoToggle.Text = "🎯 Ativar Aceitar Missão"
    aceitarMissaoToggle.TextSize = 20
    aceitarMissaoToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    aceitarMissaoToggle.MouseButton1Click:Connect(function()
        aceitandoMissao = not aceitandoMissao
        if aceitandoMissao then
            aceitarMissaoToggle.Text = "🎯 Desativar Aceitar Missão"
            ativarAceitarMissao()
        else
            aceitarMissaoToggle.Text = "🎯 Ativar Aceitar Missão"
            desativarAceitarMissao()
        end
    end)

    -- Botão Resgatar Todos os Códigos
    redeemerButton.Parent = panelFrame
    redeemerButton.Size = UDim2.new(0, 230, 0, 40)
    redeemerButton.Position = UDim2.new(0, 10, 0, 250)
    redeemerButton.Text = "🎟️ Resgatar Todos os Códigos"
    redeemerButton.TextSize = 20
    redeemerButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    redeemerButton.MouseButton1Click:Connect(function()
        resgatarTodosOsCodigos()
    end)
end

-- Função para ativar/desativar ESP
function ativarESP()
    -- ESP para mostrar os nomes, time, distância e localização
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local espPart = Instance.new("BillboardGui")
            espPart.Adornee = player.Character.HumanoidRootPart
            espPart.Size = UDim2.new(0, 200, 0, 50)
            espPart.StudsOffset = Vector3.new(0, 3, 0)
            espPart.Name = "ESP"
            espPart.Parent = player.Character.HumanoidRootPart

            local texto = Instance.new("TextLabel")
            texto.Text = player.Name .. "\n" .. "Time: " .. (player.Team == game.Teams.Pirates and "Pirata" or "Marinha")
            texto.Size = UDim2.new(1, 0, 1, 0)
            texto.BackgroundTransparency = 1
            texto.TextColor3 = (player.Team == game.Teams.Pirates) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 255)
            texto.TextScaled = true
            texto.Parent = espPart
        end
    end
end

-- Função para desativar ESP
function desativarESP()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local espPart = player.Character.HumanoidRootPart:FindFirstChild("ESP")
            if espPart then
                espPart:Destroy()
            end
        end
    end
end

-- Funções para Auto Farm
function iniciarAutoFarm()
    -- Adicione aqui o código para o Auto Farm
end

function pararAutoFarm()
    -- Adicione aqui o código para parar o Auto Farm
end

-- Funções para Auto Click
function ativarAutoClick()
    -- Código de Auto Click
end

function desativarAutoClick()
    -- Código de desativar Auto Click
end

-- Funções para Aceitar Missão
function ativarAceitarMissao()
    -- Código para aceitar missões automaticamente
end

function desativarAceitarMissao()
    -- Código para desativar a aceitação automática de missões
end

-- Função para Resgatar Todos os Códigos
function resgatarTodosOsCodigos()
    -- Código para resgatar todos os códigos
end

-- Chama a função de criar o painel
criarPainel()
