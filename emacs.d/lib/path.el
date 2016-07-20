;;; path.el --- Support file to load $PATH
;;
;; Copyright (C) 2015 Brunno dos Santos <emacs at brunno dot me>
;;
;; Author: Brunno dos Santos @squiter
;; URL: http://github.com/squiter/emacs-fast-start
;;
;; This file is NOT part of GNU Emacs.
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; See <http://www.gnu.org/licenses/> for a copy of the GNU General
;; Public License.
;;
;;; Commentary:
;;
;; If you use GUI Emacs you probably needs to configure properly your
;; $PATH env var. This file helps to do it.

;;; Code:

(defun path-abs-buffer ()
  "Get the current buffer absolute path."
  (file-truename (or (buffer-file-name) default-directory)))


(defun path-join (root &rest dirs)
  "Join paths together starting at ROOT and proceeding with DIRS.
Ex: (path-join \"/tmp\" \"a\" \"b\" \"c\") => /tmp/a/b/c"
  (if (not dirs)
      root
    (apply 'path-join
           (expand-file-name (car dirs) root)
           (cdr dirs))))

(defun set-exec-path-from-shell-PATH ()
  "Function that set $PATH env var."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(when (window-system)
  (set-exec-path-from-shell-PATH))

(provide 'lib/path)
;;; path.el ends here
