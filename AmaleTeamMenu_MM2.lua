--[[ AMALE TEAM MENU v6 | MM2 (Murder Mystery 2) | TEK SCRIPT v6.1 - hepsini kopyala ]]
local ENV = (getgenv and getgenv()) or _G
local function runBlock(n, fn)
 local ok, err = pcall(fn)
 if not ok then
  warn("[AMALE] modül " .. n .. " hatası: " .. tostring(err))
  local M = ENV.AmaleMenu
  if M and M.errors then table.insert(M.errors, 1, "modül " .. n .. ": " .. tostring(err)) end
 end
end
runBlock(1, function()
local CONFIG = {
 Title = "AMALE TEAM MENU",
 ButtonText = "AT",
 ButtonSize = 56,
 MenuWidth = 440,
 MenuHeight = 270,
 MainColor = Color3.fromRGB(220, 30, 30),
 DarkColor = Color3.fromRGB(120, 12, 12),
 SelectColor = Color3.fromRGB(255, 85, 85),
 ToggleKey = Enum.KeyCode.RightControl, -- bilgisayarda menu ac/kapat
}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local env = (getgenv and getgenv()) or _G
if env.AmaleCleanup then pcall(env.AmaleCleanup) end
local A = { parts = {}, errors = {}, closers = {}, hbFns = {}, steppedFns = {}, renderFns = {} }
env.AmaleMenu = A
local errSeen = {}
local function safe(fn, ...)
 local ok, err = pcall(fn, ...)
 if not ok then
  err = tostring(err)
  if not errSeen[err] then
   errSeen[err] = true
   warn("[AMALE] " .. err)
   table.insert(A.errors, 1, err)
   if #A.errors > 6 then table.remove(A.errors) end
  end
 end
 return ok
end
local function cam()
 return Workspace.CurrentCamera
end
local S = {
 flyOn = false, flySpeed = 60, flyButtons = true,
 walkOn = false, walkSpeed = 32,
 cfOn = false, cfSpeed = 30,
 jumpOn = false, jumpPower = 80,
 infJump = false, bhop = false, noclip = false,
 spinOn = false, spinSpeed = 360,
 clickTP = false, freeze = false,
 aim = false, aimSmooth = 0.4, aimHead = true, aimTeam = true,
 aimWall = false, aimRange = 300, aimMaxDist = 1000,
 aimSticky = false, aimPredict = 0, aimCircle = false,
 esp = false, espName = true, espInfo = true, espTeamColor = false,
 tracers = false, crosshair = false,
 bright = false, xray = false,
 fov = 70, fovChanged = false,
 gravOn = false, gravity = 100,
 timeLock = false, clock = 14,
 noFog = false, noShadows = false, fpsBoost = false,
 antiAfk = true, antiFling = false, antiVoid = false, hud = false,
 godHP = false, instantPrompt = false,
 glide = false, glideSpeed = 20, climb = false, climbSpeed = 40,
 antiRagdoll = false,
 sizeOn = false, sizeMul = 2, rainbow = false, disco = false,
 launchPower = 150,
 flyNoclip = false, autoWalk = false, aimHold = false, aimByDist = false,
 espMaxDist = 0, ghost = false,
 timeLapse = false, lapseSpeed = 1, brightOn = false, brightness = 3,
 exposureOn = false, exposure = 0.5,
 mmEsp = false, espMurd = true, espSher = true, espInno = true, mmInfo = true, mmTracer = false,
 gunEsp = false, trapEsp = false, roleHud = false, mmWarn = false, sherWarn = false, mmWarnDist = 40,
 autoShoot = false, shootDelay = 0.6, autoEquipGun = false, quickBtns = false,
 autoGun = false, autoEscape = false, escapeDist = 30, coinFarm = false, coinDelay = 0.5,
 aimMurdOnly = false,
 knifeName = "Knife", gunToolName = "Gun", gunDropName = "GunDrop", trapName = "Trap", coinName = "Coin_Server",
 locked = false, btnSize = CONFIG.ButtonSize,
}
local MAIN = CONFIG.MainColor
local DARK = CONFIG.DarkColor
local SELECT = CONFIG.SelectColor
local BG = Color3.fromRGB(24, 24, 28)
local ROW = Color3.fromRGB(42, 42, 50)
local GRAY = Color3.fromRGB(95, 95, 105)
local WHITE = Color3.new(1, 1, 1)
local FONT = Enum.Font.SourceSansBold
local GREEN = Color3.fromRGB(0, 255, 70)
local BLUE = Color3.fromRGB(0, 170, 255)
local conns = {}
local function bind(signal, fn)
 local c = signal:Connect(fn)
 table.insert(conns, c)
 return c
end
local function new(class, props, parent)
 local o = Instance.new(class)
 for k, v in pairs(props) do
  pcall(function() o[k] = v end)
 end
 if parent then o.Parent = parent end
 return o
end
local function corner(o, r)
 new("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o)
end
local orders = setmetatable({}, { __mode = "k" })
local function ord(page)
 orders[page] = (orders[page] or 0) + 1
 return orders[page]
end
local function isPress(input)
 return input.UserInputType == Enum.UserInputType.Touch
  or input.UserInputType == Enum.UserInputType.MouseButton1
end
local function makeDraggable(handle, target, canDrag)
 local dragging, dragInput, startPos, startFramePos
 bind(handle.InputBegan, function(input)
  if isPress(input) and (not canDrag or canDrag()) then
   dragging = true
   dragInput = input
   startPos = input.Position
   startFramePos = target.Position
   local c
   c = input.Changed:Connect(function()
    if input.UserInputState == Enum.UserInputState.End then
     dragging = false
     c:Disconnect()
    end
   end)
  end
 end)
 bind(UIS.InputChanged, function(input)
  if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
   local d = input.Position - startPos
   target.Position = UDim2.new(
    startFramePos.X.Scale, startFramePos.X.Offset + d.X,
    startFramePos.Y.Scale, startFramePos.Y.Offset + d.Y
   )
  end
 end)
end
local function holdButton(btn, onChange)
 local held
 bind(btn.InputBegan, function(input)
  if isPress(input) then
   held = input
   onChange(true)
  end
 end)
 bind(UIS.InputEnded, function(input)
  if held and input == held then
   held = nil
   onChange(false)
  end
 end)
end
local gui = new("ScreenGui", {
 Name = "AmaleTeamMenu",
 ResetOnSpawn = false,
 IgnoreGuiInset = true,
 DisplayOrder = 999,
 ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
do
 local ok = pcall(function()
  if gethui then
   gui.Parent = gethui()
  else
   gui.Parent = CoreGui
  end
 end)
 if not ok or not gui.Parent then
  gui.Parent = player:WaitForChild("PlayerGui")
 end
end
local menu = new("Frame", {
 Name = "Menu",
 Size = UDim2.fromOffset(CONFIG.MenuWidth, CONFIG.MenuHeight),
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 BackgroundColor3 = BG,
 Visible = false,
 ClipsDescendants = true,
 ZIndex = 5,
}, gui)
corner(menu, 10)
new("UIStroke", { Color = MAIN, Thickness = 2 }, menu)
local titleBar = new("Frame", {
 Size = UDim2.new(1, 0, 0, 32),
 BackgroundColor3 = DARK,
 BorderSizePixel = 0,
}, menu)
new("TextLabel", {
 Size = UDim2.new(1, -80, 1, 0),
 Position = UDim2.fromOffset(40, 0),
 BackgroundTransparency = 1,
 Text = CONFIG.Title,
 TextColor3 = WHITE,
 Font = FONT,
 TextSize = 20,
}, titleBar)
local closeBtn = new("TextButton", {
 Size = UDim2.fromOffset(30, 24),
 Position = UDim2.new(1, -36, 0.5, -12),
 BackgroundColor3 = MAIN,
 Text = "X",
 TextColor3 = WHITE,
 Font = FONT,
 TextSize = 16,
}, titleBar)
corner(closeBtn, 6)
closeBtn.Activated:Connect(function() menu.Visible = false end)
makeDraggable(titleBar, menu)
local sidebar = new("ScrollingFrame", {
 Size = UDim2.new(0, 108, 1, -32),
 Position = UDim2.fromOffset(0, 32),
 BackgroundColor3 = DARK,
 BorderSizePixel = 0,
 ScrollBarThickness = 3,
 CanvasSize = UDim2.new(),
 AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, menu)
new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, sidebar)
new("UIPadding", {
 PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6),
 PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
}, sidebar)
local content = new("Frame", {
 Size = UDim2.new(1, -108, 1, -32),
 Position = UDim2.fromOffset(108, 32),
 BackgroundTransparency = 1,
}, menu)
local BTN_POS = UDim2.new(0, 14, 0.4, 0)
local openBtn = new("TextButton", {
 Name = "OpenButton",
 Size = UDim2.fromOffset(S.btnSize, S.btnSize),
 Position = BTN_POS,
 BackgroundColor3 = MAIN,
 Text = CONFIG.ButtonText,
 TextColor3 = WHITE,
 Font = FONT,
 TextScaled = true,
 AutoButtonColor = false,
 ZIndex = 10,
}, gui)
corner(openBtn, 100)
local btnStroke = new("UIStroke", { Color = WHITE, Thickness = 2 }, openBtn)
new("UIPadding", {
 PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
 PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
}, openBtn)
makeDraggable(openBtn, openBtn, function() return not S.locked end)
local lastToggle = 0
local function toggleMenu()
 if tick() - lastToggle > 0.25 then
  lastToggle = tick()
  menu.Visible = not menu.Visible
 end
end
local pressPos, btnMoved = nil, false
bind(openBtn.InputBegan, function(input)
 if isPress(input) then
  pressPos = input.Position
  btnMoved = false
 end
end)
bind(UIS.InputChanged, function(input)
 if pressPos and (input.UserInputType == Enum.UserInputType.Touch
  or input.UserInputType == Enum.UserInputType.MouseMovement) then
  if (input.Position - pressPos).Magnitude > 12 then btnMoved = true end
 end
end)
bind(openBtn.InputEnded, function(input)
 if isPress(input) and pressPos then
  if not btnMoved then toggleMenu() end
  pressPos = nil
 end
end)
openBtn.Activated:Connect(function()
 if not btnMoved then toggleMenu() end
end)
bind(UIS.InputBegan, function(input, processed)
 if not processed and input.KeyCode == CONFIG.ToggleKey then toggleMenu() end
end)
local tabs, userPicked = {}, false
local function selectTab(name, byUser)
 if byUser then userPicked = true end
 if not tabs[name] then return end
 for n, t in pairs(tabs) do
  local on = (n == name)
  t.page.Visible = on
  t.btn.BackgroundColor3 = on and SELECT or MAIN
 end
end
local function lowestTab()
 local best, bo = nil, math.huge
 for n, t in pairs(tabs) do
  if t.order < bo then best, bo = n, t.order end
 end
 return best
end
local function createTab(name, order)
 order = order or 50
 local btn = new("TextButton", {
  Size = UDim2.new(1, 0, 0, 34),
  BackgroundColor3 = MAIN,
  Text = name,
  TextColor3 = WHITE,
  Font = FONT,
  TextSize = 17,
  AutoButtonColor = false,
  LayoutOrder = order,
 }, sidebar)
 corner(btn, 8)
 local page = new("ScrollingFrame", {
  Size = UDim2.fromScale(1, 1),
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  ScrollBarThickness = 4,
  CanvasSize = UDim2.new(),
  AutomaticCanvasSize = Enum.AutomaticSize.Y,
  Visible = false,
 }, content)
 new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, page)
 new("UIPadding", {
  PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6),
  PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6),
 }, page)
 tabs[name] = { btn = btn, page = page, order = order }
 btn.Activated:Connect(function() selectTab(name, true) end)
 if not userPicked then selectTab(lowestTab()) end
 return page
end
local toggles = {}
local function addSection(page, text)
 new("TextLabel", {
  Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = text,
  TextColor3 = SELECT, Font = FONT, TextSize = 15,
  TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = ord(page),
 }, page)
end
local function addToggle(page, text, default, callback, keep)
 local row = new("Frame", {
  Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = ROW, LayoutOrder = ord(page),
 }, page)
 corner(row, 8)
 new("TextLabel", {
  Size = UDim2.new(1, -72, 1, 0), Position = UDim2.fromOffset(10, 0),
  BackgroundTransparency = 1, Text = text, TextColor3 = WHITE, Font = FONT,
  TextSize = 16, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
 }, row)
 local sw = new("TextButton", {
  Size = UDim2.fromOffset(52, 24), Position = UDim2.new(1, -60, 0.5, -12),
  Text = "", AutoButtonColor = false, BackgroundColor3 = GRAY,
 }, row)
 corner(sw, 12)
 local knob = new("Frame", { Size = UDim2.fromOffset(18, 18), BackgroundColor3 = WHITE }, sw)
 corner(knob, 9)
 local on = default and true or false
 local function render()
  sw.BackgroundColor3 = on and MAIN or GRAY
  knob.Position = on and UDim2.fromOffset(31, 3) or UDim2.fromOffset(3, 3)
 end
 local function set(v, fire)
  on = v and true or false
  render()
  if fire then safe(callback, on) end
 end
 render()
 sw.Activated:Connect(function() set(not on, true) end)
 if not keep then
  table.insert(toggles, { get = function() return on end, set = set })
 end
 if on then safe(callback, on) end
 return { Set = set }
