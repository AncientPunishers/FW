print("Framework Version: v1.12\nLoading")

--Locals
local oldtick = tick()
local Camera = game:GetService("Workspace").CurrentCamera
local CharcaterMiddle = game:GetService("Workspace").Ignore.LocalCharacter.Middle
local Mouse = game.Players.LocalPlayer:GetMouse()
local RunService = Game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local FovFunction = nil

--Tables
local Framework = {Settings={FullBright=true,Fov=90}}
local Esp = {Settings={Boxes=false,Distances=false,Armor=false,ItemDistances=false,ItemNames=false,OreDistances=false,OreNames=false,PlayerRenderDistance=1000,ItemRenderDistance=1000,OreRenderDistance=1000,PlayerBoxColor=Color3.fromRGB(120,81,169),PlayerDistanceColor=Color3.fromRGB(120,81,169),PlayerArmorColor=Color3.fromRGB(120,81,169),Sleeping=false,PlayerSleepingColor=Color3.fromRGB(120,81,169),LocalChamsColor=Color3.fromRGB(120,81,169),LocalChamsMaterial=Enum.Material.ForceField},Drawings={},Connections={}}
local Crosshair = {Enabled=false,CrosshairThickness=2,CrosshairSize=8,CrosshairColor=Color3.fromRGB(255,0,255),X,Y,X1,Y1,X2,Y2,X3,Y3,Spin=false,CrosshairOffset=3}
local Aimbot = {Settings={FovEnabled=false,FovTransparency=1,FovSize=90,FovFilled=false,FovColor=Color3.fromRGB(120,81,169),TargetSleepers=false,AimbotHitpart="Head",Prediction=false,DropPrediction=false,HighlightTarget=true},Fov={},FovCircleDrawing=nil,AimbotSmoothing=3,HighlightedTarget=nil,TargetSleepersSilent=false,FovHitpartSilent="Head",}
local AllowedOres = {"StoneOre","NitrateOre","IronOre"}
local AllowedItems = {"PartsBox","MilitaryCrate","SnallBox","SnallBox","Backpack","VendingMachine"}

--Get Fov Function
for i,v in pairs(getreg()) do
    if type(v) == "function" and getfenv(v).script and getfenv(v).script.Name == "Camera" then
        if type(v) == "function" and #getupvalues(v) > 17 then
            FovFunction = v
        end
    end
end

--Functions
function Framework:SetFov(Number)
    setupvalue(FovFunction,17,Number)
end
function Framework:ReplaceSkybox(SkyBoxName)
    local Sky = Lighting:FindFirstChildOfClass("Sky")
    if not Sky then Sky = Instance.new("Sky",Lighting) end
    if SkyBoxName == "Standard" then
        Sky:Destroy()
    end
    local SkyBoxes = {
        ["Standard"] = {["SkyboxBk"] = Sky.SkyboxBk,["SkyboxDn"] = Sky.SkyboxDn,["SkyboxFt"] = Sky.SkyboxFt,["SkyboxLf"] = Sky.SkyboxLf,["SkyboxRt"] = Sky.SkyboxRt,["SkyboxUp"] = Sky.SkyboxUp,},
        ["Among Us"] = {["SkyboxBk"] = "rbxassetid://5752463190",["SkyboxDn"] = "rbxassetid://5752463190",["SkyboxFt"] = "rbxassetid://5752463190",["SkyboxLf"] = "rbxassetid://5752463190",["SkyboxRt"] = "rbxassetid://5752463190",["SkyboxUp"] = "rbxassetid://5752463190"},
        ["Spongebob"] = {["SkyboxBk"]="rbxassetid://277099484",["SkyboxDn"]="rbxassetid://277099500",["SkyboxFt"]="rbxassetid://277099554",["SkyboxLf"]="rbxassetid://277099531",["SkyboxRt"]="rbxassetid://277099589",["SkyboxUp"]="rbxassetid://277101591"},
        ["Deep Space"] = {["SkyboxBk"]="rbxassetid://159248188",["SkyboxDn"]="rbxassetid://159248183",["SkyboxFt"]="rbxassetid://159248187",["SkyboxLf"]="rbxassetid://159248173",["SkyboxRt"]="rbxassetid://159248192",["SkyboxUp"]="rbxassetid://159248176"},
        ["Winter"] = {["SkyboxBk"]="rbxassetid://510645155",["SkyboxDn"]="rbxassetid://510645130",["SkyboxFt"]="rbxassetid://510645179",["SkyboxLf"]="rbxassetid://510645117",["SkyboxRt"]="rbxassetid://510645146",["SkyboxUp"]="rbxassetid://510645195"},
        ["Clouded Sky"] = {["SkyboxBk"]="rbxassetid://252760981",["SkyboxDn"]="rbxassetid://252763035",["SkyboxFt"]="rbxassetid://252761439",["SkyboxLf"]="rbxassetid://252760980",["SkyboxRt"]="rbxassetid://252760986",["SkyboxUp"]="rbxassetid://252762652"},
    }
    for i, v in pairs(SkyBoxes[SkyBoxName]) do
        Sky[i] = v
    end
