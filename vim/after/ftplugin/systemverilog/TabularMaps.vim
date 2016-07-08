" Provides extra :Tabularize commands

if !exists(':Tabularize') || get(g:, 'no_default_tabular_maps', 0)
  finish " Tabular.vim wasn't loaded or the default maps are unwanted
endif

let s:save_cpo = &cpo
set cpo&vim

if !exists(':Tabularize')
  echom "Give up here; the Tabular plugin musn't have been loaded"
  finish
endif

AddTabularPattern! verilog_port_declarations /\v\S+(\s*\[[^\]]*])?/l1l0
