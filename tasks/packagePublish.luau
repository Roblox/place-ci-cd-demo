json_string = [===[{
  "model":{
    "ad":{
      "a.lua":{
        "content":"print(\"a.lua\")"
      }
    }
  },
  "b.lua":{
    "content":"print(\"b.lua\")"
  },
  "d.lua":{
    "content":"print(\"d.lua\")"
  }
}]===]

local function read_json(string)
	return game:GetService("HttpService"):JSONDecode(string)
end

local function create_module_script(name, content)
	local module_script = Instance.new("ModuleScript")
	module_script.Name = name
	--module_script.Source = content
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

local function main()
	local root = read_json(json_string)
	local model = Instance.new("Model")
	model.Parent = game.Workspace
	deserialize_directory(root, model)
end

main()