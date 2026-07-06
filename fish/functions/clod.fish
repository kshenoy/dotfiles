function clod --wraps claude --description 'Accelerate claude startup'
    claude --remote-control "$argv[1]" --name "$argv[1]"
end
