" Vundle

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdcommenter.git'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'ervandew/supertab'
"Plugin 'valloric/youcompleteme'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'alvan/vim-closetag'
Plugin 'jiangmiao/auto-pairs'
Plugin 'gko/vim-coloresque'
Plugin 'rstacruz/vim-hyperstyle'
Plugin 'pangloss/vim-javascript'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Colors

syntax on

set background=dark
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

highlight Pmenu ctermfg=15 ctermbg=0
highlight PmenuSel ctermfg=4 ctermbg=15 

" Line numbers

set relativenumber
set number

" Tabs

set tabstop=2
set softtabstop=0 noexpandtab
set shiftwidth=2

set list lcs=tab:\|\ 
hi SpecialKey ctermfg=238

set breakindent
set autoindent

" Ctrl S

" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command -nargs=0 -bar Update if &modified 
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>


" Send more characters for redraws
set ttyfast

" Enable mouse use in all modes
set mouse=a

" Set this to the name of your terminal that supports mouse codes.
" Must be one of: xterm, xterm2, netterm, dec, jsbterm, pterm
set ttymouse=xterm

" Autocomplete

"let g:ycm_path_to_python_interpreter = '/usr/bin/python2'

"let g:ycm_key_list_select_completion = ['\<C-TAB>', '\<Down>']
"let g:ycm_key_list_previous_completion = ['\<C-S-TAB>', '\<Up>']

"let g:SuperTabDefaultCompletionType = '\<C-Tab>'

"let g:UltiSnipsJumpForwardTrigger="<tab>"                                       
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"                                    

let g:ycm_key_list_select_completion   = ['<C-j>', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']

let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0

let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsExpandTrigger           = '<tab>'
let g:UltiSnipsJumpForwardTrigger      = '<CR>'
let g:UltiSnipsJumpBackwardTrigger     = '<s-CR>'

nnoremap <leader>ue :UltiSnipsEdit<cr>
