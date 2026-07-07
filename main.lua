--[=[
 d888b   db     db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88     88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88     88    88            odD'      88      88    88 88ooo88 
88  ooo 88     88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b   d88   .88.        j88.         88booo. 88b  d88 88   88   @uniquadev
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP  CONVERTER 
]=]

local NotifSystem = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Persistent UI Screen Setup
local ScreenGui = PlayerGui:FindFirstChild("FrvgmxtNotifSystem")
if not ScreenGui then
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FrvgmxtNotifSystem"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui
end

-- 2. Stacking Layout Container
local Container = ScreenGui:FindFirstChild("Container")
if not Container then
    Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(0.4, 0, 0.9, 0)
    Container.Position = UDim2.new(0.3, 0, 0.02008, 0)
    Container.BackgroundTransparency = 1
    Container.Parent = ScreenGui

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = Container
end

-- 3. Dynamic Notification Spawn
function NotifSystem.new(text: string, duration: number)
    duration = duration or 3
    
    local NotifFrame = Instance.new("CanvasGroup")
    NotifFrame.Name = [[text only notif]]
    NotifFrame.BorderSizePixel = 0
    NotifFrame.BackgroundColor3 = Color3.fromRGB(0, 13, 27)
    NotifFrame.GroupTransparency = 1
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 21313)
    UICorner.Parent = NotifFrame

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = [[text]]
    TextLabel.TextWrapped = true
    TextLabel.BorderSizePixel = 0
    TextLabel.TextSize = 18
    TextLabel.TextScaled = true
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Font = Enum.Font.SourceSans -- 100% stable fallback across all game contexts
    TextLabel.TextColor3 = Color3.fromRGB(219, 219, 219)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Text = text
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Position = UDim2.new(0, 0, 0, 0)
    TextLabel.Parent = NotifFrame

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)
    UITextSizeConstraint.MaxTextSize = 18

    -- Safe dynamic string layout boundaries measurement
    local baseMinWidth = 129
    local paddingOffset = 42
    local maximumBoundaryWidth = 600
    
    -- Using native property bounds structure avoiding datatype errors entirely
    local calculatedSize = TextService:GetTextSize(text, 18, Enum.Font.SourceSans, Vector2.new(maximumBoundaryWidth, 50))
    local dynamicWidth = math.max(baseMinWidth, calculatedSize.X + paddingOffset)

    NotifFrame.Size = UDim2.new(0, dynamicWidth, 0, 49)

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", NotifFrame)
    UIAspectRatioConstraint.AspectRatio = dynamicWidth / 49

    NotifFrame.Parent = Container

    -- Animation Engine sequences
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

return NotifSystem
