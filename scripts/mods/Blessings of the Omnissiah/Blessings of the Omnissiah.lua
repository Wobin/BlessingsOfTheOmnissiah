--[[
Title: Blessings of the Omnissiah
Author: Wobin
Date: 02/02/2023
Repository: https://github.com/Wobin/BlessingsOfTheOmnissiah
Version: 1.4
]]--

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

local isLowerRank = function(trait) 
  local rank = trait.rarity + 1
  while mod.blessings[trait.id] and mod.blessings[trait.id][rank] ~= nil do
    if mod.blessings[trait.id][rank] == "seen" then      
      return true;
    end    
    rank = rank + 1
  end
  return false;
end

local traitVisibility = function(trait,lower_rank_indicator)  
  if mod:get("lowerRankFilter") == 1 then
    if lower_rank_indicator then 
      return false
    else
      return mod.blessings[trait.id] and mod.blessings[trait.id][trait.rarity] == "unseen"   
    end
  elseif mod:get("lowerRankFilter") == 2 then
    if not isLowerRank(trait) then
      return not lower_rank_indicator and mod.blessings[trait.id] and mod.blessings[trait.id][trait.rarity] == "unseen"        
    else
      return lower_rank_indicator and mod.blessings[trait.id] and mod.blessings[trait.id][trait.rarity] == "unseen"   
    end
  elseif mod:get("lowerRankFilter") == 3 then
    if isLowerRank(trait) then
      return false      
    end
    if not lower_rank_indicator then 
      return mod.blessings[trait.id] and mod.blessings[trait.id][trait.rarity] == "unseen"   
    end
  end  
end

local BlessingVisibilitySlot = function(item, index, lower_rank_indicator)      
  if item.traits == nil or item.traits[index] == nil then     
    return false
  end   
  local trait = item.traits[index]   
  local template = ItemUtils.trait_category(item)
  if template and not mod.traitCategory[template] then
    indexBlessings(template)    
    return false      
  end
  return traitVisibility(trait, lower_rank_indicator)
end

local BlessingVisibilityItem = function(content, index, lower_rank_indicator)    
  if content.element.item.traits == nil or content.element.item.traits[index] == nil then     
    return false
  end 
  local trait = content.element.item.traits[index]   
  
  local template = string.match(trait.id, "content/items/traits/([^/]+)/%S+")
  if template and not mod.traitCategory[template] then
    indexBlessings(template)        
    return false
  end  
  return traitVisibility(trait, lower_rank_indicator)
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
                offset = {27, -5, 10},
                size = {30, 30},                
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
            style_id = "blessings_icon_b1a",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.dark_orange(255, true),
                offset = {27, -5, 10},
                size = {30, 30},                
            },
            visibility_function = function (content)                                                                  
                if content.trait_1 then                                     
                   return BlessingVisibilityItem(content, 1, true)
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
                offset = {69, -5, 20},
                size = {30, 30},                
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
            style_id = "blessings_icon_b2a",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.dark_orange(255, true),
                offset = {69, -5, 20},
                size = {30, 30},                
            },
            visibility_function = function (content)        
                   if content.trait_2 then                   
                    return BlessingVisibilityItem(content, 2, true)
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
            },
             {
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_b3a",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.dark_orange(255, true),
                offset = {112, 0, 10},
                size = {35, 35},                
            },
            visibility_function = function (content)        
                   if content.trait_3 then 
                    return BlessingVisibilityItem(content, 3, true)
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
                offset = {27, -5, 10},
                size = {30, 30},                
            },
            visibility_function = function (content)        
                  if content.item ~= nil and content.item.traits ~= nil then                    
                    return BlessingVisibilitySlot(content.item, 1)
                  end
                  return false
                end
            },
             {
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_a1c",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.dark_orange(255, true),
                offset = {27, -5, 10},
                size = {30, 30},                
            },
            visibility_function = function (content)        
                  if content.item ~= nil and content.item.traits ~= nil then                    
                    return BlessingVisibilitySlot(content.item, 1, true)
                  end
                  return false
                end
            },{
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_a2",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.online_green(255, true),
                offset = {69, -5, 10},
                size = {30, 30},                
            },
            visibility_function = function (content)        
                  if content.item ~= nil and content.item.traits ~= nil  then                    
                    return BlessingVisibilitySlot(content.item, 2)
                  end
                  return false
                end
          },{
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_a2",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.dark_orange(255, true),
                offset = {69, -5, 10},
                size = {30, 30},                
            },
            visibility_function = function (content)        
                  if content.item ~= nil and content.item.traits ~= nil  then                    
                    return BlessingVisibilitySlot(content.item, 2, true)
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
          }, {
            pass_type = "texture",
            value = "content/ui/materials/symbols/new_item_indicator",
            style_id = "blessings_icon_a3",
            style = {
               vertical_alignment = "bottom",
                horizontal_alignment = "left",
                color = Color.dark_orange(255, true),
                offset = {112, 0, 10},
                size = {35, 35},                
            },
            visibility_function = function (content)        
                  if content.item ~= nil and content.item.traits ~= nil  then                    
                    return BlessingVisibilitySlot(content.item, 3, true)
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
  mod:hook_safe(CLASS.CraftingExtractTraitView,"_perform_crafting", function(self)
      mod.blessings = {}
      mod.traitCategory = {}
      end)
end
