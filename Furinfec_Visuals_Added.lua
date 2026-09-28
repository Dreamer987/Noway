local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"
))()

local Window = Library:CreateWindow({
    Title = "Character",
    Footer = "Basic v2",
    ToggleKeybind = Enum.KeyCode.RightControl,
})

local Tab = Window:AddTab("General", "user")
local Character = Tab:AddLeftGroupbox("Character")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

--// SPEED BOOST
Character:AddSlider("SpeedBoost", {
    Text = "Speed Boost",
    Default = 21,
    Min = 1,
    Max = 100,
    Rounding = 0,

    Callback = function(Value)
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end,
})

Character:AddToggle("EnableSpeedBoost", {
    Text = "Enable Speed Boost",
    Default = false,

    Callback = function(Value)
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            if Value then
                Humanoid.WalkSpeed = Library.Options.SpeedBoost.Value
            else
                Humanoid.WalkSpeed = 16
            end
        end
    end,
})

--// FLY
local FlyEnabled = false
local FlyConnection

Character:AddToggle("Fly", {
    Text = "Fly",
    Default = false,

    Callback = function(Value)
        FlyEnabled = Value

        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end

        if not Value then
            local Root = Player.Character
                and Player.Character:FindFirstChild("HumanoidRootPart")

            if Root then
                Root.AssemblyLinearVelocity = Vector3.zero
            end
            return
        end

        FlyConnection = RunService.RenderStepped:Connect(function()
            if not FlyEnabled then return end

            local Character = Player.Character
            local Root = Character and Character:FindFirstChild("HumanoidRootPart")

            if not Root then return end

            local Camera = workspace.CurrentCamera
            local Speed = Library.Options.FlySpeed.Value

            local Direction = Vector3.zero

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                Direction += Camera.CFrame.LookVector
            end

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                Direction -= Camera.CFrame.LookVector
            end

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                Direction -= Camera.CFrame.RightVector
            end

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                Direction += Camera.CFrame.RightVector
            end

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                Direction += Vector3.new(0, 1, 0)
            end

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
                Direction -= Vector3.new(0, 1, 0)
            end

            if Direction.Magnitude > 0 then
                Direction = Direction.Unit * Speed
            end

            Root.AssemblyLinearVelocity = Direction
        end)
    end,
})

Character:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 20,
    Min = 1,
    Max = 100,
    Rounding = 0,
})

--// NOCLIP
local NoclipEnabled = false
local NoclipConnection

Character:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,

    Callback = function(Value)
        NoclipEnabled = Value

        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end

        if Value then
            NoclipConnection = RunService.Stepped:Connect(function()
                local Character = Player.Character

                if Character then
                    for _, Part in ipairs(Character:GetDescendants()) do
                        if Part:IsA("BasePart") then
                            Part.CanCollide = false
                        end
                    end
                end
            end)
        else
            local Character = Player.Character

            if Character then
                for _, Part in ipairs(Character:GetDescendants()) do
                    if Part:IsA("BasePart") then
                        Part.CanCollide = true
                    end
                end
            end
        end
    end,
})

--// AUTO PUNCH
local PunchRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("SkillRemote")

Character:AddToggle("AutoPunch", {
    Text = "Auto punch",
    Default = false,

    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Library.Toggles.AutoPunch.Value do

                    local Character = Player.Character
                    local Root = Character
                        and Character:FindFirstChild("HumanoidRootPart")

                    if Root then
                        local Camera = workspace.CurrentCamera

                        local args = {
                            [1] = {
                                ["Camera"] = Camera.CFrame,
                                ["SkillId"] = "1",
                                ["Began"] = true,
                                ["CFrame"] = Root.CFrame,
                                ["Typ\208\181"] = 1,
                                ["Aim"] = Root.Position + Camera.CFrame.LookVector * 100
                            }
                        }

                        PunchRemote:FireServer(unpack(args))
                    end

                    task.wait(Library.Options.PunchDelay.Value)
                end
            end)
        end
    end,
})

--// PUNCH DELAY
Character:AddSlider("PunchDelay", {
    Text = "Punch Delay",
    Default = 0.07,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Suffix = "s",
})

Library:OnUnload(function()
    if FlyConnection then
        FlyConnection:Disconnect()
    end

    if NoclipConnection then
        NoclipConnection:Disconnect()
    end
end)
--// AUTOMATION
local Automation = Tab:AddRightGroupbox("Automation")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- AUTO FARM SPEED
--==================================================

