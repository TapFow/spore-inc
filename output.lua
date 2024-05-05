local CoreGui 		= game:GetService("CoreGui")
local TweenService	= game:GetService("TweenService")
local owner = owner

repeat task.wait() until CoreGui:FindFirstChild("mshx") and game:IsLoaded()

local Colors = {
	unexpected = Color3.fromRGB(149, 198, 131),
	print = Color3.fromRGB(220, 220, 220),
	warn = Color3.fromRGB(255, 142, 60),
	error = Color3.fromRGB(255, 68, 64)
}

local UsedLayoutOrder = 1
local mshx, background, output , GradientParent = nil , nil , nil , nil
task.wait(0.125)
if CoreGui:WaitForChild("mshx") then
	mshx = CoreGui:WaitForChild("mshx")
	if mshx:FindFirstChild("Background") then
		background = mshx:WaitForChild("Background")
		
		if background:FindFirstChild("truth") then
			GradientParent = background:WaitForChild("truth")
		else
			error("no mshx.Background.truth!")
		end
		
		if background:FindFirstChild("Output") then
			output = background:WaitForChild("Output")
		else
			error("no mshx.Background.output!")
		end
	else
		error("no mshx.Background!")
	end
else
	error("no CoreGui.mshx!")
end

if GradientParent == nil then error("no GradientParent.") return end
if output:FindFirstChild("TextBox") then output:FindFirstChild("TextBox").Visible = false end

local OutputSF = Instance.new("ScrollingFrame" , output)
OutputSF.Parent = output
OutputSF.Name = "OutputScrollingFrame"
OutputSF.BackgroundTransparency = 1
OutputSF.Size = UDim2.new(1 , 0 , 1 , 0)

Instance.new("UIListLayout", OutputSF).Parent = OutputSF

function createoutput(text , colorstr)
	if OutputSF == nil then error("createouput - no output scrolling frame!") return end
	if tostring(text) == nil then error("createouput - text cannot be tostring()!") return end
	
	local UsedColor = Colors[colorstr] ~= nil and Colors[colorstr] or Colors["unexpected"]

	local NewOutput = Instance.new("TextLabel" , OutputSF)
	NewOutput.LayoutOrder = UsedLayoutOrder
	NewOutput.Text = tostring(text)
	NewOutput.TextColor3 = UsedColor
	NewOutput.BackgroundTransparency = 1
	NewOutput.TextTransparency = 0
	NewOutput.Visible = true
	NewOutput.Size = UDim2.new(1 , -15 , 0.25 , -15)
	NewOutput.TextWrapped = true
	NewOutput.TextXAlignment = Enum.TextXAlignment.Left
	NewOutput.TextYAlignment = Enum.TextYAlignment.Top
	
	UsedLayoutOrder = UsedLayoutOrder + 1
end

function resetoutput()
	if OutputSF == nil then error("resetoutput - no output scrolling frame!") return end
	
	UsedLayoutOrder = 1
	for index, value in next, OutputSF:GetChildren() do
		if value:IsA("TextLabel") or value:IsA("TextBox") then
			value:Destroy()
		end
	end
end

_G.output , _G.createoutput = createoutput , createoutput
_G.resetoutput = resetoutput


local gradient : UIGradient = Instance.new("UIGradient", GradientParent)
GradientParent.TextColor3 = Color3.new(1 , 1 , 1)

gradient.Offset = Vector2.new(0 , 0)
gradient.Rotation = 0
gradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0 , 0),NumberSequenceKeypoint.new(1 , 0)}

gradient.Archivable = true
gradient.Name = "cool gradient - rbxlxss - 2024"

task.spawn(function()
	local TweenInfos = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local TweenParams = {Offset = Vector2.new(1, 0)}
	local CreatedTween = TweenService:Create(gradient, TweenInfos, TweenParams)
	local StartingV2Pos = Vector2.new(-1, 0)
	local list = {}
	local s, kpt = ColorSequence.new, ColorSequenceKeypoint.new
	local counter = 0
	local status = "down"

	gradient.Offset = StartingV2Pos

	local function rainbowColors()

		local sat, val = 255, 255

		for i = 1, 15 do

			local hue = i * 17
			table.insert(list, Color3.fromHSV(hue / 255, sat / 255, val / 255))

		end

	end

	rainbowColors()

	gradient.Color = s({
		kpt(0, list[#list]),
		kpt(0.5, list[#list - 1]),
		kpt(1, list[#list - 2])
	})

	counter = #list

	local function animate()

		CreatedTween:Play()
		CreatedTween.Completed:Wait()
		gradient.Offset = StartingV2Pos
		gradient.Rotation = 180

		if counter == #list - 1 and status == "down" then

			gradient.Color = s({

				kpt(0, gradient.Color.Keypoints[1].Value),
				kpt(0.5, list[#list]),
				kpt(1, list[1])

			})

			counter = 1
			status = "up"

		elseif counter == #list and status == "down" then

			gradient.Color = s({

				kpt(0, gradient.Color.Keypoints[1].Value),
				kpt(0.5, list[1]),
				kpt(1, list[2])

			})

			counter = 2
			status = "up"

		elseif counter <= #list - 2 and status == "down" then 

			gradient.Color = s({

				kpt(0, gradient.Color.Keypoints[1].Value),
				kpt(0.5, list[counter + 1]),
				kpt(1, list[counter + 2])

			})

			counter = counter + 2
			status = "up"

		end

		CreatedTween:Play()
		CreatedTween.Completed:Wait()
		gradient.Offset = StartingV2Pos
		gradient.Rotation = 0

		if counter == #list - 1 and status == "up" then

			gradient.Color = s({

				kpt(0, list[1]),
				kpt(0.5, list[#list]),
				kpt(1, gradient.Color.Keypoints[3].Value)

			})

			counter = 1
			status = "down"

		elseif counter == #list and status == "up" then

			gradient.Color = s({

				kpt(0, list[2]),
				kpt(0.5, list[1]),
				kpt(1, gradient.Color.Keypoints[3].Value)

			})

			counter = 2
			status = "down"

		elseif counter <= #list - 2 and status == "up" then

			gradient.Color = s({

				kpt(0, list[counter + 2]),
				kpt(0.5, list[counter + 1]),
				kpt(1, gradient.Color.Keypoints[3].Value)

			})

			counter = counter + 2
			status = "down"

		end

		animate()

	end

	animate()

end)

if owner.UserId == 3346057398 or owner.UserId == 3954888715 then
	createoutput("rbxlx was here lol" , "print")
	createoutput("i hate this" , "warn")
	createoutput("mushyhax on top" , "error")

	task.wait(1)
	createoutput("this should have green color" , "mushyhaxontop")
	
	task.wait(5)
	resetoutput()
end

return createoutput , resetoutput , {mshx, background, output , OutputSF}
