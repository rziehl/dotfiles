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
set scrolloff=3
set shortmess=atI
set hidden
set clipboard=unnamed

filetype plugin on

nmap <CR> _i<Enter><Esc>
set numberwidth=5
syntax on
set listchars=tab:>-,trail:.,extends:.,precedes:<",eol:$
"set cursorline
set listchars=tab:>-,trail:.,extends:.,precedes:<
set list
set colorcolumn=80

"Home colorscheme
"colorscheme seoul256
colorscheme grb256

"Work colorscheme
"colorscheme sorcerer

"Command-t ignores
:set wildignore+=*.eot,*.svg,*.png,*.o,*.pyc,*.ttf,*.woff,*.lock,*.db,*.swp,env/*

"my custom vim commands
command DeleteTrailingWhitespace %s/\s\+$//
