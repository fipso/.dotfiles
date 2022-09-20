nnoremap <C-n> :NvimTreeToggle<CR>

lua require'nvim-tree'.setup {
            \ actions = {
                \ open_file = {
                    \ resize_window = true
                \ }
            \ },
	    \ view = {
	        \ preserve_window_proportions = true,
          \ side = "right"
            \ }
        \ }
