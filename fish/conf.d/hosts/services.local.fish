# All services VM specific configuration goes here
if test (hostname) != services
    return
end

function gitn --wraps git --description 'git for the Coppermind notes repo'
    git -C ~/Coppermind $argv
end
