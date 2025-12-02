-- I don't want anymore the base mappings of NvChad
-- require("nvchad.mappings")

-- Define the map function using vim.api.nvim_set_keymap
local map = function(mode, lhs, rhs, opts)
    if mode ~= "s" then
        opts = opts or {}
        opts.noremap = true
        opts.silent = opts.silent ~= false -- Default to true for silent if not explicitly set to false
        vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
end

-- Define an `unmap` function to simplify key unmapping
local unmap = function(mode, keybind)
    vim.keymap.set(mode, keybind, "<nop>", { noremap = true, silent = true })
end

-- REMOVING ALL CURRENT UNWANTED DEFAULT MAPPINGS
unmap("x", "#")
unmap("n", "&")
unmap("x", "*")
unmap("n", "<C-L>")
unmap("x", "@")
unmap("x", "Q")
unmap("n", "Y")
unmap("n", "[d")
unmap("i", "<C-W>")
unmap("i", "<C-U>")
unmap("n", "<C-W><C-D>")
unmap("n", "<C-W>d")
unmap("n", '"')
unmap("n", "'")
unmap("n", "`")
unmap("n", "<tab>")
unmap("n", "<space>")
unmap("o", "gc")
unmap("n", "]d")
unmap("n", "g`")
unmap("n", "g'")
unmap("n", "<C-L>")

-- Define individual categories with mappings as lists
local insert_mode_mappings = {
    {
        mode = "i",
        key = "<C-b>",
        cmd = "<ESC>^i",
        opts = { desc = "Move to beginning of line" },
    },
    {
        mode = "i",
        key = "<C-e>",
        cmd = "<End>",
        opts = { desc = "Move to end of line" },
    },
    {
        mode = "i",
        key = "<C-h>",
        cmd = "<Left>",
        opts = { desc = "Move left" },
    },
    {
        mode = "i",
        key = "<C-l>",
        cmd = "<Right>",
        opts = { desc = "Move right" },
    },
    {
        mode = "i",
        key = "<C-j>",
        cmd = "<Down>",
        opts = { desc = "Move down" },
    },
    { mode = "i", key = "<C-k>", cmd = "<Up>", opts = { desc = "Move up" } },
    {
        mode = "i",
        key = "jk",
        cmd = "<ESC>",
        opts = { desc = "Exit insert mode" },
    },
    {
        mode = "i",
        key = "<C-R>",
        cmd = "<C-R>",
        opts = { desc = "Open registers list" },
    },
}

local general_mappings = {
    {
        mode = "n",
        key = "<Esc>",
        cmd = "<cmd>noh<CR>",
        opts = { desc = "Clear highlights" },
    },
    {
        mode = "n",
        key = "<C-s>",
        cmd = "<cmd>w<CR>",
        opts = { desc = "Save file" },
    },
    {
        mode = "n",
        key = "<C-c>",
        cmd = "<cmd>%y*<CR>",
        opts = { desc = "Copy whole file" },
    },
    {
        mode = "n",
        key = "<C-a>",
        cmd = "gg0vG$",
        opts = { desc = "Select all file content" },
    },
    {
        mode = "n",
        key = ";",
        cmd = ":",
        opts = { desc = "Enter command mode" },
    },
    { mode = "n", key = "gx", cmd = "gx", opts = { desc = "Open file link" } },
    {
        mode = "n",
        key = '"',
        cmd = '"',
        opts = { desc = "Open registers list" },
    },
    {
        mode = "n",
        key = "#",
        cmd = "#",
        opts = { desc = "Search for next occurence" },
    },
}

