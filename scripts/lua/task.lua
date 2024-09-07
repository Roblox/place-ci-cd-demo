local function read_json(string)
	return game:GetService("HttpService"):JSONDecode(string)
end

local function create_module_script(name, content)
	local module_script = Instance.new("ModuleScript")
	module_script.Name = name
	module_script.Source = content
	return module_script
end

local function create_folder(name)
	local folder = Instance.new("Folder")
	folder.Name = name
	return folder
end

local function deserialize_directory(directory, parent)
	for key, value in pairs(directory) do
		if (value["content"]) then
			local ms = create_module_script(key, value["content"])
			ms.Parent = parent
		else
			local p = create_folder(key)
			p.Parent = parent
			deserialize_directory(value, p)
		end
	end
end

local function publish_package_asset(instance)
	local ws = game.Workspace
	local as = game.AssetService

	local requestParameters = {
		CreatorId = 1253904492,
		CreatorType = Enum.AssetCreatorType.User,
		Name = "Today",
		Description = "hack your game",
	}

	local result, assetId
	print("creating an asset")
	local success, err = pcall(function()
		result, assetId = as:CreateAssetAsync(instance, Enum.AssetType.Model, requestParameters)
	end)

	if success then
		print(result, assetId)
	else
		warn(err)
	end
	
	print("creating a new version")
	local versionId
	local success, err = pcall(function()
		result, versionId = as:CreateAssetVersionAsync(instance, Enum.AssetType.Model, assetId, requestParameters)
	end)

	if success then
		print(result, versionId)
	else
		warn(err)
	end
end

local function main()
	local root = read_json(json_string)
	local model = Instance.new("Model")
	model.Name = "Target"
	model.Parent = game.Workspace
	deserialize_directory(root, model)
	publish_package_asset(model)
end

main()