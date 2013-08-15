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
  cp -r ~/.config/fish/functions ~/dotfiles/.config/fish/functions
  cp -r ~/.vim ~/dotfiles
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
  #for file in (lf); cd $file ^ /dev/null; and echo -n $file; and echo -n ' '; and git br -v | grep '\*' | cut -d ' ' -f2; and cd ..; end | column -t
}

#if git rev-parse > /dev/null ^ /dev/null
#  set_color $fish_color_cwd
#  echo -n "("
#  echo -n (git config user.email)
#  echo -n ":"
#  echo -n (git branch 2> /dev/null | grep '\*' | awk '{print $2}')
#  echo -n ")"
#end
#
#set_color $fish_color_quote
#echo -n "~>"
#set_color normal

#function bash_prompt(){
#  directories=$(pwd | cut -d / -f 4-99)
#  git rev-parse > /dev/null 2> /dev/null
#  echo $?
#
#  if [$? -eq 0]; then
#    git_user=$(git config user.email)
#    git_branch=$(git branch 2> /dev/null | grep '\*' | awk '{print $2}')
#    export PS1="$directories($git_user:$git_branch)~>"
#  else
#    export PS1="$directories~>"
#  fi
#}
#
#bash_prompt
