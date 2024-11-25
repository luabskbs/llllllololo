-- Create the main GUI container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "FPSBoostHub"

-- Create the main frame of the GUI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Add title to the GUI
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Text = "FPS Boost Hub"
Title.TextCentered = true
Title.Parent = MainFrame

-- Create a button to enable/disable aimbot
local AimbotButton = Instance.new("TextButton")
AimbotButton.Size = UDim2.new(1, 0, 0, 40)
AimbotButton.Position = UDim2.new(0, 0, 0, 60)
AimbotButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.TextSize = 20
AimbotButton.Text = "Toggle Aimbot"
AimbotButton.Parent = MainFrame

local AimbotEnabled = false
AimbotButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    if AimbotEnabled then
        AimbotButton.Text = "Aimbot: ON"
    else
        AimbotButton.Text = "Aimbot: OFF"
    end
end)

-- FPS Boost function
local function boostFPS()
    local PlayerSettings = game:GetService("UserSettings").GameSettings
    PlayerSettings:SetControlsEnabled(false)
    game:GetService("RunService"):Set3dRenderingEnabled(false)
    -- Additional FPS optimizations can be added here
end

-- FPS Boost button
local FPSBoostButton = Instance.new("TextButton")
FPSBoostButton.Size = UDim2.new(1, 0, 0, 40)
FPSBoostButton.Position = UDim2.new(0, 0, 0, 120)
FPSBoostButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
FPSBoostButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSBoostButton.TextSize = 20
FPSBoostButton.Text = "Activate FPS Boost"
FPSBoostButton.Parent = MainFrame

FPSBoostButton.MouseButton1Click:Connect(function()
    boostFPS()
    FPSBoostButton.Text = "FPS Boost: ON"
end)

-- Walkspeed Slider
local WalkSpeedSlider = Instance.new("Slider")
WalkSpeedSlider.Size = UDim2.new(1, 0, 0, 40)
WalkSpeedSlider.Position = UDim2.new(0, 0, 0, 180)
WalkSpeedSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
WalkSpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedSlider.TextSize = 20
WalkSpeedSlider.Text = "WalkSpeed"
WalkSpeedSlider.Parent = MainFrame

-- Update walkspeed based on slider value
WalkSpeedSlider.Changed:Connect(function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)

-- Function for Aimbot logic
local function aimbotLogic()
    local teamCheck = false
    local fov = 150
    local smoothing = 1

    local RunService = game:GetService("RunService")

    local FOVring = Drawing.new("Circle")
    FOVring.Visible = true
    FOVring.Thickness = 1.5
    FOVring.Radius = fov
    FOVring.Transparency = 1
    FOVring.Color = Color3.fromRGB(255, 128, 128)
    FOVring.Position = workspace.CurrentCamera.ViewportSize / 2

    local function getClosest(cframe)
        local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
        local target = nil
        local mag = math.huge

        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer and (v.Team ~= game.Players.LocalPlayer.Team or not teamCheck) then
                local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude
                if magBuf < mag then
                    mag = magBuf
                    target = v
                end
            end
        end
        return target
    end

    RunService.RenderStepped:Connect(function()
        if AimbotEnabled then
            local UserInputService = game:GetService("UserInputService")
            local pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
            local cam = workspace.CurrentCamera
            local zz = workspace.CurrentCamera.ViewportSize / 2

            if pressed then
                local curTar = getClosest(cam.CFrame)
                local ssHeadPoint = cam:WorldToScreenPoint(curTar.Character.Head.Position)
                ssHeadPoint = Vector2.new(ssHeadPoint.X, ssHeadPoint.Y)

                if (ssHeadPoint - zz).Magnitude < fov then
                    workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(cam.CFrame.Position, curTar.Character.Head.Position), smoothing)
                end
            end
        end
    end)
end

-- Start Aimbot Logic
aimbotLogic()