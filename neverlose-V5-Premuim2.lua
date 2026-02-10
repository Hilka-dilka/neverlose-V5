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

    -- Слой для всплывающих окон (Dropdowns)
    local Overlay = Instance.new("Frame", ScreenGui)
    Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundTransparency = 1; Overlay.ZIndex+10

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

    -- Логотип
    local Logo = Instance.new("Frame", Sidebar)
    Logo.Size = UDim2.new(1, 0, 0, 80); Logo.BackgroundTransparency = 1
    local Icon = Instance.new("Frame", Logo); Icon.Size = UDim2.new(0, 26, 0, 26); Icon.Position = UDim2.new(0, 20, 0, 25); Icon.BackgroundColor3 = Theme.Accent; ApplyStyle(Icon, 6)
    local NL = Instance.new("TextLabel", Icon); NL.Text = "NL"; NL.Size = UDim2.new(1,0,1,0); NL.Font = "GothamBold"; NL.TextColor3 = Color3.new(1,1,1); NL.TextSize = 13; NL.BackgroundTransparency = 1
    local Title = Instance.new("TextLabel", Logo); Title.Text = "Neverlose"; Title.Position = UDim2.new(0, 55, 0, 22); Title.Font = "GothamBold"; Title.TextColor3 = Theme.Text; Title.TextSize = 16; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1
    local Sub = Instance.new("TextLabel", Logo); Sub.Text = "Roblox"; Sub.Position = UDim2.new(0, 55, 0, 38); Sub.Font = "Gotham"; Sub.TextColor3 = Theme.Muted; Sub.TextSize = 11; Sub.TextXAlignment = "Left"; Sub.BackgroundTransparency = 1

    local TabScroll = Instance.new("ScrollingFrame", Sidebar)
    TabScroll.Size = UDim2.new(1, 0, 1, -100); TabScroll.Position = UDim2.new(0, 0, 0, 80); TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabScroll); TabListLayout.SortOrder = "LayoutOrder"; TabListLayout.Padding = UDim.new(0, 2)

    local ContentArea = Instance.new("Frame", Main)
    ContentArea.Size = UDim2.new(1, -220, 1, -80); ContentArea.Position = UDim2.new(0, 210, 0, 70); ContentArea.BackgroundTransparency = 1

    local Tabs = {}
    local Window = {}

    -- Функция для создания бокового окна (Скриншот 74)
    local function CreateSubWindow(name)
        local Sub = Instance.new("Frame", Main)
        Sub.Size = UDim2.new(0, 250, 0, 350)
        Sub.Position = UDim2.new(1, 15, 0, 0) -- Справа от основного меню
        Sub.BackgroundColor3 = Theme.Group
        Sub.Visible = false
        ApplyStyle(Sub, 8, true)

        local Header = Instance.new("TextLabel", Sub)
        Header.Text = name; Header.Size = UDim2.new(1, -20, 0, 40); Header.Position = UDim2.new(0, 15, 0, 0)
        Header.Font = "GothamBold"; Header.TextColor3 = Theme.Text; Header.TextSize = 14; Header.TextXAlignment = "Left"; Header.BackgroundTransparency = 1

        local Container = Instance.new("Frame", Sub)
        Container.Size = UDim2.new(1, -20, 1, -50); Container.Position = UDim2.new(0, 10, 0, 40); Container.BackgroundTransparency = 1
        Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

        return Sub, Container
    end

    function Window:AddCategory(catName)
        Library.LayoutOrderNum = Library.LayoutOrderNum + 1
        local CatLabel = Instance.new("TextLabel", TabScroll)
        CatLabel.Size = UDim2.new(1, 0, 0, 35); CatLabel.Text = "      " .. catName:upper(); CatLabel.Font = "GothamBold"; CatLabel.TextColor3 = Theme.Muted; CatLabel.TextSize = 10; CatLabel.TextXAlignment = "Left"; CatLabel.BackgroundTransparency = 1; CatLabel.LayoutOrder = Library.LayoutOrderNum
    end

    function Window:AddTab(tabName)
        Library.LayoutOrderNum = Library.LayoutOrderNum + 1
        local Btn = Instance.new("TextButton", TabScroll)
        Btn.Size = UDim2.new(1, -30, 0, 38); Btn.Position = UDim2.new(0, 15, 0, 0); Btn.BackgroundColor3 = Theme.Element; Btn.BackgroundTransparency = 1; Btn.Text = "          " .. tabName; Btn.Font = "GothamMedium"; Btn.TextColor3 = Theme.Muted; Btn.TextSize = 13; Btn.TextXAlignment = "Left"; Btn.AutoButtonColor = false; Btn.LayoutOrder = Library.LayoutOrderNum; ApplyStyle(Btn, 6)

        local Page = Instance.new("Frame", ContentArea); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1
        local Grid = Instance.new("UIGridLayout", Page); Grid.CellSize = UDim2.new(0.485, 0, 0, 260); Grid.CellPadding = UDim2.new(0.02, 0, 0, 15)

        Btn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do t.P.Visible = false; t.B.TextColor3 = Theme.Muted; t.B.BackgroundTransparency = 1 end
            Page.Visible = true; Btn.TextColor3 = Theme.Text; Btn.BackgroundTransparency = 0.5
        end)

        table.insert(Tabs, {P = Page, B = Btn})
        if #Tabs == 1 then Page.Visible = true; Btn.TextColor3 = Theme.Text; Btn.BackgroundTransparency = 0.5 end

        local Tab = {}
        function Tab:AddGroup(title)
            local G = Instance.new("Frame", Page); G.BackgroundColor3 = Theme.Group; ApplyStyle(G, 8, true)
            local GT = Instance.new("TextLabel", G); GT.Text = title:upper(); GT.Size = UDim2.new(1, -30, 0, 30); GT.Position = UDim2.new(0, 15, 0, 5); GT.Font = "GothamBold"; GT.TextColor3 = Theme.Muted; GT.TextSize = 10; GT.TextXAlignment = "Left"; GT.BackgroundTransparency = 1
            local C = Instance.new("Frame", G); C.Size = UDim2.new(1, -30, 1, -45); C.Position = UDim2.new(0, 15, 0, 40); C.BackgroundTransparency = 1
            Instance.new("UIListLayout", C).Padding = UDim.new(0, 10)

            local function InternalElements(container)
                local E = {}
                function E:AddToggle(txt, callback)
                    local state = false
                    local F = Instance.new("Frame", container); F.Size = UDim2.new(1, 0, 0, 26); F.BackgroundTransparency = 1
                    local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(1, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                    local Sw = Instance.new("TextButton", F); Sw.Size = UDim2.new(0, 38, 0, 18); Sw.Position = UDim2.new(1, 0, 0.5, 0); Sw.AnchorPoint = Vector2.new(1,0.5); Sw.BackgroundColor3 = Theme.Element; Sw.Text = ""; ApplyStyle(Sw, 10, true)
                    local D = Instance.new("Frame", Sw); D.Size = UDim2.new(0, 12, 0, 12); D.Position = UDim2.new(0, 3, 0.5, -6); D.BackgroundColor3 = Theme.Muted; ApplyStyle(D, 10)
                    Sw.MouseButton1Click:Connect(function()
                        state = not state
                        TweenService:Create(D, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = Color3.new(1,1,1)}):Play()
                        TweenService:Create(Sw, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.Element}):Play()
                        if callback then callback(state) end
                    end)
                end

                function E:AddSlider(txt, min, max, suffix, callback)
                    local F = Instance.new("Frame", container); F.Size = UDim2.new(1, 0, 0, 35); F.BackgroundTransparency = 1
                    local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(0.6, 0, 0, 18); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                    local V = Instance.new("TextLabel", F); V.Text = tostring(min)..suffix; V.Size = UDim2.new(0.4, 0, 0, 18); V.Position = UDim2.new(0.6,0,0,0); V.Font = "GothamMedium"; V.TextColor3 = Theme.Accent; V.TextSize = 13; V.TextXAlignment = "Right"; V.BackgroundTransparency = 1
                    local Bar = Instance.new("Frame", F); Bar.Size = UDim2.new(1, 0, 0, 4); Bar.Position = UDim2.new(0, 0, 0, 28); Bar.BackgroundColor3 = Theme.Element; ApplyStyle(Bar, 2)
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

                -- РАБОЧИЙ ДРОПДАУН (Скриншот 73)
                function E:AddDropdown(txt, options, callback)
                    local F = Instance.new("Frame", container); F.Size = UDim2.new(1, 0, 0, 24); F.BackgroundTransparency = 1
                    local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(0.5, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                    
                    local Box = Instance.new("TextButton", F)
                    Box.Size = UDim2.new(0.45, 0, 1, 0); Box.Position = UDim2.new(1, 0, 0, 0); Box.AnchorPoint = Vector2.new(1,0); Box.BackgroundColor3 = Theme.Element; Box.Text = ""; ApplyStyle(Box, 4, true)
                    
                    local S = Instance.new("TextLabel", Box); S.Text = options[1]; S.Size = UDim2.new(1, -10, 1, 0); S.Position = UDim2.new(0, 8, 0, 0); S.Font = "GothamMedium"; S.TextColor3 = Color3.new(1,1,1); S.TextSize = 12; S.TextXAlignment = "Left"; S.BackgroundTransparency = 1

                    Box.MouseButton1Click:Connect(function()
                        -- Создаем меню выбора
                        local DropMenu = Instance.new("Frame", Overlay)
                        DropMenu.Size = UDim2.new(0, Box.AbsoluteSize.X, 0, #options * 25 + 10)
                        DropMenu.Position = UDim2.new(0, Box.AbsolutePosition.X, 0, Box.AbsolutePosition.Y + 30)
                        DropMenu.BackgroundColor3 = Theme.Element; ApplyStyle(DropMenu, 6, true)
                        Instance.new("UIListLayout", DropMenu).Padding = UDim.new(0, 2)
                        Instance.new("UIPadding", DropMenu).PaddingTop = UDim.new(0, 5)

                        for _, opt in pairs(options) do
                            local OptBtn = Instance.new("TextButton", DropMenu)
                            OptBtn.Size = UDim2.new(1, 0, 0, 22); OptBtn.BackgroundTransparency = 1; OptBtn.Text = "  " .. opt; OptBtn.Font = "GothamMedium"; OptBtn.TextColor3 = Theme.Muted; OptBtn.TextSize = 12; OptBtn.TextXAlignment = "Left"
                            OptBtn.MouseButton1Click:Connect(function()
                                S.Text = opt; DropMenu:Destroy()
                                if callback then callback(opt) end
                            end)
                        end
                        -- Закрыть при клике мимо
                        local Close; Close = UserInputService.InputBegan:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 then DropMenu:Destroy(); Close:Disconnect() end
                        end)
                    end)
                end

                -- СТРЕЛКА С БОКОВЫМ ОКНОМ (Скриншот 74)
                function E:AddArrow(txt)
                    local F = Instance.new("Frame", container); F.Size = UDim2.new(1, 0, 0, 24); F.BackgroundTransparency = 1
                    local L = Instance.new("TextLabel", F); L.Text = txt; L.Size = UDim2.new(1, 0, 1, 0); L.Font = "GothamMedium"; L.TextColor3 = Theme.Text; L.TextSize = 14; L.TextXAlignment = "Left"; L.BackgroundTransparency = 1
                    local A = Instance.new("TextButton", F); A.Size = UDim2.new(0, 20, 1, 0); A.Position = UDim2.new(1, 0, 0, 0); A.AnchorPoint = Vector2.new(1,0); A.BackgroundTransparency = 1; A.Text = ">"; A.Font = "GothamBold"; A.TextColor3 = Theme.Muted; A.TextSize = 16
                    
                    local Sub, SubContainer = CreateSubWindow(txt)
                    A.MouseButton1Click:Connect(function() 
                        Sub.Visible = not Sub.Visible 
                    end)
                    return InternalElements(SubContainer) -- Позволяет добавлять элементы в боковое окно
                end

                return E
            end
            return InternalElements(C)
        end
        return Tab
    end
    return Window
end

return Library
