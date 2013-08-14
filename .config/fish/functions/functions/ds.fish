function ds
  set_color $fish_color_quote
  echo "directory stack:"
  echo "----------------"
  set_color normal
  dirs -v | ruby -e 'STDIN.read.split(" ").each_with_index {|dir, index| puts "#{index+1}: #{dir}" }'
  set_color $fish_color_quote
  echo "----------------"
  set_color normal
end
