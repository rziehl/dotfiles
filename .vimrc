set t_ut=
set t_Co=256
set expandtab
set shiftwidth=2
set softtabstop=2
set number
set smartindent
set autoindent
set foldmethod=syntax
set foldlevel=20
set wildmode=longest,list,full
set wildmenu
set ignorecase
set smartcase
"set scrolloff=14
set shortmess=atI
set hidden
set clipboard=unnamed

filetype plugin on
filetype on

nmap <CR> _i<Enter><Esc>
set numberwidth=5
syntax on
set listchars=tab:>-,trail:.,extends:.,precedes:<
set list
set colorcolumn=80
set encoding=utf8

" CTAGS & TAGLIST
set tags=./tags;/
let Tlist_Inc_Winwidth=0
nmap <Leader>T :TlistToggle<CR>
let Tlist_Ctags_Cmd = "/usr/local/Cellar/ctags/5.8/bin/ctags"
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1

"Command-t ignores
:set wildignore+=*.eot,*.svg,*.png,*.o,*.pyc,*.ttf,*.woff,*.lock,*.db,*.swp,env/*
set wildignore+=/Users/rob/c_game/dependencies/*
set wildignore+=/Users/rob/c_game/dependencies_source/*
set wildignore+=/Users/rob/c_game/bin/*

"my custom vim commands
command DeleteTrailingWhitespace %s/\s\+$//

" Disable arrow keys.
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
