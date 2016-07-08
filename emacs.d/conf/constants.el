;;; constants.el --- Constants used in other files
;;
;; This file contains all constants used in other files, like directories, files etc.

(require 'lib/path)
(require 'lib/env)

;;; (Directories) ;;;
(defconst *user-home-directory*
  (getenv-or "HOME" (concat (expand-file-name "~") "/"))
  "Path to user home directory.")

(defconst *emacsd-directory*
  (path-join *user-home-directory* ".emacs.d")
  "Path to emacs.d directory.")
;
;(defconst *projects-directory*
;  (path-join *user-home-directory* "projects-source")
;  "Path to my default project directory.")
;
;
;(defconst *all-project-directories*
;  (list
;   *projects-directory*
;   (path-join *projects-directory* "another-project-source") ;; you can duplicate or delete this line if you want
;   )
;  "List of all my project directories.")

(provide 'constants)
;;; constants.el ends here
