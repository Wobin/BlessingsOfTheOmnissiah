require("scripts/ui/view_content_blueprints/item_blueprints")
local mod = get_mod("Blessings of the Omnissiah")
local ItemUtils = require("scripts/utilities/items")
mod.blessings = {}
mod.traitCategory = {}


local indexBlessings = function(template)
  mod.traitCategory[template] = true
  Managers.backend.interfaces.crafting:trait_sticker_book(template):next(
    function(data)
      mod.blessings = table.merge(mod.blessings, data)      
    end)
end

local BlessingVisibilitySlot = function(item, index)      
  if item.traits == nil or item.traits[index] == nil then     
    return false
  end   
  local template = ItemUtils.trait_category(item)
  if template and not mod.traitCategory[template] then
    indexBlessings(template)    
    return false      
  end
  local trait = item.traits[index]   
  return mod.blessings[trait.id] and mod.blessings[trait.id][trait.rarity] == "unseen"   
end

local BlessingVisibilityItem = function(content, index)    
  if content.element.item.traits == nil or content.element.item.traits[index] == nil then     
    return false
  end 
  local trait = content.element.item.traits[index]   
  local template = string.match(trait.id, "content/items/traits/([^/]+)/%S+")
  if template and not mod.traitCategory[template] then
    indexBlessings(template)        
    return false
  end    
  return mod.blessings[trait.id] and mod.blessings[trait.id][trait.rarity] == "unseen"   
end

mod.item_blessings= {
  {
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_b1",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.online_green(255, true),
                offset = {28, 0, 10},
                size = {35, 35},                
            },
            visibility_function = function (content)                                                                  
                if content.trait_1 then                                     
                   return BlessingVisibilityItem(content, 1)
                  end
                  return false
                end
            },
              {
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_b2",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.online_green(255, true),
                offset = {70, 0, 10},
                size = {35, 35},                
            },
            visibility_function = function (content)        
                   if content.trait_2 then                   
                    return BlessingVisibilityItem(content, 2)
                  end
                  return false
                end
            },
              {
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_b3",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.online_green(255, true),
                offset = {112, 0, 10},
                size = {35, 35},                
            },
            visibility_function = function (content)        
                   if content.trait_3 then 
                    return BlessingVisibilityItem(content, 3)
                  end
                  return false
                end
            }
  }
    
mod.itemslot_blessings = {
  {
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_a1",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.online_green(255, true),
                offset = {28, 0, 10},
                size = {35, 35},                
            },
            visibility_function = function (content)        
                  if content.item ~= nil and content.item.traits ~= nil then                    
                    return BlessingVisibilitySlot(content.item, 1)
                  end
                  return false
                end
            }, {
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_a2",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.online_green(255, true),
                offset = {70, 0, 10},
                size = {35, 35},                
            },
            visibility_function = function (content)        
                  if content.item ~= nil and content.item.traits ~= nil  then                    
                    return BlessingVisibilitySlot(content.item, 2)
                  end
                  return false
                end
          }, {
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_a3",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.online_green(255, true),
                offset = {112, 0, 10},
                size = {35, 35},                
            },
            visibility_function = function (content)        
                  if content.item ~= nil and content.item.traits ~= nil  then                    
                    return BlessingVisibilitySlot(content.item, 3)
                  end
                  return false
                end
          }}
   


 
local isIn = function(source, match)
  for _,v in ipairs(source) do
    if v.style_id == match.style_id then
      return true
    end
  end
  return false;
end

mod.on_all_mods_loaded = function()  
  mod:hook_require("scripts/ui/pass_templates/item_pass_templates", function(data)                   
      for _,texture in ipairs(mod.itemslot_blessings) do
        if not isIn(data.item_slot, texture) then
          table.insert(data.item_slot, texture)        
        end
      end 
      for _, texture in ipairs(mod.item_blessings) do
        if not isIn(data.item, texture) then
          table.insert(data.item, texture)        
        end
      end
    return data
  end)
end


