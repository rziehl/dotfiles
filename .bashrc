export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="/Users/rziehl/adt-bundle-mac-x86_64/sdk/platform-tools:$PATH"
export PATH="/Users/rziehl/dev/sdk/android-ndk-r8d:$PATH"
eval "$(rbenv init -)"
export FY_PATH_TOOLS=~/git/tools
export FY_JAVA_CMD=drip
export UNITY_BUILD="/Users/rziehl/git/Unity/ios_example/ios_simulator_5_build"
export LIBRARIES_DIR="/Users/rziehl/git/Libraries"

alias vim='mvim -v'
alias ls='ls -alGh'
alias eb='vim ~/.bashrc'
alias sb='source ~/.bashrc'
alias tree='tree -C'
alias rake='bundle exec rake'
alias less='less -r'
alias activate='source env/bin/activate'
alias lft='for FILE in $(lf); do echo $(file $FILE); done'
alias git-root='cd $(git rev-parse --show-cdup)'
alias ctags='/usr/local/Cellar/ctags/5.8/bin/ctags'

# commits per day
alias cpd='git log --pretty=format:"%ad" --date=short | uniq -c'

# GCC (updated version and cross compilation)
#   brew tap homebrew/versions
#   brew install gcc48
# also download:
#   http://crossgcc.rts-software.org/download/gcc-4.8.0-qt-4.8.4-win32/gcc-4.8.0-qt-4.8.4-for-mingw32.dmg
#   http://crossgcc.rts-software.org/download/gcc-4.8.0-for-linux32-linux64/gcc-4.8.0-for-linux32.dmg
#alias gcc='gcc-4.8'
#alias win32-gcc='/usr/local/gcc-4.8.0-qt-4.8.4-for-mingw32/win32-gcc/bin/i586-mingw32-gcc-4.8.0'
#alias linux-gcc='/usr/local/gcc-4.8.0-for-linux32/bin/i586-pc-linux-gcc-4.8.0'

# String utils
alias lstrip="sed 's/^ *//'"
alias squeeze="sed 's/  */ /g'"

# List all files and folders excluding . and .. in the current directory
function lf(){
  ls |
  ruby -e "puts STDIN.read.squeeze(' ')" |
  cut -d ' ' -f9 |
  ruby -e "STDIN.readlines.each {|line| line.strip!; puts line unless line.empty? || line.eql?('.') || line.eql?('..')}"
}

# Sync all my dotfiles in my dotfiles folder
function dotsync(){
  cp ~/.vimrc ~/dotfiles/.vimrc
  cp ~/.screenrc ~/dotfiles/.screenrc
  cp ~/.gitignore_global ~/dotfiles/.gitignore_global
  cp ~/.gitconfig ~/dotfiles/.gitconfig
  cp ~/.bashrc ~/dotfiles/.bashrc
  cp ~/.bash_profile ~/dotfiles/.bash_profile
  cp ~/.ctags ~/dotfiles/.ctags
  rsync -ur --delete ~/.vim ~/dotfiles
}

# Update local files with dotfiles repo contents
function dotsync_out(){
  cp ~/dotfiles/.vimrc ~/.vimrc
  cp ~/dotfiles/.screenrc ~/.screenrc
  cp ~/dotfiles/.gitignore_global ~/.gitignore_global
  cp ~/dotfiles/.bashrc ~/.bashrc
  cp ~/dotfiles/.gitconfig ~/.gitconfig
  cp ~/dotfiles/.bash_profile ~/.bash_profile
  cp ~/dotfiles/.ctags ~/.ctags
  rsync -ur --delete ~/dotfiles/.vim ~/.
}

# Prints each subdirectory and what git branch it is currently on
function git-dirs(){
  for file in $(lf); do
    cd $file 2> /dev/null

    if [ $? -eq 0 ]; then
      git br -v &> /dev/null

      if [ $? -eq 0 ]; then
        echo -n $file
        echo -n ' '
        git br -v 2> /dev/null |
        grep '\*' |
        cut -d ' ' -f2
      fi

      cd ..
    fi
  done
}

# Prompt
blue=$(tput setaf 4)
orange=$(tput setaf 3)
bold_red=$(tput bold)$(tput setaf 1)
green=$(tput setaf 2)
normal=$(tput sgr0)

function bash_prompt(){
  virtualenv=''

  python -c 'import sys; print sys.real_prefix' &>/dev/null

  if [ $? -eq 0 ]; then
    virtualenv=$(echo "\[$bold_red\][V_ENV_ON]\[$normal\]:")
  fi

  directories=$(pwd | cut -d / -f 4-99)
  git rev-parse &> /dev/null

  if [ $? -eq 0 ]; then
    git_user=$(git config user.email)
    git_branch=$(git branch 2> /dev/null | grep '\*' | awk '{print $2}')
    export PS1="$virtualenv\[$blue\]$directories\[$normal\]($git_user:\[$orange\]$git_branch\[$normal\])\[$green\]~>\[$normal\]"
  else
    export PS1="$virtualenv\[$orange\]$directories\[$green\]~>\[$normal\]"
  fi
}