end
local function addStepper(page, text, min, max, step, default, callback)
 local row = new("Frame", {
  Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = ROW, LayoutOrder = ord(page),
 }, page)
 corner(row, 8)
 new("TextLabel", {
  Size = UDim2.new(1, -134, 1, 0), Position = UDim2.fromOffset(10, 0),
  BackgroundTransparency = 1, Text = text, TextColor3 = WHITE, Font = FONT,
  TextSize = 15, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
 }, row)
 local value = default
 local valLabel = new("TextLabel", {
  Size = UDim2.fromOffset(50, 28), Position = UDim2.new(1, -92, 0.5, -14),
  BackgroundTransparency = 1, Text = tostring(value), TextColor3 = WHITE,
  Font = FONT, TextSize = 17,
 }, row)
 local function set(v)
  v = math.clamp(math.floor(v * 100 + 0.5) / 100, min, max)
  value = v
  valLabel.Text = tostring(v)
  safe(callback, v)
 end
 local minus = new("TextButton", {
  Size = UDim2.fromOffset(32, 28), Position = UDim2.new(1, -126, 0.5, -14),
  BackgroundColor3 = MAIN, Text = "-", TextColor3 = WHITE, Font = FONT, TextSize = 20,
 }, row)
 corner(minus, 6)
 local plus = new("TextButton", {
  Size = UDim2.fromOffset(32, 28), Position = UDim2.new(1, -40, 0.5, -14),
  BackgroundColor3 = MAIN, Text = "+", TextColor3 = WHITE, Font = FONT, TextSize = 20,
 }, row)
 corner(plus, 6)
 minus.Activated:Connect(function() set(value - step) end)
 plus.Activated:Connect(function() set(value + step) end)
end
local function addButton(page, text, callback)
 local b = new("TextButton", {
  Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = MAIN, Text = text,
  TextColor3 = WHITE, Font = FONT, TextSize = 16, LayoutOrder = ord(page),
 }, page)
 corner(b, 8)
 b.Activated:Connect(function() safe(callback) end)
 return b
end
local function addLabel(page, text)
 return new("TextLabel", {
  Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
  BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(190, 190, 200),
  Font = Enum.Font.SourceSans, TextSize = 14, TextWrapped = true,
  TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = ord(page),
 }, page)
end
local function addTextBox(page, text, placeholder, callback)
 local row = new("Frame", {
  Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = ROW, LayoutOrder = ord(page),
 }, page)
 corner(row, 8)
 new("TextLabel", {
  Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.fromOffset(10, 0),
  BackgroundTransparency = 1, Text = text, TextColor3 = WHITE, Font = FONT,
  TextSize = 15, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
 }, row)
 local box = new("TextBox", {
  Size = UDim2.new(0.6, -16, 0, 28), Position = UDim2.new(0.4, 4, 0.5, -14),
  BackgroundColor3 = BG, Text = "", PlaceholderText = placeholder,
  PlaceholderColor3 = GRAY, TextColor3 = WHITE, Font = FONT, TextSize = 15,
  ClearTextOnFocus = false,
 }, row)
 corner(box, 6)
 box.FocusLost:Connect(function() safe(callback, box.Text) end)
 return box
end
local function getHum()
 local c = player.Character
 return c and c:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
 local c = player.Character
 return c and c:FindFirstChild("HumanoidRootPart")
end
local EXCLUDE
do
 local ok, v = pcall(function() return Enum.RaycastFilterType.Exclude end)
 if ok and v then
  EXCLUDE = v
 else
  EXCLUDE = Enum.RaycastFilterType.Blacklist
 end
end
local lightBackup = {}
local function lset(prop, value)
 if lightBackup[prop] == nil then lightBackup[prop] = Lighting[prop] end
 Lighting[prop] = value
end
local function lrestore(...)
 for _, prop in ipairs({ ... }) do
  if lightBackup[prop] ~= nil then
   Lighting[prop] = lightBackup[prop]
   lightBackup[prop] = nil
  end
 end
end
local function teamKey(p)
 if p.Team then return "T:" .. p.Team.Name end
 local v = p:GetAttribute("Team") or p:GetAttribute("TeamName")
 if v == nil and p.Character then v = p.Character:GetAttribute("Team") end
 if v == nil then
  for _, holder in ipairs({ p, p:FindFirstChild("leaderstats") }) do
   local o = holder:FindFirstChild("Team")
   if o and o:IsA("ValueBase") then
    v = o.Value
    break
   end
  end
 end
 if v ~= nil then return "A:" .. tostring(v) end
 return nil
end
local function relation(p)
 local a, b = teamKey(player), teamKey(p)
 if not a or not b then return "unknown" end
 return (a == b) and "ally" or "enemy"
end
function A.hb(fn) table.insert(A.hbFns, fn) end
function A.stepped(fn) table.insert(A.steppedFns, fn) end
function A.render(fn) table.insert(A.renderFns, fn) end
function A.onClose(fn) table.insert(A.closers, fn) end
function A.every(sec, fn)
 local acc = 0
 A.hb(function(dt)
  acc = acc + dt
  if acc >= sec then
   acc = 0
   fn()
  end
 end)
end
bind(RunService.Heartbeat, function(dt)
 for _, f in ipairs(A.hbFns) do safe(f, dt) end
end)
bind(RunService.Stepped, function()
 for _, f in ipairs(A.steppedFns) do safe(f) end
end)
bind(RunService.RenderStepped, function()
 for _, f in ipairs(A.renderFns) do safe(f) end
end)
local toastLabel = new("TextLabel", {
 Name = "Toast", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 10),
 Size = UDim2.fromOffset(260, 28), BackgroundColor3 = Color3.new(0, 0, 0),
 BackgroundTransparency = 0.35, TextColor3 = WHITE, Font = FONT, TextSize = 15,
 Text = "", Visible = false, ZIndex = 20,
}, gui)
corner(toastLabel, 8)
local toastId = 0
function A.toast(text)
 toastId = toastId + 1
 local id = toastId
 toastLabel.Text = text
 toastLabel.Visible = true
 task.delay(3, function()
  if id == toastId then toastLabel.Visible = false end
 end)
end
local MODULES = 5
function A.partLoaded(n)
 A.parts[n] = true
 local count = 0
 for _ in pairs(A.parts) do count = count + 1 end
 if count >= MODULES then
  A.toast("AMALE hazır! (" .. count .. "/" .. MODULES .. " modül)")
 else
  A.toast("AMALE: " .. count .. "/" .. MODULES .. " modül yüklendi")
 end
end
function A.close()
 for _, fn in ipairs(A.closers) do pcall(fn) end
 for _, c in ipairs(conns) do
  pcall(function() c:Disconnect() end)
 end
 pcall(function() gui:Destroy() end)
end
env.AmaleCleanup = A.close
function A.panic()
 for _, t in ipairs(toggles) do
  if t.get() then t.set(false, true) end
 end
end
A.player, A.S, A.safe, A.bind, A.new, A.corner, A.ord, A.gui, A.menu = player, S, safe, bind, new, corner, ord, gui, menu
A.createTab, A.selectTab, A.addSection, A.addToggle = createTab, selectTab, addSection, addToggle
A.addStepper, A.addButton, A.addLabel, A.addTextBox = addStepper, addButton, addLabel, addTextBox
A.holdButton, A.makeDraggable, A.isPress, A.getHum, A.getRoot = holdButton, makeDraggable, isPress, getHum, getRoot
A.cam, A.EXCLUDE, A.lset, A.lrestore, A.teamKey, A.relation = cam, EXCLUDE, lset, lrestore, teamKey, relation
A.MAIN, A.DARK, A.SELECT, A.BG, A.ROW, A.GRAY, A.WHITE, A.FONT = MAIN, DARK, SELECT, BG, ROW, GRAY, WHITE, FONT
A.GREEN, A.BLUE, A.CONFIG, A.openBtn, A.toggles, A.conns = GREEN, BLUE, CONFIG, openBtn, toggles, conns
safe(function()
 local pg = createTab("Ayarlar", 99)
 addSection(pg, "KIRMIZI TUŞ")
 addToggle(pg, "Tuşu Kilitle (taşınmasın)", false, function(v)
  S.locked = v
  btnStroke.Color = v and Color3.fromRGB(255, 220, 0) or WHITE
 end, true)
 addStepper(pg, "Tuş Boyu", 30, 120, 5, S.btnSize, function(v)
  S.btnSize = v
  openBtn.Size = UDim2.fromOffset(v, v)
 end)
 addStepper(pg, "Tuş Saydamlığı", 0, 0.8, 0.1, 0, function(v)
  openBtn.BackgroundTransparency = v
 end)
 local colors = {
  MAIN, Color3.fromRGB(0, 140, 255), Color3.fromRGB(0, 190, 80),
  Color3.fromRGB(160, 60, 220), Color3.fromRGB(255, 150, 0),
 }
 local ci = 1
 addButton(pg, "Tuş Rengini Değiştir", function()
  ci = ci % #colors + 1
  openBtn.BackgroundColor3 = colors[ci]
 end)
 addButton(pg, "Tuşu Eski Yerine Al", function()
  openBtn.Position = BTN_POS
 end)
 addSection(pg, "MENÜ")
 addStepper(pg, "Menü Genişliği", 340, 600, 20, CONFIG.MenuWidth, function(v)
  menu.Size = UDim2.fromOffset(v, menu.Size.Y.Offset)
 end)
 addStepper(pg, "Menü Yüksekliği", 200, 400, 20, CONFIG.MenuHeight, function(v)
  menu.Size = UDim2.fromOffset(menu.Size.X.Offset, v)
 end)
 addStepper(pg, "Menü Saydamlığı", 0, 0.6, 0.1, 0, function(v)
  menu.BackgroundTransparency = v
 end)
 addButton(pg, "PANİK: Tüm Özellikleri Kapat", A.panic)
 addButton(pg, "Menüyü Tamamen Kapat (Sil)", A.close)
 addSection(pg, "DURUM")
 local partsLabel = addLabel(pg, "")
 local errLabel = addLabel(pg, "Hata yok.")
 A.every(1, function()
  local names = { "Çekirdek", "Hareket", "Aimlock", "Görsel", "MM2" }
  local list = {}
  for i = 1, #names do
   list[#list + 1] = names[i] .. ": " .. (A.parts[i] and "tamam" or "YOK")
  end
  partsLabel.Text = table.concat(list, "  |  ")
  if #A.errors == 0 then
   errLabel.Text = "Hata yok."
  else
   errLabel.Text = "Son hatalar:\n" .. table.concat(A.errors, "\n")
  end
 end)
 addLabel(pg, CONFIG.Title .. " v6 MM2 - Menü başlığından tutup taşıyabilirsin.")
end)
A.partLoaded(1)
end)
runBlock(2, function()
local A = ((getgenv and getgenv()) or _G).AmaleMenu
if not A then
 warn("[AMALE] Önce 1. parçayı çalıştır.")
 return
end
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local player, S, safe, bind, new, corner, ord, gui = A.player, A.S, A.safe, A.bind, A.new, A.corner, A.ord, A.gui
local createTab, addSection, addToggle, addStepper = A.createTab, A.addSection, A.addToggle, A.addStepper
local addButton, addLabel, addTextBox = A.addButton, A.addLabel, A.addTextBox
local getHum, getRoot, cam, holdButton, EXCLUDE = A.getHum, A.getRoot, A.cam, A.holdButton, A.EXCLUDE
local relation, lset, lrestore = A.relation, A.lset, A.lrestore
local MAIN, WHITE, FONT, ROW, GREEN, BLUE = A.MAIN, A.WHITE, A.FONT, A.ROW, A.GREEN, A.BLUE
local coordLabel
local hud = new("TextLabel", {
 Name = "HUD", AnchorPoint = Vector2.new(1, 0),
 Position = UDim2.new(1, -8, 0, 8), Size = UDim2.fromOffset(200, 0),
 AutomaticSize = Enum.AutomaticSize.Y,
 BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.5,
 TextColor3 = WHITE, Font = FONT, TextSize = 14, Text = "",
 Visible = false, ZIndex = 3,
}, gui)
corner(hud, 6)
local flyUp, flyDown = false, false
local flyUpBtn = new("TextButton", {
 Name = "FlyUp", Size = UDim2.fromOffset(64, 52), Position = UDim2.new(1, -84, 0.5, -60),
 BackgroundColor3 = MAIN, BackgroundTransparency = 0.25, Text = "UP",
 TextColor3 = WHITE, Font = FONT, TextSize = 20, AutoButtonColor = false,
 Visible = false, ZIndex = 8,
}, gui)
corner(flyUpBtn, 10)
local flyDownBtn = new("TextButton", {
 Name = "FlyDown", Size = UDim2.fromOffset(64, 52), Position = UDim2.new(1, -84, 0.5, 4),
 BackgroundColor3 = MAIN, BackgroundTransparency = 0.25, Text = "DOWN",
 TextColor3 = WHITE, Font = FONT, TextSize = 18, AutoButtonColor = false,
 Visible = false, ZIndex = 8,
}, gui)
corner(flyDownBtn, 10)
holdButton(flyUpBtn, function(v) flyUp = v end)
holdButton(flyDownBtn, function(v) flyDown = v end)
local function updateFlyUI()
 local vis = S.flyOn and S.flyButtons
 flyUpBtn.Visible = vis
 flyDownBtn.Visible = vis
 if not vis then
  flyUp = false
  flyDown = false
 end
end
local climbParams = RaycastParams.new()
climbParams.FilterType = EXCLUDE
local flyBV, flyBG
local controls
task.spawn(function()
 pcall(function()
  local ps = player:WaitForChild("PlayerScripts", 5)
  controls = require(ps:WaitForChild("PlayerModule", 5)):GetControls()
 end)
end)
local function getMove()
 if controls then
  local ok, v = pcall(function() return controls:GetMoveVector() end)
  if ok and v then return v end
 end
 local hum = getHum()
 if hum then
  local md = cam().CFrame:VectorToObjectSpace(hum.MoveDirection)
  return Vector3.new(md.X, 0, md.Z)
 end
 return Vector3.zero
end
local function stopFly()
 if flyBV then flyBV:Destroy() flyBV = nil end
 if flyBG then flyBG:Destroy() flyBG = nil end
 local hum = getHum()
 if hum then hum.PlatformStand = false end
end
local function startFly()
 stopFly()
 local root, hum = getRoot(), getHum()
 if not root or not hum then return end
 flyBV = Instance.new("BodyVelocity")
 flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
 flyBV.Velocity = Vector3.zero
 flyBV.Parent = root
 flyBG = Instance.new("BodyGyro")
 flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
 flyBG.P = 9e4
 flyBG.CFrame = root.CFrame
 flyBG.Parent = root
 hum.PlatformStand = true
end
local promptStore, promptToken = {}, 0
local function promptInstant(v)
 if v:IsA("ProximityPrompt") and promptStore[v] == nil then
  promptStore[v] = v.HoldDuration
  v.HoldDuration = 0
 end
end
local function setInstantPrompts(on)
 promptToken = promptToken + 1
 local token = promptToken
 if on then
  task.spawn(function()
   local n = 0
   for _, v in ipairs(Workspace:GetDescendants()) do
    if token ~= promptToken then return end
    pcall(promptInstant, v)
    n = n + 1
    if n % 400 == 0 then task.wait() end
   end
  end)
 else
  for v, d in pairs(promptStore) do
   pcall(function() v.HoldDuration = d end)
  end
  promptStore = {}
 end
end
bind(Workspace.DescendantAdded, function(d)
 if S.instantPrompt and d:IsA("ProximityPrompt") then pcall(promptInstant, d) end
end)
local function getPing()
 local ok, v = pcall(function()
  return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
 end)
 if ok and v then return math.floor(v) end
 return 0
end
local function setAntiRagdoll(on)
 local hum = getHum()
 if not hum then return end
 hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not on)
 hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not on)
