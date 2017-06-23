" Highlight TODO_CLEANUP etc. in addition to TODO
syn match   TodoTags         '\(TODO\|FIXME\|BOZO\)_\w\+'
syn cluster perlComment      add=TodoTags
hi def link TodoTags         Todo
