--[[ Krullov Hub — Universal ]]
local function getService(s) return game:GetService(s) end
local Players = getService("Players")
local Player = Players.LocalPlayer
local RunService = getService("RunService")
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Workspace = getService("Workspace")
local CoreGui = getService("CoreGui")

local flying = false
local flySpeed = 50
local walkSpeed = 50
local keys = {w = false, a = false, s = false, d = false, space = false, lctrl = false}
local char, root, humanoid
local menuVisible = true
local fireActive = false
local fireParts = {}
local flyConnection, fireConnection

local tiffany = Color3.fromRGB(129, 216, 208)
local tiffanyDark = Color3.fromRGB(90, 180, 170)
local bgColor = Color3.fromRGB(0, 0, 0)
local btnColor = Color3.fromRGB(25, 25, 25)
local purpleNight = Color3.fromRGB(60, 20, 100)
local purpleNightDark = Color3.fromRGB(40, 10, 70)

-- КИЛЛ
local function killAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            pcall(function()
                local c = plr.Character
                if not c then return end
                local hrp = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChild("Humanoid")
                if h then h.Health = 0; h:TakeDamage(9e9) end
                if hrp then
                    for _ = 1, 5 do
                        Instance.new("Explosion", Workspace).Position = hrp.Position + Vector3.new(math.random(-5,5), math.random(-5,5), math.random(-5,5))
                    end
                    hrp:BreakJoints()
                    hrp.CFrame = CFrame.new(99999, -99999, 99999)
                end
                for _, v in pairs(c:GetDescendants()) do
                    if v:IsA("BasePart") then v:Destroy() end
                end
                for _, v in pairs(c:GetChildren()) do
                    if v:IsA("BasePart") then v:Destroy() end
                end
            end)
        end
    end
end

-- ДИЛДО x1.5
local function giveDildo()
    local tool = Instance.new("Tool")
    tool.Name = "DILDO"
    tool.RequiresHandle = true
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.75, 4.5, 0.75)
    handle.BrickColor = BrickColor.new("Hot pink")
    handle.Material = Enum.Material.SmoothPlastic
    handle.Parent = tool
    local tip = Instance.new("Part")
    tip.Name = "Tip"
    tip.Size = Vector3.new(1.2, 1.2, 1.2)
    tip.BrickColor = BrickColor.new("Hot pink")
    tip.Material = Enum.Material.SmoothPlastic
    tip.Parent = tool
    local w1 = Instance.new("Weld"); w1.Part0 = handle; w1.Part1 = tip; w1.C0 = CFrame.new(0, 2.55, 0); w1.Parent = tool
    for i = -1, 1, 2 do
        local ball = Instance.new("Part")
        ball.Name = "Ball"; ball.Size = Vector3.new(0.9, 0.9, 0.9); ball.Shape = Enum.PartType.Ball
        ball.BrickColor = BrickColor.new("Hot pink"); ball.Material = Enum.Material.SmoothPlastic
        ball.Parent = tool
        local w = Instance.new("Weld"); w.Part0 = handle; w.Part1 = ball
        w.C0 = CFrame.new(i * 0.6, -2.7, 0); w.Parent = tool
    end
    tool.Parent = Player.Backpack
end

-- ФАЕР ШОУ
local function toggleBigFire()
    fireActive = not fireActive
    if fireActive then
        fireConnection = RunService.Heartbeat:Connect(function()
            if not fireActive then return end
            local pos = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.HumanoidRootPart.Position
            if not pos then return end
            for _ = 1, 5 do
                local fp = Instance.new("Part"); fp.Size = Vector3.new(12, 12, 12)
                fp.Position = pos + Vector3.new(math.random(-20,20), math.random(-6,6), math.random(-20,20))
                fp.Anchored = true; fp.CanCollide = false; fp.Transparency = 1; fp.Parent = Workspace
                local fire = Instance.new("Fire", fp); fire.Heat = 999; fire.Size = 999
                fire.Color = Color3.fromRGB(255, 50, 0); fire.SecondaryColor = Color3.fromRGB(255, 200, 0)
                table.insert(fireParts, fp)
            end
            while #fireParts > 80 do fireParts[1]:Destroy(); table.remove(fireParts, 1) end
        end)
    else
        if fireConnection then fireConnection:Disconnect() end
        for _, fp in pairs(fireParts) do fp:Destroy() end
        fireParts = {}
    end
