local cmp = require 'cmp'

cmp.setup {
    completion = {
        keyword_length = 3
    },
    sources = cmp.config.sources({{
        name = 'nvim_lsp'
    }, {
        name = 'nvim_lua'
    }}, {{
        name = 'buffer'
    }, {
        name = 'omni'
    }, {
        name = 'path'
    }, {
        name = 'latex_symbols'
    }}),
    mapping = cmp.mapping.preset.insert {
        ['<cr>'] = cmp.mapping.confirm {
            select = false
        },
        ['<tab>'] = function(fallback)
            return cmp.visible() and cmp.select_next_item() or fallback()
        end,
        ['<s-tab>'] = function(fallback)
            return cmp.visible() and cmp.select_prev_item() or fallback()
        end
    }
}

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{
        name = 'buffer'
    }}
})
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{
        name = 'path'
    }}, {{
        name = 'cmdline'
    } -- keyword_pattern = [[^\@<!Man\s]] },
    })
})
