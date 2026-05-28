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
        bib = { "bibtex-tidy" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
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
        ["bibtex-tidy"] = {
            command = "bibtex-tidy",
            args = {
                "--tab",
                "--blank-lines",
                "--curly",
                "--wrap=75",
                "--no-align",
            },
            timeout_ms = 5000,
        },
        prettier = {
            command = "prettier",
            args = {
                "--print-width",
                "80",
                "--prose-wrap",
                "always",
                "--stdin-filepath",
                "$FILENAME",
            },
            stdin = true,
            timeout_ms = 5000,
        },
        ["tex-fmt"] = {
            command = "tex-fmt",
            args = {
                "--wraplen",
                "80",
                "--tabsize",
                "1",
                "--usetabs",
                "--stdin",
            },
        },
    },
})
