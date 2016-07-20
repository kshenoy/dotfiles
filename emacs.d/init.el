;; -*- mode: emacs-lisp -*-

(setq my-init-config-org    (expand-file-name "config.org" user-emacs-directory)
      my-init-config-el     (expand-file-name "config.el"  user-emacs-directory)
      my-init-config-loaded nil)

(when (>= emacs-major-version 24)
      ;; Run org-babel-load-file only if config.org is newer than config.el (http://disq.us/p/o5rfst)
      (if (file-exists-p my-init-config-org)
          (unless (and (file-exists-p my-init-config-el)
                       (time-less-p (nth 5 (file-attributes my-init-config-org)) (nth 5 (file-attributes my-init-config-el))))
            (if (fboundp 'org-babel-load-file)
                (progn
                  (org-babel-load-file my-init-config-org)
                  (setq my-init-config-loaded t))
              (message "Function not found: org-babel-load-file")))
        (message "Init-org file '%s' missing." my-init-config-org)))

(message "Falling back to loading init-el file '%s'" my-init-config-el)
(unless my-init-config-loaded (load-file my-init-config-el))
