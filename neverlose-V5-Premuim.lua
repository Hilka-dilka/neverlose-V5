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
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function Library:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "Neverlose_Premium_V5"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local Overlay = Instance.new("Frame", ScreenGui)
    Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundTransparency = 1; Overlay.ZIndex = 10000

    local Main = Instance.new("CanvasGroup", ScreenGui)
    Main.Size = UDim2.new(0, 880, 0, 620)
    Main.Position = UDim2.new(0.5, -440, 0.5, -310)
    Main.BackgroundColor3 = Theme.Main
    Main.GroupTransparency = 1
    ApplyStyle(Main, 10, true)
    
    TweenService:Create(Main, TweenInfo.new(0.5), {GroupTransparency = 0}):Play()

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 200, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    ApplyStyle(Sidebar, 10)
    MakeDraggable(Main, Sidebar)

    local Logo = Instance.new("Frame", Sidebar)
    Logo.Size = UDim2.new(1, 0, 0, 80); Logo.BackgroundTransparency = 1
    local Icon = Instance.new("Frame", Logo); Icon.Size = UDim2.new(0, 26, 0, 26); Icon.Position = UDim2.new(0, 20, 0, 25); Icon.BackgroundColor3 = Theme.Accent; ApplyStyle(Icon, 6)
    local Title = Instance.new("TextLabel", Logo); Title.Text = "Neverlose"; Title.Position = UDim2.new(0, 55, 0, 22); Title.Font = "GothamBold"; Title.TextColor3 = Theme.Text; Title.TextSize = 16; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1
    local SubLogo = Instance.new("TextLabel", Logo); SubLogo.Text = "Roblox"; SubLogo.Position = UDim2.new(0, 55, 0, 38); SubLogo.Font = "Gotham"; SubLogo.TextColor3 = Theme.Muted; SubLogo.TextSize = 11; SubLogo.TextXAlignment = "Left"; SubLogo.BackgroundTransparency = 1

    local TabScroll = Instance.new("ScrollingFrame", Sidebar)
    TabScroll.Size = UDim2.new(1, 0, 1, -160); TabScroll.Position = UDim2.new(0, 0, 0, 80); TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabScroll); TabListLayout.SortOrder = "LayoutOrder"; TabListLayout.Padding = UDim.new(0, 2)

    local ContentArea = Instance.new("Frame", Main)
    ContentArea.Size = UDim2.new(1, -220, 1, -20); ContentArea.Position = UDim2.new(0, 210, 0, 10); ContentArea.BackgroundTransparency = 1

    local Tabs = {}
    local WindowFunctions = {}

    function WindowFunctions:AddCategory(name)
        Library.LayoutOrderNum = Library.LayoutOrderNum + 1
        local L = Instance.new("TextLabel", TabScroll)
        L.Size = UDim2.new(1, 0, 0, 35); L.Text = "      " .. name:upper(); L.Font = "GothamBold"; L.TextColor3 = Theme.Muted; L.TextSize = 10; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1; L.LayoutOrder = Library.LayoutOrderNum
    end

    function WindowFunctions:AddTab(tabName, isUnderDev)
        Library.LayoutOrderNum = Library.LayoutOrderNum + 1
        local Btn = Instance.new("TextButton", TabScroll)
        Btn.Size = UDim2.new(1, -30, 0, 38); Btn.Position = UDim2.new(0, 15, 0, 0); Btn.BackgroundColor3 = Theme.Element; Btn.BackgroundTransparency = 1; Btn.Text = "          " .. tabName; Btn.Font = "GothamMedium"; Btn.TextColor3 = Theme.Muted; Btn.TextSize = 13; Btn.TextXAlignment = "Left"; Btn.AutoButtonColor = false; Btn.LayoutOrder = Library.LayoutOrderNum; ApplyStyle(Btn, 6)

        local Page = Instance.new("CanvasGroup", ContentArea); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1

        if isUnderDev then
            local DevLabel = Instance.new("TextLabel", Page)
            DevLabel.Size = UDim2.new(1, 0, 1, 0); DevLabel.Text = "UNDER DEVELOPMENT"; DevLabel.Font = "GothamBold"; DevLabel.TextColor3 = Theme.Muted; DevLabel.TextSize = 24; DevLabel.BackgroundTransparency = 1
        end

        Btn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do t.P.Visible = false; t.B.TextColor3 = Theme.Muted; t.B.BackgroundTransparency = 1 end
            Page.Visible = true; Btn.TextColor3 = Theme.Text; Btn.BackgroundTransparency = 0.5
            Page.GroupTransparency = 1; TweenService:Create(Page, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
        end)

        table.insert(Tabs, {P = Page, B = Btn})
        if #Tabs == 1 then Page.Visible = true; Btn.TextColor3 = Theme.Text; Btn.BackgroundTransparency = 0.5; Page.GroupTransparency = 0 end

        local TabFunctions = {}

        -- НОВЫЙ МЕТОД: КАРТИНКА ВМЕСТО ПОД-ВКЛАДОК
        function TabFunctions:AddTopImage(id)
            local Img = Instance.new("ImageLabel", Page)
            Img.Size = UDim2.new(0, 300, 0, 150) -- Размер можно менять
            Img.Position = UDim2.new(0.5, -150, 0, 5)
            Img.BackgroundTransparency = 1
            Img.Image = "rbxassetid://" .. id
            Img.ZIndex = 5
        end

        function TabFunctions:AddGroup(title)
            local G = Instance.new("Frame", Page); G.BackgroundColor3 = Theme.Group; ApplyStyle(G, 8, true)
            local Container = Instance.new("Frame", G); Container.Size = UDim2.new(1, -30, 1, -45); Container.Position = UDim2.new(0, 15, 0, 40); Container.BackgroundTransparency = 1
            Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)
            local GT = Instance.new("TextLabel", G); GT.Text = title:upper(); GT.Size = UDim2.new(1, -30, 0, 30); GT.Position = UDim2.new(0, 15, 0, 5); GT.Font = "GothamBold"; GT.TextColor3 = Theme.Muted; GT.TextSize = 10; GT.TextXAlignment = "Left"; GT.BackgroundTransparency = 1

            local ElementFunctions = {}

            function ElementFunctions:AddToggle(txt, callback)
                local state = false
                local F = Instance.new("Frame", Container); F.Size = UDim2.new(1, 0, 0, 26); F.BackgroundTransparency = 1
                local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(1, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                local Sw = Instance.new("TextButton", F); Sw.Size = UDim2.new(0, 36, 0, 18); Sw.Position = UDim2.new(1, 0, 0.5, 0); Sw.AnchorPoint = Vector2.new(1,0.5); Sw.BackgroundColor3 = Theme.Element; Sw.Text = ""; ApplyStyle(Sw, 10, true)
                local D = Instance.new("Frame", Sw); D.Size = UDim2.new(0, 12, 0, 12); D.Position = UDim2.new(0, 3, 0.5, -6); D.BackgroundColor3 = Theme.Muted; ApplyStyle(D, 10)
                Sw.MouseButton1Click:Connect(function()
                    state = not state
                    TweenService:Create(D, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = state and Theme.Text or Theme.Muted}):Play()
                    TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.Element}):Play()
                    if callback then callback(state) end
                end)
            end

            function ElementFunctions:AddSlider(txt, min, max, suffix, callback)
                local F = Instance.new("Frame", Container); F.Size = UDim2.new(1, 0, 0, 35); F.BackgroundTransparency = 1
                local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(0.6, 0, 0, 18); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                local V = Instance.new("TextLabel", F); V.Text = tostring(min)..suffix; V.Size = UDim2.new(0.4, 0, 0, 18); V.Position = UDim2.new(0.6,0,0,0); V.Font = "GothamMedium"; V.TextColor3 = Theme.Accent; V.TextSize = 13; V.TextXAlignment = "Right"; V.BackgroundTransparency = 1
                local Bar = Instance.new("Frame", F); Bar.Size = UDim2.new(1, 0, 0, 4); Bar.Position = UDim2.new(0, 0, 0, 26); Bar.BackgroundColor3 = Theme.Element; ApplyStyle(Bar, 2)
                local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new(0, 0, 1, 0); Fill.BackgroundColor3 = Theme.Accent; ApplyStyle(Fill, 2)
                local function update(input)
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    local value = math.floor(min + (max - min) * pos); V.Text = tostring(value) .. suffix
                    if callback then callback(value) end
                end
                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        update(input)
                        local move = UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
                        local release; release = UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect(); release:Disconnect() end end)
                    end
                end)
            end

            function ElementFunctions:AddDropdown(txt, options, callback)
                local F = Instance.new("Frame", Container); F.Size = UDim2.new(1, 0, 0, 24); F.BackgroundTransparency = 1
                local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(0.5, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                local Box = Instance.new("TextButton", F); Box.Size = UDim2.new(0.45, 0, 1, 0); Box.Position = UDim2.new(1, 0, 0, 0); Box.AnchorPoint = Vector2.new(1,0); Box.BackgroundColor3 = Theme.Element; Box.Text = ""; ApplyStyle(Box, 4, true)
                local Val = Instance.new("TextLabel", Box); Val.Size = UDim2.new(1,-10,1,0); Val.Position = UDim2.new(0,5,0,0); Val.Text = options[1] or ""; Val.Font = "GothamMedium"; Val.TextColor3 = Theme.Text; Val.TextSize = 12; Val.TextXAlignment = "Left"; Val.BackgroundTransparency = 1
                
                Box.MouseButton1Click:Connect(function()
                    if Overlay:FindFirstChild("DropMenu") then Overlay.DropMenu:Destroy() return end
                    local DropMenu = Instance.new("ScrollingFrame", Overlay)
                    DropMenu.Name = "DropMenu"; DropMenu.Size = UDim2.new(0, Box.AbsoluteSize.X, 0, math.min(#options * 28 + 8, 200)); DropMenu.Position = UDim2.new(0, Box.AbsolutePosition.X, 0, Box.AbsolutePosition.Y + Box.AbsoluteSize.Y + 2); DropMenu.BackgroundColor3 = Theme.Element; DropMenu.ScrollBarThickness = 0; DropMenu.ZIndex = 10001; ApplyStyle(DropMenu, 6, true)
                    Instance.new("UIListLayout", DropMenu)
                    for _, opt in pairs(options) do
                        local oBtn = Instance.new("TextButton", DropMenu)
                        oBtn.Size = UDim2.new(1,0,0,28); oBtn.BackgroundColor3 = Theme.Element; oBtn.Text = "  "..opt; oBtn.Font = "GothamMedium"; oBtn.TextColor3 = Theme.Muted; oBtn.TextSize = 13; oBtn.TextXAlignment = "Left"; oBtn.BorderSizePixel = 0
                        oBtn.MouseEnter:Connect(function() TweenService:Create(oBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Hover, TextColor3 = Theme.Text}):Play() end)
                        oBtn.MouseLeave:Connect(function() TweenService:Create(oBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element, TextColor3 = Theme.Muted}):Play() end)
                        oBtn.MouseButton1Click:Connect(function() Val.Text = opt; DropMenu:Destroy(); if callback then callback(opt) end end)
                    end
                end)
            end

            function ElementFunctions:AddArrow(txt, callback)
               local F = Instance.new("Frame", Container); F.Size = UDim2.new(1, 0, 0, 24); F.BackgroundTransparency = 1
               local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(1, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
               local A = Instance.new("TextButton", F); A.Size = UDim2.new(0, 20, 1, 0); A.Position = UDim2.new(1, 0, 0, 0); A.AnchorPoint = Vector2.new(1,0); A.BackgroundTransparency = 1; A.Text = ">"; A.Font = "GothamBold"; A.TextColor3 = Theme.Muted; A.TextSize = 16
               A.MouseButton1Click:Connect(function() if callback then callback() end end)
            end

            return ElementFunctions
        end

        local PageGrid = Instance.new("UIGridLayout", Page); PageGrid.CellSize = UDim2.new(0.485, 0, 0, 320); PageGrid.CellPadding = UDim2.new(0.02, 0, 0, 15)
        local Pad = Instance.new("UIPadding", Page); Pad.PaddingTop = UDim.new(0, 160); Pad.PaddingLeft = UDim.new(0, 10); Pad.PaddingRight = UDim.new(0, 10)
        
        return TabFunctions
    end
    return WindowFunctions
end

return Library
