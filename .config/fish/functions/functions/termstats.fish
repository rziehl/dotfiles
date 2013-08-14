function termstats
  cat ~/.config/fish/fish_history | grep '^- cmd:' | awk '{print $3}' | sort | uniq -c | sort -r
end
