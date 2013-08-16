export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

alias vim='mvim -v'
alias ls='ls -alG'
alias eb='vim ~/.bashrc'
alias sb='source ~/.bashrc'
alias tree='tree -C'
alias rake='bundle exec rake'
alias less='less -r'
alias squeeze="sed 's/  */ /g'"

function lf(){
  ls |
  ruby -e "puts STDIN.read.squeeze(' ')" |
  cut -d ' ' -f9 |
  ruby -e "STDIN.readlines.each {|line| line.strip!; puts line unless line.empty? || line.eql?('.') || line.eql?('..')}"
}

function en(){
  vim ~/BTSync/dev_notes
}

function dotsync(){
  cp ~/.vimrc ~/dotfiles/.vimrc
  cp ~/.tmux.conf ~/dotfiles/.tmux.conf
  cp ~/.screenrc ~/dotfiles/.screenrc
  cp ~/.gitignore_global ~/dotfiles/.gitignore_global
  cp ~/.gitconfig ~/dotfiles/.gitconfig
  cp ~/.config/fish/config.fish ~/dotfiles/.config/fish/config.fish
  cp ~/.bashrc ~/dotfiles/.bashrc
  rsync -ur --delete ~/.config/fish/functions ~/dotfiles/.config/fish
  rsync -ur --delete ~/.vim ~/dotfiles
}

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

function bash_prompt(){
  directories=$(pwd | cut -d / -f 4-99)
  git rev-parse &> /dev/null

  if [ $? -eq 0 ]; then
    git_user=$(git config user.email)
    git_branch=$(git branch 2> /dev/null | grep '\*' | awk '{print $2}')
    export PS1="\e[0;34m$directories\e[m($git_user:\e[0;33m$git_branch\e[m)\e[0;32m~>\e[m"
  else
    export PS1="\e[0;33m$directories\e[m\e[0;32m~>\e[m"
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

export PROMPT_COMMAND="sync_history; bash_prompt; $PROMPT_COMMAND"
