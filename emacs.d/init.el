;; -*- mode: emacs-lisp -*-

(setq --init-org-file (expand-file-name "config.org" user-emacs-directory)
      --init-el-file  (expand-file-name "config.el"  user-emacs-directory)
      --init-config-loaded nil)

(when (>= emacs-major-version 24)
      ;; Run org-babel-load-file only if config.org is newer than config.el
      (if (file-exists-p --init-org-file)
          (unless (and (file-exists-p --init-el-file)
                       (time-less-p (nth 5 (file-attributes --init-org-file)) (nth 5 (file-attributes --init-el-file))))
            (if (fboundp 'org-babel-load-file)
                (progn
                  (org-babel-load-file --init-org-file)
                  (setq --init-config-loaded t))
              (message "Function not found: org-babel-load-file")))
        (message "Init org file '%s' missing." --init-org-file)))

(unless --init-config-loaded (load-file --init-el-file))
