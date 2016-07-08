;;; functions.el --- Custom functions
;;

(defun my/switch-fullscreen nil
  "Switch to fullscreen.  Works in OSX."
  (interactive)
  (let* ((modes '(nil fullboth fullwidth fullheight))
         (cm (cdr (assoc 'fullscreen (frame-parameters) ) ) )
         (next (cadr (member cm modes) ) ) )
    (modify-frame-parameters
     (selected-frame)
     (list (cons 'fullscreen next)))))



(provide 'functions)
;;; functions.el ends here
