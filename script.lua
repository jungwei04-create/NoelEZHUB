--=====================================================
-- NOEL EZ | SPEEDHUB X | VENOM
-- Menú con efecto agua + todas las funciones
--=====================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local VENOM_ID = "rbxassetid://18326941175"

local C = {
    Speed=false, WS=90, Fly=false, FS=60, Noclip=false,
    ESP=false, ER=1000, Tracers=false, AF=false, AA=false,
    FB=false, RF=false,
}

local Ch, H, Rt
local FC, FV, FG, FU = nil,nil,nil,0
local NC, EC, TC, AFC = nil,nil,nil,nil
local EO, TO = {}, {}
local FogOrig = nil

local function RC()
    Ch = Player.Character
    if Ch then
        H = Ch:FindFirstChildOfClass("Humanoid")
        Rt = Ch:FindFirstChild("HumanoidRootPart")
    end
end

local function IA()
    return Ch and Ch.Parent and H and H.Health>0 and Rt
end

RC()
Player.CharacterAdded:Connect(function() task.wait(1) RC() end)

-- FLY
local function StopFly()
    if FC then FC:Disconnect() FC=nil end
    if FV then pcall(function() FV:Destroy() end) FV=nil end
    if FG then pcall(function() FG:Destroy() end) FG=nil end
    if H then pcall(function() H.PlatformStand=false end) end
    FU = 0
end

local function StartFly()
    RC()
    if not IA() then task.wait(1) RC() end
    if not IA() then return end
    StopFly()
    FV = Instance.new("BodyVelocity")
    FV.Name = "NoelEZ_FlyVelocity"
    FV.MaxForce = Vector3.new(1e5,1e5,1e5)
    FV.Velocity = Vector3.zero
    FV.Parent = Rt
    FG = Instance.new("BodyGyro")
    FG.MaxTorque = Vector3.new(1e5,1e5,1e5)
    FG.P = 1e4
    FG.CFrame = Rt.CFrame
    FG.Parent = Rt
    H.PlatformStand = true
    FC = RS.RenderStepped:Connect(function()
        if not IA() then StopFly() return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local mv = Vector3.zero
        pcall(function()
            if UIS:IsKeyDown(Enum.KeyCode.W) then mv = mv + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then mv = mv - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then mv = mv + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then mv = mv - cam.CFrame.RightVector end
        end)
        if H.MoveDirection.Magnitude > 0.05 then mv = H.MoveDirection end
        local ud = 0
        pcall(function()
            if UIS:IsKeyDown(Enum.KeyCode.Space) then ud = ud + 1 end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then ud = ud - 1 end
        end)
        ud = ud + FU
        local vl = Vector3.zero
        if mv.Magnitude > 0.05 then vl = mv.Unit * C.FS end
        if ud ~= 0 then vl = vl + Vector3.new(0, ud * C.FS, 0) end
        if FV then FV.Velocity = vl end
        if FG then FG.CFrame = cam.CFrame end
    end)
end

local function ToggleFly(s)
    C.Fly = s
    if s then StartFly() else StopFly() end
    if _G.FlyUpBtn then _G.FlyUpBtn.Visible = s end
    if _G.FlyDownBtn then _G.FlyDownBtn.Visible = s end
end

-- SPEED
local function ToggleSpeed(s)
    C.Speed = s
    RC()
    if H then H.WalkSpeed = s and C.WS or 16 end
end

-- NOCLIP
local function StopNoclip()
    if NC then NC:Disconnect() NC=nil end
end

