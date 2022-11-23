--  Lua interface to vim-plug by https://dev.to/vonheikemen/neovim-using-vim-plug-in-lua-3oom
--
local configs = {
  lazy = {},
  start = {}
}

local plug = {
  begin = vim.fn['plug#begin'],

  -- "end" is a keyword, need something else
  ends = function()
    vim.fn['plug#end']()

    for i, config in pairs(configs.start) do
      config()
    end
  end
}

-- Not a fan of global functions, but it makes it easier to copy/paste
_G.VimPlugApplyConfig = function(plugin_name)
  local fn = configs.lazy[plugin_name]
  if type(fn) == 'function' then fn() end
end

local plug_name = function(repo)
  return repo:match("^[%w-]+/([%w-_.]+)$")
end

-- "Meta-functions"
local meta = {
  -- Function call "operation"
  __call = function(self, repo, opts)
    opts = opts or vim.empty_dict()

    -- we declare some aliases for `do` and `for`
    opts['do'] = opts.run
    opts.run = nil

    opts['for'] = opts.ft
    opts.ft = nil

    vim.call('plug#', repo, opts)

    -- Add basic support to colocate plugin config
    if type(opts.config) == 'function' then
      local plugin = opts.as or plug_name(repo)

      if opts['for'] == nil and opts.on == nil then
        configs.start[plugin] = opts.config
      else
        configs.lazy[plugin] = opts.config

        local user_cmd = [[ autocmd! User %s ++once lua VimPlugApplyConfig('%s') ]]
        vim.cmd(user_cmd:format(plugin, plugin))
      end

    end
  end
}

-- Meta-tables are awesome
return setmetatable(plug, meta)
