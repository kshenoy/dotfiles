function mcd --wraps=mkdir
  mkdir -p $argv
  cd $argv
end

