;;; filetype.el --- Filetype specific configuration
;;


;; Verilog/System Verilog
(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))
(add-to-list 'auto-mode-alist '("\\.x\\'" . verilog-mode))


;; C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))



(provide 'filetype)
;;; filetype.el ends here
