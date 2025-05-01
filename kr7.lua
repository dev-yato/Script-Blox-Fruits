local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tabela com as Ilhas e NPCs de Missão
local islands = {
    -- Sea 1
    {min = 1, max = 15, island = "Bandit Island", questNpc = "Bandit Quest Giver", sea = 1},
    {min = 15, max = 30, island = "Monkey Island", questNpc = "Monkey Quest Giver", sea = 1},
    {min = 30, max = 60, island = "Desert Island", questNpc = "Desert Quest Giver", sea = 1},
    {min = 60, max = 100, island = "Jungle Island", questNpc = "Jungle Quest Giver", sea = 1},
    {min = 100, max = 150, island = "Pirate Island", questNpc = "Pirate Quest Giver", sea = 1},
    {min = 150, max = 225, island = "Sky Island", questNpc = "Sky Quest Giver", sea = 1},
    {min = 225, max = 300, island = "Magma Island", questNpc = "Magma Quest Giver", sea = 1},
    {min = 300, max = 450, island = "Fountain City", questNpc = "Fountain Quest Giver", sea = 1},

    -- Sea 2
    {min = 700, max = 850, island = "Kingdom of Rose", questNpc = "Rose Quest Giver", sea = 2},
    {min = 850, max = 1000, island = "Green Zone", questNpc = "Green Quest Giver", sea = 2},
    {min = 1000, max = 1350, island = "Congo Island", questNpc = "Congo Quest Giver", sea = 2},
    {min = 1350, max = 1500, island = "Cursed Ship", questNpc = "Cursed Ship Quest Giver", sea = 2},

    -- Sea 3
    {min = 1500, max = 1750, island = "Hydra Island", questNpc = "Hydra Quest Giver", sea = 3},
    {min = 1750, max = 2000, island = "Great Tree", questNpc = "Great Tree Quest Giver", sea = 3},
    {min = 2000, max = 2250, island = "Castle on the Sea", questNpc = "Castle Quest Giver", sea = 3},
    {min = 2250, max = 2450, island = "Haunted Castle", questNpc = "Haunted Castle Quest Giver", sea = 3},
    {min = 2450, max = 2650, island = "Tiki Outpost", questNpc = "Tiki Outpost Quest Giver", sea = 3},
}

-- Função para voar até a ilha
local function flyToIsland(destination)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(
        (humanoidRootPart.Position - destination.Position).Magnitude / 300, -- velocidade 300
        Enum.EasingStyle.Linear
    )
    local goal = {CFrame = destination.CFrame}
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
end

-- Função para pegar a missão automaticamente
local function getQuestForIsland(questNpc)
    local npc = workspace:FindFirstChild(questNpc)
    if npc then
        -- Simula clicar no NPC para pegar a missão
        fireclickdetector(npc.ClickDetector)
        wait(0.5)
        -- Inicia a missão
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questNpc, 1)
    end
end

-- Função para atacar NPCs com melee
local function attackMelee(npc)
    local tool = player.Backpack:FindFirstChildWhichIsA("Tool")
    if tool then
        tool.Parent = character
        tool:Activate()
    end
end

-- Função para auto-click nos NPCs
local function autoClickAttack(npc)
    local clickDetector = npc:FindFirstChild("ClickDetector")
    if clickDetector then
        -- Simula clicar no NPC para continuar o ataque com auto-click
        fireclickdetector(clickDetector)
    end
end

-- Função para verificar a missão do jogador baseado no nível
local function getCurrentIsland(level)
    for _, island in pairs(islands) do
        if level >= island.min and level <= island.max then
            return island
        end
    end
    return nil
end

-- Loop de farm
while true do
    -- Checa se o AutoFarm está ativado
    if _G.autoFarm then
        local level = player.Data.Level.Value
        local currentIsland = getCurrentIsland(level)

        if currentIsland then
            -- Encontra a ilha e o NPC da missão
            local islandPart = workspace:FindFirstChild(currentIsland.island)
            if islandPart then
                -- Se o jogador não estiver na ilha correta, voa para lá
                if (character.HumanoidRootPart.Position - islandPart.Position).Magnitude > 50 then
                    flyToIsland(islandPart)
                end

                -- Pega a missão automaticamente
                getQuestForIsland(currentIsland.questNpc)

                -- Ataca todos os NPCs da ilha
                for _, npc in pairs(workspace.Enemies:GetChildren()) do
                    if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                        -- Se o NPC estiver perto, começa o ataque
                        if (npc.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude < 100 then
                            repeat
                                -- Ataca com melee a cada 0.1ms
                                attackMelee(npc)
                                -- Auto click para garantir que o ataque continue
                                autoClickAttack(npc)
                                wait(0.1)
                            until npc.Humanoid.Health <= 0 or not _G.autoFarm
                        end
                    end
                end
            end
        end
    end
    wait(1)
end