end
local fpsAvg = 60
local lastSafeCF
A.hb(function(dt)
 if dt > 0 then fpsAvg = fpsAvg * 0.9 + (1 / dt) * 0.1 end
 local hum, root = getHum(), getRoot()
 if S.flyOn and flyBV and flyBG then
  local cf = cam().CFrame
  local mv = getMove()
  local vert = (flyUp and 1 or 0) - (flyDown and 1 or 0)
  local dir = cf.RightVector * mv.X + cf.LookVector * (-mv.Z) + Vector3.new(0, vert, 0)
  flyBV.Velocity = dir * S.flySpeed
  flyBG.CFrame = cf
 end
 if hum then
  if S.walkOn then hum.WalkSpeed = S.walkSpeed end
  if S.jumpOn then
   hum.UseJumpPower = true
   hum.JumpPower = S.jumpPower
  end
  if S.bhop and not hum.Sit and hum.MoveDirection.Magnitude > 0
   and hum.FloorMaterial ~= Enum.Material.Air then
   hum:ChangeState(Enum.HumanoidStateType.Jumping)
  end
 end
 if root and hum then
  if S.cfOn and not S.flyOn and hum.MoveDirection.Magnitude > 0 then
   root.CFrame = root.CFrame + hum.MoveDirection * (S.cfSpeed * dt)
  end
  if S.spinOn and not S.flyOn then
   root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(S.spinSpeed) * dt, 0)
  end
  if S.antiVoid then
   if root.Position.Y < Workspace.FallenPartsDestroyHeight + 80 then
    if lastSafeCF then
     root.CFrame = lastSafeCF + Vector3.new(0, 5, 0)
     root.AssemblyLinearVelocity = Vector3.zero
    end
   elseif hum.FloorMaterial ~= Enum.Material.Air then
    lastSafeCF = root.CFrame
   end
  end
 end
 if root and hum and not S.flyOn then
  if S.glide then
   local v = root.AssemblyLinearVelocity
   if v.Y < -S.glideSpeed then
    root.AssemblyLinearVelocity = Vector3.new(v.X, -S.glideSpeed, v.Z)
   end
  end
  if S.climb and hum.MoveDirection.Magnitude > 0 then
   climbParams.FilterDescendantsInstances = { player.Character }
   if Workspace:Raycast(root.Position, hum.MoveDirection * 3, climbParams) then
    local v = root.AssemblyLinearVelocity
    root.AssemblyLinearVelocity = Vector3.new(v.X, S.climbSpeed, v.Z)
   end
  end
 end
 if S.godHP and hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
  hum.Health = hum.MaxHealth
 end
end)
pcall(function() RunService:UnbindFromRenderStep("AmaleWalk") end)
RunService:BindToRenderStep("AmaleWalk", Enum.RenderPriority.Input.Value + 1, function()
 if S.autoWalk then
  local hum = getHum()
  if hum then hum:Move(Vector3.new(0, 0, -1), true) end
 end
end)
A.stepped(function()
 local char = player.Character
 if char and (S.noclip or (S.flyOn and S.flyNoclip)) then
  for _, v in ipairs(char:GetDescendants()) do
   if v:IsA("BasePart") then v.CanCollide = false end
  end
 end
 if S.antiFling then
  for _, p in ipairs(Players:GetPlayers()) do
   if p ~= player and p.Character then
    for _, v in ipairs(p.Character:GetDescendants()) do
     if v:IsA("BasePart") then v.CanCollide = false end
    end
   end
  end
 end
end)
A.every(0.4, function()
 local root = getRoot()
 local px, py, pz, spd = 0, 0, 0, 0
 if root then
  px = math.floor(root.Position.X)
  py = math.floor(root.Position.Y)
  pz = math.floor(root.Position.Z)
  spd = math.floor(root.AssemblyLinearVelocity.Magnitude)
 end
 if S.hud then
  hud.Text = string.format(
   "FPS: %d | Ping: %d ms | Hız: %d\nX %d  Y %d  Z %d",
   math.floor(fpsAvg), getPing(), spd, px, py, pz
  )
 end
 if coordLabel then
  coordLabel.Text = string.format("Konumun: X %d  Y %d  Z %d", px, py, pz)
 end
end)
bind(UIS.JumpRequest, function()
 if S.infJump then
  local hum = getHum()
  if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
 end
end)
bind(player.CharacterAdded, function()
 task.wait(0.6)
 safe(function()
  if S.flyOn then startFly() end
  if S.antiRagdoll then setAntiRagdoll(true) end
  if S.freeze then
   local r = getRoot()
   if r then r.Anchored = true end
  end
 end)
end)
bind(player.Idled, function()
 if S.antiAfk then
  safe(function()
   local vu = game:GetService("VirtualUser")
   vu:CaptureController()
   vu:ClickButton2(Vector2.new())
  end)
 end
end)
local function clickTeleport(ray)
 local params = RaycastParams.new()
 params.FilterType = EXCLUDE
 params.FilterDescendantsInstances = { player.Character or gui }
 local res = Workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
 local root = getRoot()
 if res and root then
  root.CFrame = CFrame.new(res.Position + Vector3.new(0, 3, 0))
 end
