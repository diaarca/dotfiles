local autocmd = vim.api.nvim_create_autocmd

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
    callback = function(args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        local buftype =
            vim.api.nvim_get_option_value("buftype", { buf = args.buf })

        if not vim.g.ui_entered and args.event == "UIEnter" then
            vim.g.ui_entered = true
        end

        if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
            vim.api.nvim_exec_autocmds(
                "User",
                { pattern = "FilePost", modeline = false }
            )
            vim.api.nvim_del_augroup_by_name("NvFilePost")

            vim.schedule(function()
                vim.api.nvim_exec_autocmds("FileType", {})

                if vim.g.editorconfig then
                    require("editorconfig").config(args.buf)
                end
            end)
        end
    end,
})

-- Fix for annoying underscore highlighting in markdown
autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        -- Clear highlight for italic delimiters (underscores)
        vim.api.nvim_set_hl(0, "@markup.italic.delimiter", { link = "Normal" })
        vim.api.nvim_set_hl(0, "markdownItalicDelimiter", { link = "Normal" })
        -- Clear highlight for errors (often red background for underscores)
        vim.api.nvim_set_hl(0, "markdownError", { link = "Normal" })
    end,
})