end

-- НУБ ВЕЧЕРИНКА
local function noobParty()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            pcall(function()
                local c = plr.Character
                if not c then return end
                for _, v in pairs(c:GetChildren()) do
                    if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then v:Destroy() end
                end
                for _, part in pairs(c:GetChildren()) do
                    if part:IsA("Part") and part.Name == "Head" then part.BrickColor = BrickColor.new("Bright yellow") end
                    if part:IsA("Part") and part.Name == "Torso" then part.BrickColor = BrickColor.new("Bright blue") end
                    if part:IsA("Part") and part.Name:find("Left Arm") then part.BrickColor = BrickColor.new("Bright yellow") end
                    if part:IsA("Part") and part.Name:find("Right Arm") then part.BrickColor = BrickColor.new("Bright yellow") end
                    if part:IsA("Part") and part.Name == "Left Leg" then part.BrickColor = BrickColor.new("Bright blue") end
                    if part:IsA("Part") and part.Name == "Right Leg" then part.BrickColor = BrickColor.new("Bright blue") end
                end
                local pants = Instance.new("Pants"); pants.PantsTemplate = "http://www.roblox.com/asset/?id=0"
                pants.Color3 = Color3.fromRGB(0, 50, 200); pants.Parent = c
                local shirt = Instance.new("Shirt"); shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=0"
                shirt.Color3 = Color3.fromRGB(0, 150, 50); shirt.Parent = c
            end)
        end
    end
end

-- СБРОС
local function resetAll()
    fireActive = false
    if fireConnection then fireConnection:Disconnect() end
    for _, fp in pairs(fireParts) do fp:Destroy() end
    fireParts = {}
    if flying then stopFly() end
    flySpeed = 50
    walkSpeed = 16
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = 16
    end
end

-- УНИЧТОЖИТЬ СЕРВЕР
local function destroyServer()
    for _ = 1, 500 do
        local pos = Workspace:FindFirstChild("Baseplate") and Workspace.Baseplate.Position or Vector3.zero
        Instance.new("Explosion", Workspace).Position = pos + Vector3.new(math.random(-150,150), math.random(0,80), math.random(-150,150))
    end
    for _ = 1, 300 do
        local fp = Instance.new("Part")
        fp.Size = Vector3.new(25, 25, 25)
        fp.Position = Vector3.new(math.random(-300,300), math.random(0,50), math.random(-300,300))
        fp.Anchored = true; fp.CanCollide = false; fp.Transparency = 1; fp.Parent = Workspace
        local fire = Instance.new("Fire", fp); fire.Heat = 999; fire.Size = 999
        fire.Color = Color3.fromRGB(255, 0, 0); fire.SecondaryColor = Color3.fromRGB(255, 150, 0)
    end
    killAll()
    for _ = 1, 7500 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(1,1,1); p.Position = Vector3.new(math.random(-100,100), math.random(0,40), math.random(-100,100))
        p.Anchored = true; p.CanCollide = false; p.Transparency = 0.4; p.BrickColor = BrickColor.random()
        p.Parent = Workspace
    end
end

-- ФЛАЙ
local function startFly()
    char = Player.Character
    if not char then return end
    root = char:FindFirstChild("HumanoidRootPart")
    humanoid = char:FindFirstChild("Humanoid")
    if not root or not humanoid then return end
    humanoid.PlatformStand = true
    local bg = Instance.new("BodyGyro"); bg.MaxTorque = Vector3.new(1,1,1)*9e9; bg.P = 9e9; bg.Parent = root
    local bv = Instance.new("BodyVelocity"); bv.MaxForce = Vector3.new(1,1,1)*9e9; bv.P = 9e9; bv.Parent = root
    flying = true
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying or not root then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local dir = Vector3.zero
        if keys.w then dir = dir + cam.CFrame.LookVector end
        if keys.s then dir = dir - cam.CFrame.LookVector end
        if keys.a then dir = dir - cam.CFrame.RightVector end
        if keys.d then dir = dir + cam.CFrame.RightVector end
        if keys.space then dir = dir + Vector3.new(0,1,0) end
        if keys.lctrl then dir = dir - Vector3.new(0,1,0) end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    if flyConnection then flyConnection:Disconnect() end
    if root then for _, v in pairs{root:FindFirstChild("BodyVelocity"), root:FindFirstChild("BodyGyro")} do if v then v:Destroy() end end end
    if humanoid then humanoid.PlatformStand = false end
