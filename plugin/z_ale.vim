vim9script

# Some other vim configs (e.g., Koehler theme) do stuff like `hi clear`.
# We prevent that from clobbering highlights in the below config by naming this
# file so that it runs late.

g:ale_linters = {
    go: ['gopls', 'golangci-lint'],
}

g:ale_fixers = {
    go: ['gofmt', 'goimports'],  # gopls is slow
}

g:ale_fix_on_save = v:true

# simplify code
g:ale_go_gofmt_options = '-s'

g:ale_go_gopls_init_options = {
    #'editor.formatOnSave': v:true,
    'ui.semanticTokens': true,
    analyses: {
        composites: false,
        nilness: true,
        unusedparams: true,
        unusedwrites: true,
        useany: true,
        unusedvariable: true,
    },
}

#g:ale_go_staticcheck_options = '-checks all,-ST1005'

var gitroot = system('git rev-parse --show-toplevel | tr -d "\n"')
var lint_options = ""
if gitroot != ""
    var path = gitroot .. "/golangci-lint.yml"
    if filereadable(path)
        #echo "Found linter config: " .. path
        lint_options = '--config=' .. path
    endif
endif

if lint_options == ""
    lint_options = '--enable=asasalint,durationcheck,errchkjson,errname,errorlint,exportloopref,gocheckcompilerdirectives,gocritic,gomnd,nlreturn,prealloc,predeclared,reassign,unconvert,unparam,usestdlibvars,wastedassign,whitespace,wrapcheck,wsl'
endif

g:ale_go_golangci_lint_options = lint_options

#g:ale_go_golangci_lint_options = '--presets=bugs,error,style,unused,complexity,import'
g:ale_go_golangci_lint_package = 1

hi ALEWarning gui=undercurl guisp=Yellow cterm=underline
