# Per-machine configuration goes here
# Add a new host by dropping a conf.d/hosts/<name>.local.fish file and a case below

set -l host_dir (dirname (status --current-filename))/hosts

switch (hostname)
    case Kartiks-MacBook-Pro.local
        source $host_dir/Kartiks-MacBook-Pro.local.fish

    case services
        source $host_dir/services.local.fish
end