end
function Framework:IsSleeping(Model)
    if Model and Model:FindFirstChild("AnimationController") and Model.AnimationController:FindFirstChild("Animator") then
        for i,v in pairs(Model.AnimationController.Animator:GetPlayingAnimationTracks()) do
            if v.Animation.AnimationId == "rbxassetid://12501841745" then
                return true
            else
                return false
            end
        end
    end
end
function Framework:IsVisible(PlayerModel)
    local parts = Camera:GetPartsObscuringTarget({PlayerModel:GetPivot().Position},game:GetService("Workspace").Ignore:GetDescendants())
    if #parts > 0 then
        return false
    else
        return true
    end
end
function Framework:GetCenterScreen()
    return Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
end
function Framework:ReplaceSound(SoundName,NewId)
    game:GetService("SoundService")[SoundName].SoundId = NewId
end
function Framework:CreateConnection(Object,Callback)
    local Connection = Object:Connect(Callback)
    table.insert(Esp.Connections, Connection)
    return Connection
end
function Framework:GetArmor(Model)
    if Model.Armor:FindFirstChildOfClass("Folder") then
        return true
    else
        return false
    end
end
function Framework:GetHoldingTool()
    if getrenv()._G.modules.FPS.GetEquippedItem().id == nil then return "None" end
    return getrenv()._G.modules.FPS.GetEquippedItem().id
end
function Framework:GetEntitys()
    return getrenv()._G.modules.Entity.List
end
function Framework:GetPlayers()
    return getupvalues(getrenv()._G.modules.Player.GetPlayerModel)[1]
end
function Framework:DistanceFromCharacter(Vector3)
    return (CharcaterMiddle:GetPivot().p - Vector3).Magnitude
end
function Framework:IsOnScreen(Model)
    local RandomVar, OnScreen = Camera:WorldToViewportPoint(Model:GetPivot().p)
    return OnScreen
end
function Framework:ToggleLeaves(Trans)
    for i,v in pairs(Framework:GetEntitys()) do
        if v.typ == "Tree1" or v.typ == "Tree2" then
            v.model.Leaves.Transparency = Trans
        end
    end
end
function Framework:PositionToVector2(Vector3)
    local ViewportPosition, onscreen = Camera:WorldToViewportPoint(Vector3)
    return Vector2.new(ViewportPosition.X,ViewportPosition.Y), onscreen
end
function Framework:MoveMouse(PositionX,PositionY,Smoothing) --Provide Characters X And Y As It Takes Off Mouse
    NewPos = Vector2.new(Mouse.X-PositionX, Mouse.Y-PositionY)
    mousemoverel((-NewPos.X*0.5)/Smoothing,(-NewPos.Y*0.5)/Smoothing)