# History - increase filesize and always append
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend

alias sync_history="history -a; history -c; history -r"

# gnuplot
export GDFONTPATH="/Users/rob/Library/Fonts"

# Terminal Statistics
function termstats(){
  history |
  awk '{print $2}' |
  sort |
  uniq -c |
  sort -r
}

# More detailed history
function chronicle_update(){
  last_command=$(history 1 | awk '{$1=""; print $0}')
  current_dir=$(pwd)
  current_time=$(date)
  chronicle_entry="$current_time $current_dir $last_command"
  echo $chronicle_entry >> ~/.chronicle
}

function chronicle(){
  touch ~/.chronicle

  # sourcing bashrc causes duplicate entries
  # because everything is timestamped we can just remove duplicates
  uniq ~/.chronicle > ~/.chronicle.temp
  cat ~/.chronicle.temp > ~/.chronicle
  cat ~/.chronicle
}

# More statistics with chronicle
#
# number of commands entered per day:
#   chronicle | cut -d ' ' -f2-3 | uniq -c
# number of unique commands entered per day:
#   chronicle | cut -d ' ' -f2,3,8 | uniq -c | wc -l | xargs echo
# most commonly used directories:
#   chronicle | cut -d ' ' -f7 | sort | uniq -c | sort -r

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# This is a pretty hacky function but an interesting one
# that probably doesn't make sense at first to a random dotfiles spelunker
# This function checks to see if the current directory has a
# env/ directory used by virtualenv for Python development
# If the current directory is within a git repository then this function
# is smart enough to check the root of the git repository for the env/
# directory
# It will then automatically activate that virtual environment and
# add a message saying that virtualenv is on in my bash prompt
# It will also cache the current project directory so that each time I
# type a command at my terminal, it simply checks to see if we are in
# the project hierarchy so that it does not perform unnecessary activation
# again which might potentially be slow (I don't know maybe it's not)
# If I leave the project directory tree, then the cached file will be
# deleted and my virtualenv will be deactivated
# It still has a few bugs that I am fully aware of but it certainly does
# streamline my personal Python workflow
# It always assumes your virtualenv is called env/
# I think if you cd into a subdirectory of a Python project it might
# have issues too if the project isn't under git revision control and
# you cd-ed from outside the project directory into it (although I haven't
# tested this yet)

function activate_virtualenv(){
  env_dir='env/bin/activate'
  git_root='./'
  venv_dir_cache_file="$HOME/.last_venv_project_dir"

  # see if we have a cached venv project directory
  test -e $venv_dir_cache_file

  if [ $? -eq 0 ]; then
    pwd | grep $(cat $venv_dir_cache_file) > /dev/null

    if [ $? -eq 0 ]; then
      # we are in a subdirectory of the current python project with venv
      return 0
    fi
  fi

  # test to see if we are in a git repo
  git rev-parse &> /dev/null

  if [ $? -eq 0 ]; then
    git_root=$(git rev-parse --show-cdup)
  fi

  rel_env_dir=$git_root$env_dir

  test -e $rel_env_dir

  if [ $? -eq 0 ]; then
    source $rel_env_dir

    # hack to get the absolute path of a relative path
    pushd $git_root &> /dev/null
    absolute_git_root=$(pwd)
    popd &> /dev/null

    echo $absolute_git_root > $venv_dir_cache_file
  else
    # automatically deactivate it if not in a virtualenv
    deactivate &> /dev/null
    rm $venv_dir_cache_file &> /dev/null
  fi
}

# recursive sed for mass code refactoring
# usage: rsed '*.c' 's/old/new/g'
function rsed(){
  for file in $(find . -type file -name $1); do
    LANG=C sed -i "" $2 $file
  done
}

export -f rsed

# recursive grep
# usage: rgrep '*.c' 'goto'
function rgrep(){
  find . -type file -name $1 | xargs grep $2
}

export PROMPT_COMMAND="activate_virtualenv; chronicle_update; sync_history; bash_prompt; $PROMPT_COMMAND"

# Fuel specific stuff
export FY_PATH_ANDROID_NDK=/Users/rziehl/dev/sdk/android-ndk-r8d/ndk-build
export FY_PATH_ANDROID_SDK=/Users/rziehl/adt-bundle-mac-x86_64/sdk
export PATH="/usr/local/share/python:$PATH"
