pcall(function()
    -- Criar GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "Kr7Hub"
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")

    -- Ícone
    local icon = Instance.new("ImageButton")
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0, 20, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Image = "https://cdn.discordapp.com/icons/1363950243905011812/b754d8296b87d6329d3c1a4a0336e91d.png?size=2048"
    icon.Parent = gui

    -- Painel
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 350)
    frame.Position = UDim2.new(0.5, -160, 0.5, -175)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Visible = false
    frame.Draggable = true
    frame.Active = true
    frame.Parent = gui

    local activate = Instance.new("TextButton")
    activate.Size = UDim2.new(0.8, 0, 0.15, 0)
    activate.Position = UDim2.new(0.1, 0, 0.1, 0)
    activate.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    activate.Text = "Ativar Auto Farm"
    activate.TextColor3 = Color3.new(1, 1, 1)
    activate.Parent = frame

    local codes = Instance.new("TextButton")
    codes.Size = UDim2.new(0.8, 0, 0.15, 0)
    codes.Position = UDim2.new(0.1, 0, 0.3, 0)
    codes.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    codes.Text = "Resgatar Códigos"
    codes.TextColor3 = Color3.new(1, 1, 1)
    codes.Parent = frame

    local espButton = Instance.new("TextButton")
    espButton.Size = UDim2.new(0.8, 0, 0.15, 0)
    espButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    espButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    espButton.Text = "Ativar ESP"
    espButton.TextColor3 = Color3.new(1, 1, 1)
    espButton.Parent = frame

    local fechar = Instance.new("TextButton")
    fechar.Size = UDim2.new(0.8, 0, 0.15, 0)
    fechar.Position = UDim2.new(0.1, 0, 0.7, 0)
    fechar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    fechar.Text = "Fechar Painel"
    fechar.TextColor3 = Color3.new(1, 1, 1)
    fechar.Parent = frame

    -- Abrir/Fechar painel
    icon.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)

    -- Variáveis de controle
    local autoFarmAtivo = false
    local espAtivo = false

    -- ESP Function
    local function createESP(player)
        if player.Character and not player.Character:FindFirstChild("Kr7ESP") then
            local billboard = Instance.new("BillboardGui", player.Character)
            billboard.Name = "Kr7ESP"
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.AlwaysOnTop = true

            local text = Instance.new("TextLabel", billboard)
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = player.Name
            text.TextColor3 = player.Team and (player.Team.Name == "Pirates" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 255)) or Color3.fromRGB(255, 255, 255)
            text.TextStrokeTransparency = 0
        end
    end

    local function removeESP(player)
        if player.Character and player.Character:FindFirstChild("Kr7ESP") then
            player.Character:FindFirstChild("Kr7ESP"):Destroy()
        end
    end

    -- ESP Toggle
    espButton.MouseButton1Click:Connect(function()
        espAtivo = not espAtivo
        if espAtivo then
            espButton.Text = "Desativar ESP"
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    createESP(player)
                end
            end
            game.Players.PlayerAdded:Connect(function(p)
                if p ~= game.Players.LocalPlayer then
                    p.CharacterAdded:Connect(function()
                        wait(1)
                        if espAtivo then createESP(p) end
                    end)
                end
            end)
        else
            espButton.Text = "Ativar ESP"
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    removeESP(player)
                end
            end
        end
    end)

    -- Auto Farm Toggle
    activate.MouseButton1Click:Connect(function()
        autoFarmAtivo = not autoFarmAtivo
        if autoFarmAtivo then
            activate.Text = "Auto Farm Ativado"
            spawn(function()
                while autoFarmAtivo do
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        local level = player.Data.Level.Value
                        local quest = getQuestForLevel(level)
                        if quest then
                            teleportToIsland(quest.Position)
                            startQuest(quest)
                            farmNPC(quest)
                        end
                    end)
                    wait(1)
                end
            end)
        else
            activate.Text = "Ativar Auto Farm"
        end
    end)

    -- Resgatar Códigos
    codes.MouseButton1Click:Connect(function()
        local codigos = {
            "Sub2NoobMaster123", "Axiore", "StrawHatMaine", "Bignews", "Sub2Daigrock",
            "Fudd10", "Fudd10_V2", "TheGreatAce", "TantaiGaming"
        }
        for _, code in pairs(codigos) do
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
            end)
            wait(0.2)
        end
    end)

    -- Fechar painel
    fechar.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)

    -- Missões e Ilhas (Adicione todas depois)
    local quests = {
        {LevelMin = 1, LevelMax = 9, QuestName = "BanditQuest1", NPC = "Bandit", Position = CFrame.new(1060, 16, 1547)},
        {LevelMin = 10, LevelMax = 14, QuestName = "MonkeyQuest", NPC = "Monkey", Position = CFrame.new(-1599, 37, 156)},
        -- Complete a lista de missões!
    }

    function getQuestForLevel(level)
        for _, quest in ipairs(quests) do
            if level >= quest.LevelMin and level <= quest.LevelMax then
                return quest
            end
        end
        return nil
    end

    function startQuest(quest)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", quest.QuestName, 1)
    end

    function teleportToIsland(pos)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = pos
        end
    end

    function farmNPC(quest)
        local player = game.Players.LocalPlayer
        local character = player.Character
        local tool = character:FindFirstChildOfClass("Tool")
        if not tool then
            tool = player.Backpack:FindFirstChildOfClass("Tool")
            if tool then
                player.Character.Humanoid:EquipTool(tool)
            end
        end
        for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
            if npc.Name == quest.NPC and npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
                repeat
                    pcall(function()
                        character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0) -- em cima da cabeça
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    end)
                    wait(0.1)
                until not npc or npc.Humanoid.Health <= 0 or not autoFarmAtivo
            end
        end
    end
end)
