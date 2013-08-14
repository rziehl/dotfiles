function git-dirs
  for file in (lf); cd $file ^ /dev/null; and echo -n $file; and echo -n ' '; and git br -v | grep '\*' | cut -d ' ' -f2; and cd ..; end | column -t
end
