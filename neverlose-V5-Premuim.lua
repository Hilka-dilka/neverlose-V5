local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = { LayoutOrderNum = 0 }

local Theme = {
    Main = Color3.fromRGB(8, 9, 13),
    Sidebar = Color3.fromRGB(12, 13, 18),
    Group = Color3.fromRGB(16, 17, 23),
    Accent = Color3.fromRGB(165, 183, 250),
    Outline = Color3.fromRGB(35, 37, 48),
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(160, 165, 180),
    Element = Color3.fromRGB(28, 30, 40),
    Hover = Color3.fromRGB(45, 48, 62)
}

local function ApplyStyle(obj, radius, hasStroke)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, radius)
    if hasStroke then
        local s = Instance.new("UIStroke", obj)
        s.Color = Theme.Outline
        s.Thickness = 1.2
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end
end

local function MakeDraggable(obj, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Library:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "Neverlose_Final_Premium"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local Overlay = Instance.new("Frame", ScreenGui)
    Overlay.Size = UDim2.new(1,0,1,0)
    Overlay.BackgroundTransparency = 1
    Overlay.ZIndex = 10000

    local Main = Instance.new("CanvasGroup", ScreenGui)
    Main.Size = UDim2.new(0, 880, 0, 620)
    Main.Position = UDim2.new(0.5, -440, 0.5, -310)
    Main.BackgroundColor3 = Theme.Main
    ApplyStyle(Main, 10, true)

    TweenService:Create(Main, TweenInfo.new(0.4), {GroupTransparency = 0}):Play()

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 200, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    ApplyStyle(Sidebar, 10)
    MakeDraggable(Main, Sidebar)

    local TabScroll = Instance.new("ScrollingFrame", Sidebar)
    TabScroll.Size = UDim2.new(1,0,1,-160)
    TabScroll.Position = UDim2.new(0,0,0,80)
    TabScroll.ScrollBarThickness = 0
    TabScroll.BackgroundTransparency = 1
    Instance.new("UIListLayout", TabScroll).Padding = UDim.new(0,2)

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1,-220,1,-20)
    Content.Position = UDim2.new(0,210,0,10)
    Content.BackgroundTransparency = 1

    local Tabs = {}
    local Window = {}

    function Window:AddCategory(name)
        local L = Instance.new("TextLabel", TabScroll)
        L.Size = UDim2.new(1,0,0,30)
        L.Text = "      "..name:upper()
        L.Font = Enum.Font.GothamBold
        L.TextSize = 10
        L.TextColor3 = Theme.Muted
        L.BackgroundTransparency = 1
    end

    function Window:AddTab(name)
        local Btn = Instance.new("TextButton", TabScroll)
        Btn.Size = UDim2.new(1,-30,0,38)
        Btn.Position = UDim2.new(0,15,0,0)
        Btn.Text = "          "..name
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 13
        Btn.TextColor3 = Theme.Muted
        Btn.BackgroundColor3 = Theme.Element
        Btn.BackgroundTransparency = 1
        Btn.AutoButtonColor = false
        ApplyStyle(Btn, 6)

        local Page = Instance.new("CanvasGroup", Content)
        Page.Visible = false
        Page.BackgroundTransparency = 1

        Btn.MouseButton1Click:Connect(function()
            for _,t in pairs(Tabs) do
                t.Page.Visible = false
                t.Btn.TextColor3 = Theme.Muted
                t.Btn.BackgroundTransparency = 1
            end
            Page.Visible = true
            Btn.TextColor3 = Theme.Text
            Btn.BackgroundTransparency = 0.4
        end)

        if Tabs == 1 then
    Page.Visible = true
    Btn.BackgroundTransparency = 0
end


        local Tab = {}

        function Tab:AddGroup(title)
            local G = Instance.new("Frame", Page)
            G.Size = UDim2.new(1,0,0,300)
            G.BackgroundColor3 = Theme.Group
            ApplyStyle(G, 8, true)

            local Container = Instance.new("Frame", G)
            Container.Size = UDim2.new(1,-30,1,-45)
            Container.Position = UDim2.new(0,15,0,40)
            Container.BackgroundTransparency = 1
            Instance.new("UIListLayout", Container).Padding = UDim.new(0,10)

            local Group = {}

            function Group:AddToggle(text, callback)
                local state = false

                local F = Instance.new("Frame", Container)
                F.Size = UDim2.new(1,0,0,26)
                F.BackgroundTransparency = 1

                local L = Instance.new("TextLabel", F)
                L.Size = UDim2.new(1,0,1,0)
                L.Text = text
                L.Font = Enum.Font.GothamMedium
                L.TextSize = 14
                L.TextColor3 = Theme.Text
                L.BackgroundTransparency = 1
                L.TextXAlignment = Left

                local Sw = Instance.new("TextButton", F)
                Sw.Size = UDim2.new(0,36,0,18)
                Sw.Position = UDim2.new(1,0,0.5,0)
                Sw.AnchorPoint = Vector2.new(1,0.5)
                Sw.BackgroundColor3 = Theme.Element
                Sw.Text = ""
                ApplyStyle(Sw, 10, true)

                local Dot = Instance.new("Frame", Sw)
                Dot.Size = UDim2.new(0,12,0,12)
                Dot.Position = UDim2.new(0,3,0.5,-6)
                Dot.BackgroundColor3 = Theme.Muted
                ApplyStyle(Dot, 10)

                Sw.MouseButton1Click:Connect(function()
                    state = not state

                    local bgColor = state and Theme.Accent or Theme.Element
                    local dotColor = state and Theme.Text or Theme.Muted
                    local dotPos = state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)

                    TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = bgColor}):Play()
                    TweenService:Create(Dot, TweenInfo.new(0.2), {BackgroundColor3 = dotColor, Position = dotPos}):Play()

                    if callback then callback(state) end
                end)
            end

            return Group
        end

        return Tab
    end

    return Window
end

return Library
