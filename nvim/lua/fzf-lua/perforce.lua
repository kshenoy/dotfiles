-- perforce support
-- :PROPERTIES:
-- :header-args+: :tangle (concat (or (getenv "XDG_CONFIG_HOME") (concat (getenv "HOME") "/.config")) "/nvim/lua/fzf-lua/perforce.lua")
-- :END:


-- [[file:../../../dotfiles/nvim.org::*perforce support][perforce support:1]]
local core  = require "fzf-lua.core"
local utils = require "fzf-lua.utils"
local config = require "fzf-lua.config"

local M = {}
-- perforce support:1 ends here



-- Check if currently in a Perforce repo

-- [[file:../../../dotfiles/nvim.org::*perforce support][perforce support:2]]
M.is_p4_repo = function(opts, noerr)
    local _, err = utils.io_systemlist("p4 info")
    return not (err ~= 0)
end
-- perforce support:2 ends here



-- Get the root of the repo

-- [[file:../../../dotfiles/nvim.org::*perforce support][perforce support:3]]
M.get_root = function(opts, noerr)
    local output, err = utils.io_systemlist("p4 info")
    if err ~= 0 then
        if not noerr then utils.info(unpack(output)) end
        return nil
    end
    return utils.strsplit(output[4], ' ')[3]
end
-- perforce support:3 ends here



-- Get the files in the repo

-- [[file:../../../dotfiles/nvim.org::*perforce support][perforce support:4]]
M.files = function(opts)
    if not opts then opts = {} end
    opts.cwd = opts.cwd or M.get_root(opts)
    if not opts.cwd then return end
    opts.cmd = opts.cmd or "p4 have " .. opts.cwd .. "/..."
    opts.prompt = opts.prompt or "P4Files> "
    opts.fn_transform = function(x)
        return utils.strsplit(x, ' ')[3]
    end

    -- Set other options from git and override as required
    opts = config.normalize_opts(opts, config.globals.git.files)
    opts.git_icons = false
    local contents = core.mt_cmd_wrapper(opts)
    opts = core.set_header(opts, opts.headers or {"cwd"})
    return core.fzf_exec(contents, opts)
end
-- perforce support:4 ends here



-- Get the status

-- [[file:../../../dotfiles/nvim.org::*perforce support][perforce support:5]]
M.status = function(opts)
    if not opts then opts = {} end
    opts.cmd = opts.cmd or "p4 opened -s | cut -d ' ' -f1 | xargs p4 where | cut -d ' ' -f3"
    opts.cwd = opts.cwd or M.get_root(opts)
    opts.prompt = opts.prompt or "P4Status> "
    opts.fn_transform = function(x)
        return utils.strsplit(x, ' ')[1]
    end

    -- Set other options from git and override as required
    opts = config.normalize_opts(opts, config.globals.git.files)
    opts.git_icons = false
    local contents = core.mt_cmd_wrapper(opts)
    opts = core.set_header(opts, opts.headers or {"cwd"})
    return core.fzf_exec(contents, opts)
end
-- perforce support:5 ends here



-- Diff the file


-- [[file:../../../dotfiles/nvim.org::*perforce support][perforce support:6]]
return M
-- perforce support:6 ends here
