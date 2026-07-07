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

-- 1. Create a single core ScreenGui container if it doesn't exist yet
local ScreenGui = PlayerGui:FindFirstChild("FrvgmxtNotifSystem")
if not ScreenGui then
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FrvgmxtNotifSystem"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui
end

-- 2. Create the alignment frame that handles stacking notifications down the screen
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

-- 3. Define the constructor function
function NotifSystem.new(text: string, duration: number)
    duration = duration or 3
    
    -- StarterGui.ScreenGui.text only notif (CanvasGroup for uniform fading)
    local NotifFrame = Instance.new("CanvasGroup")
    NotifFrame.Name = [[text only notif]]
    NotifFrame.BorderSizePixel = 0
    NotifFrame.BackgroundColor3 = Color3.fromRGB(0, 13, 27)
    NotifFrame.GroupTransparency = 1
    
    -- StarterGui.ScreenGui.text only notif.UICorner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 21313)
    UICorner.Parent = NotifFrame

    -- StarterGui.ScreenGui.text only notif.text
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = [[text]]
    TextLabel.TextWrapped = true
    TextLabel.BorderSizePixel = 0
    TextLabel.TextSize = 18
    TextLabel.TextScaled = true
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    -- Using default font enum fallback to guarantee compatibility across environments
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.TextColor3 = Color3.fromRGB(219, 219, 219)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Text = text
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Position = UDim2.new(0, 0, 0, 0)
    TextLabel.Parent = NotifFrame

    -- StarterGui.ScreenGui.text only notif.text.UITextSizeConstraint
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)
    UITextSizeConstraint.MaxTextSize = 18

    -- Universal method to get text bounds without relying on GetTextBoundsParams
    local minWidth = 129
    local paddingX = 42
    local maxBoundsWidth = 600
    
    local calculatedSize = TextService:GetTextSize(text, 18, TextLabel.Font, Vector2.new(maxBoundsWidth, 50))
    local dynamicWidth = math.max(minWidth, calculatedSize.X + paddingX)

    NotifFrame.Size = UDim2.new(0, dynamicWidth, 0, 49)

    -- StarterGui.ScreenGui.text only notif.UIAspectRatioConstraint
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", NotifFrame)
    UIAspectRatioConstraint.AspectRatio = dynamicWidth / 49

    NotifFrame.Parent = Container

    -- Animations
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
