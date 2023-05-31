" Some other vim configs (e.g., Koehler theme) do stuff like `hi clear`.
" We prevent that from clobbering highlights in the below config by naming this
" file so that it runs late.

let g:ale_linters = {
  \ 'go': ['gopls'],
  \}

let g:ale_go_gopls_init_options = {'ui.diagnostic.analyses': {
  \ 'composites': v:false,
  \}}

hi ALEWarning gui=undercurl guisp=Yellow cterm=underline
