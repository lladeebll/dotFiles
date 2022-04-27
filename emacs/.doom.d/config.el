;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Adeeb HS"
      user-mail-address "adeeb.hs1@gmail.com"
      display-line-numbers-type 'relative
      ;;confirm-kill-emacs nil
)

(setq doom-theme 'doom-dracula)

(setq scroll-margin 3)
(setq hscroll-margin 3)

(setq doom-font (font-spec :family "monospace" :size 25 :weight 'semi-light)
       doom-variable-pitch-font (font-spec :family "sans" :size 23))

(use-package fira-code-mode
  :config
  (fira-code-mode-set-font)
  :custom (fira-code-mode-disabled-ligatures '("[]" "#{" "#(" "#_" "#_(" "x" "***" "<>")) ;; List of ligatures to turn off
  :hook prog-mode org-mode ;; Enables fira-code-mode automatically for programming and org major modes
  )

(use-package all-the-icons
  :if (display-graphic-p))
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode)
  )             ;; Icons for dired
(setq doom-themes-treemacs-theme "doom-colors")
(setq +ligatures-extras-in-modes '(haskell-mode org-mode))
(set-scroll-bar-mode 'right)

(use-package highlight-indent-guides
  :ensure t
  :commands highlight-indent-guides-mode
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character
        ;;highlight-indent-guides-character ?\❯
   )
 )

(setq org-directory "~/org/")
(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq
        org-pretty-entities t
        org-startup-folded t
        org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        ;;org-superstar-item-bullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        )
  )

(setq key-chord-two-keys-delay 0.1)
(key-chord-define evil-insert-state-map "fj" 'evil-normal-state)
(key-chord-mode 1)

(defhydra hydra-window-size (:timeout 5)
"Resize window"
("=" evil-window-increase-width "Increase Width")
("-" evil-window-decrease-width "Decrease Width")
("+" evil-window-increase-height "Increase Height")
("_" evil-window-decrease-height "Decrease Height")
("f" nil "finished" :exit t))

(map! :leader
    (:prefix ("w". "window")
    :desc "Resize current window" "c" #'hydra-window-size/body))

(map! :leader
      :desc "M-x" ";" #'execute-extended-command)

(map! :leader
      :desc "Eval Expression" ":" #'eval-expression)

(define-key evil-normal-state-map (kbd "0") #'evil-first-non-blank)
(define-key evil-normal-state-map (kbd "^") #'evil-beginning-of-line)

(global-set-key (kbd "<backtab>") 'un-indent-by-removing-4-spaces)
(defun un-indent-by-removing-4-spaces ()
  "remove 4 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-line)
      ;; get rid of tabs at beginning of line
      (when (looking-at "^\\s-+")
        (untabify (match-beginning 0) (match-end 0)))
      (when (looking-at "^    ")
        (replace-match "")))))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :custom
  ;; (+lsp-company-backends '(company-tabnine :separate company-capf company-yasnippet)) ;; to enable Tab-nine autocomplete
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package lsp-mode
  :after lsp
  :commands (lsp lsp-deferred)
  :config
  (lsp-enable-which-key-integration t)
  )

(after! lsp-mode
    (setq lsp-enable-symbol-highlighting nil)                   ;; 1
    (setq lsp-ui-doc-enable nil)                                ;; 2
    (setq lsp-ui-doc-show-with-cursor nil)
    (setq lsp-ui-doc-show-with-mouse nil)
    (setq lsp-lens-enable nil)                                  ;; 3
    (setq lsp-headerline-breadcrumb-segments
          '(path-up-to-project file symbols))
    (setq lsp-headerline-breadcrumb-enable nil)                 ;; 4
    (setq lsp-ui-sideline-enable t)                             ;; 5
    (setq lsp-ui-sideline-show-code-actions t)
    (setq lsp-ui-sideline-enable t)                             ;; 6
    (setq lsp-ui-sideline-show-hover t)
    (setq lsp-modeline-code-actions-enable t)                   ;; 7

    (setq lsp-diagnostics-provider :auto)                       ;; 8
    (setq lsp-ui-sideline-enable t)                             ;; 9
    (setq lsp-eldoc-enable-hover t)                             ;; 10
    (setq lsp-modeline-diagnostics-enable t)                    ;; 11

    (setq lsp-signature-auto-activate t)                        ;; 12
    (setq lsp-signature-render-documentation nil)               ;; 13

    (setq lsp-completion-provider :capf)                        ;; 14
    (setq lsp-completion-show-detail t)                         ;; 15
    (setq lsp-completion-show-kind t)                           ;; 16
  )

(use-package lsp-ui
  :after lsp
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom)
  )

(use-package lsp-treemacs
  :after lsp)

(setq lsp-clients-clangd-args '("--header-insertion=never"))

(use-package lsp-pyright
  :after lsp
  :ensure t
  :init
  (setq lsp-pyright-multi-root nil)
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(use-package pyvenv
  :config
  (pyvenv-mode 1))

(plist-put! +ligatures-extra-symbols
            :sum        "Σ"
            :product    "Ⲡ"
            )

(after! haskell-mode
  (set-ligatures!  'haskell-mode
    :lambda        "\\"
    :composition   "."
    :null          "()"
    :int           "Int"
    :float         "Double"
    ;; :str           "String"
    ;; :bool          "Bool"
    :in            "`elem`"
    :not-in        "`notElem`"
    :union         "`union`"
    :intersect     "`intersect`"
    :or            "||"
    :and           "&&"
    :for           "forall"
    :sum           "sum"
    :product       "product"
    )
   )

(use-package autoinsert
  :config
  (setq auto-insert-query nil)             ; disable the default auto-inserts
  (auto-insert-mode 1)                     ; enable auto-insert-mode globally
  (add-hook 'find-file-hook 'auto-insert)  ; insert templates when we create new files
  (setq auto-insert-alist nil)             ; remove this line to restore defaults
  ;; (add-to-list 'auto-insert-alist          ; add "competitive coding" templates to auto insert
  ;;              '("^/home/adeeb/code/.+\\.cpp\\'" . "/home/adeeb/code/template.cpp"))
  (add-to-list 'auto-insert-alist          ; the same with ~ expansion
               (cons (concat "^" (expand-file-name "~/code/") ".+\\.cpp\\'")
                     (expand-file-name "~/code/template.cpp")))
 )

(setq vterm-shell "/bin/zsh")
(after! vterm
  (set-popup-rule! "\\*doom:vterm-popup:.*\\*" :size 0.35 :vslot -4 :select t :quit nil :ttl 0 :side 'right)
  )

(setq
 ;; browse-url-browser-function 'eww-browse-url                    ; Use eww as the default browser
 shr-use-fonts  nil                                             ; No special fonts
 shr-use-colors nil                                             ; No colours
 shr-indentation 2                                              ; Left-side margin
 shr-width 70                                                   ; Fold text to 70 columns
 shr-image-animate nil                                          ; Amination switched off
 shr-inhibit-images t                                           ; Images are switched off
 )
(defun my/eww-toggle-images ()
  "Toggle whether images are loaded and reload the current page from cache."
  (interactive)
  (setq-local shr-inhibit-images (not shr-inhibit-images))
  (eww-reload t)
  (message "Images are now %s"
           (if shr-inhibit-images "off" "on")))

(map! :leader
    (:prefix ("e". "eww-browser")
    :desc "Open new eww buffer" "o" #'eww))

(after! eww
  (set-popup-rule! "*eww*" :size 0.4 :vslot -4 :select t :quit nil :ttl 0 :side 'right)
  )

(use-package dashboard
  :init
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title nil)
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "~/.dotfiles/emacs/logo1c.png")  ;; use custom image as banner
  (setq dashboard-set-init-info t)
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (projects . 5)))
  (setq dashboard-set-navigator t)
  (setq dashboard-projects-backend 'projectile)
  (setq doom-fallback-buffer-name "*dashboard*")

:config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((bookmarks . "book"))))

(add-to-list 'recentf-exclude "/.emacs.d/.local/etc/workspaces/autosave") ;;hide recent files from recentf
(add-to-list 'projectile-ignored-projects "*.emacs.d")                 ;;hide emacs.d dir from projectile projects

;; (use-package flyspell
;;   :ensure nil
;;   :defer t
;;   :if (executable-find "aspell")
;;   :hook (((text-mode outline-mode latex-mode org-mode markdown-mode) . flyspell-mode))
;;   :custom
;;   (flyspell-issue-message-flag nil)
;;   (ispell-program-name "aspell")
;;   (ispell-extra-args
;;    '("--sug-mode=ultra" "--lang=en_US" "--camel-case"))
;;   )
(remove-hook 'org-mode-hook #'flyspell-mode)

(beacon-mode 1)