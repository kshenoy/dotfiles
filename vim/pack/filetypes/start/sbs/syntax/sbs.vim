"Author: Aaron Mertz
"Email: aaron.mertz@amd.com
"Version: 1.0

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "sbs"

syntax keyword sbsKeyword REQUIRES_SBS_MODULES C_PUBLIC_HEADERS C_SOURCE_FILES MODULE VERILOG_OPTIONS VERILOG_INCLUDE_FILES VERILOG_SOURCE_FILES LIKE_VERILOG OPTIONS PREPROCESSOR_MAKEFILE ARBITRARY_FILES GLOBAL_DATA C_INCDIR VERILOG_MODULE C_PREBUILT_LIBRARIES
syntax keyword sbsType for_xprop generated type rpl_exempt sim_artifact not_sim_artifact xprop_opts not_for_xprop not_for_rpl
syntax match   sbsLineComment "//.*"
syntax match   sbsDefine "#\(define\|else\|elsif\|endif\|ifdef\|ifndef\|ifdef\|if\|error\)\>"
syntax region  sbsString start=/"/ skip=/\\"/ end=/"/

highlight! default link sbsLineComment Comment
highlight! default link sbsKeyword Keyword
highlight! default link sbsDefine Define
highlight! default link sbsString String
highlight! default link sbsType Function
