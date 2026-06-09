require("options")
require("custom.bibtex_fetch")
require("custom.cheatsheet")
require("custom.latex_merge_block")

return {
    -- AESTHETIC FEATURES
    -- Rendering Markdown plugin
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        config = function()
            require("configs.render-markdown")
        end,
    },
    -- Image Rendering
    {
        "3rd/image.nvim",
        build = false,
        lazy = false,
        config = function()
            require("configs.image")
        end,
    },
    -- Code coloration plugin
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("configs.treesitter")
        end,
    },
    -- Embedded context display plugin
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufNewFile", "BufReadPost" },
        config = function()
            require("configs.treesitter-context")
        end,
    },
    -- LSP server installer plugin
    {
        "williamboman/mason.nvim",
        config = function()
            require("configs.mason")
        end,
    },
    -- Automatic switch between dark and light theme
    {
        "f-person/auto-dark-mode.nvim",
        lazy = false,
        config = function()
            require("configs.auto-dark-mode")
        end,
    },

    -- IMPROVEMENT CODE FEATURES
    -- LSP server plugin for jumps, rename and autocomplete
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        config = function()
            require("configs.lspconfig")
        end,
    },
    -- Code formatters plugin
    {
        "stevearc/conform.nvim",
        lazy = false,
        config = function()
            require("configs.conform")
        end,
    },
    {
        "elentok/open-link.nvim",
        lazy = false,
        config = function()
            require("configs.open-link")
        end,
    },
    -- Image Pasting
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        config = function()
            require("configs.img-clip")
        end,
    },
    {
        "VPavliashvili/json-nvim",
        ft = "json",
    },

    -- BIBLIOGRAPHY & LATEX FEATURES
    -- Telescope BibTeX: For fuzzy finding standard .bib files
    {
        "nvim-telescope/telescope-bibtex.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("configs.telescope-bibtex")
        end,
    },
    -- cmp-vimtex: Autocompletion source for citations
    {
        "micangl/cmp-vimtex",
    },
}
