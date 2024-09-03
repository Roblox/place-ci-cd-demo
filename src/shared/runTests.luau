local Workspace = game:GetService("Workspace")

return function()
	assert(1 + 1 == 2, "1+1 != 2")
	assert(Workspace.Gravity > 0, "Gravity is negative")
end
