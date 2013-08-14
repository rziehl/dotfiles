set -x PATH /Applications/Postgres.app/Contents/MacOS/bin $PATH
set -x PATH /usr/local/bin $PATH
set -x PATH /Users/rob/.rbenv/bin $PATH
set -x PATH /Users/rob/.rbenv/shims $PATH
set -x PATH /usr/local/share/python $PATH

set fishconf ~/.config/fish/config.fish
eval "rbenv init"
eval "rbenv rehash"
eval clear

set fish_greeting

set GREP_COLOR '0;34'
# general greps
function cgrep; grep -rn $argv --include '*.c' --color=always .; end
function cppgrep; grep -rn $argv --include '*.cpp' --color=always .; end
function hgrep; grep -rn $argv --include '*.h' --color=always .; end
function jgrep; grep -rn $argv --include '*.java' --color=always .; end

# web dev related greps
function rbgrep; grep -rn $argv --include '*.rb' --color=always .; end
function erbgrep; grep -rn $argv --include '*.html.erb' --color=always .; end
function jsgrep; grep -rn $argv --include '*.js' --color=always .; end
function cofgrep; grep -rn $argv --include '*.js.coffee' -- color=always .; end
function cssgrep; grep -rn $argv --include '*.css' --color=always .; end
function sassgrep; grep -rn $argv --include '*.css.sass' --color=always .; end
function scssgrep; grep -rn $argv --include '*.css.scss' --color=always .; end