Automation:AddToggle("AutoFarmSpeed", {
    Text = "Auto farm speed",
    Default = false,

    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Library.Toggles.AutoFarmSpeed.Value do
                    local Character = LocalPlayer.Character
                    local Humanoid = Character
                        and Character:FindFirstChildOfClass("Humanoid")

                    if Humanoid then
                        -- Auto walk tại chỗ
                        Humanoid:Move(Vector3.new(1, 0, 0), false)
                    end

                    task.wait(0.05)
                end

                local Character = LocalPlayer.Character
                local Humanoid = Character
                    and Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid:Move(Vector3.zero, false)
                end
            end)
        end
    end,
})

--==================================================
-- AUTO GET GOOD BOTH TRADING PLAZA
--==================================================

Automation:AddToggle("AutoGetGoodBoth", {
    Text = "Auto get good both trading plaza",
    Default = false,

    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Library.Toggles.AutoGetGoodBoth.Value do

                    for i = 1, 16 do
                        if not Library.Toggles.AutoGetGoodBoth.Value then
                            break
                        end

                        local Booth = workspace:FindFirstChild("Misc")
                            and workspace.Misc:FindFirstChild("Booths")
                            and workspace.Misc.Booths:FindFirstChild("Booth" .. i)

                        local TradeBooth = Booth
                            and Booth:FindFirstChild("TradeBooth")

                        local RE = TradeBooth
                            and TradeBooth:FindFirstChild("RE")

                        local Claim = RE
                            and RE:FindFirstChild("Claim")

                        if Claim then
                            pcall(function()
                                Claim:FireServer(true)
                            end)
                        end

                        task.wait(0.05)
                    end

                    task.wait(0.05)
                end
            end)
        end
    end,
})

--==================================================
-- AUTO SOUND SERVER / DASH
--==================================================

local SoundServerStarted = false

Automation:AddToggle("AutoSoundServer", {
    Text = "Auto sound server",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        -- Lần đầu chỉ hiện thông báo
        if not SoundServerStarted then
            SoundServerStarted = true

            Library:Notify({
                Title = "Auto sound server",
                Description = "You need bypass cooldown dash",
                Time = 4
            })

            return
        end

        -- Lần bật tiếp theo mới chạy
        task.spawn(function()
            while Library.Toggles.AutoSoundServer.Value do

                local Character = LocalPlayer.Character
                local Root = Character
                    and Character:FindFirstChild("HumanoidRootPart")

                if Root then
                    local Camera = workspace.CurrentCamera

                    local args = {
                        [1] = {
                            ["Camera"] = Camera.CFrame,
                            ["SkillId"] = "7",
                            ["Typ\208\181"] = 1,
                            ["Began"] = true,
                            ["CFrame"] = Root.CFrame,
                            ["DashDirection"] = Camera.CFrame.LookVector,
                            ["Aim"] = Root.Position
                                + Camera.CFrame.LookVector * 150
                        }
                    }

                    pcall(function()
                        ReplicatedStorage
                            :WaitForChild("Remotes")
                            :WaitForChild("SkillRemote")
                            :FireServer(unpack(args))
                    end)
                end

                task.wait(0.02)
            end
        end)
    end,
})

--==================================================
-- ENEMY BLAST AURA
--==================================================

local EnemyBlastRange = 300

