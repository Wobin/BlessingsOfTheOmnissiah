--[[
Title: Blessings of the Omnissiah
Author: Wobin
Date: 12/06/2023
Repository: https://github.com/Wobin/BlessingsOfTheOmnissiah
Version: 2.2

https://github.com/Aussiemon/Darktide-Source-Code/blob/4cd2fae4d6d248cb76751e7e4df386abaf8f2b62/scripts/ui/views/inventory_view/inventory_view_content_blueprints.lua#L712
]]--

require("scripts/ui/view_content_blueprints/item_blueprints")
require("scripts/ui/views/crafting_modify_view/crafting_modify_view")
require("scripts/ui/views/crafting_view/crafting_view")

local mod = get_mod("Blessings of the Omnissiah")
local ItemUtils = require("scripts/utilities/items")
local craftModifyView = CLASSES.CraftingModifyView
local next = next
mod.blessings = {}
mod.traitCategory = {}
mod.waitingOn = {}
local settings = {filter = 2}




local indexBlessings = function(template)  
  mod.traitCategory[template] = true  
  mod.waitingOn[template] = true
  Managers.backend.interfaces.crafting:trait_sticker_book(template):next(
    function(data)
      mod.blessings = table.merge(mod.blessings, data)                  
      mod.waitingOn[template] = nil
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
local isHighestRank = function(trait)
  local rank = trait.rarity + 1
  while mod.blessings[trait.id] and mod.blessings[trait.id][rank] ~= nil do
    if mod.blessings[trait.id][rank] == "seen" then              
      return false
    end
    rank = rank + 1
  end
  return true;
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

local BlessingStored = function(trait)
 local template = string.match(trait.id, "content/items/traits/([^/]+)/%S+")
 if template and not mod.traitCategory[template] then
    indexBlessings(template)   
    return false
  end
  return true
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
  if not BlessingStored(trait) then 
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
   


 
local item_type_filter_list = {
  "WEAPON_MELEE",
  "WEAPON_RANGED",
  "GADGET"
}
local isIn = function(source, match)
  for _,v in ipairs(source) do
    if v.style_id == match.style_id then
      return true
    end
  end
  return false;
end



local cycleFilter = function()
  settings.filter = (settings.filter + 1) % 3
end

local isNotFiltered = function()
  return settings.filter == 2
end

local isFilterByBlessing = function()
  return settings.filter == 0
end

local isFilterByMaxBlessing = function()
  return settings.filter == 1
end


local countOf = function(items)
  local count = 0  
  for i,v in pairs(items or {}) do 
    count = count +1 
  end
  return count
end

local no_filter_definition = {
	input_action = "hotkey_menu_special_2",
	display_name = "loc_BotO_not_filter_blessing",
	alignment = "right_alignment",
	on_pressed_callback = "cb_on_filter",
  visibility_function  = function() return isFilterByMaxBlessing() and (mod.index or 0) < 3 and next(mod.waitingOn) == nil end
}
local filter_unearnt_definition = {
	input_action = "hotkey_menu_special_2",
	display_name = "loc_BotO_filter_unearnt_blessing",
	alignment = "right_alignment",
	on_pressed_callback = "cb_on_filter",
  visibility_function  = function() return isNotFiltered() and (mod.index or 0) < 3 and next(mod.waitingOn) == nil end
}
local filter_max_unearnt_definition = {
  input_action = "hotkey_menu_special_2",
	display_name = "loc_BotO_filter_max_blessing",
	alignment = "right_alignment",
	on_pressed_callback = "cb_on_filter",
  visibility_function  = function() return isFilterByBlessing() and (mod.index or 0) < 3 and next(mod.waitingOn) == nil end
}

local ProcessAllBlessings = function(items)  
  for _,v in pairs(items or {}) do
    if  v.__master_item.item_type ~= "GADGET" and v.__master_item.traits then
      for _, trait in ipairs(v.__master_item.traits) do
          BlessingStored(trait)
      end
    end
  end
end

 local refreshView = function()
    if craftModifyView then
      local character_id = craftModifyView:_player():character_id()
      local item_type_filter_list = {
        "WEAPON_MELEE",
        "WEAPON_RANGED",
        "GADGET"
        }
        craftModifyView._inventory_promise = Managers.data_service.gear:fetch_inventory(character_id, nil, item_type_filter_list)
        craftModifyView._inventory_promise:next(callback(craftModifyView, "_cb_fetch_inventory_items"))        
    end
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
      settings.filter = 2
      refreshView()
    end)
  
  
  CLASSES.CraftingView.cb_on_filter = function(self)    
    cycleFilter()
    refreshView()
  end
  
  mod.FilterBlessings = function(item_list)     
    local list = {}        
    mod.FoundItemsFilter = 0
    for i,v in pairs(item_list or {}) do      
      if v.__master_item then
        if isNotFiltered() or v.__master_item.item_type == "GADGET" then      
          list[i] = v
        else 
          local traits = v.__master_item.traits
          if traits then          
            for _,trait in ipairs(traits) do
              BlessingStored(trait)
              if (mod.blessings[trait.id] and mod.blessings[trait.id][trait.rarity] == "unseen") 
              and (isFilterByBlessing() or (isFilterByMaxBlessing() and not isLowerRank(trait))) then                
                list[i] = v
                mod.FoundItemsFilter = mod.FoundItemsFilter + 1
              end
            end
          end
        end        
      end
    end       
    return list
  end
  

  mod:hook_safe( CLASSES.CraftingView, "_setup_tab_bar", function(self, tab_params, additional)
      mod.tab_bar = self      
      if self._tab_bar_views then
        for i,v in ipairs(self._tab_bar_views) do
          local legend = v.input_legend_buttons
          if not legend then return end
          if not table.find_by_key(legend, "display_name", filter_unearnt_definition.display_name) then
            table.insert(legend, filter_unearnt_definition)    
          end
          if not table.find_by_key(legend, "display_name", filter_max_unearnt_definition.display_name) then
            table.insert(legend, filter_max_unearnt_definition)    
          end        
          if not table.find_by_key(legend, "display_name", no_filter_definition.display_name) then
            table.insert(legend, no_filter_definition)    
          end        

        end
      end
    end)
  
  mod:hook_safe(CLASSES.CraftingModifyView, "on_enter", function(self)    
      mod.charId = self:_player():character_id()
      craftModifyView = self      
      mod.index = 0      
  end)

  mod:hook_safe(CLASSES.CraftingModifyView, "cb_switch_tab", function(self, index)
    mod.index = index        
  end)

  
  mod:hook(CLASSES.CraftingModifyView, "_cb_fetch_inventory_items", function(func, self, items)             
      if mod.index == 0 then        
        ProcessAllBlessings(items)
      end
      
      local filtered_items = mod.FilterBlessings(items) 
      mod.oldIndex = mod.index        
      func(self, filtered_items)
      self._inventory_items = items      
      mod.items = items
      self:cb_switch_tab(mod.oldIndex)
    end)
  
end






  
