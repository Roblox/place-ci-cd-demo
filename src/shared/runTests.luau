local Workspace = game:GetService("Workspace")

return function()
	assert(1 + 1 == 2, "1+1 != 2")
	assert(Workspace.Gravity > 0, "Gravity is negative")
	assert(Workspace:FindFirstChild("1x1x1x1"), "1x1x1x1 is missing!") --This test will fail, as there is no such Instance
end
