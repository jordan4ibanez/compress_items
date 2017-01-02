--this is a simple mod which allows you to compress nodes

--minetest.registered_craftitems
local registered_nodes = table.copy(minetest.registered_nodes)
local layers_of_compression = 5 -- how many layers of compression are allowed

local number = 9

--for nodes
for i = 1,layers_of_compression do

	local darkness = i * 40
	
	local lower = 9 * (9^(i-2))
	
	for item,def in pairs(registered_nodes) do
		--make a copy of the original node
		local copy_item = item
		local copy_def = table.copy(def)
		
		if copy_def.mod_origin ~= "*builtin*" and copy_item ~= "" then
			local name = copy_item:match("^.-:(.*)")
			copy_def.groups["not_in_creative_inventory"] = 1
			
			--darken textures the more they're compressed
			for num,tex in ipairs(copy_def.tiles) do
				if type(tex) == "string" then
					copy_def.tiles[num] = tex.."^[colorize:#000000:"..darkness
				end
			end
			if copy_def.wield_image then
				copy_def.wield_image = copy_def.wield_image.."^[colorize:#000000:"..darkness
			end
			if copy_def.inventory_image then
				copy_def.inventory_image = copy_def.inventory_image.."^[colorize:#000000:"..darkness
			end
			
			--only do defined description
			if copy_def.description then
				copy_def.description = copy_def.description.." (Compressed "..number..")"
			end
			
			minetest.register_node("compress_items:"..name.."_"..number, copy_def)
			
			
			
			local lower_item
			if i == 1 then
				lower_item = item
			else
				lower_item = "compress_items:"..name.."_"..lower
			end
			--register input
			minetest.register_craft({
				output = "compress_items:"..name.."_"..number,
				recipe = {
					{lower_item, lower_item, lower_item},
					{lower_item, lower_item, lower_item},
					{lower_item, lower_item, lower_item}
				}
			})
			
			
			--register output
			minetest.register_craft({
				output = lower_item.." "..9,
				recipe = {
					{"compress_items:"..name.."_"..number},
				}
			})
		end
		
	end
	
	--how many nodes are compressed
	number = 9 * (9^i)
	
end

--free up memory
registered_nodes = nil

