;; Contains AI-generated code
;; MODEL USED: Claude Sonnet 4.5

(defun serverhorror/find-home-directory ()
  "Return the 'HOME' directory of the user running"
  (interactive)
  ;; Example: Run OS-specific code in Emacs Lisp
  (cond
   ;; Linux or macOS settings
   ((or (eq system-type 'gnu/linux)
	(eq system-type 'darwin))
    "~")

   ;; Windows-specific settings here
   ((eq system-type 'windows-nt)
    (getenv "USERPROFILE"))
   ))

(provide 'serverhorror/find-home-directory)
