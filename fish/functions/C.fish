# [[file:~/.config/dotfiles/fish/fish.org::*aliases][aliases:10]]
function C --wraps=cat
  if type -q bat
    bat $argv
  else
    cat $argv
  end
end
# aliases:10 ends here
