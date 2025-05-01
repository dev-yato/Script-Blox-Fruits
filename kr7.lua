local ScreenGui = Instance.new("ScreenGui")
local IconButton = Instance.new("ImageButton")
local MainFrame = Instance.new("Frame")
local ActivateButton = Instance.new("TextButton")
local RedeemCodesButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local UIS = game:GetService("UserInputService")

ScreenGui.Name = "Kr7Hub"
ScreenGui.Parent = game.CoreGui

-- Icon Button
IconButton.Name = "IconButton"
IconButton.Parent = ScreenGui
IconButton.BackgroundTransparency = 1
IconButton.Position = UDim2.new(0, 20, 0, 20)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Image = "rbxassetid://89766253362395"

-- Main Panel
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

-- Activate Button
ActivateButton.Name = "ActivateButton"
ActivateButton.Parent = MainFrame
ActivateButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ActivateButton.Position = UDim2.new(0.1, 0, 0.2, 0)
ActivateButton.Size = UDim2.new(0.8, 0, 0.2, 0)
ActivateButton.Text = "Ativar Auto Farm"

-- Redeem Codes Button
RedeemCodesButton.Name = "RedeemCodesButton"
RedeemCodesButton.Parent = MainFrame
RedeemCodesButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
RedeemCodesButton.Position = UDim2.new(0.1, 0, 0.5, 0)
RedeemCodesButton.Size = UDim2.new(0.8, 0, 0.2, 0)
RedeemCodesButton.Text = "Resgatar Todos os Códigos"

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Position = UDim2.new(0.1, 0, 0.75, 0)
CloseButton.Size = UDim2.new(0.8, 0, 0.15, 0)
CloseButton.Text = "Fechar Painel"

-- Script Functions
local isFarming = false

ActivateButton.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    if isFarming then
        ActivateButton.Text = "Auto Farm Ativado"
        spawn(function()
            while isFarming do
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local level = player.Data.Level.Value
                    -- Aqui você deve inserir a lógica de pegar missão + teleportar para a ilha certa + atacar NPC
                    local quest = getQuestForLevel(level)
                    if quest then
                        getQuest(quest)
                        farmNPC(quest)
                    end
                end)
                wait(0.1)
            end
        end)
    else
        ActivateButton.Text = "Ativar Auto Farm"
    end
end)

RedeemCodesButton.MouseButton1Click:Connect(function()
    local codes = {
        "Sub2NoobMaster123", "Axiore", "TantaiGaming", "StrawHatMaine",
        "Sub2Daigrock", "Bignews", "TheGreatAce", "Fudd10", "Fudd10_V2"
        -- você pode adicionar todos os códigos que quiser aqui
    }
    for _, code in pairs(codes) do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
        end)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Funções fake (exemplo, precisa adaptar pro Blox Fruits real)
function getQuestForLevel(level)
    -- Aqui você faz o mapeamento do level para a missão certa
    -- Exemplo:
    if level < 10 then
        return {QuestName = "BanditQuest1", NPC = "Bandit"}
    elseif level < 30 then
        return {QuestName = "MonkeyQuest", NPC = "Monkey"}
    -- Continue para todos os níveis até 2650
    else
        return nil
    end
end

function getQuest(quest)
    -- Função para pegar missão
    local args = {
        [1] = quest.QuestName,
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", unpack(args))
end

function farmNPC(quest)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then
        -- Equipar melee
        tool = player.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            player.Character.Humanoid:EquipTool(tool)
        end
    end

    -- Procurar e atacar NPCs
    for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
        if npc.Name == quest.NPC and npc:FindFirstChild("HumanoidRootPart") then
            repeat
                pcall(function()
                    character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end)
                wait(0.1)
            until not npc or npc.Humanoid.Health <= 0 or not isFarming
        end
    end
end
