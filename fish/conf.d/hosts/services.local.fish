# All services VM specific configuration goes here
if test (hostname) != "services"
    return
end

function gitn --wraps git --description 'git for the Coppermind notes repo'
    git -C ~/Documents/Notes/Coppermind $argv
end

function clod --wraps claude --description 'Accelerate claude startup'
    claude --remote-control "$argv[1]" --name "$argv[1]"
end
