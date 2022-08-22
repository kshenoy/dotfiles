------------------------------------------------------------------------------------------------------------------------
-- Perforce extension for fzf-lua
------------------------------------------------------------------------------------------------------------------------
local core  = require "fzf-lua.core"
local utils = require "fzf-lua.utils"
local config = require "fzf-lua.config"

local M = {}

-- Check if currently in a Perforce repo -------------------------------------------------------------------------------
M.is_p4_repo = function(opts, noerr)
    local _, err = utils.io_systemlist("p4 info")
    return not (err ~= 0)
end


-- Get the root of the repo --------------------------------------------------------------------------------------------
M.get_root = function(opts, noerr)
    local output, err = utils.io_systemlist("p4 info")
    if err ~= 0 then
        if not noerr then utils.info(unpack(output)) end
        return nil
    end
    return utils.strsplit(output[4], ' ')[3]
end


-- Get the files in the repo -------------------------------------------------------------------------------------------
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


-- Get the status ------------------------------------------------------------------------------------------------------
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


-- TODO: Diff the file -------------------------------------------------------------------------------------------------


return M
