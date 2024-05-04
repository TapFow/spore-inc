local owner 		= owner
local RunService 	= game:GetService("RunService")
local CoreGui 		= game:GetService("CoreGui")


local MainGui = Instance.new("ScreenGui" , CoreGui)
MainGui.Name , MainGui.Parent , MainGui.ZIndexBehavior , MainGui.IgnoreGuiInset , MainGui.Archivable = "rbxlx_MainGUI" , CoreGui , Enum.ZIndexBehavior.Sibling , true , false

local HolderFrame = Instance.new("Frame" , MainGui)
HolderFrame.Archivable , HolderFrame.Active , HolderFrame.AnchorPoint , HolderFrame.AutomaticSize , HolderFrame.BackgroundColor3 , HolderFrame.BackgroundTransparency , HolderFrame.BorderColor3 , HolderFrame.Interactable , HolderFrame.LayoutOrder , HolderFrame.Name , HolderFrame.Parent , HolderFrame.Position, HolderFrame.Rotation , HolderFrame.Size , HolderFrame.SizeConstraint , HolderFrame.Style , HolderFrame.Visible , HolderFrame.ZIndex = false , false , Vector2.new(0 , 0) , Enum.AutomaticSize.None , Color3.new(0 , 0 , 0) , 0.5 , Color3.new(0 , 0 , 0) , true , 999 , "HolderFrame" , MainGui , UDim2.new(0.814, 0, 0, 0) , 0 , UDim2.new(0.186, 0, 0.031, 0) , Enum.SizeConstraint.RelativeXY , Enum.FrameStyle.Custom , true , 999

local UICorner = Instance.new("UICorner" , HolderFrame)
UICorner.CornerRadius , UICorner.Name , UICorner.Parent = UDim.new(1 , 0) , "UICorner" , HolderFrame


local FPSsign = Instance.new("TextLabel" , HolderFrame)
FPSsign.Name = "FPSsign"; FPSsign.Parent = HolderFrame; FPSsign.Position = UDim2.new(0.123999998, 0, 0.5, 0); FPSsign.Size = UDim2.new(0.247999996, 0, 1, 0); FPSsign.AnchorPoint = Vector2.new(0.5, 0.5); FPSsign.BackgroundColor = BrickColor.new("Institutional white"); FPSsign.BackgroundColor3 = Color3.new(1, 1, 1); FPSsign.BackgroundTransparency = 1; FPSsign.Font = Enum.Font.Nunito; FPSsign.FontSize = Enum.FontSize.Size24; FPSsign.Text = "FPS:"; FPSsign.TextColor = BrickColor.new("Really black"); FPSsign.TextColor3 = Color3.new(0, 0, 0); FPSsign.TextSize = 20; FPSsign.TextStrokeColor3 = Color3.new(1, 1, 1); 

local PINGsign = Instance.new("TextLabel" , HolderFrame)
PINGsign.Name = "PINGsign"; PINGsign.Parent = HolderFrame; PINGsign.Position = UDim2.new(0.624000013, 0, 0.5, 0); PINGsign.Size = UDim2.new(0.247999996, 0, 1, 0); PINGsign.AnchorPoint = Vector2.new(0.5, 0.5); PINGsign.BackgroundColor = BrickColor.new("Institutional white"); PINGsign.BackgroundColor3 = Color3.new(1, 1, 1); PINGsign.BackgroundTransparency = 1; PINGsign.Font = Enum.Font.Nunito; PINGsign.FontSize = Enum.FontSize.Size24; PINGsign.Text = "PING:"; PINGsign.TextColor = BrickColor.new("Really black"); PINGsign.TextColor3 = Color3.new(0, 0, 0); PINGsign.TextSize = 20; PINGsign.TextStrokeColor3 = Color3.new(1, 1, 1); 

local FPSCounter = Instance.new("TextLabel" , HolderFrame)
FPSCounter.Name = "FPS"; FPSCounter.Parent = HolderFrame; FPSCounter.Position = UDim2.new(0.375999987, 0, 0.5, 0); FPSCounter.Size = UDim2.new(0.247999996, 0, 1, 0); FPSCounter.AnchorPoint = Vector2.new(0.5, 0.5); FPSCounter.BackgroundColor = BrickColor.new("Institutional white"); FPSCounter.BackgroundColor3 = Color3.new(1, 1, 1); FPSCounter.BackgroundTransparency = 1; FPSCounter.Font = Enum.Font.Nunito; FPSCounter.FontSize = Enum.FontSize.Size24; FPSCounter.Text = "N/A"; FPSCounter.TextColor = BrickColor.new("Really black"); FPSCounter.TextColor3 = Color3.new(0, 0, 0); FPSCounter.TextSize = 20; FPSCounter.TextStrokeColor3 = Color3.new(1, 1, 1); 

local PingCounter = Instance.new("TextLabel" , HolderFrame)
PingCounter.Name = "PING"; PingCounter.Parent = HolderFrame; PingCounter.Position = UDim2.new(0.875999987, 0, 0.5, 0); PingCounter.Size = UDim2.new(0.247999996, 0, 1, 0); PingCounter.AnchorPoint = Vector2.new(0.5, 0.5); PingCounter.BackgroundColor = BrickColor.new("Institutional white"); PingCounter.BackgroundColor3 = Color3.new(1, 1, 1); PingCounter.BackgroundTransparency = 1; PingCounter.Font = Enum.Font.Nunito; PingCounter.FontSize = Enum.FontSize.Size24; PingCounter.Text = "N/A"; PingCounter.TextColor = BrickColor.new("Really black"); PingCounter.TextColor3 = Color3.new(0, 0, 0); PingCounter.TextSize = 20; PingCounter.TextStrokeColor3 = Color3.new(1, 1, 1); 


local Colors = {
	Good = Color3.fromRGB(0, 255, 0),
	Normal = Color3.fromRGB(255, 255, 0),
	Bad = Color3.fromRGB(255, 0, 0)
}

function GetPing()
	return owner:GetNetworkPing() * 1000
end

RunService.RenderStepped:Connect(function(TimeBetween)
	local FPS = math.floor(1 / TimeBetween)

	FPSCounter.Text = tostring(FPS)

	if FPS >= 50 then
		FPSCounter.TextColor3 = Colors.Good

	elseif FPS >= 30 then
		FPSCounter.TextColor3 = Colors.Normal

	elseif FPS >= 0 then
		FPSCounter.TextColor3 = Colors.Bad

	end
end)

local PingThread = coroutine.wrap(function()
	while RunService.RenderStepped:Wait() do
		local Ping = tonumber(string.format("%.3f", GetPing() * 1000))
		PingCounter.Text = (math.floor(Ping)).." ms"
		
		if Ping > 900 then
			PingCounter.TextColor3 = Colors.Bad
		elseif Ping > 199 then
			PingCounter.TextColor3 = Colors.Normal
		elseif Ping <= 110 then
			PingCounter.TextColor3 = Colors.Good
		end
	end
end)

PingThread()
