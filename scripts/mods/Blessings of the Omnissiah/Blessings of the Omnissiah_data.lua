local mod = get_mod("Blessings of the Omnissiah")

return {
	name = mod:localize("mod_title"),
	description = mod:localize("mod_description"),
	is_togglable = true,
  options = {
		widgets = {{
      setting_id    = "lowerRankFilter",
      type          = "dropdown",
      default_value = 1,
      options = {
        {text = "no_filter_localization_id",   value = 1, show_widgets = { --[[...]] }},
        {text = "show_lower_rank_localization_id",   value = 2, show_widgets = { --[[...]] }},
        {text = "hide_lower_rank_localization_id", value = 3, show_widgets = { --[[...]] }},
      },  
    }}
  }
}
