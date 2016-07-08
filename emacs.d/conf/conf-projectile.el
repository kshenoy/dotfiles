;;; conf-projectile.el
;;

(projectile-global-mode)

;;; projectile-helm
;; (setq projectile-completion-system 'helm)
;; (setq projectile-switch-project-action 'helm-projectile)
;; (setq helm-projectile-sources-list '(helm-source-projectile-buffers-list
;;                                      helm-source-projectile-files-list))

;; ;;
;; ;;; Jumping between projects (Thanks to Renan Ranelli)
;; ;;

;; ;; variables
;; (defvar default-project-source *projects-directory*)

;; (defvar project-sources *all-project-directories*)

;; ;; helm integration for opening projects
;; ;; Jumping between projects
;; ;;
;; (defvar rr/project-sources *all-project-directories*)

;; (defvar rr/default-file-regexps
;;   '("Gemfile$"
;;     "Readme"
;;     "README"))

;; (defun rr/helm-open-project ()
;;   "Bring up a Project search interface in helm."
;;   (interactive)
;;   (helm :sources '(rr/helm-open-project--source)
;;         :buffer "*helm-list-projects*"))

;; (defvar rr/helm-open-project--source
;;   '((name . "Open Project")
;;     (delayed)
;;     (candidates . rr/list-projects)
;;     (action . rr/open-project)))

;; (defun rr/list-projects ()
;;   "Lists all projects given project sources."
;;   (->> rr/project-sources
;;        (-filter 'file-exists-p)
;;        (-mapcat (lambda (dir) (directory-files dir t directory-files-no-dot-files-regexp)))))

;; (defun rr/open-project (path)
;;   "Open project available at PATH."
;;   ;; TODO: Add default file get.
;;   (let* ((candidates (-mapcat (lambda (d) (directory-files path t d)) rr/default-file-regexps))
;;          (elected (car candidates)))
;;     (find-file (or elected path))))



;;; Keybindings
;(global-set-key (kbd "C-c o") 'rr/helm-open-project)
;(global-set-key (kbd "C-x f") 'helm-projectile)
;(global-set-key (kbd "C-c p s a") 'helm-projectile-ack)



(provide 'conf-projectile)
;;; conf-projectile.el ends here
