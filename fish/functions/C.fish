function C --wraps=cat --description "Uses an appropriate file viewer: bat > cat"
  if type -q bat
    bat $argv
  else
    cat $argv
  end
end
