-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			-- Telescope is a fuzzy finder that comes with a lot of different things that
			-- it can fuzzy find! It's more than just a "file finder", it can search
			-- many different aspects of Neovim, your workspace, LSP, and more!
			--
			-- The easiest way to use Telescope, is to start by doing something like:
			--  :Telescope help_tags
			--
			-- After running this command, a window will open up and you're able to
			-- type in the prompt window. You'll see a list of `help_tags` options and
			-- a corresponding preview of the help.
			--
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			--
			-- This opens a window that shows you all of the keymaps for the current
			-- Telescope picker. This is really useful to discover what Telescope can
			-- do as well as how to actually do it!

			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			local U = require("utils")
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				defaults = {
					mappings = {
						i = {
							-- ['<c-enter>'] = 'to_fuzzy_refine',
							["<c-l>"] = false,
							["<c-j>"] = actions.move_selection_next,
							["<c-k>"] = actions.move_selection_previous,
							["<c-d>"] = function(prompt_bufnr)
								local picker = action_state.get_current_picker(prompt_bufnr)
								if picker.prompt_title == "Buffers" then
									actions.delete_buffer(prompt_bufnr)
								end
							end,
							["<CR>"] = function(prompt_bufnr)
								U.telescope_selection_made = true
								actions.select_default(prompt_bufnr)
							end,
							["<C-x>"] = function(prompt_bufnr)
								U.telescope_selection_made = true
								actions.select_horizontal(prompt_bufnr)
							end,
							["<C-v>"] = function(prompt_bufnr)
								U.telescope_selection_made = true
								actions.select_vertical(prompt_bufnr)
							end,
							["<C-t>"] = function(prompt_bufnr)
								U.telescope_selection_made = true
								actions.select_tab(prompt_bufnr)
							end,
						},
						n = {
							["<CR>"] = function(prompt_bufnr)
								U.telescope_selection_made = true
								actions.select_default(prompt_bufnr)
							end,
							["<C-x>"] = function(prompt_bufnr)
								U.telescope_selection_made = true
								actions.select_horizontal(prompt_bufnr)
							end,
							["<C-v>"] = function(prompt_bufnr)
								U.telescope_selection_made = true
								actions.select_vertical(prompt_bufnr)
							end,
							["<C-t>"] = function(prompt_bufnr)
								U.telescope_selection_made = true
								actions.select_tab(prompt_bufnr)
							end,
						},
					},
					-- file_ignore_patterns = { "node_modules", ".git", ".next", ".nx" },
				},
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			local set = vim.keymap.set
			set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [h]elp" })
			set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [k]eymaps" })
			set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [f]iles" })
			set("n", "<leader>fa", function()
				builtin.find_files({ follow = true, no_ignore = true, hidden = true })
			end, { desc = "[F]ind [f]iles" })
			set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [s]elect Telescope" })
			set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind [w]ord" })
			set("n", "<leader>fc", builtin.current_buffer_fuzzy_find, { desc = "[F]ind [c]urrent word" })
			set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [g]rep" })
			set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [d]iagnostics" })
			set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [r]esume" })
			set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind recent files ("." for repeat)' })
			set("n", "<leader>fb", function()
				builtin.buffers({ sort_mru = true, ignore_current_buffer = true, show_all_buffers = true })
			end, { desc = "[F]ind existing [b]uffers" })

			-- Slightly advanced example of overriding default behavior and theme
			set("n", "<leader>f/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[F]uzzi[/]y search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			set("n", "<leader>fo", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[F]ind in [o]pen Files" })

			-- Shortcut for searching your Neovim configuration files
			set("n", "<leader>fn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[F]ind [N]eovim files" })
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
