(require 'yasnippet)

(defun camelize (str)
  "Convert STR from snake_case to CamelCase"
  (mapconcat 'identity (mapcar
                        '(lambda (word) (capitalize (downcase word)))
                        (split-string str "_")) ""))

(defun yas-c++-class-name ()
  "Construct class name from filename by converting the latter to camelcase"
  (concat "c" (camelize (file-name-base (buffer-file-name)))))

(defun yas-c++-class-method-declare-choice ()
  "Choose and return the end of a C++11 class method declaration"
  (yas-choose-value '(";" " = default;" " = delete;")))
