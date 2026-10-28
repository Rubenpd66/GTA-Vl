local W=workspace
local city=Instance.new("Model") city.Name="CiudadLibre" city.Parent=W
local function part(name,size,pos,color,parent)
 local p=Instance.new("Part") p.Name=name p.Size=size p.Position=pos p.Color=Color3.fromRGB(unpack(color)) p.Anchored=true p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth p.Parent=parent or city return p
end
local function label(p,text)
 local b=Instance.new("BillboardGui") b.Size=UDim2.fromOffset(220,48) b.StudsOffset=Vector3.new(0,5,0) b.MaxDistance=110 b.AlwaysOnTop=true b.Parent=p
 local t=Instance.new("TextLabel") t.Size=UDim2.fromScale(1,1) t.BackgroundColor3=Color3.fromRGB(18,25,38) t.BackgroundTransparency=.15 t.TextColor3=Color3.new(1,1,1) t.TextScaled=true t.Font=Enum.Font.GothamBold t.Text=text t.Parent=b
end
part("Terreno",Vector3.new(430,1,430),Vector3.new(0,0,0),{91,134,105})
for _,n in {-120,0,120} do
 part("Calle",Vector3.new(26,.2,420),Vector3.new(n,.6,0),{43,48,57})
 part("Calle",Vector3.new(420,.2,26),Vector3.new(0,.61,n),{43,48,57})
 for k=-195,195,30 do
  if math.abs(k)>16 and math.abs(math.abs(k)-120)>18 then
   part("Linea",Vector3.new(.5,.05,10),Vector3.new(n,.73,k),{245,211,105})
   part("Linea",Vector3.new(10,.05,.5),Vector3.new(k,.74,n),{245,211,105})
  end
 end
end
for _,x in {-60,60} do for _,z in {-60,60} do
 part("Acera",Vector3.new(90,1,90),Vector3.new(x,1,z),{179,184,183})
end end
local colors={{211,162,122},{123,161,177},{179,143,155},{180,185,156}}
for i,pos in {Vector3.new(-70,0,-70),Vector3.new(65,0,-68),Vector3.new(-70,0,65)} do
 for j=-1,1,2 do
 local x=pos.X+j*21 local z=pos.Z local h=22+i*7
 part("Edificio",Vector3.new(32,h,48),Vector3.new(x,h/2+1.5,z),colors[i])
 for y=8,h-3,9 do for dx=-9,9,9 do
 part("Ventana",Vector3.new(5,4,.2),Vector3.new(x+dx,y,z+24.15),{166,224,238})
 end end
 part("Cornisa",Vector3.new(34,1,50),Vector3.new(x,h+2,z),{65,74,83})
 end
 task.wait()
end
part("Parque",Vector3.new(82,.3,82),Vector3.new(60,1.7,60),{100,162,102})
part("Sendero",Vector3.new(8,.2,82),Vector3.new(60,1.95,60),{221,200,161})
for _,p in {Vector3.new(35,0,35),Vector3.new(85,0,35),Vector3.new(35,0,85),Vector3.new(85,0,85)} do
 part("Tronco",Vector3.new(2,8,2),p+Vector3.new(0,5,0),{112,82,58})
 local t=part("Copa",Vector3.new(14,14,14),p+Vector3.new(0,13,0),{54,119,87}) t.Shape=Enum.PartType.Ball
