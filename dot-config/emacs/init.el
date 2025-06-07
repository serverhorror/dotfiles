;; We want an emacs-server to be running and we want to be sure,
;; even if it wasn't started with "emacs --daemon"
(server-start)

;; Make sure the customiziations from the GUI
;; do not mess up what we want to set
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(defun nuke_traling ()
  (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))
(add-hook 'prog-mode-hook #'nuke_traling)
(add-hook 'before-save-hook #'delete-trailing-whitespace nil t)

;; yes-or-no becomes y-or-n
(setopt use-short-answers t)

;; Remove the initial startup screen so we start directly in the scratch buffer
(setq inhibit-startup-screen t)
;;(setq frame-title-format "%b")

;; ;; I Do Things ...
;; (ido-mode t)
;; (ido-everywhere t) ; no idea what this actually does ...

;; (add-to-list 'default-frame-alist '(undecorated . t))
;; (add-to-list 'default-frame-alist '(alpha-background . 90))
;; (add-to-list 'default-frame-alist '(alpha-background . 95))

;; Yes! We want a new line at the end of the file!
(setq mode-require-final-newline t)
(setq-default show-trailing-whitespace t)

;; ;; we do not like this!
(setq line-move-visual t)

(setq-default word-wrap nil)
(setq truncate-lines t) ; asdf asdf asdf  asdf asdf asdf  asdf asdf asdf  asdf asdf asdf  asdf asdf asdf  asdf asdf asdf  asdf asdf asdf
(setq-default truncate-lines t)

;; Enable auto-save for the actual file
(auto-save-visited-mode t)
;; Disable auto-save (backup files)
(auto-save-mode -1)
;; Disable menu-, tool- and scroll-bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Other useful stuff; Do "C-h f"
(blink-cursor-mode t)
(global-hl-line-mode t)
(global-display-line-numbers-mode t)
(column-number-mode t)
(show-paren-mode t)
;; Remember recently opened files
(recentf-mode t)

;; Tests for ligatures:
;; >=  != ==

;; ;; Change the font to what I like
;; ; (set-default-font "FiraCode Nerd Font Mono Ret-24") ; this is for old emacs versions!
(set-frame-font "FiraCode Nerd Font Mono Ret-16")
;; (set-face-font 'mode-line "Fira Code Nerd Font Mono Ret-10")
;; (set-face-background 'mode-line-inactive "gray") ;; is this smart?
;; (set-face-font 'mode-line-inactive  "Fira Code Nerd Font Mono Ret-10")

;; Some nicer Keybindings!
(global-set-key (kbd "<C-tab>") 'other-window)
(global-set-key (kbd "<C-w> j") 'other-window)
(global-set-key (kbd "<C-w> k") 'other-window)

;; Configure packages and add MELPA to the list of repos...
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; ;Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; ;and `package-pinned-packages`. Most users will not need or want to do this.
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; ;; Make sure we always set the ':ensure t' for all packages
;; (eval-and-compile
;;   (setq use-package-always-ensure t
;; 	use-package-expand-minimally t))

;; This assumes you've installed the package via MELPA.
;; org, org-roam mode
;; org-roam is a full management for a directory
(use-package org
  :demand t
  :ensure t
  :init
  (setq org-directory (file-truename "~/src/org"))
  (setq org-startup-indented t)
  (setq org-startup-numerated t)
  (setq org-startup-folded t)
  (setq org-hide-leading-stars t)
  (setq org-log-done "time"))

(use-package org-roam
  :demand t
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/src/org"))
  (org-roam-complete-everywhere t)
  :bind (("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
	 ("C-c n l" . org-roam-buffer-toggle))
  :config
  (org-roam-db-autosync-enable))