local function StartNoclip()
    StopNoclip()
    NC = RS.Stepped:Connect(function()
        if not C.Noclip or not IA() then return end
        for _, p in ipairs(Ch:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end)
end

local function ToggleNoclip(s)
    C.Noclip = s
    if s then StartNoclip()
    else
        StopNoclip()
        if Ch then
            for _, p in ipairs(Ch:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end

-- ESP
local function CreateESP(plr)
    if plr == Player or not plr.Character then return end
    local tR = plr.Character:FindFirstChild("HumanoidRootPart")
    if not tR then return end
    local hl = Instance.new("Highlight")
    hl.Adornee = plr.Character
    hl.FillColor = Color3.fromRGB(100, 240, 100)
    hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = plr.Character
    local bb = Instance.new("BillboardGui")
    bb.Adornee = tR
    bb.Size = UDim2.new(0,250,0,60)
    bb.StudsOffset = Vector3.new(0,3,0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = C.ER
    bb.Parent = tR
    local nm = Instance.new("TextLabel")
    nm.Size = UDim2.new(1,0,0.5,0)
    nm.BackgroundTransparency = 1
    nm.Text = plr.Name
    nm.TextColor3 = Color3.fromRGB(255,255,255)
    nm.TextStrokeTransparency = 0
    nm.Font = Enum.Font.GothamBold
    nm.TextSize = 14
    nm.Parent = bb
    local ds = Instance.new("TextLabel")
    ds.Size = UDim2.new(1,0,0.5,0)
    ds.Position = UDim2.new(0,0,0.5,0)
    ds.BackgroundTransparency = 1
    ds.Text = "0m"
    ds.TextColor3 = Color3.fromRGB(100,240,100)
    ds.TextStrokeTransparency = 0
    ds.Font = Enum.Font.GothamBold
    ds.TextSize = 12
    ds.Parent = bb
    EO[plr] = {HL=hl, BB=bb, Dist=ds}
end

local function RemoveESP(plr)
    if EO[plr] then
        pcall(function()
            if EO[plr].HL then EO[plr].HL:Destroy() end
            if EO[plr].BB then EO[plr].BB:Destroy() end
        end)
        EO[plr] = nil
    end
end

local function StopESP()
    for plr, _ in pairs(EO) do RemoveESP(plr) end
    EO = {}
    if EC then EC:Disconnect() EC=nil end
end

local function StartESP()
    StopESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then CreateESP(plr) end
    end
    EC = Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function() task.wait(0.5) if C.ESP then CreateESP(plr) end end)
    end)
end

local function ToggleESP(s)
    C.ESP = s
    if s then StartESP() else StopESP() end
end

RS.RenderStepped:Connect(function()
    if not C.ESP or not IA() then return end
    for plr, e in pairs(EO) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (Rt.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if e.Dist then e.Dist.Text = string.format("%.0fm", d) end
            if e.BB then e.BB.Enabled = d <= C.ER end
            if e.HL then e.HL.Enabled = d <= C.ER end
        end
    end
end)

-- TRACERS
local function CreateTracer(plr)
    if plr == Player or not plr.Character then return end
    if TO[plr] then RemoveTracer(plr) end
    local a1 = Instance.new("Attachment")
    a1.Parent = Rt
    local tR = plr.Character:FindFirstChild("HumanoidRootPart")
    if not tR then a1:Destroy() return end
    local a2 = Instance.new("Attachment")
    a2.Parent = tR
    local b = Instance.new("Beam")
    b.Attachment0 = a1
    b.Attachment1 = a2
    b.Width0 = 0.15
    b.Width1 = 0.15
    b.Color = ColorSequence.new(Color3.fromRGB(100,240,100))
    b.FaceCamera = true
    b.Parent = a1
    TO[plr] = {B=b, A1=a1, A2=a2}
end

local function RemoveTracer(plr)
    if TO[plr] then
        pcall(function()
            local d = TO[plr]
            if d.B then d.B:Destroy() end
            if d.A1 then d.A1:Destroy() end
            if d.A2 then d.A2:Destroy() end
        end)
        TO[plr] = nil
    end
end

local function StopTracers()
    for plr, _ in pairs(TO) do RemoveTracer(plr) end
    TO = {}
    if TC then TC:Disconnect() TC=nil end
end

local function StartTracers()
    StopTracers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then CreateTracer(plr) end
    end
    TC = RS.Heartbeat:Connect(function()
        if not C.Tracers or not IA() then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not TO[plr] then CreateTracer(plr) end
            end
        end
    end)
end

local function ToggleTracers(s)
    C.Tracers = s
    if s then StartTracers() else StopTracers() end
end

-- ANTI-FLING
RS.Heartbeat:Connect(function()
    if not C.AF or not IA() then return end
    for _, obj in ipairs(Rt:GetChildren()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyThrust") or obj:IsA("BodyForce") then
            if obj.Name ~= "NoelEZ_FlyVelocity" then obj:Destroy() end
        end
    end
end)

-- ANTI-AFK
Player.Idled:Connect(function()
    if not C.AA then return end
    pcall(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end)

-- FPS BOOST
local function ToggleFPSBoost(s)
    C.FB = s
    if s then
        pcall(function()
            _G.FPSQ = settings().Rendering.QualityLevel
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
            _G.FPSSh = Lighting.GlobalShadows
            Lighting.GlobalShadows = false
        end)
    else
        pcall(function()
            if _G.FPSQ then settings().Rendering.QualityLevel = _G.FPSQ end
        end)
        pcall(function()
            if _G.FPSSh ~= nil then Lighting.GlobalShadows = _G.FPSSh end
        end)
    end
end

-- REMOVE FOG
local function ToggleFog(s)
    C.RF = s
    if s then
        pcall(function()
            FogOrig = {C=Lighting.FogColor, E=Lighting.FogEnd, S=Lighting.FogStart}
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
        end)
    else
        pcall(function()
            if FogOrig then
                Lighting.FogColor = FogOrig.C
                Lighting.FogEnd = FogOrig.E
                Lighting.FogStart = FogOrig.S
            end
        end)
    end
end

-- UI
local Old = PlayerGui:FindFirstChild("NoelEZ")
if Old then Old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "NoelEZ"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

-- CUADRADO VENOM
local Ball = Instance.new("ImageButton")
Ball.Size = UDim2.fromOffset(60, 60)
Ball.Position = UDim2.new(0, 20, 0.5, -30)
Ball.BackgroundColor3 = Color3.fromRGB(10, 30, 10)
Ball.BackgroundTransparency = 0.2
Ball.BorderSizePixel = 0
Ball.Image = VENOM_ID
Ball.ScaleType = Enum.ScaleType.Crop
Ball.AutoButtonColor = false
Ball.Active = true
Ball.Parent = Gui
Instance.new("UICorner", Ball).CornerRadius = UDim.new(0, 12)

local BallStroke = Instance.new("UIStroke")
BallStroke.Color = Color3.fromRGB(80, 255, 80)
BallStroke.Thickness = 2
BallStroke.Parent = Ball

local BGrad = Instance.new("UIGradient")
BGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 80, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 80, 20)),
})
BGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.6),
    NumberSequenceKeypoint.new(0.5, 0.3),
    NumberSequenceKeypoint.new(1, 0.6),
})
BGrad.Parent = Ball

