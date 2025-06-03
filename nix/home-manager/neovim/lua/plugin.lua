local enabled_plugins = {
	require("plugins/catppuccin")
}

require("lazy").setup(enabled_plugins, {
	dev = {
		fallback = true
	}
});
