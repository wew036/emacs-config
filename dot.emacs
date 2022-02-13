;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

; a powerful way to switch buffers and open files
(require 'ido)

(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

; Emacs 23 uses option key as meta key by default
; this command changes to use Command key as the Emacs meta key
(setq mac-command-modifier 'meta)

; for Carbon emacs on Mac OS X, to make shell work
(setq process-connection-type t)
(setq mac-command-key-is-meta t)

;--Turn on the column numbering in the minibuffer
(column-number-mode 1)

(setq-default fill-column 79)        ; wordwrap i this column

; enable these functions
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)

; dired can copy and remove directory trees
(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)

(setq minibuffer-max-depth nil)
(setq-default line-number-mode t)
(setq Next-Line-Add-Newlines nil)
(setq transient-mark-mode t)

;--Replace yes/no+enter prompts with y/n prompts
(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'python-mode-hook 'guess-style-guess-tabs-mode)
(add-hook 'python-mode-hook (lambda ()
                              (guess-style-guess-tab-width)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; save the buffer, removing and readding the 'delete-trailing-whitespace function
;; to 'before-save-hook if it's there
;(defun save-buffer-no-delete-trailing-whitespace ()
;  (interactive)
;  (let ((normally-should-delete-trailing-whitespace (memq 'delete-trailing-whitespace before-save-hook)))
;    (when normally-should-delete-trailing-whitespace
;      (remove-hook 'before-save-hook 'delete-trailing-whitespace))
;    (save-buffer)
;    (when normally-should-delete-trailing-whitespace
;      (add-hook 'before-save-hook 'delete-trailing-whitespace))))
;(global-set-key (kbd "C-c C-s") 'save-buffer-no-delete-trailing-whitespace)

(add-hook 'python-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)
            (setq-default tab-width 3)
            (setq-default python-indent 3)
            (setq-default py-indent-tabs-mode nil)
            (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

; use python mode for scons files
(add-to-list 'auto-mode-alist '("\\.sc\\'" . python-mode))

(defun my-setup-sh-mode ()
  "My own personal preferences for `sh-mode'.

This is a custom function that sets up the parameters I usually
prefer for `sh-mode'.  It is automatically added to
`sh-mode-hook', but is can also be called interactively."
  (interactive)
  (setq sh-basic-offset 3
        sh-indentation 3))
(add-hook 'sh-mode-hook 'my-setup-sh-mode)

(defun my-c-mode-common-hook ()
  (setq tab-width 3)
  (c-set-style "bsd")
  ;(setq indent-tabs-mode t)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 3)

  ;; add a function menu
  (imenu-add-to-menubar
   (concat "Func " (file-name-nondirectory
           (buffer-file-name))))
)

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook t)

;; Instruct emacs how to layout source
(c-add-style "vmware"
     '((c-basic-offset . 3)
      (c-comment-only-line-offset . 0)
      (c-hanging-braces-alist . ((substatement-open before after)))
      (c-offsets-alist . ((topmost-intro        . 0)
                         (topmost-intro-cont   . 0)
                         (substatement         . 3)
                         (substatement-open    . 0)
                         (statement-case-open  . 3)
                         (statement-cont       . 3)
                         (access-label         . -3)
                         (inclass              . 3)
                         (inline-open          . 3)
                         (innamespace          . 0)
                         ))))
(add-hook 'c-mode-common-hook (lambda () (c-set-style "vmware")))

(defun c-or-c++-mode ()
  "Choose c-mode or c++-mode, depending on the contents of the file."
  (interactive)
  (if (save-excursion
        (goto-char (point-min))
        ;; checking if the file looks like C++
        (re-search-forward "\\<class\\|virtual\\|//\\|::\\>" nil t))
      (c++-mode)
    (c-mode)))

;; prevent echoing ^M in the shell
(add-hook 'comint-output-filter-functions 'shell-strip-ctrl-m nil t)

; a large undo buffer
(setq kill-ring-max 200)

; Kill EOL too
(setq kill-whole-line t)

;; -----------------------------------------------------------------
;; Parentheses matching
(show-paren-mode 1)

(global-font-lock-mode t)

; typed text replaces the selection if the selection is active
(delete-selection-mode 1)

; bring in the visible rectangle mode (activate by C-RET)
(cua-mode t) ; C-c, C-x, C-v will be disabled by cua-enable-cua-keys below

; blink cursor (1 makes it blink)
(blink-cursor-mode 1)

(set-cursor-color 'red)

(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(global-set-key [C-home] 'beginning-of-buffer)
(global-set-key [C-end] 'end-of-buffer)
(global-set-key [f1] 'goto-line)
(global-set-key [f3] 'auto-fill-mode)
(global-set-key [f8] 'my-tex-command)
(global-set-key [f9] 'view-mode)
(global-set-key "\C-x\C-e" 'compile)
(global-set-key "\C-x\C-p" 'grep)
(global-set-key "\M-s" 'point-to-register)
(global-set-key "\M-g" 'jump-to-register)
(global-set-key "\M-i" 'indent-region)

; use ibuffer to manage all opened buffers
(require 'ibuffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "M-h") 'ns-do-hide-emacs)

; not available in Emacs 24 by default
; ; to remember all variable values, registers, kill rings, file
; ; visited, and many other info between sessions
(require 'session)
(add-hook 'after-init-hook 'session-initialize)

(setq ispell-program-name "/usr/local/bin/aspell")

; use xcscope
(require 'xcscope)
(cscope-setup)
(setq cscope-program "/usr/local/bin/cscope")
(add-hook 'java-mode-hook (function cscope:hook))
(add-hook 'objc-mode-hook (function cscope:hook))
;(require 'exec-path-from-shell) ;; if not using the ELPA package
;(exec-path-from-shell-initialize)

; undo/redo
(require 'undo-fu)
(global-set-key (kbd "C-/") 'undo-fu-only-undo)
(global-set-key (kbd "C-?") 'undo-fu-only-redo) ; does not work in terminal
(global-set-key (kbd "C-c r") 'undo-fu-only-redo) ; works in terminal

(require 'reftex)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex)   ; with Emacs latex mode

(server-start)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(column-number-mode t)
 '(cua-enable-cua-keys nil)
 '(cua-mode t nil (cua-base))
 '(current-language-environment "Latin-1")
 '(cursor-type 'bar)
 '(default-input-method "latin-1-prefix")
 '(display-time-mode t)
 '(global-font-lock-mode t nil (font-lock))
 '(package-selected-packages '(boogie-friends undo-fu markdown-mode go-mode))
 '(pc-selection-mode t)
 '(safe-local-variable-values
   '((TeX-master . "hierarchical-storage.tex")
     (require-final-newline . t)
     (mangle-whitespace . t)))
 '(save-place nil nil (saveplace))
 '(session-use-package t nil (session))
 '(show-paren-mode t nil (paren)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :extend nil :overline nil :underline nil :slant normal :weight normal :height 160 :width normal :foundry "nil" :family "Menlo")))))
