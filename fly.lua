_G.FlyKey = "V" ---// default : "V"
_G.SpeedKey = "LeftShift" ---// default : "LeftShift"
_G.MoreSpeedKey = "LeftControl" ---// default : "LeftControl"
_G.EnableFly = true ---// switch, but terrible

local FlyKey = Enum.KeyCode[_G.FlyKey or "V"]
local SpeedKey = Enum.KeyCode[_G.SpeedKey or "LeftShift"]
local BigSpeedKey = Enum.KeyCode[_G.MoreSpeedKey or "LeftControl"]
if _G.EnableFly == nil then _G.EnableFly = true end

local SpeedKeyMultiplier1 , SpeedKeyMultiplier2 = 2 , 4
local FlightSpeed = 50
local FlightAcceleration = 4
local TurnSpeed = 16

local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local User = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local UserCharacter = nil
local UserRootPart = nil
local Connection = nil


workspace.Changed:Connect(function()
	CurrentCamera = workspace.CurrentCamera
end)

local setCharacter = function(c)
	UserCharacter = c
	UserRootPart = c:WaitForChild("HumanoidRootPart")
end

User.CharacterAdded:Connect(setCharacter)
if User.Character then
	setCharacter(User.Character)
end

local CurrentVelocity = Vector3.new(0,0,0)
local Flight = function(delta)
	if _G.EnableFly == true then
		local BaseVelocity = Vector3.new(0,0,0)
		if not UserInputService:GetFocusedTextBox() then
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				BaseVelocity = BaseVelocity + (CurrentCamera.CFrame.LookVector * FlightSpeed)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				BaseVelocity = BaseVelocity - (CurrentCamera.CFrame.RightVector * FlightSpeed)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				BaseVelocity = BaseVelocity - (CurrentCamera.CFrame.LookVector * FlightSpeed)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				BaseVelocity = BaseVelocity + (CurrentCamera.CFrame.RightVector * FlightSpeed)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				BaseVelocity = BaseVelocity + (CurrentCamera.CFrame.UpVector * FlightSpeed)
			end
			if UserInputService:IsKeyDown(SpeedKey) and not UserInputService:IsKeyDown(BigSpeedKey) then
				BaseVelocity = BaseVelocity * SpeedKeyMultiplier1
			end
			if not UserInputService:IsKeyDown(SpeedKey) and UserInputService:IsKeyDown(BigSpeedKey) then
				BaseVelocity = BaseVelocity * SpeedKeyMultiplier2
			end
			if UserInputService:IsKeyDown(SpeedKey) and UserInputService:IsKeyDown(BigSpeedKey) then
				BaseVelocity = BaseVelocity * (SpeedKeyMultiplier2 * SpeedKeyMultiplier1)
			end
		end
		if UserRootPart then
			local car = UserRootPart:GetRootPart()
			if car.Anchored then return end
			---// if not isnetworkowner(car) then return end ---/// rrahhhh, will not work if not synapse
			CurrentVelocity = CurrentVelocity:Lerp(
				BaseVelocity,
				math.clamp(delta * FlightAcceleration, 0, 1)
			)
			car.Velocity = CurrentVelocity + Vector3.new(0,2,0)
			if car ~= UserRootPart then
				car.RotVelocity = Vector3.new(0,0,0)
				car.CFrame = car.CFrame:Lerp(CFrame.lookAt(
					car.Position,
					car.Position + CurrentVelocity + CurrentCamera.CFrame.LookVector
					), math.clamp(delta * TurnSpeed, 0, 1))
			end
		end
	end
end

UserInputService.InputBegan:Connect(function(userInput,gameProcessed)
	if gameProcessed then return end
	if userInput.KeyCode == FlyKey then
		if Connection then
			StarterGui:SetCore("SendNotification",{
				Title = "rbxlx_hook",
				Text = "Flight disabled"
			})
			Connection:Disconnect()
			Connection = nil
		else
			StarterGui:SetCore("SendNotification",{
				Title = "rbxlx_hook",
				Text = "Flight enabled"
			})
			CurrentVelocity = UserRootPart.Velocity
			Connection = RunService.Heartbeat:Connect(Flight)
		end
	end
end)