end
function Framework:Draw(Type,Propities)
    Object = Drawing.new(Type)
    for i,v in next,Propities do
        Object[i] = v
    end
    if Object then
        table.insert(Esp.Drawings, Object)
        return Object
    end
end
function Framework:ItemToColor(Item)
    table = {}
    table["PartsBox"] = Color3.new(0.929,0.973,0.796)
    table["MilitaryCrate"] = Color3.new(0.075,0.353,0.086)
    table["SnallBox"] = Color3.new(0.263,0.200,0.075)
    table["MediumBox"] = Color3.new(0.404,0.302,0.094)
    table["Backpack"] = Color3.new(0.404,0.302,0.094)
    table["VendingMachine"] = Color3.new(0.192,0.478,0.988)
    table["StoneOre"] = Color3.new(0.612,0.612,0.612)
    table["IronOre"] = Color3.new(0.773,0.686,0.365)
    table["NitrateOre"] = Color3.new(1,1,1)
    return table[Item]
end

function Esp:LocalChams()
    for i,v in pairs(game:GetService("Workspace").Ignore.FPSArms:GetChildren()) do
        if v:IsA("MeshPart") then
            v.Color = Esp.Settings.LocalChamsColor
            v.Material = Esp.Settings.LocalChamsMaterial
            Esp.Connections.UpdateLocalChams = Framework:CreateConnection(RunService.RenderStepped,function()
                v.Color = Esp.Settings.LocalChamsColor
                v.Material = Esp.Settings.LocalChamsMaterial
            end)
        end
    end
end

function Esp:CreateCrosshair()
    do
        Crosshair.X = Framework:Draw("Line",{Thickness=Crosshair.CrosshairThickness,Color=Crosshair.CrosshairColor,ZIndex = -9})
        Crosshair.Y = Framework:Draw("Line",{Thickness=Crosshair.CrosshairThickness,Color=Crosshair.CrosshairColor,ZIndex = -9})
        Crosshair.X3 = Framework:Draw("Line",{Thickness=Crosshair.CrosshairThickness,Color=Crosshair.CrosshairColor,ZIndex = -9})
        Crosshair.Y3 = Framework:Draw("Line",{Thickness=Crosshair.CrosshairThickness,Color=Crosshair.CrosshairColor,ZIndex = -9})
        Crosshair.X1 = Framework:Draw("Line",{Thickness=Crosshair.CrosshairThickness,Color=Crosshair.CrosshairColor,ZIndex = -9,Visible = false})
        Crosshair.Y1 = Framework:Draw("Line",{Thickness=Crosshair.CrosshairThickness,Color=Crosshair.CrosshairColor,ZIndex = -9,Visible = false})
        Crosshair.X2 = Framework:Draw("Line",{Thickness=Crosshair.CrosshairThickness,Color=Crosshair.CrosshairColor,ZIndex = -9,Visible = false})
        Crosshair.Y2 = Framework:Draw("Line",{Thickness=Crosshair.CrosshairThickness,Color=Crosshair.CrosshairColor,ZIndex = -9,Visible = false})

        Crosshair.X.From = Framework:GetCenterScreen() - Vector2.new(0,Crosshair.CrosshairOffset)
        Crosshair.X.To = Framework:GetCenterScreen() + Vector2.new(0,Crosshair.CrosshairSize)

        Crosshair.Y.From = Framework:GetCenterScreen() - Vector2.new(Crosshair.CrosshairOffset,0)
        Crosshair.Y.To = Framework:GetCenterScreen() + Vector2.new(Crosshair.CrosshairSize,0)

        Crosshair.X.Visible = Crosshair.Enabled
        Crosshair.Y.Visible = Crosshair.Enabled
        Esp.Connections.UpdateCrosshair = Framework:CreateConnection(RunService.RenderStepped,function()
            if Crosshair.Spin == false then
                Crosshair.X2.Visible = false;Crosshair.Y2.Visible = false;Crosshair.X1.Visible = false;Crosshair.Y1.Visible = false
                Crosshair.X.Color=Crosshair.CrosshairColor
                Crosshair.X.Thickness=Crosshair.CrosshairThickness
                Crosshair.Y.Color=Crosshair.CrosshairColor
                Crosshair.Y.Thickness=Crosshair.CrosshairThickness
                Crosshair.X.From = Framework:GetCenterScreen() - Vector2.new(0,Crosshair.CrosshairSize)
                Crosshair.X.To = Framework:GetCenterScreen() + Vector2.new(0,Crosshair.CrosshairSize)
                Crosshair.Y.From = Framework:GetCenterScreen() - Vector2.new(Crosshair.CrosshairSize,0)
                Crosshair.Y.To = Framework:GetCenterScreen() + Vector2.new(Crosshair.CrosshairSize,0)
                Crosshair.X.Visible = Crosshair.Enabled
                Crosshair.Y.Visible = Crosshair.Enabled
            end
        end)
    end
