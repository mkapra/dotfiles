""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvim Configuration File
" edited: 19. Dec 2020
""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ======================================================== vim-plug
call plug#begin()
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim' " Fzf

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' " Airline Themes

Plug 'tpope/vim-sleuth' " Automatic intendations
Plug 'tpope/vim-vinegar'

Plug 'preservim/nerdcommenter' " Commenting made easier
Plug 'jiangmiao/auto-pairs' " Pair completion
Plug 'airblade/vim-gitgutter' " Show git changes
Plug 'altercation/vim-colors-solarized' " Color scheme
Plug 'voldikss/vim-floaterm' " Floating Terminal in nvim
Plug 'tmhedberg/SimpylFold' " Code folding

Plug 'Shougo/neosnippet.vim'
Plug 'mkapra/neosnippet-snippets', { 'branch': 'mkapra_specific' } " Snippets

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim' " Fancy autocomplete

Plug 'pechorin/any-jump.vim'
" Plug 'habamax/vim-asciidoctor'
call plug#end()

" ======================================================== netrw
" let g:netrw_liststyle = 3
" let g:netrw_banner = 0
" let g:netrw_browse_split = 4
" let g:netrw_winsize = 15
" let g:netrw_altv = 1
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

map <C-n> :Explore<CR>

" ======================================================== airline
let g:airline_powerline_fonts = 1
let g:airline_theme='ayu_mirage'

" ======================================================== vim-snippets
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" ======================================================== general
syntax on
filetype plugin indent on

set background=dark
colorscheme solarized

set showmatch
set number
set relativenumber
set ruler

set noswapfile
set scrolloff=7
set laststatus=2
set noshowcmd

set colorcolumn=80
set textwidth=85

set breakat=\ 	
set linebreak
set showbreak=>>
set showcmd
set wrapmargin=2
set completeopt=menuone,noinsert,noselect
set modified
set nomodeline
set notitle
set titlestring="%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)"
:highlight SignColumn ctermbg=black " Other bg color for gitgutter symbols

" ======================================================== indent/whitespaces
set smartindent
set backspace=indent,eol,start

set list
set listchars=tab:\>.\,trail:\#

" ======================================================== fzf
set rtp+=/usr/local/opt/fzf
nmap <C-f> :Files<cr>

" ======================================================== floatterm
let g:floaterm_title='terminal($1|$2)'
let g:floaterm_gitcommit='vsplit'
" Ctrl+j = FloatingTerminal
nmap <C-j> :FloatermToggle<cr>

" ======================================================== Search
set incsearch
set ignorecase " generally not case sensitive
set smartcase " case sensitive when used capital letters
set hlsearch " Highlight all results
nmap <C-h> :nohl<cr> " Ctrl+h = :nohl

""" Completion stuff in command line
set wildmenu
set wildmode=longest,list

" ======================================================== LSP
" ++++++++++ completion-nvim Settings
if has ("nvim")
    " Use completion-nvim in every buffer
    autocmd BufEnter * lua require'completion'.on_attach()

    " Use <Tab> and <S-Tab> to navigate through popup menu
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    " Set completeopt to have a better completion experience
    set completeopt=menuone,noinsert,noselect

    " Avoid showing message extra message when using completion
    set shortmess+=c

    let g:completion_trigger_keyword_length = 1
    let g:completion_matching_ignore_case = 1
    let g:completion_trigger_on_delete = 1

    let g:completion_enable_snippet = 'Neosnippet'

    let g:completion_chain_complete_list = {
    \ 'default' : {
    \   'default': [
    \       {'complete_items': ['lsp', 'snippet', 'path']},
    \       {'mode': '<c-p>'},
    \       {'mode': '<c-n>'}],
    \   }
    \}

    set pumheight=10
endif

" ++++++++++ lsp Settings
if has ("nvim")
    " Show definition
    nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
    " Go to references
    nnoremap <silent> gr  <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> K   <cmd>lua vim.lsp.buf.hover()<CR>
endif

" require'nvim_lsp'.ccls.setup{}
lua <<EOF
  require'nvim_lsp'.sourcekit.setup{}

  require'nvim_lsp'.rust_analyzer.setup{}

  require'nvim_lsp'.pyls.setup{}
  require'nvim_lsp'.texlab.setup{}
  require'nvim_lsp'.intelephense.setup{}
  require'nvim_lsp'.yamlls.setup{}
  require'nvim_lsp'.solargraph.setup{}
EOF