local toggle_mappings = {
    {
        mode = "n",
        key = "<leader>n",
        cmd = "<cmd>set nu!<CR>",
        opts = { desc = "Toggle line numbers" },
    },
    {
        mode = "n",
        key = "<leader>rn",
        cmd = "<cmd>set rnu!<CR>",
        opts = { desc = "Toggle relative line numbers" },
    },
    {
        mode = "n",
        key = "<leader>ch",
        cmd = "<cmd>lua require('custom.cheatsheet').open()<CR>",
        opts = { desc = "Toggle Cheatsheet" },
    },
    {
        mode = "n",
        key = "<leader>sl",
        cmd = "z=",
        opts = { desc = "Toggle spell check" },
    },
    {
        mode = "s",
        key = "gcc",
        cmd = "gcc",
        opts = { desc = "Toggle comment line" },
    },
    {
        mode = "s",
        key = "gc",
        cmd = "gc",
        opts = { desc = "Toggle comment line" },
    },
    {
        mode = { "n", "t" },
        key = "<C-i>",
        cmd = "<cmd>lua require('nvchad.term').toggle { pos = 'float', id = 'floatTerm' }<CR>",
        opts = { desc = "Toggle floating terminal" },
    },
    {
        mode = "t",
        key = "<Esc>",
        cmd = "<cmd>lua require('nvchad.term').toggle { pos = 'float', id = 'floatTerm' }<CR>",
        opts = { desc = "Close floating terminal" },
    },
    {
        mode = "n",
        key = "<leader>cp",
        cmd = "<cmd>lua require('custom.copilot').toggle()<CR>",
        opts = { desc = "Toggle Copilot" },
    },
}

local buffer_mappings = {
    {
        mode = "n",
        key = "<leader>x",
        cmd = "<cmd>lua require('nvchad.tabufline').close_buffer()<CR>",
        opts = { desc = "Close buffer" },
    },
    {
        mode = "n",
        key = "<tab>",
        cmd = "<cmd>lua require('nvchad.tabufline').next()<CR>",
        opts = { desc = "Go to next buffer" },
    },
    {
        mode = "n",
        key = "<S-tab>",
        cmd = "<cmd>lua require('nvchad.tabufline').prev()<CR>",
        opts = { desc = "Go to prev buffer" },
    },
    {
        mode = "n",
        key = "<C-n>",
        cmd = "<cmd>NvimTreeToggle<CR>",
        opts = { desc = "Toggle NvimTree" },
    },
    {
        mode = "n",
        key = "<leader>e",
        cmd = "<cmd>NvimTreeFocus<CR>",
        opts = { desc = "Focus NvimTree" },
    },
    {
        mode = "n",
        key = "<C-h>",
        cmd = "<C-w>h",
        opts = { desc = "Move to left window" },
    },
    {
        mode = "n",
        key = "<C-l>",
        cmd = "<C-w>l",
        opts = { desc = "Move to right window" },
    },
    {
        mode = "n",
        key = "<C-left>",
        cmd = "<C-w>h",
        opts = { desc = "Move to left window" },
    },
    {
        mode = "n",
        key = "<C-right>",
        cmd = "<C-w>l",
        opts = { desc = "Move to right window" },
    },
}

local telescope_mappings = {
    {
        mode = "n",
        key = "<leader>fw",
        cmd = "<cmd>Telescope live_grep<CR>",
        opts = { desc = "Live grep" },
    },
    {
        mode = "n",
        key = "<leader>fb",
        cmd = "<cmd>Telescope buffers<CR>",
        opts = { desc = "Find buffers" },
    },
    {
        mode = "n",
        key = "<leader>fo",
        cmd = "<cmd>Telescope oldfiles<CR>",
        opts = { desc = "Find old files" },
    },
    {
        mode = "n",
        key = "<leader>fz",
        cmd = "<cmd>Telescope current_buffer_fuzzy_find<CR>",
        opts = { desc = "Find in current buffer" },
    },
    {
        mode = "n",
        key = "<leader>ff",
        cmd = "<cmd>Telescope find_files<CR>",
        opts = { desc = "Find files" },
    },
    {
        mode = "n",
        key = "<leader>fa",
        cmd = "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
        opts = { desc = "Find all files (hidden)" },
    },
    {
        mode = "n",
        key = "<leader>cm",
        cmd = "<cmd>Telescope git_commits<CR>",
        opts = { desc = "Git commits" },
    },
    {
        mode = "n",
        key = "<leader>gt",
        cmd = "<cmd>Telescope git_status<CR>",
        opts = { desc = "Git status" },
    },
    {
        mode = "n",
        key = "<leader>th",
        cmd = "<cmd>Telescope themes<CR>",
        opts = { desc = "NvChad themes" },
    },
}

