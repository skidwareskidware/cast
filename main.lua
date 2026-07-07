local NotifLib = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Persistent ScreenGui based on your layout
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FrvgmxtNotificationSystem"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Invisible container to handle the dynamic stacking below each other
local Container = Instance.new("Frame")
Container.Name = "NotificationContainer"
Container.Size = UDim2.new(0.4, 0, 0.9, 0)
Container.Position = UDim2.new(0.3, 0, 0.02008, 0) -- Centered top alignment based on your position
Container.BackgroundTransparency = 1
Container.Parent = ScreenGui

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8) -- Spacing between each notification
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Container

function NotifLib.new(text: string, duration: number)
    duration = duration or 3
    
    -- StarterGui.ScreenGui.text only notif
    -- Converted to CanvasGroup to support smooth fading of background + text simultaneously
    local NotifFrame = Instance.new("CanvasGroup")
    NotifFrame.Name = [[text only notif]]
    NotifFrame.BorderSizePixel = 0
    NotifFrame.BackgroundColor3 = Color3.fromRGB(0, 13, 27)
    NotifFrame.GroupTransparency = 1 -- Start hidden for fade in
    
    -- StarterGui.ScreenGui.text only notif.UICorner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 21313) -- Kept your exact pill-shape radius
    UICorner.Parent = NotifFrame

    -- StarterGui.ScreenGui.text only notif.text
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = [[text]]
    TextLabel.TextWrapped = true
    TextLabel.BorderSizePixel = 0
    TextLabel.TextSize = 18
    TextLabel.TextScaled = true
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Regular, Enum.FontStyle.Normal) -- Exact font
    TextLabel.TextColor3 = Color3.fromRGB(219, 219, 219)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Text = text
    
    -- Positioning matching your offset layout adjustments
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Position = UDim2.new(0, 0, 0, 0)
    TextLabel.Parent = NotifFrame

    -- StarterGui.ScreenGui.text only notif.text.UITextSizeConstraint
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)
    UITextSizeConstraint.MaxTextSize = 18

    -- Dynamic Width Calculation (Keeps the original 49px height, scales the width)
    local textProperties = GetTextBoundsParams.new()
    textProperties.Text = text
    textProperties.Size = 18
    textProperties.Font = TextLabel.FontFace
    textProperties.Width = 600 -- Maximum scaling limit width

    local calculatedSize = TextService:GetTextBoundsAsync(textProperties)
    local minWidth = 129 -- Your original base width
    local paddingX = 40
    local dynamicWidth = math.max(minWidth, calculatedSize.X + paddingX)

    NotifFrame.Size = UDim2.new(0, dynamicWidth, 0, 49) -- Fixed height of 49 from your script

    -- StarterGui.ScreenGui.text only notif.UIAspectRatioConstraint
    -- Dynamically adjusting aspect ratio constraint so it doesn't compress the frame layout
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", NotifFrame)
    UIAspectRatioConstraint.AspectRatio = dynamicWidth / 49

    NotifFrame.Parent = Container

    -- Tween Animations
    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeIn = TweenService:Create(NotifFrame, tweenInfo, {GroupTransparency = 0})
    local fadeOut = TweenService:Create(NotifFrame, tweenInfo, {GroupTransparency = 1})

    fadeIn:Play()

    task.delay(duration, function()
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            NotifFrame:Destroy()
        end)
    end)
end

return NotifLib