end

local function setWalkSpeed(s)
    walkSpeed = s
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = s
    end
end

Player.CharacterAdded:Connect(function(c)
    char = c; root = c:WaitForChild("HumanoidRootPart"); humanoid = c:WaitForChild("Humanoid")
    humanoid.WalkSpeed = walkSpeed
    if flying then task.wait(0.3); startFly() end
end)
Player.CharacterRemoving:Connect(function() if flying then stopFly() end end)

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "Krullov"
gui.Parent = CoreGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "K"
toggleBtn.Size = UDim2.new(0,40,0,40)
toggleBtn.Position = UDim2.new(0,10,0,10)
toggleBtn.BackgroundColor3 = tiffany
toggleBtn.BorderSizePixel = 0
toggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 18
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = gui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,10)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,240,0,460)
frame.Position = UDim2.new(0,55,0,10)
frame.BackgroundColor3 = bgColor
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local border = Instance.new("Frame")
border.Size = UDim2.new(1,4,1,4)
border.Position = UDim2.new(0,-2,0,-2)
border.BackgroundColor3 = tiffany
border.BackgroundTransparency = 0.5
border.BorderSizePixel = 0
border.Parent = frame
Instance.new("UICorner", border).CornerRadius = UDim.new(0,13)

local title = Instance.new("TextLabel")
title.Text = "KRULLOV HUB"
title.Size = UDim2.new(1,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(5,5,5)
title.TextColor3 = tiffany
title.Font = Enum.Font.GothamBlack
title.TextSize = 15
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0,12)

local yOff = 42

local function makeButton(text, y)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Size = UDim2.new(1,-20,0,34)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = btnColor
    b.BorderSizePixel = 0
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.AutoButtonColor = false
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = tiffanyDark, Size = UDim2.new(1,-24,0,32), Position = UDim2.new(0,12,0,y+1)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = btnColor, Size = UDim2.new(1,-20,0,34), Position = UDim2.new(0,10,0,y)}):Play()
    end)
    return b
end

local flyBtn = makeButton("ФЛАЙ", yOff); yOff = yOff + 40
local killBtn = makeButton("УБИТЬ ВСЕХ", yOff); yOff = yOff + 40
local dildoBtn = makeButton("ДИЛДО", yOff); yOff = yOff + 40
local fireBtn = makeButton("ФАЕР ШОУ", yOff); yOff = yOff + 40
local noobBtn = makeButton("НУБ ВЕЧЕРИНКА", yOff); yOff = yOff + 40
local resetBtn = makeButton("СБРОС", yOff); yOff = yOff + 40
local nukeBtn = makeButton("-СЕРВЕР", yOff); yOff = yOff + 48

local flyLabel = Instance.new("TextLabel")
flyLabel.Text = "Скорость полёта: 50"
flyLabel.Size = UDim2.new(1,-20,0,14)
flyLabel.Position = UDim2.new(0,10,0,yOff)
flyLabel.BackgroundTransparency = 1
flyLabel.TextColor3 = Color3.fromRGB(200,200,200)
flyLabel.Font = Enum.Font.Gotham
flyLabel.TextSize = 9
flyLabel.Parent = frame
yOff = yOff + 16

local flySliderBg = Instance.new("Frame")
flySliderBg.Size = UDim2.new(1,-20,0,8)
flySliderBg.Position = UDim2.new(0,10,0,yOff)
flySliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
flySliderBg.BorderSizePixel = 0
flySliderBg.Parent = frame
Instance.new("UICorner", flySliderBg).CornerRadius = UDim.new(0,4)

