;; Make sure the customiziations from the GUI
;; do not mess up what we want to set
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Remove the initial startup screen so we start directly in the scratch buffer
(setq inhibit-startup-screen t)
(setq frame-title-format "%b")

;; Configure packages and add MELPA to the list of repos...
; (package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;; ;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; ;; I Do Things ...
;; (ido-mode t)
;; (ido-everywhere t) ; no idea what this actually does ...

(add-to-list 'default-frame-alist '(undecorated . t))
(add-to-list 'default-frame-alist '(alpha-background . 95))
;; Yes! We want a new line at the end of the file!
(setq mode-require-final-newline t)

;; Disable menu/tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)           ;; let's see ...
(scroll-bar-mode -1)
;; (setq line-move-visual t) ;; we do not like this!

(setq-default word-wrap nil)
(setq truncate-lines t)
(setq-default truncate-lines t)
(set-default 'truncate-lines t)

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
(set-face-font 'mode-line "Fira Code Nerd Font Mono Ret-10")
(set-face-background 'mode-line-inactive "gray") ;; is this smart?
(set-face-font 'mode-line-inactive  "Fira Code Nerd Font Mono Ret-10")

;; Some nicer Keybindings!
(global-set-key (kbd "<C-tab>") 'other-window)
;(global-set-key (kbd "<C-w> j") 'other-window)
;(global-set-key (kbd "<C-w> k") 'other-window)


;; (add-to-list 'default-frame-alist '(alpha-background . 90))

;; MELPA company
;; (use-package company)
;; (use-package company-go)
;; (require 'company)      ; load company mode
;; (require 'company-go)   ; load company mode go backend
;; (add-hook 'after-init-hook 'global-company-mode)

;; MELPA go-mode
;; (add-hook 'go-mode-hook 'eglot-ensure)
;; This will add add use "save hooks" for Go
;; (use-package go-mode
;;   :bind "\\.go\\'"
;;   :hook
;;   (go-mode 'eglot-ensure)
;;   (before-save 'eglot-code-action-organize-imports)
;;   )

;; MELPA treesit-auto
(use-package treesit-auto)

;; MELPA??
(use-package eglot
  :ensure t
  :defer t
  :hook
  (go-mode . eglot-ensure))