end
--SpinningCrosshair
local currentAngle = 0
Esp.Connections.SpinCrosshair = Framework:CreateConnection(RunService.Heartbeat,function(dTime)
    if Crosshair.Spin == true and Crosshair.Enabled == true then
        Crosshair.X.Visible = false;Crosshair.Y.Visible = false
        Crosshair.X2.Visible = true;Crosshair.Y2.Visible = true;Crosshair.X1.Visible = true;Crosshair.Y1.Visible = true
        CurrentAngle = CurrentAngle + math.rad(Crosshair.Speed*dTime);
        Crosshair.X2.From = GetCenterScreen() + (Vector2.new(math.cos(CurrentAngle), math.sin(CurrentAngle))*Crosshair.CrosshairOffset);
        Crosshair.X2.To = Crosshair.X.From + (Vector2.new(math.cos(CurrentAngle), math.sin(CurrentAngle))*Crosshair.CrosshairSize);

        Crosshair.Y2.From = GetCenterScreen() + (Vector2.new(math.cos(CurrentAngle + math.pi/2), math.sin(CurrentAngle + math.pi/2))*Crosshair.CrosshairOffset);
        Crosshair.Y2.To = Crosshair.Y.From + (Vector2.new(math.cos(CurrentAngle + math.pi/2), math.sin(CurrentAngle + math.pi/2))*Crosshair.CrosshairSize);

        Crosshair.X1.From = GetCenterScreen() + (Vector2.new(math.cos(CurrentAngle + math.pi), math.sin(CurrentAngle + math.pi))*Crosshair.CrosshairOffset);
        Crosshair.X1.To = Crosshair.X1.From + (Vector2.new(math.cos(CurrentAngle + math.pi), math.sin(CurrentAngle + math.pi))*Crosshair.CrosshairSize);

        Crosshair.Y1.From = GetCenterScreen() + (Vector2.new(math.cos(CurrentAngle + math.pi/2*3), math.sin(CurrentAngle + math.pi/2*3))*Crosshair.CrosshairOffset);
        Crosshair.Y1.To = Crosshair.Y1.From + (Vector2.new(math.cos(CurrentAngle + math.pi/2*3), math.sin(CurrentAngle + math.pi/2*3))*Crosshair.CrosshairSize);
    end
end)

