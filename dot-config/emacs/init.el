;; We want an emacs-server to be running and we want to be sure,
;; even if it wasn't started with "emacs --daemon"
(server-start)

;; Make sure the customiziations from the GUI
;; do not mess up what we want to set
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'serverhorror/find-home-directory)
(require 'serverhorror/nuke-trailing-spaces)


(add-hook 'before-save-hook #'delete-trailing-whitespace nil t)
(add-hook 'prog-mode-hook #'serverhorror/nuke-trailing-spaces)


;; Remove the initial startup screen so we start directly in the scratch buffer
(setq inhibit-startup-screen t)
;;(setq frame-title-format "%b")

;; ;; I Do Things ...
;; (ido-mode t)
;; (ido-everywhere t) ; no idea what this actually does ...

;; (add-to-list 'default-frame-alist '(undecorated . t))
;; (add-to-list 'default-frame-alist '(alpha-background . 90))
;; (add-to-list 'default-frame-alist '(alpha-background . 95))

;; Show line numbers everywhere
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
;; Exclude these from showing line numbers
(dolist (mode '(
		eshell-mode-hook
		help-mode-hook
		term-mode-hook
		which-key-mode-hook
		org-mode-hook
		eww-mode-hook
		))
  (add-hook mode(lambda () (display-line-numbers-mode 0))))


;; Core settings
(setopt use-short-answers t) ; yes-or-no becomes y-or-n
(setq inhibit-startup-message t)
(setq auto-save-default nil) ; Instruct auto-save-mode to save to the current file, not a backup file
(setq make-backup-files nil) ; No backup files, please
(setq mode-require-final-newline t) ; Yes! We want a new line at the end of the file!
(setq delete-trailing-lines t) ; delete extra trailing lines
(setq-default show-trailing-whitespace t)
(setq line-move-visual t) ; we do not like this!
(setq make-backup-files nil) ; Disable backup files
(setq-default word-wrap nil)
(setq truncate-lines t) ; asdf asdf asdf  asdf asdf asdf  asdf asdf asdf  asdf asdf asdf  asdf asdf asdf  asdf asdf asdf  asdf asdf asdf
(setq-default truncate-lines t)

;; Enable auto-save for the actual file
(auto-save-visited-mode t)

;; Disable auto-save
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

;; Theme
(load-theme 'modus-vivendi)

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
(setq use-package-always-ensure t)

;; Enable Vertico.
(use-package vertico
  :ensure t
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :ensure t
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

(use-package magit
  :ensure t)

;; (use-package evil
;;   :ensure t
;;   :init
;;   (setq evil-want-integration t)
;;   (setq evil-want-keybinding nil)
;;   :config
;;   (evil-mode t))

;; (use-package evil-collection
;;   :ensure t
;;   :after evil
;;   :config
;;   (evil-collection-init))

;; This assumes you've installed the package via MELPA.
;; org, org-roam mode
;; org-roam is a full management for a directory
(use-package org
  :demand t
  :ensure t
  :init
  (setq org-directory (expand-file-name "src/brain" (serverhorror/find-home-directory)))
  (setq org-agenda-files (
			  list (expand-file-name "src/brain" (serverhorror/find-home-directory))
			  ))
  (setq org-startup-indented t)
  (setq org-startup-numerated t)
  ;; (setq org-startup-folded t) ; no that is annoying
  (setq org-hide-leading-stars t)
  (setq org-log-done "time")
  )

(use-package org-roam
  :demand t
  :ensure t
  :custom
  (org-roam-directory (expand-file-name "src/brain" (serverhorror/find-home-directory)))
  (org-roam-complete-everywhere t)
  :bind (
	 ("C-c n c" . org-roam-capture)
	 ("C-c n d" . org-roam-dailies-capture-today)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
	 ("C-c n l" . org-roam-buffer-toggle)
	 )
  :config
  (org-roam-setup)
  (org-roam-db-autosync-enable))


(use-package eglot
  :ensure t
  :defer t
  :hook ((python-mode . eglot-ensure)
         (go-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
               `(python-mode
                 . ,(eglot-alternatives '(("pyright-langserver" "--stdio")
                                          "jedi-language-server"
                                          "pylsp")))))

(use-package ob-mermaid
  :ensure t)

(defun serverhorror/org-mode-prettify-symbols ()
  "Visually replace leading stars in Org headings."
  (setq prettify-symbols-alist
	'(
	  ("*" . "⋕")
	  ))
  (prettify-symbols-mode 1))
(add-hook 'org-mode-hook #'serverhorror/org-mode-prettify-symbols)

(defun serverhorror/case-insensitive-org-roam-node-read (orig-fn &rest args)
  (let ((completion-ignore-case t))
    (apply orig-fn args)))
(advice-add 'org-roam-node-read :around #'serverhorror/case-insensitive-org-roam-node-read)
