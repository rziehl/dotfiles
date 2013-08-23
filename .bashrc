export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

alias vim='mvim -v'
alias ls='ls -alG'
alias eb='vim ~/.bashrc'
alias sb='source ~/.bashrc'
alias tree='tree -C'
alias rake='bundle exec rake'
alias less='less -r'

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

function en(){
  vim ~/BTSync/dev_notes
}

# Sync all my dotfiles in my dotfiles folder
function dotsync(){
  cp ~/.vimrc ~/dotfiles/.vimrc
  cp ~/.screenrc ~/dotfiles/.screenrc
  cp ~/.gitignore_global ~/dotfiles/.gitignore_global
  cp ~/.gitconfig ~/dotfiles/.gitconfig
  cp ~/.bashrc ~/dotfiles/.bashrc
  cp ~/.bash_profile ~/dotfiles/.bash_profile
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
function bash_prompt(){
  directories=$(pwd | cut -d / -f 4-99)
  git rev-parse &> /dev/null

  if [ $? -eq 0 ]; then
    git_user=$(git config user.email)
    git_branch=$(git branch 2> /dev/null | grep '\*' | awk '{print $2}')
    export PS1="\[\e[0;34m$directories\e[m($git_user:\e[0;33m$git_branch\e[m)\e[0;32m~>\e[m"
  else
    export PS1="\[\e[0;33m$directories\e[m\e[0;32m~>\e[m"
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

export PROMPT_COMMAND="chronicle_update; sync_history; bash_prompt; $PROMPT_COMMAND"
