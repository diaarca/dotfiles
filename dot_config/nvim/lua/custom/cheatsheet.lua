-- DECLARE SOME FUNCTIONS FOR CODE LISIBILITY
-- Helper function to the header generation
local function gen_header(width)
    local to_center = string.rep(" ", math.floor((width - 63) / 2))

    return {
        "",
        "",
        to_center
            .. "  ____ _   _ _____    _  _____   ____  _   _ _____ _____ _____",
        to_center
            .. " / ___| | | | ____|  / \\|_   _| / ___|| | | | ____| ____|_   _|",
        to_center
            .. "| |   | |_| |  _|   / _ \\ | |   \\___ \\| |_| |  _| |  _|   | |",
        to_center
            .. "| |___|  _  | |___ / ___ \\| |    ___) |  _  | |___| |___  | |",
        to_center
            .. " \\____|_| |_|_____/_/   \\_\\_|   |____/|_| |_|_____|_____| |_|",
        "",
        "",
        string.rep("─", width),
        "",
    }
end

-- Helper function to truncate long descriptions
local function truncate_desc(desc, width)
    local key_space = 12
    local margin = 6
    local max_desc_length = width - key_space -- Allows space for key, padding, and box border
    return #desc > max_desc_length - margin
            and (desc:sub(1, max_desc_length - margin) .. "...")
        or desc
end

-- Helper function to the box_lines generation
local function gen_box_lines(width, category)
    local category_name = category.name
    local category_mappings = category.mappings
    local box_lines = {}

    -- Add a header for each category with a box border
    table.insert(
        box_lines,
        "╭─"
            .. category_name:upper()
            .. string.rep("─", width - #category_name - 4)
            .. "─╮"
    )

    for _, map_data in ipairs(category_mappings) do
        local line = string.format(
            "%-10s : %s",
            map_data.key,
            truncate_desc(map_data.opts.desc, width)
        )
        table.insert(
            box_lines,
            "│" .. line .. string.rep(" ", width - #line - 2) .. "│"
        )
    end

    -- Complete the box with a footer
    table.insert(box_lines, "╰" .. string.rep("─", width - 2) .. "╯")
    return box_lines
end

-- START OF THE CHEATSHEET DRAWING
local CHS = {}
local mappings = require("mappings") -- Import mappings table from mappings.lua

function CHS.open()
    -- Define the window configuration
    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)
    -- Create a new buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Set floating window options
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
    }

    -- Open the floating window
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Determine the number of columns dynamically based on the available width
    local box_width = 49
    local num_columns = math.floor((width - 6) / (box_width + 2))

    -- Start to declare the cheatsheet content
    local lines = gen_header(width)

    -- Convert the mappings table into a sortable list of categories
    local sorted_categories = {}
    for category_name, category_mappings in pairs(mappings) do
        table.insert(
            sorted_categories,
            { name = category_name, mappings = category_mappings }
        )
    end

    -- Sort categories by the number of mappings (highest to lowest)
    table.sort(sorted_categories, function(a, b)
        return #a.mappings > #b.mappings
    end)

    -- Collect formatted category boxes and compute their heights
    local category_boxes = {}
    local category_heights = {}

    for _, category in ipairs(sorted_categories) do
        -- Compute the category box
        local box_lines = gen_box_lines(box_width, category)

        -- Add the category box to the list and record its height
        table.insert(category_boxes, box_lines)
        table.insert(category_heights, #box_lines)
    end

    -- Determine the tallest box per row and pad shorter boxes
    local padded_boxes = {}
    for i = 1, #category_boxes, num_columns do
        local max_height = 0
        for j = i, math.min(i + num_columns - 1, #category_boxes) do
            max_height = math.max(max_height, category_heights[j])
        end

        for j = i, math.min(i + num_columns - 1, #category_boxes) do
            local box = category_boxes[j]
            while #box < max_height do
                -- Insert empty lines instead of borders to pad the box
                table.insert(box, "")
            end
            table.insert(padded_boxes, box)
        end
    end

    -- The space that we can exploit in order to center the boxes
    local remaining_space = (width - (num_columns * box_width)) - 1
    local between_boxes_space = 5
    remaining_space = remaining_space - between_boxes_space * (num_columns - 1)
    left_margin = math.floor(remaining_space / 2)

    -- Arrange boxes in columns
    for i = 1, #padded_boxes, num_columns do
        for line_idx = 1, #padded_boxes[i] do
            local row = string.rep(" ", left_margin)
            for col = 0, num_columns - 1 do
                local box = padded_boxes[i + col]
                if box and box[line_idx] then
                    row = row .. box[line_idx]
                    -- Add space only if it's not the last box in the row
                    if col < num_columns - 1 and i + col < #padded_boxes then
                        row = row .. string.rep(" ", between_boxes_space)
                    end
                end
            end
            table.insert(lines, row)
        end
        table.insert(lines, "")
    end

    -- Add content to the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Ensure the window closes on `q`
    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "q",
        ":q<CR>",
        { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "<leader>ch",
        ":q<CR>",
        { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "<ESC>",
        ":q<CR>",
        { noremap = true, silent = true }
    )
end

-- Expose as a global function and command
_G.DisplayCheatsheet = CHS.open
vim.api.nvim_create_user_command("DisplayCheatsheet", CHS.open, {})

return CHS