Automation:AddToggle("EnemyBlastAura", {
    Text = "Enemy blast aura",
    Default = false,

    Callback = function(Value)
        if Value then
            task.spawn(function()

                while Library.Toggles.EnemyBlastAura.Value do

                    local Character = LocalPlayer.Character
                    local Root = Character
                        and Character:FindFirstChild("HumanoidRootPart")

                    if Root then

                        local MobsFolder = workspace
                            :FindFirstChild("World Mobs")

                        if MobsFolder then

                            for _, Folder in ipairs(MobsFolder:GetChildren()) do

                                if Folder:IsA("Folder") or Folder:IsA("Model") then

                                    for _, Mob in ipairs(Folder:GetChildren()) do

                                        if not Library.Toggles.EnemyBlastAura.Value then
                                            break
                                        end

                                        if Mob:IsA("Model") then

                                            local MobRoot =
                                                Mob:FindFirstChild("HumanoidRootPart")
                                                or Mob.PrimaryPart

                                            if MobRoot then

                                                local Distance =
                                                    (MobRoot.Position - Root.Position).Magnitude

                                                if Distance <= EnemyBlastRange then

                                                    -- Lock mob
                                                    pcall(function()
                                                        ReplicatedStorage
                                                            :WaitForChild("Packages")
                                                            :WaitForChild("_Index")
                                                            :WaitForChild("sleitnick_knit@1.4.7")
                                                            :WaitForChild("knit")
                                                            :WaitForChild("Services")
                                                            :WaitForChild("SkillManager")
                                                            :WaitForChild("RE")
                                                            :WaitForChild("LockedOnChanged")
                                                            :FireServer(Mob)
                                                    end)

                                                    -- Enemy Blast
                                                    local Camera =
                                                        workspace.CurrentCamera

                                                    local args = {
                                                        [1] = {
                                                            ["Camera"] = Camera.CFrame,
                                                            ["SkillId"] = "101",
                                                            ["Began"] = true,
                                                            ["CFrame"] = Root.CFrame,
                                                            ["Typ\208\181"] = 1,
                                                            ["Aim"] = MobRoot.Position
                                                        }
                                                    }

                                                    pcall(function()
                                                        ReplicatedStorage
                                                            :WaitForChild("Remotes")
                                                            :WaitForChild("SkillRemote")
                                                            :FireServer(unpack(args))
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    task.wait(0.02)
                end
            end)
        end
    end,
})

Automation:AddSlider("EnemyBlastRange", {
    Text = "Range enemy blast",
    Default = 300,
    Min = 50,
    Max = 500,
    Rounding = 0,

    Callback = function(Value)
        EnemyBlastRange = Value
    end,
})

--==================================================
-- AUTO KILL ZAJA
--==================================================

Automation:AddToggle("AutoKillZaja", {
    Text = "Auto kill Zaja",
    Default = false,

    Callback = function(Value)

        if Value then
            task.spawn(function()

                while Library.Toggles.AutoKillZaja.Value do

                    local EventMobs = workspace
                        :FindFirstChild("World Mobs")
                        and workspace["World Mobs"]:FindFirstChild("Event Mobs")

                    local Zaja = EventMobs
                        and EventMobs:FindFirstChild("Zaja")

                    local Character = LocalPlayer.Character
                    local Root = Character
                        and Character:FindFirstChild("HumanoidRootPart")

                    if Zaja and Root then

                        local ZajaRoot =
                            Zaja:FindFirstChild("HumanoidRootPart")
                            or Zaja.PrimaryPart

                        if ZajaRoot then

                            -- Tween liên tục tới Zaja
                            local TargetCFrame =
                                ZajaRoot.CFrame * CFrame.new(0, 0, 8)

                            local Distance =
                                (Root.Position - ZajaRoot.Position).Magnitude

                            local Time =
                                math.clamp(Distance / 250, 0.05, 0.5)

                            local Tween = TweenService:Create(
                                Root,
                                TweenInfo.new(
                                    Time,
                                    Enum.EasingStyle.Linear
                                ),
                                {
                                    CFrame = TargetCFrame
                                }
                            )

                            Tween:Play()
                            Tween.Completed:Wait()
                        end
                    else
                        -- Chờ Zaja xuất hiện
                        task.wait(0.1)
                    end
                end
            end)
        end
    end,
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer



local Tab1 = Window:AddTab("Exploits", "zap")

--==================================================
-- LEFT BOX
--==================================================

local Left = Tab1:AddLeftGroupbox("Bypass")

local DashGuard = false
local TeleportLock = false
local StunGuard = false
local HideEffects = false

local SavedCFrame = nil

-- Bypass Dash -> Dash Guard
Left:AddToggle("BypassDash", {
    Text = "Bypass Dash",
    Default = false,

    Callback = function(Value)
        DashGuard = Value
    end,
})

-- Bypass Teleport -> Position Lock
Left:AddToggle("BypassTeleport", {
    Text = "Bypass Teleport",
    Default = false,

    Callback = function(Value)
        TeleportLock = Value

        local Character = LocalPlayer.Character
        local Root = Character and Character:FindFirstChild("HumanoidRootPart")

        if Value and Root then
            SavedCFrame = Root.CFrame
        else
            SavedCFrame = nil
        end
    end,
})

-- Bypass Stun -> Stun Guard
Left:AddToggle("BypassStun", {
    Text = "Bypass Stun",
    Default = false,

    Callback = function(Value)
        StunGuard = Value
    end,
})

-- Bypass Fake Lockon -> Lockon Tracker
Left:AddToggle("BypassFakeLockon", {
    Text = "Bypass Fake Lockon",
    Default = false,

    Callback = function(Value)
        -- Local tracker only
    end,
})

-- Bypass Skill Effect -> Hide Effects
Left:AddToggle("BypassSkillEffect", {
    Text = "Bypass Skill Effect",
    Default = false,

    Callback = function(Value)
        HideEffects = Value

        local Effects = workspace:FindFirstChild("Effects")

        if Effects then
            for _, Object in ipairs(Effects:GetDescendants()) do
                if Object:IsA("ParticleEmitter")
                or Object:IsA("Trail")
                or Object:IsA("Beam") then
                    Object.Enabled = not Value
                end
            end
        end
    end,
})

--==================================================
-- RIGHT BOX
--==================================================

local Right = Tab1:AddRightGroupbox("Bypass")

local AntiFall = false
local VelocityEnabled = false
local VelocityValue = 16
local InfinitePVP = false
local TeleportLockon = false

local SelectedTarget = nil

-- Anti Fall
Right:AddToggle("AntiFall", {
    Text = "Anti Fall",
    Default = false,

    Callback = function(Value)
        AntiFall = Value
    end,
})

-- Velocity Manipulation
Right:AddToggle("VelocityManipulation", {
    Text = "Velocity Manipulation",
    Default = false,

    Callback = function(Value)
        VelocityEnabled = Value
    end,
})

Right:AddSlider("VelocityValue", {
    Text = "Velocity",
    Default = 16,
    Min = 0,
    Max = 100,
    Rounding = 0,

    Callback = function(Value)
        VelocityValue = Value
    end,
})

-- Infinite PvP
Right:AddToggle("InfinitePvP", {
    Text = "Infinite PvP",
    Default = false,

    Callback = function(Value)
        InfinitePVP = Value
    end,
})

-- Target list
local function GetPlayers()
    local List = {}

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            table.insert(List, Player.Name)
        end
    end

    table.sort(List)

    return List
end

Right:AddDropdown("LockonTarget", {
    Text = "Lockon",
    Values = GetPlayers(),
    Default = nil,

    Callback = function(Value)
        SelectedTarget = Players:FindFirstChild(Value)
    end,
})

Right:AddToggle("TeleportLockon", {
    Text = "Teleport Lockon",
    Default = false,

    Callback = function(Value)
        TeleportLockon = Value
    end,
})

-- Refresh player list
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            Library.Options.LockonTarget:SetValues(GetPlayers())
        end)
    end
end)

--==================================================
-- MAIN LOOP
--==================================================

RunService.Heartbeat:Connect(function()

    local Character = LocalPlayer.Character
    if not Character then
        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not Root then
        return
    end

    -- Position Lock
    if TeleportLock and SavedCFrame then
        Root.CFrame = SavedCFrame
        Root.AssemblyLinearVelocity = Vector3.zero
    end

    -- Anti Fall
    if AntiFall then
        if Humanoid:GetState() == Enum.HumanoidStateType.Freefall
        or Humanoid:GetState() == Enum.HumanoidStateType.FallingDown then

            Root.AssemblyLinearVelocity = Vector3.new(
                Root.AssemblyLinearVelocity.X,
                0,
                Root.AssemblyLinearVelocity.Z
            )
        end
    end

    -- Velocity
    if VelocityEnabled then
        local Velocity = Root.AssemblyLinearVelocity

        if Velocity.Magnitude > VelocityValue then
            Root.AssemblyLinearVelocity =
                Velocity.Unit * VelocityValue
        end
    end

    -- Stun Guard
    if StunGuard then
        if Humanoid.WalkSpeed < 1 then
            Humanoid.WalkSpeed = 16
        end

        if Humanoid.JumpPower < 1 then
            Humanoid.JumpPower = 50
        end
    end

    -- Teleport Lockon
    if TeleportLockon and SelectedTarget then

        local TargetCharacter = SelectedTarget.Character
        local TargetRoot = TargetCharacter
            and TargetCharacter:FindFirstChild("HumanoidRootPart")

        if TargetRoot then
            Root.CFrame =
                TargetRoot.CFrame * CFrame.new(0, 0, 5)
        end
    end

end)

--==================================================
-- CHARACTER RESPAWN
--==================================================

LocalPlayer.CharacterAdded:Connect(function(Character)

    task.wait(1)

    if TeleportLock then
        local Root = Character:FindFirstChild("HumanoidRootPart")

        if Root then
            SavedCFrame = Root.CFrame
        end
    end
end)

Library:OnUnload(function()
    DashGuard = false
    TeleportLock = false
    StunGuard = false
    HideEffects = false
    AntiFall = false
    VelocityEnabled = false
    InfinitePVP = false
    TeleportLockon = false
end)

--==================================================
-- VISUALS
--==================================================

local Visuals = Window:AddTab("Visuals", "eye")

local EventMobsFolder = workspace:FindFirstChild("World Mobs")
    and workspace["World Mobs"]:FindFirstChild("Event Mobs")
local QuestFolder = workspace:FindFirstChild("Misc")
    and workspace.Misc:FindFirstChild("NPC")
    and workspace.Misc.NPC:FindFirstChild("Quests")
local DragonSphereFolder = workspace:FindFirstChild("Misc")
    and workspace.Misc:FindFirstChild("DragonSphereSpawns")
local PickItemFolder = workspace:FindFirstChild("Misc") and workspace.Misc:FindFirstChild("Items")

local VisualLeft = Visuals:AddLeftGroupbox("Camera")
local VisualRight = Visuals:AddRightTabbox("ESP")
local ESPTab = VisualRight:AddTab("ESP")
local ESPSettings = VisualRight:AddTab("Settings")

-- Camera
local CameraEnabled = true
local OriginalFOV = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70

VisualLeft:AddToggle("Ambient", {
    Text = "Ambient",
    Default = true,
})

VisualLeft:AddSlider("FieldOfView", {
    Text = "Field of View",
    Default = 70,
    Min = 40,
    Max = 120,
    Rounding = 0,
    Callback = function(Value)
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = Value
        end
    end,
})

VisualLeft:AddToggle("RemoveCameraShake", {
    Text = "Remove Camera Shake",
    Default = false,
})

VisualLeft:AddToggle("RemoveCameraBobbing", {
    Text = "Remove Camera Bobbing",
    Default = false,
})

VisualLeft:AddToggle("RemoveCutscenes", {
    Text = "Remove Cutscenes",
    Default = false,
})

VisualLeft:AddToggle("RemoveFog", {
    Text = "Remove Fog",
    Default = false,
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")
        if Value then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
        end
    end,
})

VisualLeft:AddToggle("ThirdPerson", {
    Text = "Third Person",
    Default = false,
    Callback = function(Value)
        if Value then
            Player.CameraMode = Enum.CameraMode.Classic
        else
            Player.CameraMode = Enum.CameraMode.LockFirstPerson
        end
    end,
})

VisualLeft:AddSlider("ThirdPersonX", {
    Text = "X Offset",
    Default = 1.5,
    Min = -5,
    Max = 5,
    Rounding = 1,
})

VisualLeft:AddSlider("ThirdPersonY", {
    Text = "Y Offset",
    Default = 1,
    Min = -5,
    Max = 5,
    Rounding = 1,
})

VisualLeft:AddSlider("ThirdPersonZ", {
    Text = "Z Offset",
    Default = 5,
    Min = 1,
    Max = 10,
    Rounding = 1,
})

VisualLeft:AddToggle("WallCheck", {
    Text = "Wall Check",
    Default = false,
})

VisualLeft:AddToggle("ViewmodelOffset", {
    Text = "Viewmodel Offset",
    Default = false,
})

VisualLeft:AddSlider("ViewmodelX", {
    Text = "X Offset",
    Default = 0,
    Min = -10,
    Max = 10,
    Rounding = 1,
})

VisualLeft:AddSlider("ViewmodelY", {
    Text = "Y Offset",
    Default = 0,
    Min = -10,
    Max = 10,
    Rounding = 1,
})

VisualLeft:AddSlider("ViewmodelZ", {
    Text = "Z Offset",
    Default = 0,
    Min = -10,
    Max = 10,
    Rounding = 1,
})

--==================================================
-- NOTIFY / ENTITY LISTS
--==================================================

local function GetFolderNames(Folder)
    local Values = {}
    if Folder then
        for _, Object in ipairs(Folder:GetChildren()) do
            table.insert(Values, Object.Name)
        end
    end
    table.sort(Values)
    if #Values == 0 then
        Values = { "None" }
    end
    return Values
end

local MobDropdown = ESPTab:AddDropdown("MobList", {
    Values = GetFolderNames(EventMobsFolder),
    Default = 1,
    Multi = true,
    Searchable = true,
    MaxVisibleDropdownItems = 12,
    Text = "Mobs",
})

ESPTab:AddToggle("NotifyMobs", {
    Text = "Notify Mobs",
    Default = true,
})

local ItemDropdown = ESPTab:AddDropdown("ItemList", {
    Values = GetFolderNames(PickItemFolder),
    Default = 1,
    Multi = false,
    Searchable = true,
    MaxVisibleDropdownItems = 12,
    Text = "Item List",
})

ESPTab:AddToggle("NotifyItems", {
    Text = "Notify Items",
    Default = false,
})

ESPTab:AddToggle("ShowDistance", {
    Text = "Show Distance",
    Default = true,
})

ESPTab:AddDivider()

ESPTab:AddToggle("NotifyCritDamage", {
    Text = "Notify Crit Damage",
    Default = false,
})

ESPTab:AddToggle("NotifyEnergy", {
    Text = "Notify Energy",
    Default = true,
})

ESPTab:AddToggle("NotifyUsedTime", {
    Text = "Notify Has Time",
    Default = false,
    Callback = function(Value)
        if Value then
            local Used = math.floor(os.clock())
            Library:Notify({
                Title = "Script Time",
                Description = string.format("Script used: %02d:%02d:%02d", math.floor(Used / 3600), math.floor(Used / 60) % 60, Used % 60),
                Time = 4,
            })
        end
    end,
})

-- Tool/equipment controls are intentionally not included here.

--==================================================
-- ESP SETTINGS
--==================================================

ESPSettings:AddToggle("RainbowEffect", {
    Text = "Rainbow Effect",
    Default = false,
})

ESPSettings:AddToggle("ESPShowDistance", {
    Text = "Show Distance",
    Default = true,
})

ESPSettings:AddSlider("FillTransparency", {
    Text = "Fill Transparency",
    Default = 0.75,
    Min = 0,
    Max = 1,
    Rounding = 2,
})

ESPSettings:AddSlider("OutlineTransparency", {
    Text = "Outline Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
})

ESPSettings:AddSlider("TextTransparency", {
    Text = "Text Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
})

ESPSettings:AddSlider("TextOutlineTransparency", {
    Text = "Text Outline Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
})

ESPSettings:AddSlider("FadeTime", {
    Text = "Fade Time",
    Default = 0.25,
    Min = 0,
    Max = 2,
    Rounding = 2,
})

ESPSettings:AddSlider("RenderLimit", {
    Text = "Render Limit",
    Default = 240,
    Min = 10,
    Max = 500,
    Rounding = 0,
})

ESPSettings:AddSlider("ESPTextSize", {
    Text = "Text Size",
    Default = 20,
    Min = 8,
    Max = 40,
    Rounding = 0,
})

ESPSettings:AddDropdown("ESPFont", {
    Values = { "Highway", "Gotham", "SourceSans", "Code" },
    Default = "Highway",
    Text = "Text Font",
})

ESPSettings:AddDropdown("TracerOrigin", {
    Values = { "Bottom", "Center", "Top" },
    Default = "Bottom",
    Text = "Tracer Origin",
})

--==================================================
-- ESP IMPLEMENTATION
--==================================================

local ESPEnabled = {
    Mobs = false,
    Players = false,
    Items = false,
    Stardust = false,
    QuestNPC = false,
}

local ESPColors = {
    Mobs = Color3.fromRGB(255, 0, 0),
    Players = Color3.fromRGB(255, 255, 255),
    Items = Color3.fromRGB(170, 0, 255),
    Stardust = Color3.fromRGB(0, 255, 255),
    QuestNPC = Color3.fromRGB(255, 255, 0),
}

local ESPObjects = {}

local function GetESPPart(Object)
    if not Object or not Object.Parent then return nil end
    if Object:IsA("BasePart") then return Object end
    if Object:IsA("Model") then
        return Object.PrimaryPart
            or Object:FindFirstChild("HumanoidRootPart")
            or Object:FindFirstChildWhichIsA("BasePart", true)
    end
    return Object:FindFirstChildWhichIsA("BasePart", true)
end

local function RemoveESP(Object)
    local Data = ESPObjects[Object]
    if not Data then return end
    if Data.Highlight then Data.Highlight:Destroy() end
    if Data.Billboard then Data.Billboard:Destroy() end
    ESPObjects[Object] = nil
end

local function CreateESP(Object, Type)
    if not Object or not Object.Parent then return end
    local Part = GetESPPart(Object)
    if not Part then return end

    local Data = ESPObjects[Object]
    if not Data then
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "AbyssallESP"
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Parent = Object:IsA("Model") and Object or Part

        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "AbyssallESPLabel"
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.fromOffset(240, 45)
        Billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        Billboard.Parent = Part

        local Label = Instance.new("TextLabel")
        Label.Name = "Text"
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.fromScale(1, 1)
        Label.TextStrokeColor3 = Color3.new(0, 0, 0)
        Label.TextScaled = false
        Label.Parent = Billboard

        Data = {
            Highlight = Highlight,
            Billboard = Billboard,
            Label = Label,
            Type = Type,
        }
        ESPObjects[Object] = Data
    end

    Data.Type = Type
    Data.Part = Part
end

local function UpdateESP()
    local Camera = workspace.CurrentCamera
    local Character = Player.Character
    local MyRoot = Character and Character:FindFirstChild("HumanoidRootPart")
    if not Camera then return end

    local Rendered = 0

    local function AddFolderObjects(Folder, Type)
        if not Folder or not ESPEnabled[Type] then return end
        for _, Object in ipairs(Folder:GetChildren()) do
            if Rendered >= (Library.Options.RenderLimit and Library.Options.RenderLimit.Value or 240) then
                break
            end
            local Part = GetESPPart(Object)
            if Part then
                CreateESP(Object, Type)
                local Data = ESPObjects[Object]
                if Data then
                    Rendered += 1
                    local Distance = MyRoot and (MyRoot.Position - Part.Position).Magnitude or 0
                    local Name = Object.Name
                    Data.Label.Text = Library.Options.ESPShowDistance.Value
                        and string.format("%s [%d]", Name, Distance)
                        or Name
                    Data.Label.TextSize = Library.Options.ESPTextSize.Value
                    Data.Label.TextTransparency = Library.Options.TextTransparency.Value
                    Data.Label.TextStrokeTransparency = Library.Options.TextOutlineTransparency.Value
                    Data.Label.Font = Enum.Font[Library.Options.ESPFont.Value] or Enum.Font.Gotham
                    Data.Highlight.FillTransparency = Library.Options.FillTransparency.Value
                    Data.Highlight.OutlineTransparency = Library.Options.OutlineTransparency.Value

                    local Color = ESPColors[Type]
                    if Library.Options.RainbowEffect.Value then
                        Color = Color3.fromHSV((os.clock() * 0.15) % 1, 1, 1)
                    end
                    Data.Highlight.FillColor = Color
                    Data.Highlight.OutlineColor = Color
                end
            end
        end
    end

    AddFolderObjects(EventMobsFolder, "Mobs")
    AddFolderObjects(DragonSphereFolder, "Stardust")
    AddFolderObjects(QuestFolder, "QuestNPC")
    AddFolderObjects(PickItemFolder, "Items")

    if ESPEnabled.Players then
        for _, Target in ipairs(Players:GetPlayers()) do
            if Rendered >= (Library.Options.RenderLimit and Library.Options.RenderLimit.Value or 240) then break end
            if Target ~= Player and Target.Character then
                local Root = Target.Character:FindFirstChild("HumanoidRootPart")
                if Root then
                    CreateESP(Target.Character, "Players")
                    local Data = ESPObjects[Target.Character]
                    if Data then
                        Rendered += 1
                        local Distance = MyRoot and (MyRoot.Position - Root.Position).Magnitude or 0
                        Data.Label.Text = Library.Options.ESPShowDistance.Value
                            and string.format("%s [%d]", Target.Name, Distance)
                            or Target.Name
                        Data.Label.TextSize = Library.Options.ESPTextSize.Value
                        Data.Label.TextTransparency = Library.Options.TextTransparency.Value
                        Data.Label.TextStrokeTransparency = Library.Options.TextOutlineTransparency.Value
                        Data.Label.Font = Enum.Font.Gotham
                        local Color = ESPColors.Players
                        if Library.Options.RainbowEffect.Value then
                            Color = Color3.fromHSV((os.clock() * 0.15) % 1, 1, 1)
                        end
                        Data.Highlight.FillColor = Color
                        Data.Highlight.OutlineColor = Color
                        Data.Highlight.FillTransparency = Library.Options.FillTransparency.Value
                        Data.Highlight.OutlineTransparency = Library.Options.OutlineTransparency.Value
                    end
                end
            end
        end
    end

    for Object in pairs(ESPObjects) do
        if not Object.Parent then
            RemoveESP(Object)
        end
    end
end

ESPTab:AddToggle("ESPMobs", {
    Text = "Mobs",
    Default = false,
    Callback = function(Value) ESPEnabled.Mobs = Value end,
})

ESPTab:AddToggle("ESPPlayers", {
    Text = "Players",
    Default = false,
    Callback = function(Value) ESPEnabled.Players = Value end,
})

ESPTab:AddToggle("ESPItems", {
    Text = "Items",
    Default = false,
    Callback = function(Value) ESPEnabled.Items = Value end,
})

ESPTab:AddToggle("ESPStardust", {
    Text = "Stardust Orb",
    Default = false,
    Callback = function(Value) ESPEnabled.Stardust = Value end,
})

ESPTab:AddToggle("ESPQuestNPC", {
    Text = "Quest NPC",
    Default = false,
    Callback = function(Value) ESPEnabled.QuestNPC = Value end,
})

-- Refresh the mob/item dropdowns whenever objects are added/removed.
local Connections = {}

local function RefreshMobDropdown()
    if MobDropdown and EventMobsFolder then
        MobDropdown:SetValues(GetFolderNames(EventMobsFolder))
    end
end

local function RefreshItemDropdown()
    if ItemDropdown and PickItemFolder then
        ItemDropdown:SetValues(GetFolderNames(PickItemFolder))
    end
end

if EventMobsFolder then
    table.insert(Connections, EventMobsFolder.ChildAdded:Connect(function(Mob)
        RefreshMobDropdown()
        if Library.Options.NotifyMobs and Library.Options.NotifyMobs.Value then
            local Sound = Instance.new("Sound")
            Sound.SoundId = "rbxassetid://6026984224"
            Sound.Volume = 0.7
            Sound.Parent = workspace.CurrentCamera or workspace
            Sound:Play()
            game:GetService("Debris"):AddItem(Sound, 3)
            Library:Notify({Title = "Mob Spawned", Description = Mob.Name, Time = 4})
        end
    end))
    table.insert(Connections, EventMobsFolder.ChildRemoved:Connect(RefreshMobDropdown))
end

if PickItemFolder then
    table.insert(Connections, PickItemFolder.ChildAdded:Connect(function(Item)
        RefreshItemDropdown()
        if Library.Options.NotifyItems and Library.Options.NotifyItems.Value then
            Library:Notify({Title = "Item", Description = Item.Name, Time = 4})
        end
    end))
    table.insert(Connections, PickItemFolder.ChildRemoved:Connect(RefreshItemDropdown))
end

-- Notify Crit Damage / Notify Enemy / Energy monitor.
local LastHealth
local LastHealthTime = 0
local LastEnergyState = false

local function BindCharacter(Character)
    local Humanoid = Character:WaitForChild("Humanoid", 10)
    if not Humanoid then return end
    LastHealth = Humanoid.Health
    LastHealthTime = os.clock()

    Humanoid.HealthChanged:Connect(function(NewHealth)
        local Old = LastHealth or NewHealth
        local Delta = Old - NewHealth
        local Now = os.clock()

        if Delta > 0 and (Now - LastHealthTime) <= 0.8 then
            if Library.Options.NotifyCritDamage and Library.Options.NotifyCritDamage.Value then
                Library:Notify({
                    Title = "Crit Damage",
                    Description = string.format("-%0.0f HP", Delta),
                    Time = 3,
                })
            end
        end

        LastHealth = NewHealth
        LastHealthTime = Now
    end)
end

if Player.Character then task.spawn(BindCharacter, Player.Character) end
Player.CharacterAdded:Connect(BindCharacter)

-- Energy is read from workspace.Characters[LocalPlayer.Name].Status.
task.spawn(function()
    while not Library.Unloaded do
        local Characters = workspace:FindFirstChild("Characters")
        local CharacterFolder = Characters and Characters:FindFirstChild(Player.Name)
        local Status = CharacterFolder and CharacterFolder:FindFirstChild("Status")
        local CurrentEnergy = Status and Status:FindFirstChild("CurrentEnergy")
        local MaxEnergy = Status and Status:FindFirstChild("MaxEnergy")

        if CurrentEnergy and MaxEnergy and MaxEnergy.Value > 0 then
            local Low = CurrentEnergy.Value < (MaxEnergy.Value * 0.10)
            if Low and not LastEnergyState then
                if Library.Options.NotifyEnergy and Library.Options.NotifyEnergy.Value then
                    local Sound = Instance.new("Sound")
                    Sound.SoundId = "rbxassetid://6026984224"
                    Sound.Volume = 0.7
                    Sound.Parent = workspace.CurrentCamera or workspace
                    Sound:Play()
                    game:GetService("Debris"):AddItem(Sound, 3)
                    Library:Notify({
                        Title = "Energy",
                        Description = string.format("Energy low: %0.0f / %0.0f", CurrentEnergy.Value, MaxEnergy.Value),
                        Time = 4,
                    })
                end
            end
            LastEnergyState = Low
        end

        task.wait(0.15)
    end
end)

-- Simple third-person camera offset.
RunService:BindToRenderStep("AbyssallVisuals", Enum.RenderPriority.Camera.Value + 1, function()
    if Library.Unloaded then return end
    local Camera = workspace.CurrentCamera
    if not Camera then return end

    if Library.Options.ThirdPerson and Library.Options.ThirdPerson.Value then
        local Character = Player.Character
        local Root = Character and Character:FindFirstChild("HumanoidRootPart")
        if Root then
            Camera.CameraType = Enum.CameraType.Custom
            local Offset = Vector3.new(
                Library.Options.ThirdPersonX.Value,
                Library.Options.ThirdPersonY.Value,
                Library.Options.ThirdPersonZ.Value
            )
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid.CameraOffset = Offset
            end
        end
    else
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.CameraOffset = Vector3.zero
        end
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        pcall(UpdateESP)
        task.wait(Library.Options.FadeTime and math.max(0.05, Library.Options.FadeTime.Value) or 0.25)
    end
end)

Library:OnUnload(function()
    EquipLoop = false
    pcall(function()
        RunService:UnbindFromRenderStep("AbyssallVisuals")
    end)
    for _, Connection in ipairs(Connections) do
        pcall(function() Connection:Disconnect() end)
    end
    for Object in pairs(ESPObjects) do
        RemoveESP(Object)
    end
    if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = OriginalFOV
    end
end)
