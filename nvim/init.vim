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

Plug 'https://github.com/joshdick/onedark.vim.git'

if has ("nvim")
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim' " Fancy autocomplete
endif

Plug 'brooth/far.vim'
Plug 'pechorin/any-jump.vim'
call plug#end()

" ======================================================== netrw
map <C-n> :Explore<CR>
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

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

colorscheme onedark

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

lua << EOF
local on_attach = function(client, bufnr)
  local nvim_lsp = require('lspconfig')
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "texlab", "pyls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF
endif