task.spawn(function()
    while Ball and Ball.Parent do
        for i = 0, 360, 5 do
            if not Ball or not Ball.Parent then break end
            pcall(function()
                BGrad.Rotation = i
                BGrad.Offset = Vector2.new(math.sin(math.rad(i)) * 0.7, math.cos(math.rad(i * 0.9)) * 0.7)
            end)
            task.wait(0.02)
        end
    end
end)

-- MENÚ
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(500, 320)
Main.Position = UDim2.new(0.5, -250, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 30, 10)
Main.BackgroundTransparency = 0.25
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local MainGrad = Instance.new("UIGradient")
MainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 30, 10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 240, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 30, 10)),
})
MainGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.5),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(1, 0.5),
})
MainGrad.Parent = Main

task.spawn(function()
    while Main and Main.Parent do
        for i = 0, 360, 4 do
            if not Main or not Main.Parent then break end
            pcall(function()
                MainGrad.Rotation = i
                MainGrad.Offset = Vector2.new(math.sin(math.rad(i)) * 0.7, math.cos(math.rad(i * 0.8)) * 0.7)
            end)
            task.wait(0.015)
        end
    end
end)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(80, 255, 80)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.3
Stroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Color3.fromRGB(15, 50, 15)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local HeaderText = Instance.new("TextLabel")
HeaderText.Size = UDim2.new(1, -80, 1, 0)
HeaderText.Position = UDim2.fromOffset(10, 0)
HeaderText.BackgroundTransparency = 1
HeaderText.Text = "Noel EZ  |  SpeedHub X  |  Venom"
HeaderText.TextColor3 = Color3.fromRGB(220, 255, 220)
HeaderText.Font = Enum.Font.GothamBold
HeaderText.TextSize = 12
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.Parent = Header

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(28, 28)
Minimize.Position = UDim2.new(1, -56, 0, 2)
Minimize.BackgroundTransparency = 1
Minimize.Text = "−"
Minimize.TextColor3 = Color3.fromRGB(220, 255, 220)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 20
Minimize.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(28, 28)
Close.Position = UDim2.new(1, -28, 0, 2)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(220, 255, 220)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.Parent = Header

