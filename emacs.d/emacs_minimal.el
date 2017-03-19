(require 'package)

; List the packages you want
(setq package-list '(evil
                                           evil-leader))

; Add Melpa as the default Emacs Package repository
; only contains a very limited number of packages
(add-to-list 'package-archives
                          '("melpa" . "http://melpa.milkbox.net/packages/") t)

; Activate all the packages (in particular autoloads)
(package-initialize)

; Update your local package index
(unless package-archive-contents
    (package-refresh-contents))

; Install all missing packages
(dolist (package package-list)
    (unless (package-installed-p package)
          (package-install package)))

(let ((default-directory  "~/.emacs.d/elpa/org-plus-contrib-20170210/"))
    (normal-top-level-add-subdirs-to-load-path))
(require 'org)
(require 'org-id)
