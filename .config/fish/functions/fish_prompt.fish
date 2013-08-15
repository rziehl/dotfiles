function fish_prompt
  set_color $fish_color_quote
  echo -n (pwd | cut -d / -f 4-99)

  if git rev-parse > /dev/null ^ /dev/null
    set_color $fish_color_cwd
    echo -n "("
    set_color $fish_color_normal
    echo -n (git config user.email)
    set_color $fish_color_cwd
    echo -n ":"
    echo -n (git branch 2> /dev/null | grep '\*' | awk '{print $2}')
    echo -n ")"
  end

  set_color $fish_color_quote
  echo -n "~>"
  set_color normal
end
