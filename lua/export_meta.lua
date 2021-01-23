-- ./darktable -d lua
-- Copy to: C:\Users\matze\AppData\Local\darktable\lua

local dt = require "darktable"
--local du = require "lib/dtutils"
local json = require "json"

local FILE_ENDING = "meta"

--du.check_min_api_version("5.0.0", "export_meta")

dt.print("export_meta plugin is installed")

dt.register_event("intermediate-export-image",
  function (event, image, filename, format, storage)
    dt.print_log("Export " .. image.path .. "/" ..image.filename .. " to " .. filename)
    
    local tags = {};

    for _, tag in ipairs(image:get_tags()) do
        if tag.name:find("darktable") ~= 1 then
            table.insert(tags, tag.name)
        end
    end

    color_labels = ""
    if image.red then
      color_labels = color_labels .. "r"
    end
    if image.green then
      color_labels = color_labels .. "g"
    end
    if image.blue then
      color_labels = color_labels .. "b"
    end
    if image.yellow then
      color_labels = color_labels .. "y"
    end
    if image.purple then
      color_labels = color_labels .. "p"
    end

    local meta = {
        Tags = tags,
        Rating = image.rating,
        ColorLabels = color_labels
    };

    local file = assert(io.open(filename .. "." .. FILE_ENDING, "w"))   
    file:write(json.encode(meta));
    file:close()
  end
)

--[[
dt.preferences.register("preferenceExamples",        -- script: This is a string used to avoid name collision in preferences (i.e namespace). Set it to something unique, usually the name of the script handling the preference.
                        "preferenceExamplesString",  -- name
                        "string",                     -- type
                        "Example String",            -- label
                        "Example String Tooltip",    -- tooltip
                        "String")                     -- default

*dt.preferences.register("preferenceExamples",        -- script: This is a string used to avoid name collision in preferences (i.e namespace). Set it to something unique, usually the name of the script handling the preference. 
                        "preferenceExamplesString",  -- name
                        "bool",                       -- type
                        "Example Boolean",           -- label
                        "Example Boolean Tooltip",   -- tooltip
                        true)                         -- default
]]