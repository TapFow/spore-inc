---// services
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")

--// stuff
local owner = Players.LocalPlayer
local Highlights = {}
local UsesTeam = owner.Team ~= nil

--// functions
function CreateHL(Player : Player)
	if Player.Character == nil then return nil end
	local character = Player.Character
	local ColorUsed = Color3.fromRGB(6, 255, 151)
	
	if UsesTeam == true then
		if Player.Team ~= nil then
			ColorUsed = Player.Team.TeamColor.Color
		end
	end
	
	local NewESP = Instance.new("Highlight", character)
	NewESP.Parent = character
	NewESP.Adornee = character

	NewESP.Archivable = false
	NewESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	NewESP.Enabled = true
	NewESP.FillColor = ColorUsed
	NewESP.FillTransparency = 0.75
	NewESP.Name = Player.Name .. "'s highlight. - rbxlxss"
	NewESP.OutlineColor = ColorUsed
	NewESP.OutlineTransparency = 0.25
	
	table.insert(Highlights , NewESP)
	return NewESP
end

function ClearHL()
	for index, Highlight in next, Highlights do
		if Highlight ~= nil and Highlight:IsA("Highlight") then
			Highlight:Destroy()
		end
	end
	
	table.clear(Highlights)
	Highlights = {}
end

function CreateHLESP()
	if UsesTeam == true then warn("ESP.lua - UsesTeam = true!") end
	
	Players.PlayerAdded:Connect(function(NewPlayer : Player)
		NewPlayer.CharacterAdded:Connect(function(character : Model)
			
			task.spawn(function()
				repeat task.wait() until character ~= nil
				task.wait(0.1)

				print("ESP.lua - Players.PlayerAdded - New Character!: " .. tostring(character.Name))
				if NewPlayer ~= owner then
					if UsesTeam == true then
						if NewPlayer.Team ~= owner.Team then
							if character ~= nil then
								local NewESP = CreateHL(NewPlayer)
								NewESP.Parent = character
								NewESP.Adornee = character
							end
						end
					else
						if character ~= nil then
							local NewESP = CreateHL(NewPlayer)
							NewESP.Parent = character
							NewESP.Adornee = character
						end
					end
				end
			end)
		end)
	end)
	
	for _, NewPlayer in next, Players:GetPlayers() do
		if NewPlayer ~= owner then
			
			if UsesTeam == true then
				if NewPlayer.Team ~= owner.Team then
					local character = NewPlayer.Character

					if character ~= nil then
						local NewESP = CreateHL(NewPlayer)
						NewESP.Parent = character
						NewESP.Adornee = character
					end
				end
			else
				local character = NewPlayer.Character

				if character ~= nil then
					local NewESP = CreateHL(NewPlayer)
					NewESP.Parent = character
					NewESP.Adornee = character
				end
			end
		end
		
		NewPlayer.CharacterAdded:Connect(function(character : Model)
			task.spawn(function()
				repeat task.wait() until character ~= nil
				task.wait(0.1)

				print("ESP.lua - Players.PlayerAdded - New Character!: " .. tostring(character.Name))
				if NewPlayer ~= owner then
					if UsesTeam == true then
						if NewPlayer.Team ~= owner.Team then
							if character ~= nil then
								local NewESP = CreateHL(NewPlayer)
								NewESP.Parent = character
								NewESP.Adornee = character
							end
						end
					else
						if character ~= nil then
							local NewESP = CreateHL(NewPlayer)
							NewESP.Parent = character
							NewESP.Adornee = character
						end
					end
				end
			end)
		end)
	end
end

CreateHLESP()

owner:GetPropertyChangedSignal("Team"):Connect(function()
	UsesTeam = owner.Team ~= nil
	
	ClearHL()
	task.wait()
	CreateHLESP()
end)

_G.ClearHL = ClearHL
