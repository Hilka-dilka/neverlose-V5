
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
    Element = Color3.fromRGB(28, 30, 40)
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
    ScreenGui.Name = "Neverlose_V5_Interactive"
    ScreenGui.IgnoreGuiInset = true

    local Overlay = Instance.new("Frame", ScreenGui)
    Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundTransparency = 1; Overlay.ZIndex = 500

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 850, 0, 600)
    Main.Position = UDim2.new(0.5, -425, 0.5, -300)
    Main.BackgroundColor3 = Theme.Main
    ApplyStyle(Main, 10, true)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 200, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    ApplyStyle(Sidebar, 10)
    MakeDraggable(Main, Sidebar)

    local Logo = Instance.new("Frame", Sidebar)
    Logo.Size = UDim2.new(1, 0, 0, 80); Logo.BackgroundTransparency = 1
    local Icon = Instance.new("ImageLabel", Logo)
    Icon.Size = UDim2.new(0, 32, 0, 32); Icon.Position = UDim2.new(0, 20, 0, 22); Icon.Image = "rbxassetid://78953354249507"; Icon.BackgroundTransparency = 1
    local Title = Instance.new("TextLabel", Logo); Title.Text = "Neverlose"; Title.Position = UDim2.new(0, 55, 0, 22); Title.Font = "GothamBold"; Title.TextColor3 = Theme.Text; Title.TextSize = 16; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

    local TabScroll = Instance.new("Frame", Sidebar)
    TabScroll.Size = UDim2.new(1, 0, 1, -100); TabScroll.Position = UDim2.new(0, 0, 0, 80); TabScroll.BackgroundTransparency = 1
    local TabListLayout = Instance.new("UIListLayout", TabScroll); TabListLayout.SortOrder = "LayoutOrder"; TabListLayout.Padding = UDim.new(0, 2)

    local ContentArea = Instance.new("Frame", Main)
    ContentArea.Size = UDim2.new(1, -220, 1, -80); ContentArea.Position = UDim2.new(0, 210, 0, 70); ContentArea.BackgroundTransparency = 1; ContentArea.ClipsDescendants = true

    local Tabs = {}
    local Window = {}

    local function CreateSubWindow(name)
        local Sub = Instance.new("Frame", Main)
        Sub.Size = UDim2.new(0, 250, 0, 350)
        Sub.Position = UDim2.new(1, 15, 0.1, 0)
        Sub.BackgroundColor3 = Theme.Group
        Sub.Visible = false; ApplyStyle(Sub, 8, true)
        local Header = Instance.new("TextLabel", Sub); Header.Text = name; Header.Size = UDim2.new(1, -20, 0, 40); Header.Position = UDim2.new(0, 15, 0, 0); Header.Font = "GothamBold"; Header.TextColor3 = Theme.Text; Header.TextSize = 14; Header.TextXAlignment = "Left"; Header.BackgroundTransparency = 1
        local Container = Instance.new("Frame", Sub); Container.Size = UDim2.new(1, -20, 1, -50); Container.Position = UDim2.new(0, 10, 0, 40); Container.BackgroundTransparency = 1
        Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

        local function SetupCloseOnOutside()
            local Close; Close = UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and Sub.Visible then
                    local mousePos = i.Position; local subPos = Sub.AbsolutePosition; local subSize = Sub.AbsoluteSize
                    if mousePos.X < subPos.X or mousePos.X > subPos.X + subSize.X or mousePos.Y < subPos.Y or mousePos.Y > subPos.Y + subSize.Y then
                        Sub.Visible = false; Close:Disconnect()
                    end
                end
            end)
        end
        return Sub, Container, SetupCloseOnOutside
    end

    function Window:AddCategory(catName)
        Library.LayoutOrderNum = Library.LayoutOrderNum + 1
        local CatLabel = Instance.new("TextLabel", TabScroll)
        CatLabel.Size = UDim2.new(1, 0, 0, 35); CatLabel.Text = "      " .. catName:upper(); CatLabel.Font = "GothamBold"; CatLabel.TextColor3 = Theme.Muted; CatLabel.TextSize = 10; CatLabel.TextXAlignment = "Left"; CatLabel.BackgroundTransparency = 1; CatLabel.LayoutOrder = Library.LayoutOrderNum
    end

    function Window:AddTab(tabName, iconId, iconW, iconH)
        Library.LayoutOrderNum = Library.LayoutOrderNum + 1
        local Btn = Instance.new("TextButton", TabScroll)
        Btn.Size = UDim2.new(1, -30, 0, 38); Btn.Position = UDim2.new(0, 15, 0, 0); Btn.BackgroundColor3 = Theme.Element; Btn.BackgroundTransparency = 1; Btn.Font = "GothamMedium"; Btn.TextColor3 = Theme.Muted; Btn.TextSize = 13; Btn.AutoButtonColor = false; Btn.LayoutOrder = Library.LayoutOrderNum; ApplyStyle(Btn, 6)
        local Highlight = Instance.new("Frame", Btn); Highlight.Size = UDim2.new(1, 0, 1, 0); Highlight.BackgroundColor3 = Theme.Accent; Highlight.BackgroundTransparency = 1; Highlight.ZIndex = 0; ApplyStyle(Highlight, 6)
        
        local TabIcon
        if iconId then
            TabIcon = Instance.new("ImageLabel", Btn); TabIcon.Size = UDim2.new(0, iconW or 16, 0, iconH or 16); TabIcon.Position = UDim2.new(0, 10, 0.5, -(iconH or 16)/2); TabIcon.Image = "rbxassetid://" .. iconId; TabIcon.BackgroundTransparency = 1
            Btn.Text = "          " .. tabName
        end
        
        local Page = Instance.new("Frame", ContentArea); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1
        local Grid = Instance.new("UIGridLayout", Page); Grid.FillDirection = "Horizontal"; Grid.CellSize = UDim2.new(0.485, 0, 0, 280); Grid.CellPadding = UDim2.new(0.02, 0, 0, 15)

        Btn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do 
                t.P.Visible = false 
                t.B.TextColor3 = Theme.Muted
                t.H.BackgroundTransparency = 1
                if t.Icon then t.Icon.ImageColor3 = Color3.new(1, 1, 1) end
            end
            Page.Visible = true; Btn.TextColor3 = Theme.Text; Highlight.BackgroundTransparency = 0.3
        end)
        
        Btn.MouseEnter:Connect(function() 
            if Page.Visible then
                Btn.TextColor3 = Theme.Text
                if TabIcon then TabIcon.ImageColor3 = Color3.new(1, 1, 1) end
            else 
                Highlight.BackgroundTransparency = 0.5 
                Btn.TextColor3 = Theme.Accent
                if TabIcon then TabIcon.ImageColor3 = Theme.Accent end
            end 
        end)
        
        Btn.MouseLeave:Connect(function() 
            if Page.Visible then
                Btn.TextColor3 = Theme.Text
                if TabIcon then TabIcon.ImageColor3 = Color3.new(1, 1, 1) end
            else 
                Highlight.BackgroundTransparency = 1 
                Btn.TextColor3 = Theme.Muted
                if TabIcon then TabIcon.ImageColor3 = Color3.new(1, 1, 1) end
            end 
        end)

        table.insert(Tabs, {P = Page, B = Btn, H = Highlight, I = TabIcon})
        if #Tabs == 1 then Page.Visible = true; Btn.TextColor3 = Theme.Text; Highlight.BackgroundTransparency = 0.3 end

        local Tab = {}
        function Tab:AddGroup(title)
            local G = Instance.new("Frame", Page); G.BackgroundColor3 = Theme.Group; ApplyStyle(G, 8, true)
            local GT = Instance.new("TextLabel", G); GT.Text = title:upper(); GT.Size = UDim2.new(1, -30, 0, 30); GT.Position = UDim2.new(0, 15, 0, 5); GT.Font = "GothamBold"; GT.TextColor3 = Theme.Muted; GT.TextSize = 10; GT.TextXAlignment = "Left"; GT.BackgroundTransparency = 1
            local C = Instance.new("Frame", G); C.Size = UDim2.new(1, -30, 1, -45); C.Position = UDim2.new(0, 15, 0, 40); C.BackgroundTransparency = 1
            Instance.new("UIListLayout", C).Padding = UDim.new(0, 10)
            
            local function Internal(container)
                local E = {}

                function E:AddToggle(txt, callback)
                    local state = false
                    local F = Instance.new("Frame", container); F.Size = UDim2.new(1, 0, 0, 24); F.BackgroundTransparency = 1
                    local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(1, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 13; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                    local Sw = Instance.new("TextButton", F); Sw.Size = UDim2.new(0, 34, 0, 16); Sw.Position = UDim2.new(1, 0, 0.5, 0); Sw.AnchorPoint = Vector2.new(1,0.5); Sw.BackgroundColor3 = Theme.Element; Sw.Text = ""; ApplyStyle(Sw, 10, true)
                    local D = Instance.new("Frame", Sw); D.Size = UDim2.new(0, 10, 0, 10); D.Position = UDim2.new(0, 3, 0.5, -5); D.BackgroundColor3 = Theme.Muted; ApplyStyle(D, 10)
                    Sw.MouseButton1Click:Connect(function()
                        state = not state
                        TweenService:Create(D, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5), BackgroundColor3 = state and Color3.new(1,1,1) or Theme.Muted}):Play()
                        TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.Element}):Play()
                        callback(state)
                    end)
                    return F
                end

                -- ИСПРАВЛЕННЫЙ СЛАЙДЕР
                function E:AddSlider(txt, min, max, suffix, callback)
                    local F = Instance.new("Frame", container); F.Size = UDim2.new(1, 0, 0, 26); F.BackgroundTransparency = 1
                    local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(0.4, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 13; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                    
                    local Bar = Instance.new("Frame", F); Bar.Size = UDim2.new(0.35, 0, 0, 4); Bar.Position = UDim2.new(0.45, 0, 0.5, -2); Bar.BackgroundColor3 = Theme.Element; ApplyStyle(Bar, 2)
                    local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new(0, 0, 1, 0); Fill.BackgroundColor3 = Theme.Accent; ApplyStyle(Fill, 2)
                    local Knob = Instance.new("Frame", F); Knob.Size = UDim2.new(0, 10, 0, 10); Knob.Position = UDim2.new(0.45, -5, 0.5, -5); Knob.BackgroundColor3 = Color3.new(1,1,1); ApplyStyle(Knob, 10); Knob.ZIndex = 5
                    
                    local Box = Instance.new("TextBox", F); Box.Size = UDim2.new(0, 45, 0, 20); Box.Position = UDim2.new(1, 0, 0.5, 0); Box.AnchorPoint = Vector2.new(1, 0.5); Box.BackgroundColor3 = Theme.Element; Box.Text = tostring(min); Box.Font = "GothamMedium"; Box.TextColor3 = Theme.Accent; Box.TextSize = 11; ApplyStyle(Box, 4, true)

                    local function update(val)
                        val = math.clamp(val, min, max); local p = (val - min) / (max - min)
                        Fill.Size = UDim2.new(p, 0, 1, 0)
                        Knob.Position = UDim2.new(0.45 + 0.35 * p, -5, 0.5, -5)
                        Box.Text = tostring(val) .. suffix; callback(val)
                    end
                    
                    local function setFromClick(xPos)
                        local barStart = Bar.AbsolutePosition.X
                        local barEnd = barStart + Bar.AbsoluteSize.X
                        local p = math.clamp((xPos - barStart) / (barEnd - barStart), 0, 1)
                        local val = math.floor(min + (max - min) * p + 0.5)
                        update(val)
                    end
                    
                    Bar.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            setFromClick(UserInputService:GetMouseLocation().X)
                            local move = UserInputService.InputChanged:Connect(function(i) 
                                if i.UserInputType == Enum.UserInputType.MouseMovement then
                                    setFromClick(UserInputService:GetMouseLocation().X)
                                end 
                            end)
                            local release; release = UserInputService.InputEnded:Connect(function(i) 
                                if i.UserInputType == Enum.UserInputType.MouseButton1 then 
                                    move:Disconnect(); release:Disconnect() 
                                end 
                            end)
                        end
                    end)
                    
                    Knob.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local move = UserInputService.InputChanged:Connect(function(i) 
                                if i.UserInputType == Enum.UserInputType.MouseMovement then
                                    setFromClick(UserInputService:GetMouseLocation().X)
                                end 
                            end)
                            local release; release = UserInputService.InputEnded:Connect(function(i) 
                                if i.UserInputType == Enum.UserInputType.MouseButton1 then 
                                    move:Disconnect(); release:Disconnect() 
                                end 
                            end)
                        end
                    end)
                    
                    Box.FocusLost:Connect(function() 
                        local cleaned = Box.Text:gsub(suffix, ""):gsub("[^%d.-]", "")
                        local num = tonumber(cleaned)
                        if num then update(num) else update(min) end
                    end)
                    
                    update(min)
                    return F
                end

                function E:AddDropdown(txt, options, callback)
                    local F = Instance.new("Frame", container); F.Size = UDim2.new(1, 0, 0, 24); F.BackgroundTransparency = 1
                    local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(0.5, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                    
                    local Box = Instance.new("TextButton", F)
                    Box.Size = UDim2.new(0.45, 0, 0, 20); Box.Position = UDim2.new(1, 0, 0, 2); Box.AnchorPoint = Vector2.new(1, 0); Box.BackgroundColor3 = Theme.Element; Box.Text = ""; ApplyStyle(Box, 4, true)
                    
                    local S = Instance.new("TextLabel", Box); S.Text = options[1]; S.Size = UDim2.new(1, -10, 1, 0); S.Position = UDim2.new(0, 8, 0, 0); S.Font = "GothamMedium"; S.TextColor3 = Color3.new(1,1,1); S.TextSize = 12; S.TextXAlignment = "Left"; S.BackgroundTransparency = 1

                    Box.MouseButton1Click:Connect(function()
                        local DropMenu = Instance.new("Frame", Overlay)
                        DropMenu.Size = UDim2.new(0, Box.AbsoluteSize.X, 0, #options * 25 + 10)
                        DropMenu.BackgroundColor3 = Theme.Element; ApplyStyle(DropMenu, 6, true)
                        Instance.new("UIListLayout", DropMenu).Padding = UDim.new(0, 2)
                        Instance.new("UIPadding", DropMenu).PaddingTop = UDim.new(0, 5)

                        for i, opt in ipairs(options) do
                            local OptBtn = Instance.new("TextButton", DropMenu)
                            OptBtn.Size = UDim2.new(1, 0, 0, 22); OptBtn.BackgroundTransparency = 1; OptBtn.Text = "  " .. opt; OptBtn.Font = "GothamMedium"; OptBtn.TextColor3 = Color3.new(1, 1, 1); OptBtn.TextSize = 12; OptBtn.TextXAlignment = "Left"; OptBtn.ZIndex = 21; OptBtn.AutoButtonColor = false
                            
                            OptBtn.MouseEnter:Connect(function()
                                OptBtn.TextColor3 = Theme.Accent
                            end)
                            OptBtn.MouseLeave:Connect(function()
                                OptBtn.TextColor3 = Color3.new(1, 1, 1)
                            end)
                            
                            OptBtn.MouseButton1Click:Connect(function()
                                if Close and Close.Disconnect then Close:Disconnect() end
                                DropMenu:Destroy()
                                S.Text = opt
                                if callback then callback(opt) end
                            end)
                            
                            -- Добавляем линию-разделитель между элементами
                            if i < #options then
                                local Sep = Instance.new("Frame", DropMenu)
                                Sep.Size = UDim2.new(1, -16, 0, 1)
                                Sep.Position = UDim2.new(0, 8, 1, -1)
                                Sep.BackgroundColor3 = Theme.Outline
                                Sep.BorderSizePixel = 0
                                Sep.ZIndex = 22
                            end
                        end
                        
                        DropMenu.Position = UDim2.new(0, Box.AbsolutePosition.X + Box.AbsoluteSize.X/2 - DropMenu.AbsoluteSize.X/2, 0, Box.AbsolutePosition.Y + Box.AbsoluteSize.Y)
                        DropMenu.ZIndex = 20
                        
                        local Close; Close = UserInputService.InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                                local mousePos = i.Position
                                local dropPos = DropMenu.AbsolutePosition
                                local dropSize = DropMenu.AbsoluteSize
                                if mousePos.X < dropPos.X or mousePos.X > dropPos.X + dropSize.X or
                                   mousePos.Y < dropPos.Y or mousePos.Y > dropPos.Y + dropSize.Y then
                                    DropMenu:Destroy()
                                    Close:Disconnect()
                                end
                            end
                        end)
                    end)
                end

                function E:AddArrow(txt)
                    local F = Instance.new("Frame", container); F.Size = UDim2.new(1, 0, 0, 24); F.BackgroundTransparency = 1
                    local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(1, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                    local A = Instance.new("TextButton", F); A.Size = UDim2.new(0, 20, 1, 0); A.Position = UDim2.new(1, 0, 0, 0); A.AnchorPoint = Vector2.new(1,0); A.BackgroundTransparency = 1; A.Text = ">"; A.Font = "GothamBold"; A.TextColor3 = Theme.Muted; A.TextSize = 16
                    
                    local Sub, SubContainer, SetupClose = CreateSubWindow(txt)
                    A.MouseButton1Click:Connect(function() 
                        Sub.Visible = not Sub.Visible
                        if Sub.Visible then SetupClose() end
                    end)
                    return Internal(SubContainer)
                end

                function E:AddColorPicker(txt, default, callback)
                    local F = Instance.new("Frame", container); F.Size = UDim2.new(1, 0, 0, 24); F.BackgroundTransparency = 1
                    local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(0.8, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 13; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                    
                    local CP = Instance.new("TextButton", F); CP.Size = UDim2.new(0, 18, 0, 18); CP.Position = UDim2.new(1, 0, 0.5, -9); CP.AnchorPoint = Vector2.new(1, 0.5); CP.BackgroundColor3 = default; CP.Text = ""; ApplyStyle(CP, 4, true)
                    CP.MouseButton1Click:Connect(function() 
                        local nextC = Color3.fromHSV(math.random(), 1, 1)
                        CP.BackgroundColor3 = nextC
                        callback(nextC)
                    end)
                    return F
                end

                function E:AddCombo(txt, config)
                    -- config = {
                    --   toggle = true/false,
                    --   color = true/false,
                    --   dropdown = {"A","B"},
                    --   defaultColor = Color3.new(),
                    --   callbacks = {
                    --       toggle = function() end,
                    --       color = function() end,
                    --       dropdown = function() end
                    --   }
                    -- }

                    local F = Instance.new("Frame", container)
                    F.Size = UDim2.new(1, 0, 0, 26)
                    F.BackgroundTransparency = 1

                    local L = Instance.new("TextLabel", F)
                    L.Text = txt
                    L.Size = UDim2.new(0.4, 0, 1, 0)
                    L.Font = "GothamMedium"
                    L.TextColor3 = Theme.Text
                    L.TextSize = 13
                    L.TextXAlignment = Enum.TextXAlignment.Left
                    L.TextYAlignment = Enum.TextYAlignment.Center
                    L.BackgroundTransparency = 1

                    local offset = 0

                    -- DROPDOWN
                    if config.dropdown then
                        local Box = Instance.new("TextButton", F)
                        Box.Size = UDim2.new(0, 110, 0, 22)
                        Box.AnchorPoint = Vector2.new(1, 0.5)
                        Box.Position = UDim2.new(1, -offset, 0.5, 0)
                        Box.BackgroundColor3 = Theme.Element
                        Box.Text = ""
                        ApplyStyle(Box, 4, true)

                        local current = config.dropdown[1]

                        local S = Instance.new("TextLabel", Box)
                        S.Text = current
                        S.Size = UDim2.new(1, -10, 1, 0)
                        S.Position = UDim2.new(0, 8, 0, 0)
                        S.Font = "GothamMedium"
                        S.TextColor3 = Color3.new(1,1,1)
                        S.TextSize = 12
                        S.TextXAlignment = Enum.TextXAlignment.Left
                        S.TextYAlignment = Enum.TextYAlignment.Center
                        S.BackgroundTransparency = 1

                        Box.MouseButton1Click:Connect(function()
                            local DropMenu = Instance.new("Frame", Overlay)
                            DropMenu.Size = UDim2.new(0, Box.AbsoluteSize.X, 0, #config.dropdown * 24 + 8)
                            DropMenu.Position = UDim2.new(
                                0,
                                Box.AbsolutePosition.X,
                                0,
                                Box.AbsolutePosition.Y + Box.AbsoluteSize.Y + 2
                            )
                            DropMenu.BackgroundColor3 = Theme.Element
                            DropMenu.BackgroundTransparency = 0
                            DropMenu.ZIndex = 50
                            ApplyStyle(DropMenu, 6, true)

                            local Layout = Instance.new("UIListLayout", DropMenu)
                            Layout.Padding = UDim.new(0, 2)

                            for i, opt in ipairs(config.dropdown) do
                                -- Добавляем линию-разделитель перед элементом (кроме первого)
                                if i > 1 then
                                    local Sep = Instance.new("Frame", DropMenu)
                                    Sep.Size = UDim2.new(1, -16, 0, 1)
                                    Sep.BackgroundColor3 = Theme.Outline
                                    Sep.BorderSizePixel = 0
                                    Sep.ZIndex = 52
                                end
                                
                                local Opt = Instance.new("TextButton", DropMenu)
                                Opt.Size = UDim2.new(1, 0, 0, 22)
                                Opt.BackgroundColor3 = Theme.Element
                                Opt.BackgroundTransparency = 0.5
                                Opt.Text = "   " .. opt
                                Opt.Font = "GothamMedium"
                                Opt.TextSize = 12
                                Opt.TextColor3 = Color3.new(1,1,1)
                                Opt.TextXAlignment = Enum.TextXAlignment.Left
                                Opt.ZIndex = 51
                                Opt.AutoButtonColor = false
                                
                                -- Подсветка при наведении (как в основном дропдауне)
                                Opt.MouseEnter:Connect(function()
                                    Opt.TextColor3 = Theme.Accent
                                    Opt.BackgroundTransparency = 0
                                end)
                                
                                Opt.MouseLeave:Connect(function()
                                    Opt.TextColor3 = Color3.new(1,1,1)
                                    Opt.BackgroundTransparency = 0.5
                                end)
                                
                                Opt.MouseButton1Click:Connect(function()
                                    current = opt
                                    S.Text = opt
                                    DropMenu:Destroy()
                                    if config.callbacks and config.callbacks.dropdown then
                                        config.callbacks.dropdown(opt)
                                    end
                                end)
                            end
                        end)

                        offset = offset + 120
                    end

                    -- COLOR
                    if config.color then
                        local CP = Instance.new("TextButton", F)
                        CP.Size = UDim2.new(0, 18, 0, 18)
                        CP.AnchorPoint = Vector2.new(1, 0.5)
                        CP.Position = UDim2.new(1, -offset, 0.5, 0)
                        CP.BackgroundColor3 = config.defaultColor or Color3.new(1,1,1)
                        CP.Text = ""
                        ApplyStyle(CP, 4, true)

                        CP.MouseButton1Click:Connect(function()
                            local nextC = Color3.fromHSV(math.random(),1,1)
                            CP.BackgroundColor3 = nextC
                            if config.callbacks and config.callbacks.color then
                                config.callbacks.color(nextC)
                            end
                        end)

                        offset = offset + 28
                    end

                    -- TOGGLE
                    if config.toggle then
                        local state = false

                        local Sw = Instance.new("TextButton", F)
                        Sw.Size = UDim2.new(0, 34, 0, 16)
                        Sw.AnchorPoint = Vector2.new(1, 0.5)
                        Sw.Position = UDim2.new(1, -offset, 0.5, 0)
                        Sw.BackgroundColor3 = Theme.Element
                        Sw.Text = ""
                        ApplyStyle(Sw, 10, true)

                        local D = Instance.new("Frame", Sw)
                        D.Size = UDim2.new(0, 10, 0, 10)
                        D.Position = UDim2.new(0, 3, 0.5, -5)
                        D.BackgroundColor3 = Theme.Muted
                        ApplyStyle(D, 10)

                        Sw.MouseButton1Click:Connect(function()
                            state = not state

                            TweenService:Create(D, TweenInfo.new(0.2), {
                                Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
                            }):Play()

                            TweenService:Create(Sw, TweenInfo.new(0.2), {
                                BackgroundColor3 = state and Theme.Accent or Theme.Element
                            }):Play()

                            if config.callbacks and config.callbacks.toggle then
                                config.callbacks.toggle(state)
                            end
                        end)
                    end

                    return F
                end

                return E
            end
            return Internal(C)
        end
        return Tab
    end
    return Window
end



-- ==========================================
-- МЕНЮ И ПРОВЕРКИ
-- ==========================================
local Win = Library:CreateWindow()

-- RAGE
Win:AddCategory("Aimbot")
local Rage = Win:AddTab("Rage", 114138721928267, 17, 17)

-- Rage Main
local RMain = Rage:AddGroup("Main")
RMain:AddToggle("Enabled", function(v) print("Rage master: ", v) end)
RMain:AddToggle("Silent Aim", function(v) print("Silent: ", v) end)
RMain:AddToggle("Automatic Fire", function(v) print("AutoFire: ", v) end)
RMain:AddSlider("Field of View", 0, 100, "°", function(v) print("FOV: ", v) end)

-- Rage Selection
local RSelect = Rage:AddGroup("Selection")
RSelect:AddDropdown("Target", {"closest player", "min health", "highest damage"}, function(v) print("Target: ", v) end)
RSelect:AddDropdown("Hitboxes", {"Head", "Chest", "Stomach", "Arms", "Legs"}, function(v) print("Hitbox: ", v) end)
RSelect:AddSlider("Min Damage", 0, 100, "", function(v) print("MinDmg: ", v) end)

-- Rage Other
local ROther = Rage:AddGroup("Other")
ROther:AddSlider("Delay ms", 0, 100, "ms", function(v) print("Delay: ", v) end)
local NoAim = ROther:AddArrow("No Aim")
NoAim:AddToggle("Jump", function(v) print("NoAim Jump: ", v) end)
NoAim:AddToggle("Fall", function(v) print("NoAim Fall: ", v) end)
NoAim:AddToggle("Wall", function(v) print("NoAim Wall: ", v) end)
ROther:AddToggle("Double Tap", function(v) print("DT: ", v) end)

-- Rage Anti-Aim
local RAA = Rage:AddGroup("Anti-Aim")
RAA:AddToggle("Enabled", function(v) print("AA Master: ", v) end)
local Yaw = RAA:AddArrow("Yaw")
Yaw:AddDropdown("Yaw Mode", {"Off", "Static", "Jitter"}, function(v) print("Yaw Mode: ", v) end)
Yaw:AddSlider("Jitter Speed", 0, 100, "", function(v) print("Jit Speed: ", v) end)

-- LEGIT
local Legit = Win:AddTab("Legit", 121760043006079, 13, 17)
Legit:AddGroup("Status"):AddToggle("В разработке!", function() end)

-- VISUALS
Win:AddCategory("Common")
local Visuals = Win:AddTab("Visuals", 125333486455959, 17, 15)

-- Visuals Enemy
local VEnemy = Visuals:AddGroup("Enemy")
VEnemy:AddToggle("Enabled", function(v) print("ESP: ", v) end)
VEnemy:AddToggle("Offscreen Arrow", function(v) print("Arrow: ", v) end)
VEnemy:AddToggle("Box", function(v) print("Box: ", v) end)
VEnemy:AddToggle("Name", function(v) print("Name: ", v) end)
VEnemy:AddToggle("HealthBar", function(v) print("Health: ", v) end)
VEnemy:AddToggle("Tracers", function(v) print("Tracers: ", v) end)

-- Visuals Enemy Model
local VModel = Visuals:AddGroup("Enemy Model")
-- Player - toggle + colorpicker + dropdown
VModel:AddCombo("Player", {
    toggle = true,
    color = true,
    dropdown = {"Glow","Flat","Metal","ForceField"},
    defaultColor = Color3.fromRGB(165,183,250),
    callbacks = {
        toggle = function(v)
            print("Player Enabled:", v)
        end,
        color = function(c)
            print("Player Color:", c)
        end,
        dropdown = function(m)
            print("Player Material:", m)
        end
    }
})
    
-- Behind Walls - toggle + colorpicker + dropdown  
VModel:AddCombo("Behind Walls", {
    toggle = true,
    color = true,
    dropdown = {"Glow","Flat","Metal","ForceField"},
    defaultColor = Color3.fromRGB(255, 50, 50),
    callbacks = {
        toggle = function(v)
            print("Behind Walls Enabled:", v)
        end,
        color = function(c)
            print("Behind Walls Color:", c)
        end,
        dropdown = function(m)
            print("Behind Walls Material:", m)
        end
    }
})
    
-- Skull Particles - toggle + colorpicker
VModel:AddCombo("Skull Particles", {
    toggle = true,
    color = true,
    defaultColor = Color3.fromRGB(255, 255, 255),
    callbacks = {
        toggle = function(v)
            print("Skull:", v)
        end,
        color = function(c)
            print("Skull Color:", c)
        end
    }
})

-- Visuals World
local VWorld = Visuals:AddGroup("World")
-- Skybox - toggle + colorpicker
VWorld:AddCombo("Skybox", {
    toggle = true,
    color = true,
    defaultColor = Color3.fromRGB(0, 0, 50),
    callbacks = {
        toggle = function(v)
            print("Skybox:", v)
        end,
        color = function(c)
            print("Sky Color:", c)
        end
    }
})
    
-- Light - toggle + colorpicker
VWorld:AddCombo("Light", {
    toggle = true,
    color = true,
    defaultColor = Color3.fromRGB(255, 255, 255),
    callbacks = {
        toggle = function(v)
            print("Light:", v)
        end,
        color = function(c)
            print("Light Color:", c)
        end
    }
})
    
VWorld:AddToggle("No Textures", function(v) print("No Textures: ", v) end)

-- MISC
local Misc = Win:AddTab("Miscellaneous", 130609685961592, 15, 15)

-- Miscellaneous Movement
local MMove = Misc:AddGroup("Movement")

-- air strafe
local AirStrafeEnabled = false
local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local currentSpeed = 16 -- global speedw
local fastWalkEnabled = false -- Добавляем переменную для отслеживания состояния fast walk

MMove:AddToggle("Air Strafe", function(state)
    AirStrafeEnabled = state
    print("Air Strafe:", state)
end)

-- Функция для получения текущей скорости для air strafe
local function getAirStrafeSpeed()
    if fastWalkEnabled then
        return currentSpeed
    else
        return 16 -- дефолтная скорость
    end
end

-- Обработка респавна для air strafe
Player.CharacterAdded:Connect(function()
    -- Сбрасываем состояние air strafe при респавне если он был включен
    if AirStrafeEnabled then
        -- Небольшая задержка чтобы персонаж загрузился
        task.wait(0.5)
        print("Air Strafe: Active after respawn")
    end
end)

RunService.RenderStepped:Connect(function()
    if not AirStrafeEnabled then return end
    local Character = Player.Character
    if not Character then return end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not HRP then return end

    -- only when jump
    if Humanoid.FloorMaterial ~= Enum.Material.Air then return end

    local moveDir = Vector3.new()
    local lookCFrame = HRP.CFrame

    -- move
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + lookCFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - lookCFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - lookCFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + lookCFrame.RightVector end

    moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)
    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit
        -- Используем скорость в зависимости от состояния fast walk
        local airSpeed = getAirStrafeSpeed()
        HRP.Velocity = Vector3.new(moveDir.X * airSpeed, HRP.Velocity.Y, moveDir.Z * airSpeed)
    end
end)

-- inf jump
local jumping = false

MMove:AddToggle("Infinity Jump", function(v)
    jumping = v
    print("Inf Jump: ", v)
end)

-- Обработка респавна для inf jump
Player.CharacterAdded:Connect(function()
    if jumping then
        task.wait(0.5)
        print("Infinity Jump: Active after respawn")
    end
end)

-- jump request
game:GetService("UserInputService").JumpRequest:Connect(function()
    if jumping and game.Players.LocalPlayer.Character then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- fly
local Fly = MMove:AddArrow("Fly")
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local camera = workspace.CurrentCamera

-- Функция для включения/выключения полета
local function toggleFly(state)
    flying = state
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    
    if flying then
        humanoid.PlatformStand = true
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = hrp
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.P = 3000
        bodyGyro.D = 500
        bodyGyro.Parent = hrp
        
        print("Fly: Enabled")
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        humanoid.PlatformStand = false
        print("Fly: Disabled")
    end
end

Fly:AddToggle("Enabled", function(v) 
    toggleFly(v)
end)

Fly:AddSlider("Fly Speed", 0, 100, "", function(v) 
    flySpeed = v
    print("FlySpd: ", v)
end)

-- fast walk
local FastWalk = MMove:AddArrow("Fast Walk")
local enabled = false

FastWalk:AddToggle("Enabled", function(v) 
	enabled = v
    fastWalkEnabled = v -- Обновляем глобальную переменную
	print("FastWalk: ", v)
	if v and Player.Character then
		Player.Character.Humanoid.WalkSpeed = currentSpeed
	elseif Player.Character then
		Player.Character.Humanoid.WalkSpeed = 16
	end
end)

FastWalk:AddSlider("Speed", 16, 100, "", function(v) 
	currentSpeed = v
	print("FastWalk Speed: ", v)
	-- Если тогл включен, меняем скорость сразу при движении слайдера
	if enabled and Player.Character then
		Player.Character.Humanoid.WalkSpeed = v
	end
end)

-- Обработка респавна для fast walk
Player.CharacterAdded:Connect(function(newCharacter)
    if enabled then
        task.wait(0.5)
        local humanoid = newCharacter:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
            print("FastWalk: Restored after respawn")
        end
    end
end)

-- Управление полетом
RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity and bodyGyro and Player.Character then
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveDirection * flySpeed
        bodyGyro.CFrame = CFrame.new(Vector3.new(0, 0, 0), camera.CFrame.LookVector)
    end
end)

-- Обновление при респавне для fly
Player.CharacterAdded:Connect(function(newCharacter)
    if flying then
        -- Небольшая задержка чтобы персонаж успел загрузиться
        task.wait(0.5)
        toggleFly(true)
    end
end)

-- Miscellaneous Features
local MFeat = Misc:AddGroup("Features")
-- server hop
local serverHopEnabled = false
local noclipEnabled = false
local noclipConnection = nil

MFeat:AddToggle("Server Hop", function(v)
    serverHopEnabled = v
    print("Server Hop: ", v)
    
    if v then
        -- Ищем сервер с наименьшим количеством игроков
        local HttpService = game:GetService("HttpService")
        local placeId = game.PlaceId
        
        -- Получаем список серверов
        local response = request({
            Url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100",
            Method = "GET"
        })
        
        if response and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            local lowestServer = nil
            local lowestPlayers = math.huge
            
            for _, server in ipairs(data.data) do
                -- Проверяем что сервер не полный и не пустой
                if server.playing < server.maxPlayers and server.playing > 0 then
                    if server.playing < lowestPlayers then
                        lowestPlayers = server.playing
                        lowestServer = server
                    end
                end
            end
            
            -- Если нашли подходящий сервер
            if lowestServer then
                print("Найден сервер с " .. lowestServer.playing .. " игроками")
                game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, lowestServer.id, game.Players.LocalPlayer)
            else
                print("Не удалось найти подходящий сервер")
                -- Отключаем тоггл если не нашли сервер
                serverHopEnabled = false
            end
        end
    end
end)

-- Функция для включения/выключения ноклипа
local function toggleNoclip(state)
    noclipEnabled = state
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("Noclip: Enabled")
    else
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        print("Noclip: Disabled")
    end
end

MFeat:AddToggle("Noclip", function(v) 
    toggleNoclip(v)
end)

-- Обработка респавна для noclip
Player.CharacterAdded:Connect(function()
    if noclipEnabled then
        task.wait(0.5)
        print("Noclip: Active after respawn")
        -- Ноклип автоматически восстановится через noclipConnection
    end
end)

-- Anti-AFK
local antiAfkEnabled = false
local antiAfkConnection = nil
local virtualUser = game:GetService("VirtualUser")

MFeat:AddToggle("Anti-AFK Kick", function(v) 
    antiAfkEnabled = v
    print("Anti-AFK: ", v)
    
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
    
    if antiAfkEnabled then
        -- Имитируем движение каждые 30 секунд
        antiAfkConnection = game:GetService("RunService").Stepped:Connect(function()
            if Player.Character then
                local humanoid = Player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    virtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(0.1)
                    virtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
        end)
    end
end)

-- Hit Sound
local hitSoundConnection = nil
local currentHitSound = "Off"

MFeat:AddDropdown("Hit Sound", {"Off", "Bell", "Clap"}, function(v) 
    print("Sound: ", v)
    currentHitSound = v
    
    -- Удаляем предыдущее подключение если было
    if hitSoundConnection then
        hitSoundConnection:Disconnect()
        hitSoundConnection = nil
    end
    
    if v ~= "Off" and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        -- Выбираем звук
        local soundId = ""
        if v == "Bell" then
            soundId = "rbxassetid://9120387138" -- Звук колокольчика
        elseif v == "Clap" then
            soundId = "rbxassetid://9120387432" -- Звук хлопка
        end
        
        -- Подключаемся к событию получения урона
        hitSoundConnection = Player.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            local humanoid = Player.Character.Humanoid
            if humanoid.Health < humanoid.MaxHealth then
                local sound = Instance.new("Sound")
                sound.SoundId = soundId
                sound.Volume = 0.5
                sound.Parent = Player.Character.Head
                sound:Play()
                
                -- Удаляем звук после воспроизведения
                game:GetService("Debris"):AddItem(sound, 2)
            end
        end)
    end
end)

-- Обработка респавна для hit sound
Player.CharacterAdded:Connect(function(newCharacter)
    task.wait(0.5)
    
    -- Восстанавливаем hit sound если он был включен
    if currentHitSound ~= "Off" then
        if hitSoundConnection then
            hitSoundConnection:Disconnect()
            hitSoundConnection = nil
        end
        
        local humanoid = newCharacter:FindFirstChild("Humanoid")
        if humanoid then
            local soundId = ""
            if currentHitSound == "Bell" then
                soundId = "rbxassetid://9120387138"
            elseif currentHitSound == "Clap" then
                soundId = "rbxassetid://9120387432"
            end
            
            hitSoundConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health < humanoid.MaxHealth then
                    local sound = Instance.new("Sound")
                    sound.SoundId = soundId
                    sound.Volume = 0.5
                    sound.Parent = newCharacter.Head
                    sound:Play()
                    
                    game:GetService("Debris"):AddItem(sound, 2)
                end
            end)
        end
    end
end)

print("Neverlose Loaded.")

return Library
