local leap = require("leap")

-- Disable default mappings
leap.opts.safe_labels = {} -- Disable default "safe" labels
leap.opts.labels = {} -- Disable all labels

-- Set up custom mappings
local mappings = {
	-- Normal mode: forward search (default `s`)
	{
		mode = "n",
		key = "<leader>s",
		action = function()
			leap.leap({ target_windows = { vim.fn.win_getid() } })
		end,
	},

	-- Normal mode: backward search (default `S`)
	{
		mode = "n",
		key = "<leader>S",
		action = function()
			leap.leap({ backward = true })
		end,
	},

	-- Visual mode: forward search
	{
		mode = "x",
		key = "<leader>s",
		action = function()
			leap.leap({ target_windows = { vim.fn.win_getid() } })
		end,
	},

	-- Visual mode: backward search
	{
		mode = "x",
		key = "<leader>S",
		action = function()
			leap.leap({ backward = true })
		end,
	},

	-- Operator-pending mode forward search
	{
		mode = "o",
		key = "<leader>s",
		action = function()
			leap.leap({ target_windows = { vim.fn.win_getid() } })
		end,
	},

	-- Operator-pending mode backward search
	{
		mode = "o",
		key = "<leader>S",
		action = function()
			leap.leap({ backward = true })
		end,
	},

	-- Cross-window jump (default `gs`)
	{
		mode = "n",
		key = "<leader>gs",
		action = function()
			leap.leap({ target_windows = require("leap.util").get_enterable_windows() })
		end,
	},
}

-- Apply the mappings
for _, map in ipairs(mappings) do
	vim.keymap.set(map.mode, map.key, map.action, { noremap = true, silent = true })
end
