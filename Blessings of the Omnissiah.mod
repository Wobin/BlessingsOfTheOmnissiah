return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Blessings of the Omnissiah` encountered an error loading the Darktide Mod Framework.")

		new_mod("Blessings of the Omnissiah", {
			mod_script       = "Blessings of the Omnissiah/scripts/mods/Blessings of the Omnissiah/Blessings of the Omnissiah",
			mod_data         = "Blessings of the Omnissiah/scripts/mods/Blessings of the Omnissiah/Blessings of the Omnissiah_data",
			mod_localization = "Blessings of the Omnissiah/scripts/mods/Blessings of the Omnissiah/Blessings of the Omnissiah_localization",
		})
	end,
	packages = {},
}
