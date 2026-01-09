local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        cs = { "clang-format" },
        java = { "clang-format" },
        javascript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        tex = { "tex-fmt" },
        markdown = { "prettier" },
        nix = { "nixfmt" }
    },

    formatters = {
        black = {
            command = "black",
            args = { "--line-length", "79", "--fast", "-" },
            timeout_ms = 5000,
        },
        stylua = {
            command = "stylua",
            args = {
                "--indent-type",
                "Spaces",
                "--indent-width",
                "4",
                "--column-width",
                "80",
                "-",
            },
            timeout_ms = 5000,
        },
    },
})
