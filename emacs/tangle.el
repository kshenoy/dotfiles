;;; tangle --- Tangle one or more org files

;;; Commentary:
;; This file can be used to tangle one or more files to their output files.

;;; Code:

(require 'org)
(require 'ob-tangle)

(defun literate-dotfiles-tangle (&rest files)
  "Tangle FILES or all files in the project."
  (when (null files)
    (setq files command-line-args-left))
  (dolist (file files)
    (with-current-buffer (find-file-noselect file)
      (org-babel-tangle))))
