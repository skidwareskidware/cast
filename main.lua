local NotifSystem = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local InterFont = Font.new("rbxasset://fonts/families/Inter.json", Enum.FontWeight.Regular)

local ScreenGui = PlayerGui:FindFirstChild("cast")
if not ScreenGui then
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "cast"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui
end

local Container = ScreenGui:FindFirstChild("Container")
if not Container then
    Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(0, 300, 0.9, 0)
    Container.Position = UDim2.new(1, -320, 0.02, 0)
    Container.BackgroundTransparency = 1
    Container.Parent = ScreenGui

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = Container
end

local function animateNotif(frame, duration)
    frame.Parent = Container
    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local fadeIn = TweenService:Create(frame, tweenInfo, {GroupTransparency = 0})
    local fadeOut = TweenService:Create(frame, tweenInfo, {GroupTransparency = 1})

    fadeIn:Play()

    task.delay(duration, function()
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            frame:Destroy()
        end)
    end)
end

function NotifSystem.basic(title: string, duration: number)
    duration = duration or 3

    local NotifFrame = Instance.new("CanvasGroup")
    NotifFrame.Name = "BasicNotif"
    NotifFrame.BorderSizePixel = 0
    NotifFrame.BackgroundColor3 = Color3.fromRGB(0, 13, 27)
    NotifFrame.GroupTransparency = 1

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 21313)
    UICorner.Parent = NotifFrame

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "text"
    TextLabel.TextWrapped = true
    TextLabel.BorderSizePixel = 0
    TextLabel.TextSize = 18
    TextLabel.TextScaled = true
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.FontFace = InterFont
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = title
    TextLabel.Size = UDim2.new(1, -30, 1, 0)
    TextLabel.Position = UDim2.new(0, 15, 0, 0)
    TextLabel.Parent = NotifFrame

    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)
    UITextSizeConstraint.MaxTextSize = 18

    local calculatedSize = TextService:GetTextSize(title, 18, InterFont, Vector2.new(260, 50))
    local dynamicWidth = math.max(130, calculatedSize.X + 45)

    NotifFrame.Size = UDim2.new(0, dynamicWidth, 0, 49)

    animateNotif(NotifFrame, duration)
end

function NotifSystem.desc(title: string, description: string, duration: number)
    duration = duration or 4

    local NotifFrame = Instance.new("CanvasGroup")
    NotifFrame.Name = "DescNotif"
    NotifFrame.BorderSizePixel = 0
    NotifFrame.BackgroundColor3 = Color3.fromRGB(0, 13, 27)
    NotifFrame.GroupTransparency = 1
    NotifFrame.Size = UDim2.new(0, 300, 0, 100)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 24)
    UICorner.Parent = NotifFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Text = title
    TitleLabel.TextSize = 18
    TitleLabel.FontFace = InterFont
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Size = UDim2.new(1, -40, 0, 24)
    TitleLabel.Position = UDim2.new(0, 20, 0, 16)
    TitleLabel.Parent = NotifFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "Description"
    DescLabel.Text = description
    DescLabel.TextSize = 15
    DescLabel.FontFace = InterFont
    DescLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DescLabel.BackgroundTransparency = 1
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.Parent = NotifFrame

    local estimatedDescSize = TextService:GetTextSize(description, 15, InterFont, Vector2.new(260, 800))

    local finalContainerHeight = 16 + 24 + 8 + estimatedDescSize.Y + 20
    NotifFrame.Size = UDim2.new(0, 300, 0, finalContainerHeight)

    DescLabel.Size = UDim2.new(1, -40, 0, estimatedDescSize.Y)
    DescLabel.Position = UDim2.new(0, 20, 0, 48)

    animateNotif(NotifFrame, duration)
end

return NotifSystem