Minimize.MouseButton1Click:Connect(function() Main.Visible = false end)
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

local ballDrag, ballMoved = false, false
local bStart, bPos
Ball.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ballDrag = true
        ballMoved = false
        bStart = input.Position
        bPos = Ball.Position
    end
end)
Ball.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if ballDrag and not ballMoved then Main.Visible = not Main.Visible end
        ballDrag = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if ballDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - bStart
        if math.abs(delta.X) > 15 or math.abs(delta.Y) > 15 then ballMoved = true end
        if ballMoved then
            Ball.Position = UDim2.new(bPos.X.Scale, bPos.X.Offset + delta.X, bPos.Y.Scale, bPos.Y.Offset + delta.Y)
        end
    end
end)

local dragging = false
local dStart, dPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dStart = input.Position
        dPos = Main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dStart
        Main.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset + delta.X, dPos.Y.Scale, dPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -40)
Content.Position = UDim2.fromOffset(10, 40)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 35, 10)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Content
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -120, 1, 0)
Pages.Position = UDim2.fromOffset(120, 0)
Pages.BackgroundTransparency = 1
Pages.Parent = Content

local tabs = {
    {Name = "Main", Icon = "◆"},
    {Name = "Visual", Icon = "👁"},
    {Name = "Settings", Icon = "⚙"},
}

local pages = {}
local tabBtns = {}

local function switchTab(name)
    for n, btn in pairs(tabBtns) do
        btn.BackgroundColor3 = (n == name) and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(10, 35, 10)
        btn.TextColor3 = (n == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 230, 200)
    end
    for n, p in pairs(pages) do p.Visible = (n == name) end
