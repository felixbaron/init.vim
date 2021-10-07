" Inspired by https://gist.github.com/subfuzion/7d00a6c919eeffaf6d3dbf9a4eb11d64#:~:text=The%20leader%20key%20provides%20a,like%20to%20redefine%20it%20to%20%2C%20.
" Dependency - https://github.com/sharkdp/fd#installation
" Dependency - https://github.com/BurntSushi/ripgrep
" Dependency - https://github.com/pycqa/isort/
" Dependency - https://github.com/psf/black

call plug#begin('~/AppData/Local/nvim/plugged')
" http://vimcolorschemes.com/
Plug 'joshdick/onedark.vim'

" Find more at https://github.com/rockerBOO/awesome-neovim
Plug 'neovim/nvim-lspconfig'
" Plug 'SirVer/ultisnips'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'davidhalter/jedi-vim'
Plug 'nvim-lua/completion-nvim'
Plug 'preservim/nerdtree'
Plug 'akinsho/toggleterm.nvim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/tagbar'
Plug 'tpope/vim-commentary'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" required by todo-comments
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" display todos
Plug 'folke/todo-comments.nvim'
Plug 'tpope/vim-fugitive'
call plug#end()

lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
EOF

" wrap text
set wrap

" neovim-qt settings https://github.com/equalsraf/neovim-qt
:set mouse=a
" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif
"
" Copy & paste with middle click
vmap <LefRelease> "*ygv

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv


" Auto start NERD tree when opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | endif

" Recommended completion settings from https://github.com/nvim-lua/completion-nvim#recommended-setting
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" replace tab with spaces
set expandtab
" Line numbering
set number

" Disable line wrapping
set nowrap

" enable line and column display
set ruler

"disable showmode since using vim-airline; otherwise use 'set showmode'
set noshowmode

" file type recognition
filetype on
filetype plugin on
filetype indent on

" syntax highlighting
syntax on

" scroll a bit horizontally when at the end of the line
set sidescroll=6

" Make it easier to work with buffers
" http://vim.wikia.com/wiki/Easier_buffer_switching
set hidden
set confirm
set autowriteall
set wildmenu wildmode=full

set guifont=Inconsolata:h17
" set guifont=Roboto\ Mono:h17
let mapleader=","


function! Light()
    echom "set bg=light"
    set bg=light
    colorscheme off
    set list
endfunction

function! Dark()
    echom "set bg=dark"
    set bg=dark
    colorscheme onedark
    "darcula fix to hide the indents:
    set nolist
endfunction

" change font size with mouse, https://stackoverflow.com/questions/35285300/how-to-change-neovim-font
let s:fontsize = 17
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Inconsolata:h" . s:fontsize
endfunction

" configure todo-comments
lua << EOF
  require("todo-comments").setup {
  }
EOF

" Enable treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"javascript", "python", "html", "json", "jsdoc", "lua", "regex", "vim", "vue", "yaml", "css"},
  highlight = {
    enable = true,
  },
}
EOF

" set colorcolumn
set colorcolumn=81

noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

silent call Dark()
" show init.vim
nnoremap <silent> <leader>in :e ~/AppData/Local/nvim/init.vim<CR>

" toggle terminal
nnoremap <silent> <leader>sh :term<CR>

" toggle buffer (switch between current and last buffer)
nnoremap <silent> <leader>bb <C-^>

" go to next buffer
nnoremap <silent> <leader><Right> :bn<CR>

" go to previous buffer
nnoremap <silent> <leader><Left> :bp<CR>

" close buffer
nnoremap <silent> <leader><Down> :bd<CR>

" list buffers
nnoremap <silent> <leader>bl :ls<CR>
" list and select buffer
nnoremap <silent> <leader><Up> :ls<CR>:buffer<Space>

" horizontal split with new buffer
nnoremap <silent> <leader>bh :new<CR>

" vertical split with new buffer
nnoremap <silent> <leader>bv :vnew<CR>

" nerdtree mappings https://github.com/preservim/nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" save/quit buffer
nnoremap <silent><leader>w :w<CR>
nnoremap <silent><leader>q :q<CR>

" run current file
nnoremap <C-E> :sp <CR> :term python % <CR>
noremap <C-Q> :bd!<CR>

" Open Terminal
noremap <C-S> :ToggleTerm<CR>

" Tagbar
noremap <F8> :TagbarToggle<CR>

" quick directory change
nnoremap <leader>cd :cd %:p:h<CR>

" tab navigation
noremap <leader>tz :tabnext<CR>
noremap <leader>tr :tabprevious<CR>
noremap <leader>tn :tabnew<CR>

" Black code formatting
noremap <leader>b :!python -m black %<CR> 
noremap <leader>i :!python -m isort %<CR>

" open TODOs
noremap <leader>t :TodoLocList<CR>

" Telescope configuration
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
