-- Custom command to fetch BibTeX from a DOI
vim.api.nvim_create_user_command("BibFetch", function(opts)
    local doi = '"' .. opts.args .. '"'
    if doi == "" then
        vim.notify("Please provide a DOI.", vim.log.levels.WARN)
        return
    end

    vim.notify(
        "Fetching BibTeX for DOI: " .. doi .. " ...",
        vim.log.levels.INFO
    )

    -- Use curl to hit doi.org and request the 'application/x-bibtex' format
    local cmd = string.format(
        'curl -sLH "Accept: application/x-bibtex" https://doi.org/%s',
        doi
    )
    local result = vim.fn.system(cmd)

    -- Check for errors or empty responses
    if
        vim.v.shell_error ~= 0
        or result == ""
        or result:match("Resource not found")
        or result:match("Not Found")
    then
        vim.notify(
            "Failed to fetch BibTeX. Check the DOI.",
            vim.log.levels.ERROR
        )
        return
    end

    -- Split the raw string into a table of lines for Neovim
    local lines = {}
    for line in result:gmatch("([^\n]*)\n?") do
        if line ~= "" then
            table.insert(lines, line)
        end
    end

    -- Add an empty line at the end for clean spacing between entries
    table.insert(lines, "")

    -- Insert the lines at the current cursor position
    vim.api.nvim_put(lines, "l", true, true)
    vim.notify("BibTeX entry inserted successfully!", vim.log.levels.INFO)
end, { nargs = 1, desc = "Fetch BibTeX entry from DOI and insert at cursor" })