end
bind(UIS.TouchTapInWorld, function(position, processedByUI)
 if S.clickTP and not processedByUI then
  safe(function()
   clickTeleport(cam():ScreenPointToRay(position.X, position.Y))
  end)
 end
end)
bind(UIS.InputBegan, function(input, processed)
 if S.clickTP and not processed
  and input.UserInputType == Enum.UserInputType.MouseButton1
  and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
  safe(function()
   local loc = UIS:GetMouseLocation()
   clickTeleport(cam():ViewportPointToRay(loc.X, loc.Y))
  end)
 end
end)
A.onClose(function()
 stopFly()
 pcall(setAntiRagdoll, false)
 pcall(setInstantPrompts, false)
 pcall(function() RunService:UnbindFromRenderStep("AmaleWalk") end)
 local h = getHum()
 if h then
  if S.walkOn then h.WalkSpeed = 16 end
  if S.jumpOn then h.JumpPower = 50 end
 end
 local r = getRoot()
 if r and S.freeze then r.Anchored = false end
 pcall(function() cam().CameraSubject = h end)
end)
safe(function()
 local pg = createTab("Fly", 1)
 addSection(pg, "UÇUŞ")
 addToggle(pg, "Fly (Uçuş)", false, function(v)
  S.flyOn = v
  if v then startFly() else stopFly() end
  updateFlyUI()
 end)
 addStepper(pg, "Fly Hızı", 10, 300, 10, S.flySpeed, function(v) S.flySpeed = v end)
 addToggle(pg, "Yukarı / Aşağı Tuşları", true, function(v)
  S.flyButtons = v
  updateFlyUI()
 end, true)
 addToggle(pg, "Fly Sırasında Noclip", false, function(v) S.flyNoclip = v end)
 addLabel(pg, "Joystick ile kameranın baktığı yöne uçarsın. Fly açıkken sağda UP / DOWN tuşları çıkar.")
end)
safe(function()
 local pg = createTab("Hareket", 2)
 addSection(pg, "HIZ VE ZIPLAMA")
 addToggle(pg, "Hız (WalkSpeed)", false, function(v)
  S.walkOn = v
  if not v then
   local h = getHum()
   if h then h.WalkSpeed = 16 end
  end
 end)
 addStepper(pg, "Yürüme Hızı", 16, 300, 4, S.walkSpeed, function(v) S.walkSpeed = v end)
 addToggle(pg, "TP Hız (CFrame, ek hız)", false, function(v) S.cfOn = v end)
 addStepper(pg, "TP Hız Değeri", 10, 200, 10, S.cfSpeed, function(v) S.cfSpeed = v end)
 addToggle(pg, "Zıplama Gücü", false, function(v)
  S.jumpOn = v
  if not v then
   local h = getHum()
   if h then h.JumpPower = 50 end
  end
 end)
 addStepper(pg, "Zıplama Değeri", 50, 400, 10, S.jumpPower, function(v) S.jumpPower = v end)
 addToggle(pg, "Sonsuz Zıplama", false, function(v) S.infJump = v end)
 addToggle(pg, "Bunny Hop (Otomatik Zıpla)", false, function(v) S.bhop = v end)
 addToggle(pg, "Yavaş Düşüş (Glide)", false, function(v) S.glide = v end)
 addStepper(pg, "Düşüş Hızı Sınırı", 5, 60, 5, S.glideSpeed, function(v) S.glideSpeed = v end)
 addToggle(pg, "Duvar Tırmanma (duvara doğru yürü)", false, function(v) S.climb = v end)
 addStepper(pg, "Tırmanma Hızı", 10, 100, 10, S.climbSpeed, function(v) S.climbSpeed = v end)
 addToggle(pg, "Otomatik İleri Yürü (kamera yönüne)", false, function(v) S.autoWalk = v end)
 addSection(pg, "DİĞER")
 addToggle(pg, "Noclip (Duvardan Geç)", false, function(v) S.noclip = v end)
 addToggle(pg, "Spin (Kendi Etrafında Dön)", false, function(v) S.spinOn = v end)
 addStepper(pg, "Spin Hızı (derece/sn)", 90, 1440, 90, S.spinSpeed, function(v) S.spinSpeed = v end)
 addToggle(pg, "Tıkla Işınlan (ekrana dokun)", false, function(v) S.clickTP = v end)
 addToggle(pg, "Dondur (Yerinde Sabitle)", false, function(v)
  S.freeze = v
  local r = getRoot()
  if r then r.Anchored = v end
 end)
 addToggle(pg, "Can Kilidi (bazı oyunlarda çalışır)", false, function(v) S.godHP = v end)
 addToggle(pg, "Anti-Ragdoll (yere yığılma yok)", false, function(v)
  S.antiRagdoll = v
  setAntiRagdoll(v)
 end)
 addButton(pg, "Otur", function()
  local h = getHum()
  if h then h.Sit = true end
 end)
 addButton(pg, "Karakteri Sıfırla (Reset)", function()
  local h = getHum()
  if h then h.Health = 0 end
 end)
end)
safe(function()
 local pg = createTab("Işınlan", 9)
 local rows = {}
 local waypoints = {}
 local function spectate(p)
  local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
  if h then cam().CameraSubject = h end
 end
 local function stopSpectate()
  local h = getHum()
  if h then cam().CameraSubject = h end
 end
 local function refreshTP()
  for _, r in ipairs(rows) do r:Destroy() end
  rows = {}
  local i = 0
  for _, p in ipairs(Players:GetPlayers()) do
   if p ~= player then
    i = i + 1
    local row = new("Frame", {
     Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = ROW, LayoutOrder = 1000 + i,
    }, pg)
    corner(row, 8)
    new("TextLabel", {
     Size = UDim2.new(1, -130, 1, 0), Position = UDim2.fromOffset(10, 0),
     BackgroundTransparency = 1, Text = p.DisplayName, TextColor3 = WHITE,
     Font = FONT, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
     TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)
    local goBtn = new("TextButton", {
     Size = UDim2.fromOffset(52, 28), Position = UDim2.new(1, -116, 0.5, -14),
     BackgroundColor3 = MAIN, Text = "Git", TextColor3 = WHITE, Font = FONT, TextSize = 15,
    }, row)
    corner(goBtn, 6)
    local watchBtn = new("TextButton", {
     Size = UDim2.fromOffset(52, 28), Position = UDim2.new(1, -58, 0.5, -14),
     BackgroundColor3 = MAIN, Text = "İzle", TextColor3 = WHITE, Font = FONT, TextSize = 15,
    }, row)
    corner(watchBtn, 6)
    goBtn.Activated:Connect(function()
     safe(function()
      local r = getRoot()
      local tr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
      if r and tr then r.CFrame = tr.CFrame * CFrame.new(0, 0, 3) end
     end)
    end)
    watchBtn.Activated:Connect(function() safe(spectate, p) end)
    table.insert(rows, row)
   end
  end
 end
 addSection(pg, "OYUNCU LİSTESİ")
 addButton(pg, "Listeyi Yenile", refreshTP)
 addButton(pg, "İzlemeyi Bırak", stopSpectate)
 refreshTP()
 bind(Players.PlayerAdded, function() task.wait(0.5) safe(refreshTP) end)
 bind(Players.PlayerRemoving, function() task.wait(0.2) safe(refreshTP) end)
 addSection(pg, "KAYITLI KONUMLAR")
 for i = 1, 5 do
  local row = new("Frame", {
   Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = ROW, LayoutOrder = ord(pg),
  }, pg)
  corner(row, 8)
  new("TextLabel", {
   Size = UDim2.new(1, -130, 1, 0), Position = UDim2.fromOffset(10, 0),
   BackgroundTransparency = 1, Text = "Konum " .. i, TextColor3 = WHITE,
   Font = FONT, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
  }, row)
  local saveBtn = new("TextButton", {
   Size = UDim2.fromOffset(52, 28), Position = UDim2.new(1, -116, 0.5, -14),
   BackgroundColor3 = MAIN, Text = "Kaydet", TextColor3 = WHITE, Font = FONT, TextSize = 14,
  }, row)
  corner(saveBtn, 6)
  local goBtn = new("TextButton", {
   Size = UDim2.fromOffset(52, 28), Position = UDim2.new(1, -58, 0.5, -14),
   BackgroundColor3 = MAIN, Text = "Git", TextColor3 = WHITE, Font = FONT, TextSize = 15,
  }, row)
  corner(goBtn, 6)
  saveBtn.Activated:Connect(function()
   local r = getRoot()
   if r then
    waypoints[i] = r.CFrame
    saveBtn.Text = "Tamam"
    task.wait(0.8)
    saveBtn.Text = "Kaydet"
   end
  end)
  goBtn.Activated:Connect(function()
   local r = getRoot()
   if r and waypoints[i] then r.CFrame = waypoints[i] end
  end)
 end
 addSection(pg, "DİĞER")
 addButton(pg, "Spawn Noktasına Git", function()
  local r = getRoot()
  local sp = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
  if r and sp then r.CFrame = sp.CFrame + Vector3.new(0, 5, 0) end
 end)
 addSection(pg, "KOORDİNATA IŞINLAN")
 local coordBox = addTextBox(pg, "X Y Z", "örn: 100 50 -20", function() end)
 addButton(pg, "Koordinata Git", function()
  local x, y, z = string.match(coordBox.Text, "(-?[%d%.]+)[%s,]+(-?[%d%.]+)[%s,]+(-?[%d%.]+)")
  local nx, ny, nz = tonumber(x), tonumber(y), tonumber(z)
  local r = getRoot()
  if r and nx and ny and nz then r.CFrame = CFrame.new(nx, ny, nz) end
 end)
 coordLabel = addLabel(pg, "Konumun: -")
end)
safe(function()
 local pg = createTab("Oyuncular", 10)
 local rows = {}
 local logLines = {}
 local infoLabel, logLabel
 local function showInfo(p)
  local r = getRoot()
  local tr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
  local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
  local dist = (r and tr) and math.floor((r.Position - tr.Position).Magnitude) or "?"
  infoLabel.Text = p.DisplayName .. " (@" .. p.Name .. ")\nID: " .. tostring(p.UserId)
   .. " | Hesap yaşı: " .. tostring(p.AccountAge) .. " gün\nTakım: "
   .. (p.Team and p.Team.Name or "yok") .. " | Can: "
   .. (hum and tostring(math.floor(hum.Health)) or "?") .. " | Mesafe: " .. tostring(dist)
 end
 local function addLog(text)
  table.insert(logLines, 1, text)
  while #logLines > 6 do table.remove(logLines) end
  if logLabel then logLabel.Text = table.concat(logLines, "\n") end
 end
 local function refreshPl()
  for _, r in ipairs(rows) do r:Destroy() end
  rows = {}
  local i = 0
  for _, p in ipairs(Players:GetPlayers()) do
   if p ~= player then
    i = i + 1
    local row = new("Frame", {
     Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = ROW, LayoutOrder = 1000 + i,
    }, pg)
    corner(row, 8)
    new("TextLabel", {
     Size = UDim2.new(1, -90, 1, 0), Position = UDim2.fromOffset(10, 0),
     BackgroundTransparency = 1, Text = p.DisplayName, TextColor3 = WHITE,
     Font = FONT, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
     TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)
    local infoBtn = new("TextButton", {
     Size = UDim2.fromOffset(70, 28), Position = UDim2.new(1, -78, 0.5, -14),
     BackgroundColor3 = MAIN, Text = "Bilgi", TextColor3 = WHITE, Font = FONT, TextSize = 15,
    }, row)
    corner(infoBtn, 6)
    infoBtn.Activated:Connect(function() safe(showInfo, p) end)
    table.insert(rows, row)
   end
  end
 end
 addSection(pg, "OYUNCU BİLGİSİ")
 infoLabel = addLabel(pg, "Aşağıdaki listeden bir oyuncunun Bilgi tuşuna bas.")
 addButton(pg, "Listeyi Yenile", refreshPl)
 addSection(pg, "GİRİŞ / ÇIKIŞ KAYDI")
 logLabel = addLabel(pg, "Henüz kimse girip çıkmadı.")
 addSection(pg, "OYUNCULAR (aşağıda listelenir)")
 refreshPl()
 bind(Players.PlayerAdded, function(p)
  safe(addLog, "+ " .. p.DisplayName .. " girdi")
  task.wait(0.5)
  safe(refreshPl)
 end)
 bind(Players.PlayerRemoving, function(p)
  safe(addLog, "- " .. p.DisplayName .. " çıktı")
  task.wait(0.2)
  safe(refreshPl)
 end)
end)
safe(function()
 local pg = createTab("Araçlar", 11)
 addSection(pg, "KORUMA")
 addToggle(pg, "Anti-AFK (atılma koruması)", true, function(v) S.antiAfk = v end, true)
 addToggle(pg, "Anti-Fling (çarpışmayı kapat)", false, function(v) S.antiFling = v end)
 addToggle(pg, "Anti-Void (boşluğa düşme koruması)", false, function(v) S.antiVoid = v end)
 addSection(pg, "BİLGİ")
 addToggle(pg, "FPS / Ping / Koordinat Göstergesi", false, function(v)
  S.hud = v
  hud.Visible = v
 end)
 addLabel(pg, "Oyun ID: " .. tostring(game.PlaceId))
 local srvLabel = addLabel(pg, "")
 A.every(1, function()
  srvLabel.Text = "Oyuncu: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
   .. " | Süre: " .. math.floor(time() / 60) .. " dk"
 end)
 addSection(pg, "SUNUCU")
 local status = addLabel(pg, "")
 addButton(pg, "Rejoin (Aynı Sunucuya Tekrar Gir)", function()
  status.Text = "Yeniden bağlanılıyor..."
  if #Players:GetPlayers() <= 1 then
   player:Kick("\nYeniden bağlanılıyor...")
   task.wait()
   TeleportService:Teleport(game.PlaceId, player)
  else
   TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
  end
 end)
 addButton(pg, "Server Hop (Başka Sunucuya Geç)", function()
  status.Text = "Sunucu aranıyor..."
  local ok, found = pcall(function()
   local url = "https://games.roblox.com/v1/games/" .. game.PlaceId
    .. "/servers/Public?sortOrder=Asc&limit=100"
   local body = game:HttpGet(url)
   local data = game:GetService("HttpService"):JSONDecode(body)
   for _, s in ipairs(data.data) do
    if s.playing < s.maxPlayers and s.id ~= game.JobId then
     TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
     return true
    end
   end
   return false
  end)
  if not ok then
   status.Text = "Bu ortamda desteklenmiyor (executor gerekir)."
  elseif not found then
   status.Text = "Uygun sunucu bulunamadı."
  end
 end)
 if setclipboard then
  addButton(pg, "JobId Kopyala", function()
   setclipboard(tostring(game.JobId))
   status.Text = "JobId kopyalandı."
  end)
 end
 addSection(pg, "ETKİLEŞİM")
 addToggle(pg, "Anında Etkileşim (E tuşunu bekletme)", false, function(v)
  S.instantPrompt = v
  setInstantPrompts(v)
 end)
 addButton(pg, "Yakındaki Prompt'ları Tetikle (executor)", function()
  if not fireproximityprompt then
   status.Text = "Bu ortamda desteklenmiyor (executor gerekir)."
   return
  end
  local r = getRoot()
  if not r then return end
  local n = 0
  for _, v in ipairs(Workspace:GetDescendants()) do
   if v:IsA("ProximityPrompt") and v.Parent and v.Parent:IsA("BasePart")
    and (v.Parent.Position - r.Position).Magnitude <= v.MaxActivationDistance + 5 then
    fireproximityprompt(v)
    n = n + 1
   end
  end
  status.Text = n .. " prompt tetiklendi."
 end)
 if setfpscap then
  addButton(pg, "FPS Sınırını Kaldır (240)", function()
   setfpscap(240)
   status.Text = "FPS sınırı 240 yapıldı."
  end)
 end
 addButton(pg, "Yakındaki ClickDetector'ları Tetikle (executor)", function()
  if not fireclickdetector then
   status.Text = "Bu ortamda desteklenmiyor (executor gerekir)."
   return
  end
  local r = getRoot()
  if not r then return end
  local n = 0
  for _, v in ipairs(Workspace:GetDescendants()) do
   if v:IsA("ClickDetector") and v.Parent and v.Parent:IsA("BasePart")
    and (v.Parent.Position - r.Position).Magnitude <= v.MaxActivationDistance + 5 then
    fireclickdetector(v)
    n = n + 1
   end
  end
  status.Text = n .. " ClickDetector tetiklendi."
 end)
 addButton(pg, "Yakındaki Dokunma Noktalarını Topla (executor)", function()
  if not firetouchinterest then
   status.Text = "Bu ortamda desteklenmiyor (executor gerekir)."
   return
  end
  local r = getRoot()
  if not r then return end
  local n = 0
  for _, v in ipairs(Workspace:GetDescendants()) do
   if v:IsA("TouchTransmitter") then
    local part = v.Parent
    if part and part:IsA("BasePart") and not part:IsDescendantOf(player.Character)
     and (part.Position - r.Position).Magnitude <= 120 then
     firetouchinterest(r, part, 0)
     firetouchinterest(r, part, 1)
     n = n + 1
    end
   end
  end
  status.Text = n .. " dokunma noktası tetiklendi."
 end)
end)
A.partLoaded(2)
end)
runBlock(3, function()
local A = ((getgenv and getgenv()) or _G).AmaleMenu
if not A then
 warn("[AMALE] Önce 1. parçayı çalıştır.")
 return
end
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player, S, safe, bind, new, corner, ord, gui = A.player, A.S, A.safe, A.bind, A.new, A.corner, A.ord, A.gui
local createTab, addSection, addToggle, addStepper = A.createTab, A.addSection, A.addToggle, A.addStepper
local addButton, addLabel, addTextBox = A.addButton, A.addLabel, A.addTextBox
local getHum, getRoot, cam, holdButton, EXCLUDE = A.getHum, A.getRoot, A.cam, A.holdButton, A.EXCLUDE
local relation, lset, lrestore = A.relation, A.lset, A.lrestore
local MAIN, WHITE, FONT, ROW, GREEN, BLUE = A.MAIN, A.WHITE, A.FONT, A.ROW, A.GREEN, A.BLUE
local aimInfoLabel
local aimHeld = false
local aimCircle = new("Frame", {
 Name = "AimCircle", AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 Size = UDim2.fromOffset(S.aimRange * 2, S.aimRange * 2),
 BackgroundTransparency = 1, Visible = false, ZIndex = 2,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, aimCircle)
new("UIStroke", { Color = MAIN, Thickness = 1.5 }, aimCircle)
local function updateAimCircle()
 aimCircle.Size = UDim2.fromOffset(S.aimRange * 2, S.aimRange * 2)
 aimCircle.Visible = S.aim and S.aimCircle
end
local aimHoldBtn = new("TextButton", {
 Name = "AimHold", Size = UDim2.fromOffset(64, 52), Position = UDim2.new(1, -84, 0.5, 70),
 BackgroundColor3 = MAIN, BackgroundTransparency = 0.25, Text = "AIM",
 TextColor3 = WHITE, Font = FONT, TextSize = 20, AutoButtonColor = false,
 Visible = false, ZIndex = 8,
}, gui)
corner(aimHoldBtn, 10)
holdButton(aimHoldBtn, function(v) aimHeld = v end)
local function refreshAimUI()
 updateAimCircle()
 aimHoldBtn.Visible = S.aimHold and S.aim
 if not aimHoldBtn.Visible then aimHeld = false end
end
local aimName = nil
local stickyChar, stickyName = nil, nil
local function visible(part)
 local c = cam()
 local params = RaycastParams.new()
 params.FilterType = EXCLUDE
 local ignore = { part.Parent }
 if player.Character then ignore[#ignore + 1] = player.Character end
 params.FilterDescendantsInstances = ignore
 local origin = c.CFrame.Position
 local res = Workspace:Raycast(origin, part.Position - origin, params)
 return res == nil
end
local function aimPart(char)
 local hum = char:FindFirstChildOfClass("Humanoid")
 if not hum or hum.Health <= 0 then return nil end
 local part = char:FindFirstChild(S.aimHead and "Head" or "HumanoidRootPart")
  or char:FindFirstChild("HumanoidRootPart")
  or char:FindFirstChildWhichIsA("BasePart")
 if not part then return nil end
 local myRoot = getRoot()
 if myRoot and (part.Position - myRoot.Position).Magnitude > S.aimMaxDist then return nil end
 if S.aimWall and not visible(part) then return nil end
 return part
end
local function eachCandidate(fn)
 if S.aim then
  for _, p in ipairs(Players:GetPlayers()) do
   if p ~= player and p.Character
    and not (S.aimTeam and relation(p) == "ally")
    and not (S.aimMurdOnly and A.roleOf and A.roleOf(p) ~= "Murderer") then
    fn(p.Character, p.DisplayName)
   end
  end
 end
end
local function pickTarget()
 local c = cam()
 local center = c.ViewportSize / 2
 local best, bestChar, bestName, bestScore = nil, nil, nil, math.huge
 eachCandidate(function(char, name)
  local part = aimPart(char)
  if part then
   local pos, onScreen = c:WorldToViewportPoint(part.Position)
   if onScreen then
    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
    if d <= S.aimRange then
     local score = S.aimByDist and (part.Position - c.CFrame.Position).Magnitude or d
     if score < bestScore then
      best, bestChar, bestName, bestScore = part, char, name, score
     end
    end
   end
  end
 end)
 return best, bestChar, bestName
end
local function aimStep()
 if not S.aim or (S.aimHold and not aimHeld) then
  aimName = nil
  stickyChar = nil
  return
 end
 local c = cam()
 local part
 if S.aimSticky and stickyChar and stickyChar.Parent then
  part = aimPart(stickyChar)
  if part then
   local _, onScreen = c:WorldToViewportPoint(part.Position)
   if not onScreen then part = nil end
  end
 end
 if not part then
  part, stickyChar, stickyName = pickTarget()
 end
 if part then
  aimName = stickyName or "?"
  local targetPos = part.Position + part.AssemblyLinearVelocity * S.aimPredict
  local goal = CFrame.lookAt(c.CFrame.Position, targetPos)
  c.CFrame = c.CFrame:Lerp(goal, S.aimSmooth)
 else
  aimName = nil
 end
end
pcall(function() RunService:UnbindFromRenderStep("AmaleAim") end)
RunService:BindToRenderStep("AmaleAim", Enum.RenderPriority.Camera.Value + 1, function()
 safe(aimStep)
end)
A.every(0.4, function()
 if aimInfoLabel then aimInfoLabel.Text = "Hedef: " .. (aimName or "yok") end
end)
A.onClose(function()
 pcall(function() RunService:UnbindFromRenderStep("AmaleAim") end)
end)
safe(function()
 local pg = createTab("Aimlock", 4)
 addSection(pg, "AIMLOCK")
 addToggle(pg, "Aimlock (Oyuncular)", false, function(v)
  S.aim = v
  stickyChar = nil
  refreshAimUI()
 end)
 addToggle(pg, "Kafaya Kilitle (kapalı = gövde)", true, function(v) S.aimHead = v end, true)
 addToggle(pg, "Takım Arkadaşını Atla", true, function(v) S.aimTeam = v end, true)
 addToggle(pg, "Duvar Kontrolü (sadece görünen)", false, function(v) S.aimWall = v end, true)
 addToggle(pg, "Hedefe Yapış (Sticky)", false, function(v)
  S.aimSticky = v
  stickyChar = nil
 end, true)
 addToggle(pg, "Hedef Çemberini Göster", false, function(v)
  S.aimCircle = v
  refreshAimUI()
 end, true)
 addToggle(pg, "AIM Tuşu (basılı tutunca nişan al)", false, function(v)
  S.aimHold = v
  refreshAimUI()
 end, true)
 addToggle(pg, "Mesafeye Göre Seç (kapalı = ekran ortası)", false, function(v) S.aimByDist = v end, true)
 addToggle(pg, "Sadece Murderer'ı Hedefle (MM2)", false, function(v) S.aimMurdOnly = v end, true)
 addStepper(pg, "Yumuşaklık (1 = sert)", 0.05, 1, 0.05, S.aimSmooth, function(v) S.aimSmooth = v end)
 addStepper(pg, "Hedef Alanı (piksel)", 100, 800, 50, S.aimRange, function(v)
  S.aimRange = v
  refreshAimUI()
 end)
 addStepper(pg, "Maks Mesafe (stud)", 100, 3000, 100, S.aimMaxDist, function(v) S.aimMaxDist = v end)
 addStepper(pg, "Tahmin (hareketli hedef)", 0, 0.5, 0.05, S.aimPredict, function(v) S.aimPredict = v end)
 aimInfoLabel = addLabel(pg, "Hedef: yok")
 addLabel(pg, "Ekranın ortasına en yakın oyuncuyu seçer. MM2'de Sheriff iken 'Sadece Murderer'ı Hedefle'yi aç.")
end)
A.partLoaded(3)
end)
runBlock(4, function()
local A = ((getgenv and getgenv()) or _G).AmaleMenu
if not A then
 warn("[AMALE] Önce 1. parçayı çalıştır.")
 return
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local player, S, safe, bind, new, corner, ord, gui = A.player, A.S, A.safe, A.bind, A.new, A.corner, A.ord, A.gui
local createTab, addSection, addToggle, addStepper = A.createTab, A.addSection, A.addToggle, A.addStepper
local addButton, addLabel, addTextBox = A.addButton, A.addLabel, A.addTextBox
local getHum, getRoot, cam, holdButton, EXCLUDE = A.getHum, A.getRoot, A.cam, A.holdButton, A.EXCLUDE
local relation, lset, lrestore = A.relation, A.lset, A.lrestore
local MAIN, WHITE, FONT, ROW, GREEN, BLUE = A.MAIN, A.WHITE, A.FONT, A.ROW, A.GREEN, A.BLUE
local tracerHolder = new("Frame", {
 Name = "Tracers", Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1,
}, gui)
local crosshair = new("Frame", {
 Name = "Crosshair", Size = UDim2.fromOffset(20, 20),
 AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
 BackgroundTransparency = 1, Visible = false, ZIndex = 2,
}, gui)
new("Frame", {
 Size = UDim2.new(1, 0, 0, 2), AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = MAIN, BorderSizePixel = 0,
}, crosshair)
new("Frame", {
 Size = UDim2.new(0, 2, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = MAIN, BorderSizePixel = 0,
}, crosshair)
local function setBright(on)
 if on then
  lset("Brightness", 2)
  lset("Ambient", Color3.fromRGB(178, 178, 178))
  lset("OutdoorAmbient", Color3.fromRGB(178, 178, 178))
 else
  lrestore("Brightness", "Ambient", "OutdoorAmbient")
 end
end
local atmBackup = {}
local function setFog(on)
 if on then
  lset("FogEnd", 1e6)
  for _, v in ipairs(Lighting:GetChildren()) do
   if v:IsA("Atmosphere") then
    if atmBackup[v] == nil then atmBackup[v] = v.Density end
    v.Density = 0
   end
  end
 else
  lrestore("FogEnd")
  for atm, d in pairs(atmBackup) do
   pcall(function() atm.Density = d end)
  end
  atmBackup = {}
 end
end
local function setShadows(on)
 if on then
  lset("GlobalShadows", false)
 else
  lrestore("GlobalShadows")
 end
end
local origGravity
local function applyGravity()
 if S.gravOn then
  if not origGravity then origGravity = Workspace.Gravity end
  Workspace.Gravity = S.gravity
 elseif origGravity then
  Workspace.Gravity = origGravity
  origGravity = nil
 end
end
local fpsStore, fpsToken, fpsQuality = {}, 0, nil
local function setFpsBoost(on)
 fpsToken = fpsToken + 1
 local token = fpsToken
 if on then
  pcall(function()
   fpsQuality = settings().Rendering.QualityLevel
   settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
  end)
  task.spawn(function()
   local n = 0
   for _, v in ipairs(Workspace:GetDescendants()) do
    if token ~= fpsToken then return end
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke")
     or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
     if v.Enabled then
      fpsStore[#fpsStore + 1] = v
      v.Enabled = false
     end
    end
    n = n + 1
    if n % 400 == 0 then task.wait() end
   end
  end)
 else
  pcall(function()
   if fpsQuality then settings().Rendering.QualityLevel = fpsQuality end
  end)
  fpsQuality = nil
  for _, v in ipairs(fpsStore) do
   pcall(function() v.Enabled = true end)
  end
  fpsStore = {}
 end
end
local xrayStore, xrayToken = {}, 0
local function setXray(on)
 xrayToken = xrayToken + 1
 local token = xrayToken
 if on then
  task.spawn(function()
   local n = 0
   for _, v in ipairs(Workspace:GetDescendants()) do
    if token ~= xrayToken then return end
    if v:IsA("BasePart") then
     local m = v:FindFirstAncestorOfClass("Model")
     if not (m and m:FindFirstChildOfClass("Humanoid")) then
      v.LocalTransparencyModifier = 0.6
      xrayStore[#xrayStore + 1] = v
     end
    end
    n = n + 1
    if n % 300 == 0 then task.wait() end
   end
  end)
 else
  for _, v in ipairs(xrayStore) do
   pcall(function() v.LocalTransparencyModifier = 0 end)
  end
  xrayStore = {}
 end
end
local espData = {}
local function clearESP(p)
 local d = espData[p]
 if d then
  for _, o in pairs(d) do
   pcall(function() o:Destroy() end)
  end
  espData[p] = nil
 end
end
local function espColor(p)
 if not S.espTeamColor then return GREEN end
 local r = relation(p)
 if r == "ally" then return BLUE end
 if r == "enemy" then return MAIN end
 return GREEN
end
local function applyESP(p)
 clearESP(p)
 if not S.esp or p == player or not p.Character then return end
 local d = {}
 local hl = Instance.new("Highlight")
 hl.FillColor = espColor(p)
 hl.OutlineColor = WHITE
 hl.FillTransparency = 0.55
 hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
 hl.Adornee = p.Character
 hl.Parent = p.Character
 d.hl = hl
 local head = p.Character:FindFirstChild("Head")
 if head and S.espName then
  local bb = Instance.new("BillboardGui")
  bb.Size = UDim2.fromOffset(150, 36)
  bb.StudsOffset = Vector3.new(0, 2.8, 0)
  bb.AlwaysOnTop = true
  bb.Adornee = head
  bb.Parent = head
  local tl = Instance.new("TextLabel")
  tl.Size = UDim2.fromScale(1, 1)
  tl.BackgroundTransparency = 1
  tl.Text = p.DisplayName
  tl.TextColor3 = WHITE
  tl.TextStrokeTransparency = 0
  tl.Font = FONT
  tl.TextSize = 14
  tl.TextWrapped = true
  tl.Parent = bb
  d.bb = bb
  d.label = tl
 end
 espData[p] = d
end
local function refreshESP()
 for _, p in ipairs(Players:GetPlayers()) do
  if S.esp then applyESP(p) else clearESP(p) end
 end
end
local function updateESPLabels()
 if not S.esp then return end
 local myRoot = getRoot()
 for p, d in pairs(espData) do
  local col = espColor(p)
  if d.hl then
   d.hl.FillColor = col
   local pr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
   d.hl.Enabled = not (S.espMaxDist > 0 and pr and myRoot
    and (pr.Position - myRoot.Position).Magnitude > S.espMaxDist)
  end
  if d.label and p.Character then
   d.label.TextColor3 = S.espTeamColor and col or WHITE
   local txt = p.DisplayName
   if S.espInfo then
    local hum = p.Character:FindFirstChildOfClass("Humanoid")
    local root = p.Character:FindFirstChild("HumanoidRootPart")
    if hum then
     txt = txt .. "\n" .. math.floor(hum.Health) .. " HP"
    end
    if root and myRoot then
     txt = txt .. " | " .. math.floor((root.Position - myRoot.Position).Magnitude) .. "m"
    end
   end
   d.label.Text = txt
  end
 end
end
local tracerFrames = {}
local function hideTracers()
 for _, f in pairs(tracerFrames) do f.Visible = false end
end
local function updateTracers()
 if not S.tracers then return end
 local c = cam()
 local vp = c.ViewportSize
 local a = Vector2.new(vp.X / 2, vp.Y)
 for _, p in ipairs(Players:GetPlayers()) do
  if p ~= player then
   local f = tracerFrames[p]
   local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
   if root then
    local pos, onScreen = c:WorldToViewportPoint(root.Position)
    if onScreen then
     if not f then
      f = new("Frame", {
       Name = "Tracer", AnchorPoint = Vector2.new(0.5, 0.5),
       BackgroundColor3 = MAIN, BorderSizePixel = 0, ZIndex = 2,
      }, tracerHolder)
      tracerFrames[p] = f
     end
     local b = Vector2.new(pos.X, pos.Y)
     local dlt = b - a
     f.Size = UDim2.fromOffset(dlt.Magnitude, 2)
     f.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
     f.Rotation = math.deg(math.atan2(dlt.Y, dlt.X))
     f.Visible = true
    elseif f then
     f.Visible = false
    end
   elseif f then
    f.Visible = false
   end
  end
 end
end
local function hookPlayer(p)
 if p == player then return end
 bind(p.CharacterAdded, function()
  task.wait(0.4)
  safe(applyESP, p)
 end)
 safe(applyESP, p)
end
for _, p in ipairs(Players:GetPlayers()) do hookPlayer(p) end
bind(Players.PlayerAdded, hookPlayer)
bind(Players.PlayerRemoving, function(p)
 clearESP(p)
 if tracerFrames[p] then
  tracerFrames[p]:Destroy()
  tracerFrames[p] = nil
 end
end)
local rainbowBackup = {}
local function setRainbow(on)
 S.rainbow = on
 if not on then
  for v, c in pairs(rainbowBackup) do
   pcall(function() v.Color = c end)
  end
  rainbowBackup = {}
 end
end
local scaleBackup = {}
local function setScale(mul)
 local hum = getHum()
 if not hum then return end
 for _, n in ipairs({ "BodyHeightScale", "BodyWidthScale", "BodyDepthScale", "HeadScale" }) do
  local o = hum:FindFirstChild(n)
  if o and o:IsA("NumberValue") then
   if scaleBackup[n] == nil then scaleBackup[n] = o.Value end
   o.Value = scaleBackup[n] * mul
  end
 end
end
local muteStore, muteToken = {}, 0
local function setMute(on)
 muteToken = muteToken + 1
 local token = muteToken
 if on then
  task.spawn(function()
   local n = 0
   for _, base in ipairs({ Workspace, SoundService }) do
    for _, v in ipairs(base:GetDescendants()) do
     if token ~= muteToken then return end
     if v:IsA("Sound") and muteStore[v] == nil then
      muteStore[v] = v.Volume
      v.Volume = 0
     end
     n = n + 1
     if n % 400 == 0 then task.wait() end
    end
   end
  end)
 else
  for v, vol in pairs(muteStore) do
   pcall(function() v.Volume = vol end)
  end
  muteStore = {}
 end
end
local function launch(forward)
 local r = getRoot()
 if not r then return end
 if forward then
  local look = r.CFrame.LookVector
  r.AssemblyLinearVelocity = Vector3.new(look.X, 0, look.Z) * S.launchPower + Vector3.new(0, 25, 0)
 else
  r.AssemblyLinearVelocity = Vector3.new(0, S.launchPower * 1.5, 0)
 end
end
A.hb(function(dt)
 if S.rainbow and player.Character then
  local rc = Color3.fromHSV((tick() * 0.5) % 1, 0.9, 1)
  for _, v in ipairs(player.Character:GetChildren()) do
   if v:IsA("BasePart") then
    if rainbowBackup[v] == nil then rainbowBackup[v] = v.Color end
    v.Color = rc
   end
  end
 end
 if S.disco then
  local dc = Color3.fromHSV((tick() * 0.4) % 1, 0.8, 1)
  lset("Ambient", dc)
  lset("OutdoorAmbient", dc)
 end
 if S.ghost and player.Character then
  for _, v in ipairs(player.Character:GetDescendants()) do
   if v:IsA("BasePart") then v.LocalTransparencyModifier = 0.6 end
  end
 end
 if S.gravOn and Workspace.Gravity ~= S.gravity then
  Workspace.Gravity = S.gravity
 end
 if S.timeLock then lset("ClockTime", S.clock) end
 if S.timeLapse then
  lset("ClockTime", (Lighting.ClockTime + dt * S.lapseSpeed) % 24)
 end
 if S.brightOn then lset("Brightness", S.brightness) end
 if S.exposureOn then lset("ExposureCompensation", S.exposure) end
 if S.fovChanged then
  local c = cam()
  if c.FieldOfView ~= S.fov then c.FieldOfView = S.fov end
 end
end)
A.every(0.2, updateESPLabels)
A.render(updateTracers)
bind(player.CharacterAdded, function()
 task.wait(0.6)
 safe(function()
  scaleBackup = {}
  if S.sizeOn then setScale(S.sizeMul) end
 end)
end)
A.onClose(function()
 for p in pairs(espData) do clearESP(p) end
 pcall(setXray, false)
 pcall(setFpsBoost, false)
 pcall(setBright, false)
 pcall(setFog, false)
 pcall(setShadows, false)
 pcall(setMute, false)
 pcall(setScale, 1)
 pcall(setRainbow, false)
 S.disco = false
 S.gravOn = false
 pcall(applyGravity)
 pcall(lrestore, "Ambient", "OutdoorAmbient", "ClockTime", "Brightness", "ExposureCompensation")
end)
safe(function()
 local pg = createTab("Görsel", 6)
 addSection(pg, "OYUNCU GÖSTERGELERİ")
 addToggle(pg, "ESP (Oyuncuları Göster)", false, function(v)
  S.esp = v
  refreshESP()
 end)
 addToggle(pg, "ESP İsim", true, function(v)
  S.espName = v
  refreshESP()
 end, true)
 addToggle(pg, "ESP Can + Mesafe", true, function(v) S.espInfo = v end, true)
 addStepper(pg, "ESP Mesafe Sınırı (0 = sınırsız)", 0, 2000, 100, S.espMaxDist, function(v) S.espMaxDist = v end)
 addToggle(pg, "Takım ESP (sadece takımlı oyunlarda)", false, function(v)
  S.espTeamColor = v
  refreshESP()
 end, true)
 addToggle(pg, "Tracer (Çizgiler)", false, function(v)
  S.tracers = v
  if not v then hideTracers() end
 end)
 addToggle(pg, "Nişangah (Ekran Ortası)", false, function(v)
  S.crosshair = v
  crosshair.Visible = v
 end)
 addStepper(pg, "Nişangah Boyutu", 10, 60, 5, 20, function(v)
  crosshair.Size = UDim2.fromOffset(v, v)
 end)
 addSection(pg, "GÖRÜNÜM")
 addToggle(pg, "Fullbright (Aydınlık)", false, function(v)
  S.bright = v
  setBright(v)
 end)
 addToggle(pg, "X-Ray (Duvarlar Şeffaf)", false, function(v)
  S.xray = v
  setXray(v)
 end)
 addStepper(pg, "Görüş Açısı (FOV)", 30, 120, 5, S.fov, function(v)
  S.fov = v
  S.fovChanged = true
  cam().FieldOfView = v
 end)
 addStepper(pg, "Kamera Mesafesi (maks)", 10, 1000, 10, 128, function(v)
  player.CameraMaxZoomDistance = v
 end)
 addToggle(pg, "1. Şahıs Kilidi", false, function(v)
  player.CameraMode = v and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
 end)
 addStepper(pg, "Kamera Kaydırma (omuz)", -5, 5, 0.5, 0, function(v)
  local h = getHum()
  if h then h.CameraOffset = Vector3.new(v, 0, 0) end
 end)
end)
safe(function()
 local pg = createTab("Dünya", 7)
 addSection(pg, "FİZİK VE ZAMAN")
 addToggle(pg, "Yerçekimi Ayarı", false, function(v)
  S.gravOn = v
  applyGravity()
 end)
 addStepper(pg, "Yerçekimi (normal 196)", 0, 400, 10, S.gravity, function(v)
  S.gravity = v
  applyGravity()
 end)
 addToggle(pg, "Saat Kilidi", false, function(v)
  S.timeLock = v
  if not v then lrestore("ClockTime") end
 end)
 addStepper(pg, "Saat (0-24)", 0, 24, 1, S.clock, function(v) S.clock = v end)
 addToggle(pg, "Zaman Akışı (hızlı gün/gece)", false, function(v)
  S.timeLapse = v
  if not v then lrestore("ClockTime") end
 end)
 addStepper(pg, "Zaman Hızı (saat/sn)", 0.1, 5, 0.1, S.lapseSpeed, function(v) S.lapseSpeed = v end)
 addToggle(pg, "Parlaklık Ayarı", false, function(v)
  S.brightOn = v
  if not v then lrestore("Brightness") end
 end)
 addStepper(pg, "Parlaklık", 0, 10, 0.5, S.brightness, function(v) S.brightness = v end)
 addToggle(pg, "Pozlama Ayarı", false, function(v)
  S.exposureOn = v
  if not v then lrestore("ExposureCompensation") end
 end)
 addStepper(pg, "Pozlama", -3, 3, 0.5, S.exposure, function(v) S.exposure = v end)
 addSection(pg, "PERFORMANS VE IŞIK")
 addToggle(pg, "Sisi Kaldır", false, function(v)
  S.noFog = v
  setFog(v)
 end)
 addToggle(pg, "Gölgeleri Kapat", false, function(v)
  S.noShadows = v
  setShadows(v)
 end)
 addToggle(pg, "FPS Boost (efekt/parçacık kapat)", false, function(v)
  S.fpsBoost = v
  setFpsBoost(v)
 end)
 addToggle(pg, "Tüm Sesleri Kapat", false, function(v) setMute(v) end)
end)
safe(function()
 local pg = createTab("Eğlence", 8)
 addSection(pg, "FIRLATMA")
 addButton(pg, "Roket (Yukarı Fırlat)", function() launch(false) end)
 addButton(pg, "Dash (İleri Atıl)", function() launch(true) end)
 addStepper(pg, "Fırlatma Gücü", 50, 500, 25, S.launchPower, function(v) S.launchPower = v end)
 addSection(pg, "GÖRÜNÜM EĞLENCESİ")
 addToggle(pg, "Boyut Değiştir (sadece sen görürsün)", false, function(v)
  S.sizeOn = v
  setScale(v and S.sizeMul or 1)
 end)
 addStepper(pg, "Boyut Çarpanı", 0.5, 4, 0.5, S.sizeMul, function(v)
  S.sizeMul = v
  if S.sizeOn then setScale(v) end
 end)
 addToggle(pg, "Gökkuşağı Karakter", false, function(v) setRainbow(v) end)
 addToggle(pg, "Karakteri Yarı Saydam Yap (sadece sen)", false, function(v)
  S.ghost = v
  if not v and player.Character then
   for _, part in ipairs(player.Character:GetDescendants()) do
    if part:IsA("BasePart") then part.LocalTransparencyModifier = 0 end
   end
  end
 end)
 addToggle(pg, "Disko Işıkları", false, function(v)
  S.disco = v
  if not v then lrestore("Ambient", "OutdoorAmbient") end
 end)
end)
A.partLoaded(4)
end)
runBlock(5, function()
local A = ((getgenv and getgenv()) or _G).AmaleMenu
if not A then
 warn("[AMALE] Çekirdek yüklenmedi.")
 return
end
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player, S, safe, bind, new, corner, gui = A.player, A.S, A.safe, A.bind, A.new, A.corner, A.gui
local createTab, addSection, addToggle, addStepper = A.createTab, A.addSection, A.addToggle, A.addStepper
local addButton, addLabel, addTextBox = A.addButton, A.addLabel, A.addTextBox
local getHum, getRoot, cam = A.getHum, A.getRoot, A.cam
local WHITE, FONT, MAIN = A.WHITE, A.FONT, A.MAIN
local ROLE_COL = {
 Murderer = Color3.fromRGB(255, 40, 40),
 Sheriff = Color3.fromRGB(0, 140, 255),
 Innocent = Color3.fromRGB(0, 255, 70),
}
local YELLOW = Color3.fromRGB(255, 220, 0)
local function hasTool(p, name)
 local c = p.Character
 if c and c:FindFirstChild(name) then return true end
 local bp = p:FindFirstChildOfClass("Backpack")
 if bp and bp:FindFirstChild(name) then return true end
 return false
end
local function roleOf(p)
 if hasTool(p, S.knifeName) then return "Murderer" end
 if hasTool(p, S.gunToolName) then return "Sheriff" end
 return "Innocent"
end
A.roleOf = roleOf
local function holderOf(role)
 for _, p in ipairs(Players:GetPlayers()) do
  if roleOf(p) == role then return p end
 end
 return nil
end
local function makeRegistry(nameKey)
 local set = {}
 local function reg(d)
  if d.Name == S[nameKey] and (d:IsA("BasePart") or d:IsA("Model")) then set[d] = true end
 end
 bind(Workspace.DescendantAdded, reg)
 local function rescan()
  for k in pairs(set) do set[k] = nil end
  task.spawn(safe, function()
   local n = 0
   for _, d in ipairs(Workspace:GetDescendants()) do
    reg(d)
    n = n + 1
    if n % 500 == 0 then task.wait() end
   end
  end)
 end
 rescan()
 return set, rescan
end
local gunSet, rescanGun = makeRegistry("gunDropName")
local trapSet, rescanTrap = makeRegistry("trapName")
local coinSet, rescanCoin = makeRegistry("coinName")
local function posOf(d) return d:GetPivot().Position end
local function partOf(d)
 if d:IsA("BasePart") then return d end
 return d:FindFirstChildWhichIsA("BasePart", true)
end
local function nearest(set, from)
 local best, bd
 for d in pairs(set) do
  if d.Parent then
   local dist = (posOf(d) - from).Magnitude
   if not bd or dist < bd then best, bd = d, dist end
  else
   set[d] = nil
  end
 end
 return best, bd
end
local holder = new("Frame", {
 Name = "MM2Overlay", Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,
}, gui)
local pool, tags = {}, {}
local function getMark(key)
 local m = pool[key]
 if m then return m end
 local box = new("Frame", {
  AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
  BorderSizePixel = 0, Visible = false, ZIndex = 2,
 }, holder)
 local stroke = new("UIStroke", { Thickness = 1.5 }, box)
 local label = new("TextLabel", {
  AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 0, -2),
  Size = UDim2.fromOffset(170, 30), BackgroundTransparency = 1, TextStrokeTransparency = 0,
  Font = FONT, TextSize = 13, TextWrapped = true, Text = "", ZIndex = 3,
 }, box)
 local line = new("Frame", {
  AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Visible = false, ZIndex = 2,
 }, holder)
 m = { box = box, stroke = stroke, label = label, line = line, seen = false }
 pool[key] = m
 return m
end
local function hideMark(m)
 m.box.Visible = false
 m.line.Visible = false
end
local function getTag(key)
 local t = tags[key]
 if t then return t end
 t = new("TextLabel", {
  AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(90, 34),
  BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.5,
  TextStrokeTransparency = 0, Font = FONT, TextSize = 13, Text = "",
  Visible = false, ZIndex = 3,
 }, holder)
 corner(t, 6)
 tags[key] = t
 return t
end
local function hideTag(key)
 local t = tags[key]
 if t then t.Visible = false end
end
local function placeTag(key, worldPos, text, col, clampOff)
 local c = cam()
 local v, on = c:WorldToViewportPoint(worldPos)
 local t = getTag(key)
 t.Text = text
 t.TextColor3 = col
 local vp = c.ViewportSize
 if on then
  t.Position = UDim2.fromOffset(v.X, v.Y)
  t.Visible = true
 elseif clampOff then
  local dir = Vector2.new(v.X, v.Y) - vp / 2
  if v.Z < 0 then dir = -dir end
  if dir.Magnitude < 1 then dir = Vector2.new(0, -1) end
  dir = dir.Unit
  t.Position = UDim2.fromOffset(
   math.clamp(vp.X / 2 + dir.X * vp.X, 50, vp.X - 50),
   math.clamp(vp.Y / 2 + dir.Y * vp.Y, 60, vp.Y - 50)
  )
  t.Visible = true
 else
  t.Visible = false
 end
end
local function roleShown(role)
 if role == "Murderer" then return S.espMurd end
 if role == "Sheriff" then return S.espSher end
 return S.espInno
end
local lastTraps = 0
local function drawEsp()
 local c = cam()
 if not c then return end
 local vp = c.ViewportSize
 local myRoot = getRoot()
 for _, p in ipairs(Players:GetPlayers()) do
  if p ~= player and S.mmEsp then
   local char = p.Character
   local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
   local hum = char and char:FindFirstChildOfClass("Humanoid")
   if root and hum and hum.Health > 0 then
    local role = roleOf(p)
    if roleShown(role) then
     local top = c:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
     local bot = c:WorldToViewportPoint(root.Position - Vector3.new(0, 3.2, 0))
     if top.Z > 0 and bot.Z > 0 then
      local m = getMark(p)
      local h = math.abs(bot.Y - top.Y)
      local col = ROLE_COL[role]
      m.box.Size = UDim2.fromOffset(h * 0.55, h)
      m.box.Position = UDim2.fromOffset(top.X, (top.Y + bot.Y) / 2)
      m.box.Visible = true
      m.stroke.Color = col
      m.label.TextColor3 = col
      if S.mmInfo then
       local dist = myRoot and math.floor((root.Position - myRoot.Position).Magnitude) or 0
       m.label.Text = p.DisplayName .. "\n[" .. role .. "] " .. dist .. "m"
      else
       m.label.Text = ""
      end
      if S.mmTracer and role ~= "Innocent" then
       local a = Vector2.new(vp.X / 2, vp.Y)
       local b = Vector2.new(top.X, (top.Y + bot.Y) / 2)
       local d = b - a
       m.line.BackgroundColor3 = col
       m.line.Size = UDim2.fromOffset(d.Magnitude, 2)
       m.line.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
       m.line.Rotation = math.deg(math.atan2(d.Y, d.X))
       m.line.Visible = true
      else
       m.line.Visible = false
      end
      m.seen = true
     end
    end
   end
  end
 end
 for key, m in pairs(pool) do
  if not m.seen then hideMark(m) end
  m.seen = false
 end
 local from = myRoot and myRoot.Position or c.CFrame.Position
 local g = S.gunEsp and nearest(gunSet, from)
 if g then
  local pos = posOf(g)
  placeTag("gun", pos, "GUN\n" .. math.floor((pos - from).Magnitude) .. "m", YELLOW, true)
 else
  hideTag("gun")
 end
 local count = 0
 if S.trapEsp then
  for d in pairs(trapSet) do
   if d.Parent then
    if count < 25 then
     count = count + 1
     local pos = posOf(d)
     placeTag("trap" .. count, pos, "TRAP\n" .. math.floor((pos - from).Magnitude) .. "m", ROLE_COL.Murderer, false)
    end
   else
    trapSet[d] = nil
   end
  end
 end
 for i = count + 1, lastTraps do hideTag("trap" .. i) end
 lastTraps = count
end
A.render(drawEsp)
bind(Players.PlayerRemoving, function(p)
 local m = pool[p]
 if m then
  m.box:Destroy()
  m.line:Destroy()
  pool[p] = nil
 end
end)
local function equipByName(name)
 local char = player.Character
 local hum = getHum()
 if not char or not hum then return nil end
 local t = char:FindFirstChild(name)
 if t and t:IsA("Tool") then return t end
 local bp = player:FindFirstChildOfClass("Backpack")
 t = bp and bp:FindFirstChild(name)
 if t and t:IsA("Tool") then
  hum:EquipTool(t)
  return t
 end
 return nil
end
local function gunRemotes(gun)
 local list = {}
 for _, d in ipairs(gun:GetDescendants()) do
  if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") or d:IsA("UnreliableRemoteEvent") then
   list[#list + 1] = d
  end
 end
 return list
end
local function tryShootRemote(gun, pos)
 local fired = false
 for _, rem in ipairs(gunRemotes(gun)) do
  if string.find(string.lower(rem.Name), "shoot", 1, true) then
   fired = true
   task.spawn(pcall, function()
    if rem:IsA("RemoteFunction") then
     rem:InvokeServer(1, pos, "AH2")
    else
     rem:FireServer(1, pos, "AH2")
    end
   end)
  end
 end
 return fired
end
local function shootMurderer(quiet)
 local m = holderOf("Murderer")
 if not m or m == player then
  if not quiet then A.toast("Murderer bulunamadı") end
  return false
 end
 local ch = m.Character
 local mr = ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Head"))
 if not mr then return false end
 local gun = equipByName(S.gunToolName)
 if not gun then
  if not quiet then A.toast("Gun yok (Sheriff değilsin)") end
  return false
 end
 if gun.Parent ~= player.Character then task.wait(0.15) end
 local pos = mr.Position + mr.AssemblyLinearVelocity * 0.08
 if not tryShootRemote(gun, pos) then
  local c = cam()
  c.CFrame = CFrame.lookAt(c.CFrame.Position, pos)
  gun:Activate()
 end
 return true
end
local accShoot = 0
A.hb(function(dt)
 if not S.autoShoot then return end
 accShoot = accShoot + dt
 if accShoot < S.shootDelay then return end
 accShoot = 0
 if roleOf(player) == "Sheriff" then task.spawn(safe, shootMurderer, true) end
end)
local function grabGun()
 local r = getRoot()
 if not r then return false end
 local g = nearest(gunSet, r.Position)
 if not g then return false end
 local back = r.CFrame
 local part = partOf(g)
 local t0 = tick()
 while tick() - t0 < 1.5 and g.Parent and roleOf(player) ~= "Sheriff" do
  local rr = getRoot()
  if rr then
   rr.CFrame = g:GetPivot()
   if firetouchinterest and part then
    firetouchinterest(rr, part, 0)
    firetouchinterest(rr, part, 1)
   end
  end
  task.wait(0.1)
 end
 local r2 = getRoot()
 if r2 then r2.CFrame = back end
 return true
end
local lastGrab = 0
local done = setmetatable({}, { __mode = "k" })
local coinLabel
local accCoin = 0
A.hb(function(dt)
 if not S.coinFarm then return end
 accCoin = accCoin + dt
 if accCoin < S.coinDelay then return end
 accCoin = 0
 local r = getRoot()
 if not r then return end
 local best, bd
 for c in pairs(coinSet) do
  if c.Parent and not done[c] then
   local d = (posOf(c) - r.Position).Magnitude
   if not bd or d < bd then best, bd = c, d end
  end
 end
 if best then
  done[best] = true
  r.CFrame = best:GetPivot()
  local part = partOf(best)
  if firetouchinterest and part then
   firetouchinterest(r, part, 0)
   firetouchinterest(r, part, 1)
  end
 end
end)
local function spawnCFrame(model)
 if not model then return nil end
 local sp = model:FindFirstChild("Spawns")
 local first = sp and sp:FindFirstChildWhichIsA("BasePart", true)
 if first then return first.CFrame + Vector3.new(0, 4, 0) end
 local loc = model:FindFirstChildWhichIsA("SpawnLocation", true)
 if loc then return loc.CFrame + Vector3.new(0, 4, 0) end
 if model:IsA("Model") then
  local cf = model:GetBoundingBox()
  return cf + Vector3.new(0, 40, 0)
 end
 return nil
end
local function findMap()
 for _, m in ipairs(Workspace:GetChildren()) do
  if m:IsA("Model") and m:FindFirstChild("CoinContainer") then return m end
 end
 return nil
end
local function goTo(cf, label)
 local r = getRoot()
 if r and cf then
  r.CFrame = cf
 else
  A.toast(label .. " bulunamadı")
 end
end
local sky, skyBack
local function skyUp()
 local r = getRoot()
 if not r or sky then return end
 skyBack = r.CFrame
 sky = Instance.new("Part")
 sky.Anchored = true
 sky.Size = Vector3.new(40, 2, 40)
 sky.Transparency = 0.5
 sky.Position = r.Position + Vector3.new(0, 500, 0)
 sky.Parent = Workspace
 r.CFrame = sky.CFrame * CFrame.new(0, 4, 0)
end
local function skyDown()
 local r = getRoot()
 if r and skyBack then r.CFrame = skyBack end
 if sky then
  sky:Destroy()
  sky = nil
 end
 skyBack = nil
end
local roleLabel = new("TextLabel", {
 Name = "RoleHUD", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 44),
 Size = UDim2.fromOffset(280, 0), AutomaticSize = Enum.AutomaticSize.Y,
 BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45,
 TextColor3 = WHITE, Font = FONT, TextSize = 14, Text = "", Visible = false, ZIndex = 3,
}, gui)
corner(roleLabel, 6)
local quick = {}
local function mkQuick(text, y, fn)
 local b = new("TextButton", {
  Size = UDim2.fromOffset(66, 44), Position = UDim2.new(1, -160, 0.5, y),
  BackgroundColor3 = MAIN, BackgroundTransparency = 0.25, Text = text,
  TextColor3 = WHITE, Font = FONT, TextSize = 15, Visible = false, ZIndex = 8,
 }, gui)
 corner(b, 10)
 b.Activated:Connect(function() safe(fn) end)
 quick[#quick + 1] = b
end
mkQuick("SHOOT", -100, function() shootMurderer() end)
mkQuick("GUN", -50, function() equipByName(S.gunToolName) end)
mkQuick("KNIFE", 0, function() equipByName(S.knifeName) end)
mkQuick("GRAB", 50, grabGun)
local lastMurd, lastWarn, lastSherWarn, calmSince = nil, 0, 0, 0
A.every(0.5, function()
 local me = roleOf(player)
 local m, sh = holderOf("Murderer"), holderOf("Sheriff")
 roleLabel.Visible = S.roleHud
 if S.roleHud then
  roleLabel.Text = "Murderer: " .. (m and m.DisplayName or "-") .. "\nSheriff: " .. (sh and sh.DisplayName or "-")
  if m and m ~= lastMurd then A.toast("Murderer: " .. m.DisplayName) end
 end
 lastMurd = m
 local r = getRoot()
 local from = r and r.Position
 if from and S.mmWarn and me ~= "Murderer" and m and m ~= player then
  local mr = m.Character and m.Character:FindFirstChild("HumanoidRootPart")
  if mr then
   local dist = (from - mr.Position).Magnitude
   if dist <= S.mmWarnDist and tick() - lastWarn > 2 then
    lastWarn = tick()
    A.toast("DİKKAT! MURDERER YAKIN: " .. math.floor(dist) .. "m")
   end
  end
 end
 if from and S.sherWarn and me == "Murderer" and sh and sh ~= player then
  local sr = sh.Character and sh.Character:FindFirstChild("HumanoidRootPart")
  if sr then
   local dist = (from - sr.Position).Magnitude
   if dist <= S.mmWarnDist and tick() - lastSherWarn > 2 then
    lastSherWarn = tick()
    A.toast("DİKKAT! SHERIFF YAKIN: " .. math.floor(dist) .. "m")
   end
  end
 end
 if S.autoEscape and me == "Innocent" and m and m ~= player then
  local mr = m.Character and m.Character:FindFirstChild("HumanoidRootPart")
  local base = (sky and skyBack) and skyBack.Position or from
  if mr and base then
   local dist = (base - mr.Position).Magnitude
   if dist <= S.escapeDist then
    calmSince = tick()
    if not sky then skyUp() end
   elseif sky and tick() - calmSince > 3 then
    skyDown()
   end
  end
 end
 if S.autoEquipGun then
  if me == "Sheriff" then
   equipByName(S.gunToolName)
  elseif me == "Murderer" then
   equipByName(S.knifeName)
  end
 end
 if S.autoGun and me == "Innocent" and tick() - lastGrab > 4 and nearest(gunSet, from or Vector3.zero) then
  lastGrab = tick()
  task.spawn(safe, grabGun)
 end
 if coinLabel then
  local n = 0
  for c in pairs(coinSet) do
   if c.Parent and not done[c] then n = n + 1 end
  end
  coinLabel.Text = "Toplanabilir coin: " .. n
 end
end)
local function watch(p)
 local h = p and p.Character and p.Character:FindFirstChildOfClass("Humanoid")
 if h then
  cam().CameraSubject = h
 else
  A.toast("Hedef bulunamadı")
 end
end
A.onClose(function()
 skyDown()
 for _, m in pairs(pool) do pcall(function() m.box:Destroy() m.line:Destroy() end) end
 pcall(function() holder:Destroy() end)
end)
safe(function()
 local pg = createTab("MM2 ESP", -2)
 addSection(pg, "OYUNCU ESP (görünmez olsa da görünür)")
 addToggle(pg, "Oyuncu ESP (kutu + isim + rol)", false, function(v) S.mmEsp = v end)
 addToggle(pg, "Murderer'ı Göster (kırmızı)", true, function(v) S.espMurd = v end, true)
 addToggle(pg, "Sheriff'i Göster (mavi)", true, function(v) S.espSher = v end, true)
 addToggle(pg, "Innocent'ları Göster (yeşil)", true, function(v) S.espInno = v end, true)
 addToggle(pg, "İsim / Rol / Mesafe Yaz", true, function(v) S.mmInfo = v end, true)
 addToggle(pg, "Murderer ve Sheriff Çizgisi (tracer)", false, function(v) S.mmTracer = v end)
 addSection(pg, "NESNE ESP")
 addToggle(pg, "Gun ESP (düşen silah, ekran dışındaysa ok yönü)", false, function(v) S.gunEsp = v end)
 addToggle(pg, "Trap ESP (tuzaklar)", false, function(v) S.trapEsp = v end)
 addSection(pg, "BİLGİ VE UYARI")
 addToggle(pg, "Rol Bilgisi Ekranda (kim murderer / sheriff)", false, function(v) S.roleHud = v end)
 addToggle(pg, "Murderer Yaklaşınca Uyar", false, function(v) S.mmWarn = v end)
 addToggle(pg, "Sheriff Yaklaşınca Uyar (sen Murderer iken)", false, function(v) S.sherWarn = v end)
 addStepper(pg, "Uyarı Mesafesi (stud)", 10, 150, 5, S.mmWarnDist, function(v) S.mmWarnDist = v end)
 addButton(pg, "Murderer'ı İzle", function() watch(holderOf("Murderer")) end)
 addButton(pg, "Sheriff'i İzle", function() watch(holderOf("Sheriff")) end)
 addButton(pg, "İzlemeyi Bırak", function()
  local h = getHum()
  if h then cam().CameraSubject = h end
 end)
 addLabel(pg, "Roller, oyuncunun elindeki/çantasındaki Knife ve Gun eşyasına göre bulunur. Kutular ekrana çizildiği için görünmez karakterlerde de çalışır.")
end)
safe(function()
 local pg = createTab("MM2 Rol", -1)
 local remLabel
 addSection(pg, "SHERIFF")
 addButton(pg, "Murderer'ı Vur (duvar arkası dahil)", function() shootMurderer() end)
 addToggle(pg, "Otomatik Vur / Sınırsız Ateş", false, function(v) S.autoShoot = v end)
 addStepper(pg, "Ateş Aralığı (sn)", 0.05, 3, 0.05, S.shootDelay, function(v) S.shootDelay = v end)
 addToggle(pg, "Aimlock Sadece Murderer'a", false, function(v) S.aimMurdOnly = v end, true)
 addToggle(pg, "Otomatik Silah Kuşan (Gun / Knife)", false, function(v) S.autoEquipGun = v end)
 addToggle(pg, "Ekranda Hızlı Tuşlar (SHOOT, GUN, KNIFE, GRAB)", false, function(v)
  S.quickBtns = v
  for _, b in ipairs(quick) do b.Visible = v end
 end)
 addButton(pg, "Gun Remote'larını Listele (hata ayıklama)", function()
  local char = player.Character
  local gun = char and char:FindFirstChild(S.gunToolName)
  if not gun then
   local bp = player:FindFirstChildOfClass("Backpack")
   gun = bp and bp:FindFirstChild(S.gunToolName)
  end
  if not gun then
   remLabel.Text = "Elinde/çantanda Gun yok."
   return
  end
  local names = {}
  for _, rem in ipairs(gunRemotes(gun)) do
   names[#names + 1] = rem.Name .. " (" .. rem.ClassName .. ")"
  end
  remLabel.Text = #names == 0 and "Gun içinde remote bulunamadı." or table.concat(names, "\n")
 end)
 remLabel = addLabel(pg, "")
 addSection(pg, "MURDERER")
 addButton(pg, "Knife Kuşan", function() equipByName(S.knifeName) end)
 addLabel(pg, "Sheriff uyarısı ve Sheriff ESP için MM2 ESP sekmesini kullan.")
 addSection(pg, "INNOCENT")
 addToggle(pg, "Otomatik Gun Al (Sheriff ölünce)", false, function(v) S.autoGun = v end)
 addButton(pg, "Gun'ı Şimdi Al", function()
  if not grabGun() then A.toast("Düşmüş silah yok") end
 end)
 addToggle(pg, "Otomatik Kaç (Murderer yaklaşınca gökyüzüne çık)", false, function(v) S.autoEscape = v end)
 addStepper(pg, "Kaçış Mesafesi (stud)", 10, 100, 5, S.escapeDist, function(v) S.escapeDist = v end)
 addButton(pg, "Gökyüzüne Çık (saklan)", skyUp)
 addButton(pg, "Aşağı İn", skyDown)
 addSection(pg, "COIN")
 addToggle(pg, "Coin Farm (otomatik topla)", false, function(v) S.coinFarm = v end)
 addStepper(pg, "Coin Aralığı (sn)", 0.2, 2, 0.1, S.coinDelay, function(v) S.coinDelay = v end)
 addButton(pg, "Coin Listesini Sıfırla", function()
  done = setmetatable({}, { __mode = "k" })
 end)
 coinLabel = addLabel(pg, "Toplanabilir coin: -")
 addSection(pg, "IŞINLANMA")
 addButton(pg, "Haritaya Git", function() goTo(spawnCFrame(findMap()), "Harita") end)
 addButton(pg, "Lobiye Git", function() goTo(spawnCFrame(Workspace:FindFirstChild("Lobby")), "Lobi") end)
 addSection(pg, "OYUN İSİMLERİ (güncelleme olursa değiştir)")
 local function nameBox(label, key, rescan)
  local box = addTextBox(pg, label, S[key], function(t)
   t = string.gsub(t, "^%s*(.-)%s*$", "%1")
   if t ~= "" then
    S[key] = t
    if rescan then rescan() end
   end
  end)
  box.Text = S[key]
 end
 nameBox("Düşen Gun Adı", "gunDropName", rescanGun)
 nameBox("Trap Adı", "trapName", rescanTrap)
 nameBox("Coin Adı", "coinName", rescanCoin)
 nameBox("Knife Eşya Adı", "knifeName", nil)
 nameBox("Gun Eşya Adı", "gunToolName", nil)
 addLabel(pg, "Bir şey bulunamıyorsa, oyun nesneyi farklı adlandırıyor olabilir. Adı buraya yazınca yeniden taranır.")
end)
A.partLoaded(5)
end)
