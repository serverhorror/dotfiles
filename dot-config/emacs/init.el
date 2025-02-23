;; Make sure the customiziations from the GUI
;; do not mess up what we want to set
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Remove the initial startup screen so we start directly in the scratch buffer
(setq inhibit-startup-screen t)

;; Configure packages and add MELPA to the list of repos...
; (package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;; ;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; I Do Things ...
(ido-mode t)
;(ido-everywhere t) ; no idea what this actually does ...

;; Yes! We want a new line at the end of the file!
(setq mode-require-final-newline t)

;; Disable menu/tool bar
;;(menu-bar-mode -1)
;;(tool-bar-mode -1)
;;(scroll-bar-mode -1)
;; ;;(set line-move-visual t) ;; this breaks startup, we have it in the


;; Other useful stuff; Do "C-h f"
(blink-cursor-mode t)
(global-hl-line-mode t)
(global-display-line-numbers-mode t)
(column-number-mode t)
(show-paren-mode t)
; Remember recently opened files
(recentf-mode t)
;; ;; remember what I typed into the commands/search/...
;; (save-hist-mode t)

;; Change the font to what I like
; (set-default-font "FiraCode Nerd Font Mono Ret-24") ; this is for old emacs versions!
(set-frame-font "FiraCode Nerd Font Mono Ret-16")
(set-face-font 'mode-line "Fira Code Nerd Font Mono Ret-8")

;; Some nicer Keybindings!
(global-set-key (kbd "<C-tab>") 'other-window)
;(global-set-key (kbd "<C-w> j") 'other-window)
;(global-set-key (kbd "<C-w> k") 'other-window)