end

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 30)
    btn.Position = UDim2.fromOffset(4, 4 + (i-1)*34)
    btn.BackgroundColor3 = Color3.fromRGB(10, 35, 10)
    btn.BorderSizePixel = 0
    btn.Text = "  " .. tab.Icon .. "   " .. tab.Name
    btn.TextColor3 = Color3.fromRGB(200, 230, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    tabBtns[tab.Name] = btn
    btn.MouseButton1Click:Connect(function() switchTab(tab.Name) end)
end

local function createPage(name)
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 2
    p.Visible = false
    p.Parent = Pages
    pages[name] = p
    return p
end

local mainPage = createPage("Main")
local visualPage = createPage("Visual")
local settingsPage = createPage("Settings")

local function AddToggle(parent, text, y, default, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -6, 0, 30)
    f.Position = UDim2.fromOffset(0, y)
    f.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
    f.BackgroundTransparency = 0.5
    f.BorderSizePixel = 0
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -55, 1, 0)
    l.Position = UDim2.fromOffset(10, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local track = Instance.new("Frame")
    track.Size = UDim2.fromOffset(34, 16)
    track.Position = UDim2.new(1, -44, 0.5, -8)
    track.BackgroundColor3 = default and Color3.fromRGB(100, 240, 100) or Color3.fromRGB(30, 100, 30)
    track.BorderSizePixel = 0
    track.Parent = f
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(12, 12)
    knob.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.fromOffset(2, 2)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local state = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f
    btn.MouseButton1Click:Connect(function()
        state = not state
        track.BackgroundColor3 = state and Color3.fromRGB(100, 240, 100) or Color3.fromRGB(30, 100, 30)
        knob:TweenPosition(state and UDim2.new(1, -14, 0.5, -6) or UDim2.fromOffset(2, 2), "Out", "Quad", 0.15, true)
        cb(state)
    end)
end

AddToggle(mainPage, "Speed", 0, false, ToggleSpeed)
AddToggle(mainPage, "Fly", 36, false, ToggleFly)
AddToggle(mainPage, "Noclip", 72, false, ToggleNoclip)
AddToggle(visualPage, "ESP (ver jugadores)", 0, false, ToggleESP)
AddToggle(visualPage, "Tracers", 36, false, ToggleTracers)
AddToggle(settingsPage, "Anti-Fling", 0, false, function(s) C.AF = s end)
AddToggle(settingsPage, "Anti-AFK", 36, false, function(s) C.AA = s end)
AddToggle(settingsPage, "FPS Boost", 72, false, ToggleFPSBoost)
AddToggle(settingsPage, "Remove Fog", 108, false, ToggleFog)

switchTab("Main")

-- FPS COUNTER
local FL = Instance.new("TextLabel")
FL.Size = UDim2.fromOffset(110, 26)
FL.Position = UDim2.new(0, 12, 0, 12)
FL.BackgroundColor3 = Color3.fromRGB(10, 35, 10)
FL.BackgroundTransparency = 0.3
FL.BorderSizePixel = 0
FL.Text = "FPS: --"
FL.TextColor3 = Color3.fromRGB(100, 240, 100)
FL.Font = Enum.Font.GothamBold
FL.TextSize = 13
FL.Parent = Gui
Instance.new("UICorner", FL).CornerRadius = UDim.new(0, 6)

local fr, lt = 0, tick()
RS.RenderStepped:Connect(function()
    fr = fr + 1
    local now = tick()
    if now - lt >= 1 then
        local fps = math.floor(fr / (now - lt))
        local col = Color3.fromRGB(100,240,100)
        if fps < 30 then col = Color3.fromRGB(255,60,60)
        elseif fps < 60 then col = Color3.fromRGB(255,200,0) end
        FL.Text = "FPS: " .. fps
        FL.TextColor3 = col
        fr = 0
        lt = now
    end
end)

-- BOTONES FLY MÓVIL
_G.FlyUpBtn = Instance.new("TextButton")
_G.FlyUpBtn.Size = UDim2.fromOffset(46,46)
_G.FlyUpBtn.Position = UDim2.new(1,-120,1,-120)
_G.FlyUpBtn.BackgroundColor3 = Color3.fromRGB(40,130,40)
_G.FlyUpBtn.BackgroundTransparency = 0.3
_G.FlyUpBtn.BorderSizePixel = 0
_G.FlyUpBtn.Text = "▲"
_G.FlyUpBtn.TextColor3 = Color3.fromRGB(255,255,255)
_G.FlyUpBtn.Font = Enum.Font.GothamBold
_G.FlyUpBtn.TextSize = 20
_G.FlyUpBtn.Visible = false
_G.FlyUpBtn.Parent = Gui
Instance.new("UICorner", _G.FlyUpBtn).CornerRadius = UDim.new(0, 10)

_G.FlyDownBtn = Instance.new("TextButton")
_G.FlyDownBtn.Size = UDim2.fromOffset(46,46)
_G.FlyDownBtn.Position = UDim2.new(1,-120,1,-68)
_G.FlyDownBtn.BackgroundColor3 = Color3.fromRGB(40,130,40)
_G.FlyDownBtn.BackgroundTransparency = 0.3
_G.FlyDownBtn.BorderSizePixel = 0
_G.FlyDownBtn.Text = "▼"
_G.FlyDownBtn.TextColor3 = Color3.fromRGB(255,255,255)
_G.FlyDownBtn.Font = Enum.Font.GothamBold
_G.FlyDownBtn.TextSize = 20
_G.FlyDownBtn.Visible = false
_G.FlyDownBtn.Parent = Gui
Instance.new("UICorner", _G.FlyDownBtn).CornerRadius = UDim.new(0, 10)

_G.FlyUpBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then FU = 1 end
end)
_G.FlyUpBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then FU = 0 end
end)
_G.FlyDownBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then FU = -1 end
end)
_G.FlyDownBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then FU = 0 end
end)

Player.CharacterAdded:Connect(function()
    task.wait(1.5)
    RC()
    if C.Noclip then StartNoclip() end
    if C.ESP then StartESP() end
    if C.Fly then StartFly() end
    if C.Speed and H then H.WalkSpeed = C.WS end
end)

print("✅ Noel EZ | Venom cargado")
    
