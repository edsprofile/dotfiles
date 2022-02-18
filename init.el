;; ***** SETTING UP MELPA and checking PACKAGES *****

;; Setting up MELPA

(require 'package)

(setq package-enable-at-startup nil)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(setq ring-bell-function #'ignore)
(tool-bar-mode -1)

;; ***** Basic setting *****

;; Put backup files neatly away                                                 
(let ((backup-dir "~/tmp/emacs/backups/")
      (auto-saves-dir "~/tmp/emacs/auto-saves/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks                           
      delete-old-versions t  ; Clean up the backups                             
      version-control t      ; Use version numbers on backups,                  
      kept-new-versions 5    ; keep some new versions                           
      kept-old-versions 2)   ; and some old ones, too

;; Remove the start screen and basic Emacs settings
(setq inhibit-startup-message t)

;; Add line number and column numbers to be displayed on Emacs bar
(line-number-mode 1)
(column-number-mode 1)

;; Make command the modifier key
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

;; Truncate long lines
(set-default 'truncate-lines t)

;;keep cursor at same position when scrolling
(setq scroll-preserve-screen-position 1)

;;scroll window up/down by one line
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))

;; ***** CUSTOM FUNCTIONS *****

;; When opening a new window the cursor will be active in that new window
;; these are custom function for following the cursor.
(defun split-follow-horizontal ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-follow-horizontal)

(defun split-follow-vertical ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-follow-vertical)

;; Copy the file path to kill
(defun copy-file-path-to-kill ()
  (interactive)
  (kill-new (buffer-file-name)))
(global-set-key (kbd "C-c C-n") 'copy-file-path-to-kill)

;; ***** PACKAGES *****
(use-package org-mode
  :ensure t)

(use-package switch-window
  :ensure t)
(global-set-key (kbd "C-x o") 'switch-window)
(setq switch-window-shortcut-style 'qwerty)

(use-package restclient
  :ensure t
  :mode (("\\.http\\'" . restclient-mode)))

;; Adding dashboard to basically customize the startup screen
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 20)
                          (bookmarks . 5)
                          (projects . 5)))
  (setq dashboard-banner-logo-title "Welcome to Emacs")
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-set-footer nil))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(use-package projectile
  :ensure t)

;; Helm awesome package that helps searching for many things
(use-package helm
  :ensure t
  :config
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-s") 'helm-occur)
  (setq helm-autoresize-max-height 0
	helm-autoresize-min-height 40
	helm-split-window-inside-p t))
(helm-mode 1)
(helm-autoresize-mode 1)

(use-package helm-projectile
  :ensure t
  :config
  (projectile-mode)
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

(use-package helm-slime
  :ensure t)

(use-package good-scroll
  :ensure t
  :config
  (good-scroll-mode 1))


(use-package which-key
  :ensure t)


;; ***** PACKAGES *****

;; vterm is good terminal emulator for emacs
(use-package vterm
  :ensure t)

(require 'display-line-numbers)

(defcustom display-line-numbers-exempt-modes
  '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
  "Major modes on which to disable line numbers."
  :group 'display-line-numbers
  :type 'list
  :version "green")


(defun display-line-numbers--turn-on ()
  "Turn on line numbers except for certain major modes.
Exempt major modes are defined in `display-line-numbers-exempt-modes'."
  (unless (or (minibufferp)
              (member major-mode display-line-numbers-exempt-modes))
    (display-line-numbers-mode)))

(global-display-line-numbers-mode)

;; magit for git interaction
(use-package magit
  :ensure t)
(global-set-key (kbd "C-x g") 'magit-status)

(use-package smartparens
  :ensure t
  :hook
  (prog-mode . smartparens-mode))

(require 'smartparens-config)

(use-package avy
  :ensure t
  :config
  (global-set-key (kbd "M-j") 'avy-goto-char-2))

(use-package ledger-mode
  :ensure t
  :config
  (setq ledger-binary-path "/opt/homebrew/bin/ledger")
  :mode "\\.ledger\\'"
  :custom (ledger-clear-whole-transactions t)
  :bind (:map ledger-mode-map
	("C-x C-s" . my/ledger-save))
  :preface
  (defun my/ledger-save ()
    "Automatically clean the ledger buffer at each save."
    (interactive)
    (save-excursion
      (when (buffer-modified-p)
        (with-demoted-errors (ledger-mode-clean-buffer))
        (save-buffer)))))

(use-package slime
  :ensure t
  :config
  (slime-setup '(slime-fancy slime-quicklisp slime-asdf helm-slime))
  (setq inferior-lisp-program "/opt/homebrew/bin/sbcl"))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(adwaita))
 '(package-selected-packages '(avy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