local nvim_tree_mappings = {
    { mode = "s", key = "<CR>", cmd = "<CR>", opts = { desc = "Open file" } },
    {
        mode = "s",
        key = "<CR>",
        cmd = "<CR>",
        opts = { desc = "Expand/Collapse directory" },
    },
    { mode = "s", key = "a", cmd = "a", opts = { desc = "Create file" } },
    { mode = "s", key = "d", cmd = "d", opts = { desc = "Delete file" } },
    { mode = "s", key = "r", cmd = "r", opts = { desc = "Rename file" } },
    { mode = "s", key = "c", cmd = "c", opts = { desc = "Copy file" } },
    { mode = "s", key = "p", cmd = "p", opts = { desc = "Paste file" } },
    { mode = "s", key = "x", cmd = "x", opts = { desc = "Cut file" } },
    { mode = "s", key = "y", cmd = "y", opts = { desc = "Copy filename" } },
    {
        mode = "s",
        key = "Y",
        cmd = "Y",
        opts = { desc = "Copy relative file path" },
    },
    {
        mode = "s",
        key = "gy",
        cmd = "gy",
        opts = { desc = "Copy file absolute path" },
    },
}

local lsp_mappings = {
    -- {
    --     mode = "i",
    --     key = "<C-F>",
    --     cmd = 'copilot#Accept("\\<CR>")',
    --     opts = {
    --         desc = "Accept Copilot suggestion",
    --         expr = true,
    --         replace_keycodes = false,
    --     },
    -- },
    -- {
    --     mode = "n",
    --     key = "<leader>ca",
    --     cmd = "<cmd>Copilot<CR>",
    --     opts = { desc = "Ask to Copilot 3 solutions" },
    -- },
    {
        mode = "n",
        key = "gd",
        cmd = "<cmd>lua vim.lsp.buf.definition()<CR>",
        opts = { desc = "Go to definition" },
    },
    {
        mode = "n",
        key = "gD",
        cmd = "<cmd>lua vim.lsp.buf.declaration()<CR>",
        opts = { desc = "Go to declaration" },
    },
    {
        mode = "n",
        key = "gr",
        cmd = "<cmd>lua vim.lsp.buf.references()<CR>",
        opts = { desc = "Show references list" },
    },
    {
        mode = "n",
        key = "<leader>r",
        cmd = "<cmd>lua vim.lsp.buf.rename()<CR>",
        opts = { desc = "Rename symbol" },
    },
    {
        mode = "n",
        key = "<leader>fm",
        cmd = "<cmd>lua require('conform').format()<CR>",
        opts = { desc = "Format file" },
    },
}

-- Now, gather all the categories in a single global list for easy iteration
local cheatsheet_mappings = {
    insert_mode = insert_mode_mappings,
    general = general_mappings,
    toggle = toggle_mappings,
    buffer = buffer_mappings,
    telescope = telescope_mappings,
    nvim_tree = nvim_tree_mappings,
    lsp = lsp_mappings,
}

-- Loop through all mappings and set themfor _, category in pairs(mappings) do
for _, category in pairs(cheatsheet_mappings) do
    for _, map_data in ipairs(category) do
        if type(map_data.mode) == "string" then
            map(map_data.mode, map_data.key, map_data.cmd, map_data.opts)
        elseif type(map_data.mode) == "table" then
            for _, mode in ipairs(map_data.mode) do
                map(mode, map_data.key, map_data.cmd, map_data.opts)
            end
        end
    end
end

-- Out of Cheatsheet mappings
map("t", "<tab>", "<tab>")
map("i", "<tab>", "<tab>")

-- Return the mappings table if needed elsewhere, such as for a cheatsheet
return cheatsheet_mappings
