# Per-machine configuration goes here
# Add a new host by dropping a conf.d/hosts/<name>.local.fish file to match the hostname of the machine

set -l local_config (dirname (status --current-filename))/hosts/(hostname).fish
if test -f $local_config
    source $local_config
end
