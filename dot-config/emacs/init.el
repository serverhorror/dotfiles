;; Make sure the customiziations from the GUI
;; do not mess up what we want to set
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(setq inhibit-startup-message t)
(setq visible-bell t)

(set-fringe-mode 25) ; more room -- not quite sure about this, we need a better way

(menu-bar-mode -1) ; no menu bar
(tool-bar-mode -1); no tool bar
(scroll-bar-mode -1); no scroll bar

;; Show line numbers everywhere
(global-display-line-numbers-mode t)
;; Exclude these from showing line numbers
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		help-mode-hook))
  (add-hook mode(lambda () (display-line-numbers-mode 0))))


;; Core settings
(setq ;; Yes, this is Emacs
      inhibit-startup-message t

      ;; Instruct auto-save-mode to save to the current file, not a backup file
      auto-save-default nil

      ;; No backup files, please
      make-backup-files nil)

;; Yes! We want a new line at the end of the file!
(setq mode-require-final-newline t)
;; No! Trailing whitespace is awful!
(setq-default show-trailing-whitespace t)
;; Delete trailing whitespace before saving buffers
(add-hook 'before-save-hook 'delete-trailing-whitespace)


;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 120)
(load-theme 'tango-dark)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package command-log-mode
  :ensure t
  :init
  (clm/toggle-command-log-buffer)
  (global-command-log-mode))

;; This is for completion ...
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

;; Recently selected stuff at the top
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; Metadata (e.g. when opening files)
(use-package marginalia
  :ensure t
  :after vertico
  :init
  (marginalia-mode))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode-hook . rainbow-delimiters-mode))