local flySliderFill = Instance.new("Frame")
flySliderFill.Size = UDim2.new(0.153,0,1,0)
flySliderFill.BackgroundColor3 = tiffany
flySliderFill.BorderSizePixel = 0
flySliderFill.Parent = flySliderBg
Instance.new("UICorner", flySliderFill).CornerRadius = UDim.new(0,4)

local flySliderBtn = Instance.new("TextButton")
flySliderBtn.Size = UDim2.new(0,18,0,18)
flySliderBtn.Position = UDim2.new(0.153,-9,0,-5)
flySliderBtn.BackgroundColor3 = tiffany
flySliderBtn.BorderSizePixel = 0
flySliderBtn.Text = ""
flySliderBtn.Parent = flySliderBg
Instance.new("UICorner", flySliderBtn).CornerRadius = UDim.new(0,9)

yOff = yOff + 14

local walkLabel = Instance.new("TextLabel")
walkLabel.Text = "Скорость ходьбы: 50"
walkLabel.Size = UDim2.new(1,-20,0,14)
walkLabel.Position = UDim2.new(0,10,0,yOff)
walkLabel.BackgroundTransparency = 1
walkLabel.TextColor3 = Color3.fromRGB(200,200,200)
walkLabel.Font = Enum.Font.Gotham
walkLabel.TextSize = 9
walkLabel.Parent = frame
yOff = yOff + 16

local walkSliderBg = Instance.new("Frame")
walkSliderBg.Size = UDim2.new(1,-20,0,8)
walkSliderBg.Position = UDim2.new(0,10,0,yOff)
walkSliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
walkSliderBg.BorderSizePixel = 0
walkSliderBg.Parent = frame
Instance.new("UICorner", walkSliderBg).CornerRadius = UDim.new(0,4)

local walkSliderFill = Instance.new("Frame")
walkSliderFill.Size = UDim2.new(0.153,0,1,0)
walkSliderFill.BackgroundColor3 = tiffany
walkSliderFill.BorderSizePixel = 0
walkSliderFill.Parent = walkSliderBg
Instance.new("UICorner", walkSliderFill).CornerRadius = UDim.new(0,4)

local walkSliderBtn = Instance.new("TextButton")
walkSliderBtn.Size = UDim2.new(0,18,0,18)
walkSliderBtn.Position = UDim2.new(0.153,-9,0,-5)
walkSliderBtn.BackgroundColor3 = tiffany
walkSliderBtn.BorderSizePixel = 0
walkSliderBtn.Text = ""
walkSliderBtn.Parent = walkSliderBg
Instance.new("UICorner", walkSliderBtn).CornerRadius = UDim.new(0,9)

yOff = yOff + 20

local linkFrame = Instance.new("Frame")
linkFrame.Size = UDim2.new(1,-20,0,32)
linkFrame.Position = UDim2.new(0,10,0,yOff)
linkFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
linkFrame.BorderSizePixel = 0
linkFrame.Parent = frame
Instance.new("UICorner", linkFrame).CornerRadius = UDim.new(0,6)

local linkBorder = Instance.new("Frame")
linkBorder.Size = UDim2.new(1,2,1,2)
linkBorder.Position = UDim2.new(0,-1,0,-1)
linkBorder.BackgroundColor3 = Color3.fromRGB(255,255,255)
linkBorder.BackgroundTransparency = 0.7
linkBorder.BorderSizePixel = 0
linkBorder.Parent = linkFrame
Instance.new("UICorner", linkBorder).CornerRadius = UDim.new(0,6)

local linkText = Instance.new("TextLabel")
linkText.Text = "t.me/krullov_scripts"
linkText.Size = UDim2.new(1,0,1,0)
linkText.BackgroundTransparency = 1
linkText.TextColor3 = Color3.fromRGB(255,255,255)
linkText.Font = Enum.Font.GothamBold
linkText.TextSize = 10
linkText.Parent = linkFrame

