;; -*- mode: emacs-lisp -*-

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables '(debug-on-error t))


;; Declare config.org as a global variable
(defvar my-init-config (expand-file-name "config.org" user-emacs-directory)
  "Main configuration org file")

(setq my-init-config-el      (expand-file-name "config.el"  user-emacs-directory)
      my-init-config-el-pass (concat my-init-config-el ".pass")
      my-init-config-loaded nil)

(when (>= emacs-major-version 24)
  ;; Run org-babel-load-file only if config.org is newer than config.el (http://disq.us/p/o5rfst)
  (if (file-exists-p my-init-config)
      (unless (and (file-exists-p my-init-config-el)
                   (time-less-p (nth 5 (file-attributes my-init-config)) (nth 5 (file-attributes my-init-config-el))))
        (if (fboundp 'org-babel-load-file)
            (progn
              (org-babel-load-file my-init-config)
              ;; If we've reached here it means there were no errors in creating the .el file
              ;; Create a copy of it in case I mess up the .org in the future
              (when (file-exists-p my-init-config-el-pass)
                (delete-file my-init-config-el-pass))
              (copy-file my-init-config-el my-init-config-el-pass)
              (setq my-init-config-loaded t))
          (message "Function not found: org-babel-load-file")))
    (message "Init-config-org file '%s' missing." my-init-config)))

(unless my-init-config-loaded (load-file my-init-config-el))