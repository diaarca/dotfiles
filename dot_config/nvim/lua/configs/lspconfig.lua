vim.lsp.config("clangd", {
    settings = {
        clangd = {
            -- Disable automatic include insertion
            InsertTextMode = 0, -- 0: disabled, 1: only for literals, 2: always
            -- Do not use fallback flags (let clangd use only compilation database)
            FallbackFlags = {},
            -- Optional: Ensure compilation database is used if available
            CompilationDatabase = {},
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
