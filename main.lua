-- Save this as your notification library script
local NotifLib = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

-- Main Core Gui Creation
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Persistent ScreenGui for notifications
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FrvgmxtNotificationSystem"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Notification Container (Handles the vertical stacking automatically)
local Container = Instance.new("Frame")
Container.Name = "NotificationContainer"
Container.Size = UDim2.new(0.3, 0, 0.9, 0)
Container.Position = UDim2.new(0.35, 0, 0.02, 0) -- Centered top
Container.BackgroundTransparency = 1
Container.Parent = ScreenGui

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8) -- Space between notifications
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Container

-- The Constructor Function
function NotifLib.new(text: string, duration: number)
    duration = duration or 3
    
    -- 1. Create a CanvasGroup to allow flawless fading of all elements inside it
    local NotifFrame = Instance.new("CanvasGroup")
    NotifFrame.Name = "TextOnlyNotif"
    NotifFrame.BackgroundColor3 = Color3.fromRGB(0, 13, 27)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.GroupTransparency = 1 -- Start invisible for fade-in
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8) -- Cleaner notification padding
    Corner.Parent = NotifFrame

    -- 2. Create and configure text label
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Text"
    TextLabel.Text = text
    TextLabel.TextSize = 18
    TextLabel.Font = Enum.Font.SourceSans -- Safe fallback, change to Font.new if assetid is active
    TextLabel.TextColor3 = Color3.fromRGB(219, 219, 219)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.TextWrapped = true
    TextLabel.Size = UDim2.new(1, -24, 1, 0) -- Give padding inside the frame
    TextLabel.Position = UDim2.new(0, 12, 0, 0)
    TextLabel.Parent = NotifFrame
    
    local SizeConstraint = Instance.new("UITextSizeConstraint")
    SizeConstraint.MaxTextSize = 18
    SizeConstraint.Parent = TextLabel

    -- 3. Dynamic Resizing Logic (Calculate text width dynamically)
    local maxBounds = Vector2.new(500, 50) -- Max width cap: 500px
    local textProperties = GetTextBoundsParams.new()
    textProperties.Text = text
    textProperties.Size = 18
    textProperties.Font = TextLabel.Font
    textProperties.Width = maxBounds.X

    local calculatedSize = TextService:GetTextBoundsAsync(textProperties)
    local paddingX = 32 -- Extra breathing space horizontally
    local paddingY = 20 -- Vertical scale space
    
    -- Apply sizes dynamically based on text length
    local finalWidth = math.max(130, calculatedSize.X + paddingX)
    local finalHeight = math.max(45, calculatedSize.Y + paddingY)
    NotifFrame.Size = UDim2.new(0, finalWidth, 0, finalHeight)
    NotifFrame.Parent = Container

    -- 4. Animation Settings
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local fadeIn = TweenService:Create(NotifFrame, tweenInfo, {GroupTransparency = 0})
    local fadeOut = TweenService:Create(NotifFrame, tweenInfo, {GroupTransparency = 1})

    -- 5. Execution Sequence
    fadeIn:Play()
    
    task.delay(duration, function()
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            NotifFrame:Destroy()
        end)
    end)
end

return NotifLib
