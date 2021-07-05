;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'molokai t)


;; -*- mode: elisp -*-

;; Disable the splash screen (to enable it agin, replace the t with 0)
(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;;;;Org mode configuration
;; Enable Org mode
(require 'org)
;; Make Org mode work with files ending in .org
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '(
     "/home/rcamarasa/documents/gitlab/robin-camarasa-phd/general/agenda/phd.org" 
     "/home/rcamarasa/documents/gitlab/robin-camarasa-phd/general/agenda/phd.org_archive" 
     ))
 ;;'(package-selected-packages '(monokai-theme))
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(with-eval-after-load 'org 'evil-maps
  (define-key evil-motion-state-map (kbd ";") 'org-agenda))


(add-hook 'org-agenda-mode-hook (lambda () (define-key org-agenda-mode-map "j" 'org-agenda-next-item)))
(add-hook 'org-agenda-mode-hook (lambda () (define-key org-agenda-mode-map "k" 'org-agenda-previous-item)))
(add-hook 'org-agenda-mode-hook (lambda () (define-key org-agenda-mode-map "k" 'org-agenda-previous-item)))

(setq org-todo-keywords '(
      (sequence "TODO" "PLANNED" "ONHOLD" "|" "DONE")
      (sequence "RECURRENT" "|" "ACHIEVED")
    )
)

(setq org-todo-keyword-faces
      '(
        ("TODO" . org-warning) ("PLANNED" . "blue")
        ("ONHOLD" . "yellow")
        ("DONE" . (:foreground "green" :weight bold))
        ("RECURRENT" . "blue")
        ("ACHIEVED" . (:foreground "green" :weight bold)))
)

(setq
   split-height-threshold 4
   split-width-threshold 40 
   split-window-preferred-function 'split-window-really-sensibly)

(setq ring-bell-function 'ignore)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/") ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

; (setq org-agenda-skip-scheduled-if-deadline-is-shown 't)




(setq org-tag-alist '(("important" . ?i)
                    ("urgent"    . ?u)))



(setq org-agenda-custom-commands
   '(("1" "Q1" tags-todo "+important+urgent")
     ("2" "Q2" tags-todo "+important-urgent")
     ("3" "Q3" tags-todo "-important+urgent")
     ("4" "Q4" tags-todo "-important-urgent")))

