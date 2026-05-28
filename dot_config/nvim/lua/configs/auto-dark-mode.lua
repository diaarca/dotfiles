require("auto-dark-mode").setup({
    update_interval = 1000,

    set_dark_mode = function()
        vim.o.background = "dark"
        require("nvconfig").base46.theme = "github_dark"
        require("base46").load_all_highlights()
    end,

    set_light_mode = function()
        vim.o.background = "light"
        require("nvconfig").base46.theme = "github_light"
        require("base46").load_all_highlights()
    end,
})