-- Подтверждение уничтожения сервера
local confirmOverlay = Instance.new("Frame")
confirmOverlay.Size = UDim2.new(1,0,1,0)
confirmOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
confirmOverlay.BackgroundTransparency = 0.6
confirmOverlay.BorderSizePixel = 0
confirmOverlay.Visible = false
confirmOverlay.Parent = gui

local confirmFrame = Instance.new("Frame")
confirmFrame.Size = UDim2.new(0,280,0,140)
confirmFrame.Position = UDim2.new(0.5,-140,0.5,-70)
confirmFrame.BackgroundColor3 = Color3.fromRGB(8,5,15)
confirmFrame.BorderSizePixel = 0
confirmFrame.Parent = confirmOverlay
Instance.new("UICorner", confirmFrame).CornerRadius = UDim.new(0,12)

local confirmBorder = Instance.new("Frame")
confirmBorder.Size = UDim2.new(1,4,1,4)
confirmBorder.Position = UDim2.new(0,-2,0,-2)
confirmBorder.BackgroundColor3 = purpleNight
confirmBorder.BorderSizePixel = 0
confirmBorder.Parent = confirmFrame
Instance.new("UICorner", confirmBorder).CornerRadius = UDim.new(0,13)

local confirmText = Instance.new("TextLabel")
confirmText.Text = "УНИЧТОЖИТЬ СЕРВЕР?!"
confirmText.Size = UDim2.new(1,0,0,35)
confirmText.Position = UDim2.new(0,0,0,22)
confirmText.BackgroundTransparency = 1
confirmText.TextColor3 = Color3.fromRGB(200,180,220)
confirmText.Font = Enum.Font.GothamBlack
confirmText.TextSize = 17
confirmText.Parent = confirmFrame

local yesFrame = Instance.new("Frame")
yesFrame.Size = UDim2.new(0,90,0,38)
yesFrame.Position = UDim2.new(0,30,0,75)
yesFrame.BackgroundColor3 = Color3.fromRGB(5,2,10)
yesFrame.BorderSizePixel = 0
yesFrame.Parent = confirmFrame
Instance.new("UICorner", yesFrame).CornerRadius = UDim.new(0,8)

local yesBorder = Instance.new("Frame")
yesBorder.Size = UDim2.new(1,4,1,4)
yesBorder.Position = UDim2.new(0,-2,0,-2)
yesBorder.BackgroundColor3 = purpleNight
yesBorder.BorderSizePixel = 0
yesBorder.Parent = yesFrame
Instance.new("UICorner", yesBorder).CornerRadius = UDim.new(0,9)

local yesBtn = Instance.new("TextButton")
yesBtn.Text = "ДА"
yesBtn.Size = UDim2.new(1,0,1,0)
yesBtn.BackgroundColor3 = Color3.fromRGB(12,6,20)
yesBtn.BorderSizePixel = 0
yesBtn.TextColor3 = Color3.fromRGB(200,170,230)
yesBtn.Font = Enum.Font.GothamBlack
yesBtn.TextSize = 17
yesBtn.AutoButtonColor = false
yesBtn.Parent = yesFrame
Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0,7)

local noBtn = Instance.new("TextButton")
noBtn.Text = "НЕТ"
noBtn.Size = UDim2.new(0,90,0,38)
noBtn.Position = UDim2.new(0,160,0,75)
noBtn.BackgroundColor3 = Color3.fromRGB(15,12,18)
noBtn.BorderSizePixel = 0
noBtn.TextColor3 = Color3.fromRGB(120,110,130)
noBtn.Font = Enum.Font.GothamBlack
noBtn.TextSize = 17
noBtn.AutoButtonColor = false
noBtn.Parent = confirmFrame
Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0,8)

yesBtn.MouseEnter:Connect(function()
    TweenService:Create(yesBtn, TweenInfo.new(0.15), {BackgroundColor3 = purpleNightDark}):Play()
end)
yesBtn.MouseLeave:Connect(function()
    TweenService:Create(yesBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(12,6,20)}):Play()
end)
noBtn.MouseEnter:Connect(function()
    TweenService:Create(noBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25,20,30)}):Play()
end)
noBtn.MouseLeave:Connect(function()
    TweenService:Create(noBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(15,12,18)}):Play()
