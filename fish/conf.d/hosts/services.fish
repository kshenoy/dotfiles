# All services VM specific configuration goes here

function gitn --wraps git --description 'git for the Coppermind notes repo'
    git -C ~/Coppermind $argv
end
