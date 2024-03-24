local fn = require("fine-cmdline").fn
require("fine-cmdline").setup({
	cmdline = {
		enable_keymaps = true,
	},
	popup = {
		position = {
			row = "10%",
			col = "50%",
		},
		size = {
			width = "60%",
			height = 1,
		},
		border = {
			text = {
				top = "Popup Command Line",
				top_align = "center",
			},
			-- style = 'none',
			style = { "#", "-", "#", "|", "#", "-", "#", "|" },
			highlight = "FloatBorder",
		},
		win_options = {
			winhighlight = "Normal:Normal",
		},
	},
	hooks = {
		before_mount = function(input)
			input.input_props.prompt = ":"
		end,
		after_mount = function(input) end,
		set_keymaps = function(imap, feedkeys)
			imap("<Up>", fn.complete_or_next_item)
		end,
	},
})

-- lukas-reineke/indent-blankline.nvim

indent_blankline_version = 3

vim.opt.list = true
vim.opt.listchars:append("space: ")
vim.opt.listchars:append("eol:↲")

vim.opt.termguicolors = true

-- version 3
if indent_blankline_version == 3 then
	local highlight = {
		"RainbowRed",
		"RainbowYellow",
		"RainbowBlue",
		"RainbowOrange",
		"RainbowGreen",
		"RainbowViolet",
		"RainbowCyan",
	}

	local hooks = require("ibl.hooks")
	-- create the highlight groups in the highlight setup hook, so they are reset
	-- every time the colorscheme changes
	hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
		vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
		vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
		vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
		vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
		vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
	end)

	require("ibl").setup({ indent = { char = "|", highlight = highlight } })
else
	-- version 2
	vim.cmd([[highlight IndentBlanklineIndent1 guifg=#703C35 gui=nocombine]])
	vim.cmd([[highlight IndentBlanklineIndent2 guifg=#75603B gui=nocombine]])
	vim.cmd([[highlight IndentBlanklineIndent3 guifg=#486339 gui=nocombine]])
	vim.cmd([[highlight IndentBlanklineIndent4 guifg=#265662 gui=nocombine]])
	vim.cmd([[highlight IndentBlanklineIndent5 guifg=#315F7F gui=nocombine]])
	vim.cmd([[highlight IndentBlanklineIndent6 guifg=#66386D gui=nocombine]])

	vim.cmd([[highlight IndentBlanklineContextIndent1 guifg=#E06C75 gui=nocombine]])
	vim.cmd([[highlight IndentBlanklineContextIndent2 guifg=#E5C07B gui=nocombine]])
	vim.cmd([[highlight IndentBlanklineContextIndent3 guifg=#98C379 gui=nocombine]])
	vim.cmd([[highlight IndentBlanklineContextIndent4 guifg=#56B6C2 gui=nocombine]])
	vim.cmd([[highlight IndentBlanklineContextIndent5 guifg=#61AFEF gui=nocombine]])
	vim.cmd([[highlight IndentBlanklineContextIndent6 guifg=#C678DD gui=nocombine]])

	require("indent_blankline").setup({
		char = "|",
		space_char_blankline = " ",
		show_current_context = true,
		show_current_context_start = true,
		char_highlight_list = {
			"IndentBlanklineIndent1",
			"IndentBlanklineIndent2",
			"IndentBlanklineIndent3",
			"IndentBlanklineIndent4",
			"IndentBlanklineIndent5",
			"IndentBlanklineIndent6",
		},
		context_patterns = {
			"class",
			"function",
			"method",
			"if",
			"for",
			"loop",
			"let",
			"while",
		},
		context_highlight_list = {
			"IndentBlanklineContextIndent1",
			"IndentBlanklineContextIndent2",
			"IndentBlanklineContextIndent3",
			"IndentBlanklineContextIndent4",
			"IndentBlanklineContextIndent5",
			"IndentBlanklineContextIndent6",
		},
	})
end

require("colorizer").setup({
	"html",
	"javascript",
	"css",
	"vim",
}, {
	css = true,
})
