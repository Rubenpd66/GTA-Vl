local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local RS=game:GetService("ReplicatedStorage")
local city=workspace:WaitForChild("CiudadLibre")
local remote=Instance.new("RemoteEvent") remote.Name="CiudadControl" remote.Parent=RS
local states={}
local route={Vector3.new(0,1,120),Vector3.new(120,1,120),Vector3.new(120,1,-120),Vector3.new(0,1,-120),Vector3.new(0,1,120)}
local function resetMission(p,s,msg)
 s.mission=nil s.step=nil s.deadline=nil
 p:SetAttribute("Objetivo",msg or "Explora o elige una actividad junto al garaje")
 p:SetAttribute("Destino",nil)
end
local function setup(p)
 local stats=Instance.new("Folder") stats.Name="leaderstats" stats.Parent=p
 local money=Instance.new("IntValue") money.Name="Dinero" money.Parent=stats
 local s={alert=0,lastAction=0} states[p]=s
 p:SetAttribute("Alerta",0) resetMission(p,s)
 p.CharacterAdded:Connect(function(c)
  resetMission(p,s) s.alert=0 p:SetAttribute("Alerta",0)
  c:WaitForChild("Humanoid").WalkSpeed=16
 end)
end
Players.PlayerAdded:Connect(setup)
for _,p in Players:GetPlayers() do setup(p) end
Players.PlayerRemoving:Connect(function(p) states[p]=nil end)
local function root(p) return p.Character and p.Character:FindFirstChild("HumanoidRootPart") end
local function carOf(p)
 for _,m in city.Coches:GetChildren() do
  if m.Conductor.Occupant and m.Conductor.Occupant.Parent==p.Character then return m end
 end
end
for _,m in city.Coches:GetChildren() do
 m.Chasis.ProximityPrompt.Triggered:Connect(function(p)
  local r=root(p)
  if r and (r.Position-m.Chasis.Position).Magnitude<16 and not m.Conductor.Occupant then m.Conductor:Sit(p.Character.Humanoid) end
 end)
 m.Conductor:GetPropertyChangedSignal("Occupant"):Connect(function() m.Chasis.ProximityPrompt.Enabled=m.Conductor.Occupant==nil end)
end
for _,name in {"Entrega","Paseo","Carrera","Alerta"} do
 local marker=city[name]
 marker.ProximityPrompt.Triggered:Connect(function(p)
  local s=states[p] local r=root(p)
  if not s or not r or (r.Position-marker.Position).Magnitude>16 then return end
  if name=="Alerta" then s.alert=math.min(3,s.alert+1) s.escape=nil p:SetAttribute("Alerta",s.alert) return end
  if s.mission then return end
  s.mission=name
  if name=="Carrera" then s.step=1 s.deadline=os.clock()+100 p:SetAttribute("Destino",route[1])
  else p:SetAttribute("Destino",city[name=="Entrega" and "DestinoEntrega" or "DestinoPaseo"].Position) end
  p:SetAttribute("Objetivo",name=="Entrega" and "Entrega el paquete en el almacén · $100" or name=="Paseo" and "Conduce hasta el marcador del norte · $150" or "Carrera: toma un coche y cruza 5 controles · 100 s")
 end)
end
remote.OnServerEvent:Connect(function(p,action,value)
 local s=states[p] local r=root(p)
 if not s or not r then return end
 if action=="Sprint" then p.Character.Humanoid.WalkSpeed=value==true and 25 or 16 return end
 if action~="Reset" or os.clock()-s.lastAction<3 then return end
 s.lastAction=os.clock()
 local m=carOf(p)
 if m then m:PivotTo(m:GetAttribute("Home")) else p.Character:PivotTo(CFrame.new(-17,5,155)) end
 resetMission(p,s,"Recuperado en el garaje. Elige una actividad.")
end)
local tickTime=0
RunService.Heartbeat:Connect(function(dt)
 dt=math.min(dt,.1)
 for _,m in city.Coches:GetChildren() do
  local seat=m.Conductor
  if seat.Occupant then
   local throttle=seat.ThrottleFloat local steer=seat.SteerFloat
   local cf=m:GetPivot()
   local distance=throttle*52*dt
   local target=cf*CFrame.Angles(0,-steer*throttle*1.65*dt,0)*CFrame.new(0,0,-distance)
   local params=RaycastParams.new() params.FilterType=Enum.RaycastFilterType.Exclude params.FilterDescendantsInstances={m,seat.Occupant.Parent}
   local delta=target.Position-cf.Position
   local hit=delta.Magnitude>.001 and workspace:Blockcast(cf,Vector3.new(6,1.5,10),delta,params)
   if not hit and math.abs(target.X)<205 and math.abs(target.Z)<205 then m:PivotTo(target) end
  end
 end
 local patrol=city.Patrulla
 local chase=nil local minDist=math.huge
 for p,s in pairs(states) do local r=root(p)
  if r and s.alert>0 then local d=(r.Position-patrol.PrimaryPart.Position).Magnitude if d<minDist then chase=p minDist=d end end
 end
 if chase then
  local r=root(chase) local pos=patrol.PrimaryPart.Position
  local delta=Vector3.new(r.Position.X-pos.X,0,r.Position.Z-pos.Z)
  if delta.Magnitude>6 then
   local nextPos=pos+delta.Unit*math.min(delta.Magnitude,dt*(18+states[chase].alert*5))
   patrol:PivotTo(CFrame.lookAt(nextPos,nextPos+delta.Unit))
  end
 end
 tickTime+=dt if tickTime<.2 then return end tickTime=0
 for p,s in pairs(states) do
  local r=root(p) if not r then continue end
  if r.Position.Y < -30 then p.Character:PivotTo(CFrame.new(-17,5,155)) end
  if s.alert>0 then
   local d=(r.Position-patrol.PrimaryPart.Position).Magnitude
   if d>95 then s.escape=s.escape or os.clock() else s.escape=nil end
   if s.escape and os.clock()-s.escape>10 then s.alert=0 p:SetAttribute("Alerta",0) end
   if d<9 then
    s.alert=0 p:SetAttribute("Alerta",0)
    local m=carOf(p) if m then m:PivotTo(m:GetAttribute("Home")) else p.Character:PivotTo(CFrame.new(-17,5,155)) end
    resetMission(p,s,"La patrulla te ha devuelto al garaje.")
   end
  end
  if s.mission then
   if s.deadline then
    local remaining=math.max(0,math.ceil(s.deadline-os.clock()))
    p:SetAttribute("Objetivo","Carrera · control "..s.step.."/5 · "..remaining.." s")
    if remaining==0 then resetMission(p,s,"Tiempo agotado. Vuelve a intentarlo.") continue end
   end
   local destination=p:GetAttribute("Destino")
   if destination and (r.Position-destination).Magnitude<14 and (s.mission=="Entrega" or carOf(p)) then
    if s.mission=="Carrera" and s.step<5 then s.step+=1 p:SetAttribute("Destino",route[s.step])
    else
     local reward=s.mission=="Entrega" and 100 or s.mission=="Paseo" and 150 or 250
     p.leaderstats.Dinero.Value+=reward resetMission(p,s,"Actividad completada +$"..reward..". Vuelve al garaje para otra.")
    end
   end
  end
 end
end)
