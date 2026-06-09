-- Custom functions for LaTeX files
local M = {}

local block_commands = {
    begin = true,
    ["end"] = true,
    item = true,
    label = true,
    caption = true,
    part = true,
    chapter = true,
    section = true,
    subsection = true,
    subsubsection = true,
    paragraph = true,
    subparagraph = true,
    documentclass = true,
    usepackage = true,
    bibliography = true,
    bibliographystyle = true,
    title = true,
    author = true,
    date = true,
    maketitle = true,
    input = true,
    include = true,
    clearpage = true,
    newpage = true,
    hline = true,
    centering = true,
    vfill = true,
    hfill = true,
    newcommand = true,
    renewcommand = true,
    providecommand = true,
    newenvironment = true,
    def = true,
}

-- Checks if a line is part of a mergeable plain text block
local function is_mergeable(line)
    if not line then
        return false
    end
    -- Check for blank line
    if line:match("^%s*$") then
        return false
    end

    -- Check for comment
    if line:match("^%s*%%") then
        return false
    end

    -- Check if it ends with \\ or \newline (excluding comments)
    local line_no_comment = line:gsub("%%.*$", "")
    if
        line_no_comment:match("\\\\%s*$")
        or line_no_comment:match("\\newline%s*$")
    then
        return false
    end

    local stripped = line:gsub("^%s+", "")
    -- Check for display math blocks
    if
        stripped:match("^\\%[")
        or stripped:match("^\\%]")
        or stripped:match("^%$%$")
    then
        return false
    end

    -- Check if it starts with a block-level LaTeX command
    if stripped:sub(1, 1) == "\\" then
        local cmd_name = stripped:sub(2):match("^([a-zA-Z]+)")
        if cmd_name and block_commands[cmd_name] then
            return false
        end
    end

    return true
end

-- Merge contiguous text lines in LaTeX file into a single line
function M.merge_latex_block()
    if vim.bo.filetype ~= "tex" then
        vim.notify(
            "This function is only for LaTeX files.",
            vim.log.levels.WARN
        )
        return
    end

    local cur_win = vim.api.nvim_get_current_win()
    local cur_buf = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(cur_win)
    local cur_line = cursor[1]
    local cur_col = cursor[2]

    local lines =
        vim.api.nvim_buf_get_lines(cur_buf, cur_line - 1, cur_line, false)
    local current_line_content = lines[1]

    if not is_mergeable(current_line_content) then
        vim.notify("Not in a mergeable LaTeX text block", vim.log.levels.INFO)
        return
    end

    -- Find start of the block
    local start_line = cur_line
    while start_line > 1 do
        local line_content = vim.api.nvim_buf_get_lines(
            cur_buf,
            start_line - 2,
            start_line - 1,
            false
        )[1]
        if is_mergeable(line_content) then
            start_line = start_line - 1
        else
            break
        end
    end

    -- Find end of the block
    local total_lines = vim.api.nvim_buf_line_count(cur_buf)
    local end_line = cur_line
    while end_line < total_lines do
        local line_content = vim.api.nvim_buf_get_lines(
            cur_buf,
            end_line,
            end_line + 1,
            false
        )[1]
        if is_mergeable(line_content) then
            end_line = end_line + 1
        else
            break
        end
    end

    if start_line == end_line then
        vim.notify(
            "Only one line in block, nothing to merge",
            vim.log.levels.INFO
        )
        return
    end

    local block_lines =
        vim.api.nvim_buf_get_lines(cur_buf, start_line - 1, end_line, false)

    -- Construct merged text
    local merged_text = ""
    for i, line in ipairs(block_lines) do
        if i == 1 then
            merged_text = line:gsub("%s+$", "")
        else
            local stripped = line:gsub("^%s+", ""):gsub("%s+$", "")
            if stripped ~= "" then
                merged_text = merged_text .. " " .. stripped
            end
        end
    end

    -- Calculate new cursor column position
    local new_col = 0
    if cur_line == start_line then
        new_col = cur_col
    else
        local prefix = ""
        for i = 1, (cur_line - start_line) do
            local line = block_lines[i]
            if i == 1 then
                prefix = line:gsub("%s+$", "")
            else
                local stripped = line:gsub("^%s+", ""):gsub("%s+$", "")
                if stripped ~= "" then
                    prefix = prefix .. " " .. stripped
                end
            end
        end
        local cur_line_content = block_lines[cur_line - start_line + 1]
        local cur_line_prefix = cur_line_content:sub(1, cur_col)
        cur_line_prefix = cur_line_prefix:gsub("^%s+", "")
        if cur_line_prefix ~= "" then
            prefix = prefix .. " " .. cur_line_prefix
        end
        new_col = #prefix
    end

    -- Replace lines in buffer
    vim.api.nvim_buf_set_lines(
        cur_buf,
        start_line - 1,
        end_line,
        false,
        { merged_text }
    )

    -- Set cursor position
    vim.api.nvim_win_set_cursor(
        cur_win,
        { start_line, math.min(new_col, #merged_text) }
    )
end
-- Create a global user command
vim.api.nvim_create_user_command(
    "LatexMergeBlock",
    M.merge_latex_block,
    { desc = "Merge LaTeX text block on the same line" }
)

return M
