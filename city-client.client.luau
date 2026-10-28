local p=game:GetService("Players").LocalPlayer
local RS=game:GetService("ReplicatedStorage")
local remote=RS:WaitForChild("CiudadControl")
local gui=Instance.new("ScreenGui") gui.Name="CiudadHUD" gui.ResetOnSpawn=false gui.Parent=p:WaitForChild("PlayerGui")
local panel=Instance.new("TextLabel") panel.Size=UDim2.new(0,500,0,132) panel.Position=UDim2.fromOffset(18,16) panel.BackgroundColor3=Color3.fromRGB(18,25,38) panel.BackgroundTransparency=.1 panel.TextColor3=Color3.fromRGB(242,239,224) panel.Font=Enum.Font.Gotham panel.TextSize=16 panel.TextWrapped=true panel.TextXAlignment=Enum.TextXAlignment.Left panel.Parent=gui
local padding=Instance.new("UIPadding") padding.PaddingLeft=UDim.new(0,14) padding.PaddingRight=UDim.new(0,12) padding.Parent=panel
local corner=Instance.new("UICorner") corner.CornerRadius=UDim.new(0,10) corner.Parent=panel
local button=Instance.new("TextButton") button.Size=UDim2.fromOffset(180,38) button.Position=UDim2.new(0,18,0,158) button.BackgroundColor3=Color3.fromRGB(242,185,71) button.Text="Recuperar [R]" button.Font=Enum.Font.GothamBold button.TextSize=16 button.Parent=gui
button.Activated:Connect(function() remote:FireServer("Reset") end)
local UIS=game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input,processed)
 if processed then return end
 if input.KeyCode==Enum.KeyCode.LeftShift then remote:FireServer("Sprint",true) end
 if input.KeyCode==Enum.KeyCode.R then remote:FireServer("Reset") end
end)
UIS.InputEnded:Connect(function(input) if input.KeyCode==Enum.KeyCode.LeftShift then remote:FireServer("Sprint",false) end end)
local marker=Instance.new("Part") marker.Name="MiDestino" marker.Anchored=true marker.CanCollide=false marker.CanQuery=false marker.Size=Vector3.new(10,.3,10) marker.Color=Color3.fromRGB(76,255,191) marker.Material=Enum.Material.Neon
local bill=Instance.new("BillboardGui") bill.Size=UDim2.fromOffset(170,40) bill.StudsOffset=Vector3.new(0,10,0) bill.AlwaysOnTop=true bill.Parent=marker
local text=Instance.new("TextLabel") text.Size=UDim2.fromScale(1,1) text.BackgroundColor3=Color3.fromRGB(18,25,38) text.TextColor3=marker.Color text.Font=Enum.Font.GothamBold text.TextSize=18 text.Parent=bill
local money=p:WaitForChild("leaderstats"):WaitForChild("Dinero")
while gui.Parent do
 local dest=p:GetAttribute("Destino")
 local r=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
 if dest then marker.Position=dest+Vector3.new(0,1,0) marker.Parent=workspace text.Text="DESTINO · "..(r and math.floor((r.Position-dest).Magnitude) or 0).." m" else marker.Parent=nil end
 panel.Text="CIUDAD LIBRE    |    $"..money.Value.."    |    ALERTA "..(p:GetAttribute("Alerta") or 0).."/3\n\n"..(p:GetAttribute("Objetivo") or "Explora la ciudad").."\n\nWASD: mover / conducir · Shift: correr · E: interactuar · Espacio: salir"
 task.wait(.2)
end