end
part("Almacen",Vector3.new(55,18,45),Vector3.new(170,9.5,-65),{119,133,145})
part("PuertaAlmacen",Vector3.new(24,12,.4),Vector3.new(170,6.5,-42.3),{66,76,87})
part("GarajeSuelo",Vector3.new(68,1,45),Vector3.new(-60,1,165),{143,151,158})
part("GarajeFondo",Vector3.new(68,18,2),Vector3.new(-60,10,187),{66,84,103})
for _,x in {-93,-27} do part("GarajePilar",Vector3.new(2,18,44),Vector3.new(x,10,165),{66,84,103}) end
local roof=part("GarajeTecho",Vector3.new(70,1,47),Vector3.new(-60,19,165),{235,178,78}) label(roof,"CIUDAD LIBRE · GARAJE")
local spawn=W:FindFirstChildOfClass("SpawnLocation")
if spawn then spawn.CFrame=CFrame.new(-17,2,155) spawn.Neutral=true end
local function point(name,pos,text)
 local p=part(name,Vector3.new(4,1,4),pos,{249,190,65}) p.Material=Enum.Material.Neon label(p,text)
 local pr=Instance.new("ProximityPrompt") pr.ActionText="Comenzar" pr.ObjectText=text pr.HoldDuration=.3 pr.MaxActivationDistance=12 pr.Parent=p
 return p
end
point("Entrega",Vector3.new(-20,1.5,142),"PAQUETE · $100")
point("Paseo",Vector3.new(-20,1.5,163),"CONDUCE · $150")
point("Carrera",Vector3.new(-20,1.5,184),"CONTRARRELOJ · $250")
local alert=point("Alerta",Vector3.new(25,1.5,145),"PRUEBA POLICIAL") alert.ProximityPrompt.ActionText="Subir alerta"
local dest=part("DestinoEntrega",Vector3.new(8,.2,8),Vector3.new(165,.8,-28),{79,227,186})
part("DestinoPaseo",Vector3.new(10,.2,10),Vector3.new(120,.8,-175),{79,227,186})
local cars=Instance.new("Folder") cars.Name="Coches" cars.Parent=city
for i=1,2 do
 local m=Instance.new("Model") m.Name=i==1 and "Sol" or "Brisa" m.Parent=cars
 local p=Vector3.new(-78+(i-1)*35,3,162)
 local body=part("Chasis",Vector3.new(7,2,12),p,i==1 and {234,154,59} or {55,174,188},m) m.PrimaryPart=body
 part("Cabina",Vector3.new(6,2.5,5),p+Vector3.new(0,2,0),{64,99,117},m)
 local seat=Instance.new("VehicleSeat") seat.Name="Conductor" seat.Size=Vector3.new(2,1,2) seat.CFrame=CFrame.new(p+Vector3.new(0,2.4,0)) seat.Anchored=true seat.Transparency=1 seat.Parent=m
 for _,x in {-3.6,3.6} do for _,z in {-3.5,3.5} do
 local w=part("Rueda",Vector3.new(2.7,1.2,2.7),p+Vector3.new(x,-.6,z),{25,28,35},m) w.Shape=Enum.PartType.Cylinder w.Orientation=Vector3.new(0,0,90)
 end end
 for _,x in {-2.3,2.3} do part("Faro",Vector3.new(1.4,.6,.2),p+Vector3.new(x,0,-6.1),{255,247,198},m) end
 local pr=Instance.new("ProximityPrompt") pr.ActionText="Conducir" pr.ObjectText=m.Name pr.MaxActivationDistance=12 pr.Parent=body
 m:SetAttribute("Home",m:GetPivot())
end
local police=Instance.new("Model") police.Name="Patrulla" police.Parent=city
local pb=part("Chasis",Vector3.new(7,3,12),Vector3.new(170,3,170),{37,52,77},police) police.PrimaryPart=pb
part("Techo",Vector3.new(6,2,5),Vector3.new(170,5,170),{220,229,235},police)
local red=part("Sirena",Vector3.new(5,.7,1),Vector3.new(170,6.4,170),{240,73,91},police) red.Material=Enum.Material.Neon
label(pb,"PATRULLA")
game:GetService("Lighting").ClockTime=16
W.CurrentCamera.CFrame=CFrame.lookAt(Vector3.new(270,240,300),Vector3.new(0,0,25))
for _,v in city:GetDescendants() do if v:IsA("ProximityPrompt") then v.RequiresLineOfSight=false end end
return "Ciudad creada: "..#city:GetDescendants().." objetos"
