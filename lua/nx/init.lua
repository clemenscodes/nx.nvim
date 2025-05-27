local log = (require 'nx.logging').log

---@alias Generator { schema: table, name: string, run_cmd: string, package: string}
---@alias Generators { workspace: Generator[], external: Generator[] }
---@alias Cache { actions: table, targets: table }
---
---@class NxGlobal : Config
---@field public nx table | nil
---@field public workspace table
---@field public graph table | nil
---@field public package_json table | nil
---@field public projects table
---@field public generators Generators
---@field public cache Cache
_G.nx = {
  log = '',

  graph_file_name = vim.fn.tempname() .. '.json',

  graph = nil,
  nx = nil,
  package_json = nil,
  projects = {},
  generators = {
    workspace = {},
    external = {},
  },

  cache = { actions = {}, targets = {} },
}

---@alias form_renderer fun(form: table, title: string | nil, callback: function, state: table)
---@class Config
---@field public nx_cmd_root string
---@field public command_runner function
---@field public form_renderer function
---@field public read_init boolean
local default_config = {
  nx_cmd_root = 'nx',
  command_runner = require('nx.command-runners').terminal_cmd(),
  form_renderer = require('nx.form-renderers').telescope(),
}

local readers = require 'nx.read-configs'

--- Setup NX and set its defaults
--- @param config table
local setup = function(config)
  log '==================================='
  log '========== Setting up NX =========='
  log '==================================='

  config = config or {}

  if config.nx_cmd_root then
    _G.nx.nx_cmd_root = config.nx_cmd_root
  else
    _G.nx.nx_cmd_root = default_config.nx_cmd_root
  end

  if config.command_runner then
    _G.nx.command_runner = config.command_runner
  else
    _G.nx.command_runner = default_config.command_runner
  end

  if config.form_renderer then
    _G.nx.form_renderer = config.form_renderer
  else
    _G.nx.form_renderer = default_config.form_renderer
  end

  log(_G.nx)

  if config.read_init ~= false then
    readers.read_nx_root(require 'nx.on-project-mod')
  end
end

return { setup = setup }
