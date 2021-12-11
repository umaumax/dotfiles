local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local popup = Popup({
	enter = true,
	focusable = true,
	border = {
		text = {
			top = vim.b.title,
			top_align = "center",
		},
		style = { "#", "-", "#", "|", "#", "-", "#", "|" },
		highlight = "FloatBorder",
	},
	position = "50%",
	size = {
		width = "90%",
		height = "30%",
	},
	buf_options = {
		modifiable = true,
		readonly = false,
	},
})

-- mount/open the component
popup:mount()

-- unmount component when cursor leaves buffer
popup:on(event.BufLeave, function()
	popup:unmount()
end)

-- set content
vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, vim.g.lines)
vim.cmd("set readonly")
vim.cmd('if exists("*markology#MarkologyDisable") | call markology#MarkologyDisable() | endif')
