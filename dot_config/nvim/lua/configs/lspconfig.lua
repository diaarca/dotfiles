vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
        "--query-driver=/nix/store/*/bin/*,usr/bin/*,/opt/homebrew/bin/*",
    },
    root_markers = {
        ".clangd",
        ".clang-format",
        ".git",
        "compile_commands.json",
    },
    settings = {
        clangd = {
            InsertTextMode = 0,
            FallbackFlags = {},
        },
    },
})

vim.lsp.enable("clangd")

vim.lsp.config("pylsp", {
    settings = {
        configurationSources = { "flake8" },
        formatCommand = { "black" },
        pylsp = {
            plugins = {
                jedi_completion = {
                    include_params = true,
                },
                jedi_signature_help = { enabled = true },
                jedi = {
                    extra_paths = {
                        "~/projects/work_odoo/odoo14",
                        "~/projects/work_odoo/odoo14",
                    },
                },
                pyflakes = { enabled = true },
                pylsp_mypy = { enabled = false },
                pycodestyle = {
                    enabled = true,
                    ignore = { "E231" },
                    maxLineLength = 120,
                },
                yapf = { enabled = true },
            },
        },
    },
})
vim.lsp.enable("pylsp")

vim.lsp.config("stylua", {})
vim.lsp.enable("stylua")

vim.lsp.config("texlab", {})
vim.lsp.enable("texlab")

vim.lsp.config("jdtls", {})
vim.lsp.enable("jdtls")
