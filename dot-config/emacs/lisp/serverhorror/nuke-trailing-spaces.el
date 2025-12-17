(defun serverhorror/nuke-trailing-spaces ()
  (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))

(provide 'serverhorror/nuke-trailing-spaces)