end)

yesBtn.MouseButton1Click:Connect(function()
    confirmOverlay.Visible = false
    destroyServer()
end)
noBtn.MouseButton1Click:Connect(function()
    confirmOverlay.Visible = false
end)

local draggingFly = false
local draggingWalk = false

flySliderBtn.MouseButton1Down:Connect(function() draggingFly = true end)
walkSliderBtn.MouseButton1Down:Connect(function() draggingWalk = true end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFly = false; draggingWalk = false
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement then
        if draggingFly then
            local relX = math.clamp((i.Position.X - flySliderBg.AbsolutePosition.X) / flySliderBg.AbsoluteSize.X, 0, 1)
            flySpeed = math.floor(10 + relX * 290)
            flyLabel.Text = "Скорость полёта: " .. flySpeed
            flySliderFill.Size = UDim2.new(relX,0,1,0)
            flySliderBtn.Position = UDim2.new(relX,-9,0,-5)
        end
        if draggingWalk then
            local relX = math.clamp((i.Position.X - walkSliderBg.AbsolutePosition.X) / walkSliderBg.AbsoluteSize.X, 0, 1)
            walkSpeed = math.floor(10 + relX * 290)
            walkLabel.Text = "Скорость ходьбы: " .. walkSpeed
            walkSliderFill.Size = UDim2.new(relX,0,1,0)
            walkSliderBtn.Position = UDim2.new(relX,-9,0,-5)
            setWalkSpeed(walkSpeed)
        end
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible; border.Visible = menuVisible
end)

flyBtn.MouseButton1Click:Connect(function()
    if flying then stopFly(); TweenService:Create(flyBtn, TweenInfo.new(0.2), {BackgroundColor3 = btnColor}):Play()
    else startFly(); TweenService:Create(flyBtn, TweenInfo.new(0.2), {BackgroundColor3 = tiffany}):Play() end
end)
killBtn.MouseButton1Click:Connect(killAll)
dildoBtn.MouseButton1Click:Connect(giveDildo)
fireBtn.MouseButton1Click:Connect(function()
    toggleBigFire()
    TweenService:Create(fireBtn, TweenInfo.new(0.2), {BackgroundColor3 = fireActive and tiffany or btnColor}):Play()
end)
noobBtn.MouseButton1Click:Connect(noobParty)
resetBtn.MouseButton1Click:Connect(function()
    resetAll()
    flyLabel.Text = "Скорость полёта: 50"
    flySliderFill.Size = UDim2.new(0.153,0,1,0)
    flySliderBtn.Position = UDim2.new(0.153,-9,0,-5)
    walkLabel.Text = "Скорость ходьбы: 16"
    walkSliderFill.Size = UDim2.new(0.024,0,1,0)
    walkSliderBtn.Position = UDim2.new(0.024,-9,0,-5)
    TweenService:Create(flyBtn, TweenInfo.new(0.2), {BackgroundColor3 = btnColor}):Play()
    TweenService:Create(fireBtn, TweenInfo.new(0.2), {BackgroundColor3 = btnColor}):Play()
end)
nukeBtn.MouseButton1Click:Connect(function()
    confirmOverlay.Visible = true
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then keys.w = true end
    if input.KeyCode == Enum.KeyCode.A then keys.a = true end
    if input.KeyCode == Enum.KeyCode.S then keys.s = true end
    if input.KeyCode == Enum.KeyCode.D then keys.d = true end
    if input.KeyCode == Enum.KeyCode.Space then keys.space = true end
    if input.KeyCode == Enum.KeyCode.LeftControl then keys.lctrl = true end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then stopFly() else startFly() end
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then keys.w = false end
    if input.KeyCode == Enum.KeyCode.A then keys.a = false end
    if input.KeyCode == Enum.KeyCode.S then keys.s = false end
    if input.KeyCode == Enum.KeyCode.D then keys.d = false end
    if input.KeyCode == Enum.KeyCode.Space then keys.space = false end
    if input.KeyCode == Enum.KeyCode.LeftControl then keys.lctrl = false end
end)