--Esp Loops
do
    function Esp:AddPlayer(Model,PlayerTable)
        local Box,BoxOutline,ArmorText,DistanceText,SleepingText,ToolName = Framework:Draw("Square",{Thickness=1,Filled=false,Color = Esp.Settings.PlayerBoxColor,ZIndex = -9}),Framework:Draw("Square",{Thickness=2,Filled=false,Color = Color3.fromRGB(0,0,0),ZIndex = -10}),Framework:Draw("Text",{Text = "Nil",Font=2,Size=13,Center=true,Outline=true,Color = Esp.Settings.PlayerArmorColor,ZIndex = -9}),Framework:Draw("Text",{Text ="",Font=2,Size=13,Center=true,Outline=true,Color = Esp.Settings.PlayerDistanceColor,ZIndex = -9}),Framework:Draw("Text",{Text ="",Font=2,Size=13,Center=true,Outline=true,Color = Esp.Settings.PlayerSleepingColor,ZIndex = -9}),Framework:Draw("Text",{Text ="",Font=2,Size=13,Center=true,Outline=true,Color = Esp.Settings.PlayerToolColor,ZIndex = -9})
        local Render = game:GetService("RunService").RenderStepped:Connect(function()
            if Model and Model:FindFirstChild("HumanoidRootPart") then
                local Position,Visible = Camera:WorldToViewportPoint(Model:GetPivot().p)
                local scale = 1 / (Position.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100;
                local w,h = math.floor(35 * scale), math.floor(50 * scale);
                local x,y = math.floor(Position.X), math.floor(Position.Y);

                if Visible == true and Esp.Settings.Boxes == true and Framework:DistanceFromCharacter(Model:GetPivot().p) <= Esp.Settings.PlayerRenderDistance then
                    if Model == Aimbot.HighlightedTarget then
                        Box.Color = Color3.fromRGB(0,0,0)
                    else
                        Box.Color = Esp.Settings.PlayerBoxColor
                    end
                    BoxOutline.Visible = true
                    Box.Visible = true
                    BoxOutline.Position = Vector2.new(math.floor(x-w* 0.5),math.floor(y-h*0.5))
                    BoxOutline.Size = Vector2.new(w,h)
                    Box.Position = Vector2.new(math.floor(x-w* 0.5),math.floor(y-h*0.5))
                    Box.Size = Vector2.new(w,h)
                else
                    BoxOutline.Visible = false
                    Box.Visible = false
                end
                if Visible == true and Esp.Settings.Distances == true and Framework:DistanceFromCharacter(Model:GetPivot().p) <= Esp.Settings.PlayerRenderDistance then
                    if Model == Aimbot.HighlightedTarget then
                        DistanceText.Color = Color3.fromRGB(0,0,0)
                    else
                        DistanceText.Color = Esp.Settings.PlayerDistanceColor
                    end
                    DistanceText.Visible = true
                    DistanceText.Position = Vector2.new(x, math.floor(y+h*0.5))
                    DistanceText.Color = Esp.Settings.PlayerDistanceColor
                    DistanceText.Text = tostring(math.floor(Framework:DistanceFromCharacter(Model:GetPivot().p))).." Studs"
                else
                    DistanceText.Visible = false
                end
                if Visible == true and Esp.Settings.Sleeping == true and Framework:DistanceFromCharacter(Model:GetPivot().p) <= Esp.Settings.PlayerRenderDistance then
                    if PlayerTable.sleeping == true then SleepingText.Text = "Sleeping" else SleepingText.Text = "Awake" end
                    SleepingText.Visible = true
                    SleepingText.Color = Esp.Settings.PlayerSleepingColor
                    SleepingText.Position = Vector2.new(x, math.floor(y-h*0.5-SleepingText.TextBounds.Y))
                else
                    SleepingText.Visible = false
                end
                if Visible == true and Esp.Settings.Armor == true and Framework:DistanceFromCharacter(Model:GetPivot().p) <= Esp.Settings.PlayerRenderDistance then
                    if Model == Aimbot.HighlightedTarget then
                        ArmorText.Color = Color3.fromRGB(0,0,0)
                    else
                        ArmorText.Color = Esp.Settings.PlayerArmorColor
                    end
                    if Framework:GetArmor(Model) == true then ArmorText.Text = "Armored" else ArmorText.Text = "No Armor" end
                    ArmorText.Visible = true
                    ArmorText.Color = Esp.Settings.PlayerArmorColor
                    ArmorText.Position = Vector2.new(x, math.floor(y+h*0.5+ArmorText.TextBounds.Y))
                else
                    ArmorText.Visible = false
                end
            else
                Box.Visible = false
                BoxOutline.Visible = false
                ArmorText.Visible = false
                DistanceText.Visible = false
                SleepingText.Visible = false
                if not Model then
                    SleepingText:Remove()
                    Box:Remove()
                    DistanceText:Remove()
                    BoxOutline:Remove()
                    ArmorText:Remove()
                    Render:Disconnect()
                end
            end
        end)
    end
end
do
    function Esp:AddOre(Item)
        local Model = Item.model
        local Distance,Name = Framework:Draw("Text",{Text ="",Font=2,Size=13,Center=true,Outline=true,Color=Color3.fromRGB(255,255,255),ZIndex = -9}),Framework:Draw("Text",{Text="",Font=2,Size=13,Center=true,Outline=true,Color=Color3.fromRGB(255,255,255),ZIndex = -9})
        local Render = game:GetService("RunService").RenderStepped:Connect(function()
            if Model and Model:FindFirstChild("Part") then
                local Pos,Visible = workspace.CurrentCamera:WorldToViewportPoint(Model:GetPivot().p)
                local pos2 = Camera:WorldToViewportPoint(Item.model:GetPivot().p)
                local pos = Vector2.new(pos2.X,pos2.Y)
                if Esp.Settings.OreDistances == true and Visible == true and Framework:DistanceFromCharacter(Item.model:GetPivot().p) <= Esp.Settings.OreRenderDistance then
                    Distance.Visible = true
                    Distance.Position = Vector2.new(pos.X,pos.Y + Distance.TextBounds.Y)
                    Distance.Color = Framework:ItemToColor(Item.typ)
                    Distance.Text = tostring(math.floor(Framework:DistanceFromCharacter(Item.model:GetPivot().p))).." Studs"
                else
                    Distance.Visible = false
                end
                if Esp.Settings.OreNames == true and Visible == true and Framework:DistanceFromCharacter(Item.model:GetPivot().p) <= Esp.Settings.OreRenderDistance then
                    Name.Visible = true
                    Name.Position = pos
                    Name.Color = Framework:ItemToColor(tostring(Item.typ))
                    Name.Text = Item.typ
                else
                    Name.Visible = false
                end
            else
                Distance.Visible = false
                Name.Visible = false
                if not Model and not Model:FindFirstChild("Part") then
                    Distance:Remove()
                    Name:Remove()
                    Render:Disconnect()
                end
            end
        end)
    end
end

function Aimbot:GetProjectileInfo()
    if getrenv()._G.modules.FPS.GetEquippedItem() == nil then return 0,0 end
    local mod = require(game:GetService("ReplicatedStorage").ItemConfigs[getrenv()._G.modules.FPS.GetEquippedItem().id])
    for i,v in pairs(mod) do
        if i == "ProjectileSpeed" or i == "ProjectileDrop" then
            return mod.ProjectileSpeed,mod.ProjectileDrop
        end
    end
    return 0,0
end

function Aimbot:CreateFov()
    FovCircle = Framework:Draw("Circle",{Visible=Aimbot.Settings.FovEnabled,Transparency=Aimbot.Settings.FovTransparency})
    FovCircle.Visible = Aimbot.Settings.FovEnabled
    FovCircle.Transparency=Aimbot.Settings.FovTransparency
    FovCircle.Thickness=2
    FovCircle.NumSides=120
    FovCircle.Radius=Aimbot.Settings.FovSize
    FovCircle.Filled=Aimbot.Settings.FovFilled
    FovCircle.Color=Aimbot.Settings.FovColor
    FovCircle.Position=Framework:GetCenterScreen()
    Aimbot.FovCircleDrawing = FovCircle
    game:GetService("RunService").RenderStepped:Connect(function()
        FovCircle.Visible = Aimbot.Settings.FovEnabled
        FovCircle.Transparency=Aimbot.Settings.FovTransparency
        FovCircle.Radius=Aimbot.Settings.FovSize
        FovCircle.Filled=Aimbot.Settings.FovFilled
        FovCircle.Color=Aimbot.Settings.FovColor
    end)
end

function Aimbot:InFov(Model)
    if not Model then return false end
    local playerpos = Camera:WorldToViewportPoint(Model:GetPivot().p)
    local distance = (Vector2.new(playerpos.X,playerpos.Y) - Vector2.new(Mouse.X,Mouse.Y)).Magnitude
    if distance <= Aimbot.Settings.FovSize + 30 then
        return true
    end
    return false
end

function Aimbot:GetClosest()
    local closest,PlayerDistance = nil,Esp.Settings.PlayerRenderDistance
    for i,v in pairs(Framework:GetPlayers()) do
        if v.model:FindFirstChild("HumanoidRootPart") then
            local pos = Camera.WorldToViewportPoint(Camera, v.model:GetPivot().Position)
            local MouseMagnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            local PlayerDistance = Framework:DistanceFromCharacter(v.model:GetPivot().Position)

            if Aimbot.Settings.TargetSleepers == true and Framework:IsSleeping(v.model) == false then
                if MouseMagnitude <= Aimbot.Settings.FovSize and PlayerDistance <= Esp.Settings.PlayerRenderDistance then
                    closest = v.model
                    PlayerDistance = PlayerDistance
                end
            elseif Aimbot.Settings.TargetSleepers == false then
                if MouseMagnitude <= Aimbot.Settings.FovSize and PlayerDistance <= Esp.Settings.PlayerRenderDistance then
                    closest = v.model
                    PlayerDistance = PlayerDistance
                end
            end
        end
    end
    if Aimbot.Settings.HighlightTarget == true then
        Aimbot.HighlightedTarget = closest
    end
    return closest
end

function Aimbot:GetVelocity(Model)
   local currentPosition = Model:GetPivot().Position
   wait(0.1)
   local newPosition = Model:GetPivot().Position
   local positionDifference = newPosition - currentPosition

   return positionDifference / 0.1
end

function Aimbot:Predict(Model)
    Prediction = Vector3.new(0,0,0)
    if Model and Prediction then
        local Velocity = Aimbot:GetVelocity(Model)
        local PS,PD = Aimbot:GetProjectileInfo()
        local Dist = (Model.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
        if Velocity == nil then Velocity = Model.HumanoidRootPart.Velocity end
        if PS == 0 then 
            PS = 800
        else
            PS = PS * 100
        end
        local TimeToTarget = tonumber(Dist) / tonumber(PS)
        Prediction = Model[Aimbot.Settings.AimbotHitpart].Position + (Velocity * TimeToTarget)
    end
    return Prediction
end

function Aimbot:SilentPredict(Model)
    Prediction = Vector3.new(0,0,0)
    if Model and Prediction then
        local Velocity = Aimbot:GetVelocity(Model)
        local PS,PD = Aimbot:GetProjectileInfo()
        local Dist = (Model.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
        if Velocity == nil then Velocity = Model.HumanoidRootPart.Velocity end
        if PS == 0 then 
            PS = 800
        else
            PS = PS + 200
        end
        local TimeToTarget = Dist / PS
        Prediction = Model[Aimbot.FovHitpartSilent].Position + (Velocity * TimeToTarget)
    end
    return Prediction
end

function Aimbot:PredictDrop(Model)
    if Model then
        local PS,PD = Aimbot:GetProjectileInfo()
        if PS == 0 then 
            PS = 800
        else
            PS = PS + 200
        end
        local distance = (Camera.CFrame.p - Model:GetPivot().p).Magnitude
        local time = (distance / PS)

        local finalspeed = PS * PS ^ 2 * time ^ 2
        time += (distance / finalspeed)

        local droptime = PD * time ^ 2

        if not tostring(droptime):find("nan") then
            return droptime
        end
        return 0
    end
end

print("Loaded In: "..tick()-oldtick)

return Framework, Esp, Aimbot, Crosshair
