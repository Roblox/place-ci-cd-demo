local lfs = require("lfs")
local json = require("dkjson")

local function is_directory(path)
    return lfs.attributes(path, "mode") == "directory"
end

local function is_lua_file(path)
    return path:match("%.lua$") or path:match("%.luau$")
end

local function read_file_content(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

local function write_to_file(data, filename)
    local file = io.open(filename, "w")
    if not file then
        error("Unable to open file for writing: " .. filename)
    end
    file:write(data)
    file:close()
    print("content saved to: " .. filename)
end

local function serialize_directory(path)
    local result = {}
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local full_path = path .. "/" .. file
            if is_directory(full_path) then
                result[file] = serialize_directory(full_path)
            else
                if is_lua_file(full_path) then
                    result[file] = {
                        content = read_file_content(full_path)
                    }
                end
            end
        end
    end
    return result
end

local function main()
    local repo_path = arg[1] or error("No path provided")

    local serialized_directory = serialize_directory(repo_path)
    local json_string = json.encode(serialized_directory, { indent = true })

    task_code = read_file_content("./scripts/lua/task.lua")
    insert_deserialized_directory_to_task = "json_string = [===[" .. json_string .. "]===]\n\n" .. task_code
    write_to_file(insert_deserialized_directory_to_task, "./tasks/packagePublish.luau")
end

main()