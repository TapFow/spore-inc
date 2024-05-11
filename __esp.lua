---// services
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

--// stuff
local owner = Players.LocalPlayer
local UsesTeamColor, UsesTeam = true, owner.Team ~= nil ---// 2: owner.Team ~= nil

local NormalColor = Color3.fromRGB(6, 255, 151)
local CollectionServiceTag = "Highlighted"

--// connections
local RenderSteppedConnection : RBXScriptConnection?

--// functions
function CreateHL(Player : Player)
	if Player.Character == nil then return nil end
	local character = Player.Character

	local NewESP = Instance.new("Highlight", character)
	NewESP.Parent = character
	NewESP.Adornee = character
	
	repeat task.wait(); NewESP.Adornee = character; NewESP.Parent = character until NewESP.Adornee == character and NewESP.Parent == character

	NewESP.Archivable = false
	NewESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	NewESP.Enabled = true
	NewESP.FillColor = NormalColor
	NewESP.FillTransparency = 0.65
	NewESP.Name = "ESP_HL"
	NewESP.OutlineColor = NormalColor
	NewESP.OutlineTransparency = 0.15

	return NewESP
end

function RenderStepped(deltatime)
	for null, Player in next, Players:GetPlayers() do
		if Player ~= owner then
			if Player.Character ~= nil then
				if Player.Character:IsDescendantOf(workspace) then
					if not CollectionService:HasTag(Player.Character, CollectionServiceTag) or not Player.Character:FindFirstChild("ESP_HL") then
						CollectionService:AddTag(Player.Character, CollectionServiceTag)

						local NewESP = CreateHL(Player)

						if UsesTeam == true and UsesTeamColor == true and NewESP ~= nil then
							NewESP.FillColor = Player.Team.TeamColor.Color
							NewESP.OutlineColor = Player.Team.TeamColor.Color
						end
					else
						if UsesTeam == true and UsesTeamColor == true and Player.Character:FindFirstChild("ESP_HL") then
							local NewESP = Player.Character:FindFirstChild("ESP_HL")

							if NewESP ~= nil then
								NewESP.FillColor = Player.Team.TeamColor.Color
								NewESP.OutlineColor = Player.Team.TeamColor.Color
							end
						end
					end
				end
			end
		end
	end
end

function StopHL()
	if typeof(RenderSteppedConnection) == "RBXScriptConnection" then RenderSteppedConnection:Disconnect() RenderSteppedConnection = nil end

	for null, Player in next, Players:GetPlayers() do
		if Player.Character ~= nil then
			if CollectionService:HasTag(Player.Character, CollectionServiceTag) then
				CollectionService:RemoveTag(Player.Character, CollectionServiceTag)

				if Player.Character:FindFirstChild("ESP_HL") then
					Player.Character:FindFirstChild("ESP_HL"):Destroy()
				end
			end
		end
	end
end

function ClearHL()
	StopHL()
	task.wait(0.01)
	RenderSteppedConnection = RunService.RenderStepped:Connect(RenderStepped)
end

---// connections
RenderSteppedConnection = RunService.RenderStepped:Connect(RenderStepped)

---// globals!
_G.ClearHL = ClearHL
_G.StartHL = ClearHL
_G.StopHL = StopHL
_G.FullStopHL = function()
	StopHL()
	_G.ClearHL, _G.StartHL, _G.StopHL, _G.FullStopHL = function() end, function() end, function() end, function() end
	script:Destroy()
end
