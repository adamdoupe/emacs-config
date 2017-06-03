 ; Set up stuff to include/uninclude based on OS
(setq adam-is-windows (or (string= "windows-nt" system-type)
			  (string= "msdos" system-type)))
(setq adam-is-linux (or (string= "gnu/linux" system-type)))

(setq adam-is-mac (or (string= "darwin" system-type)))

; mac specific stuff
(when adam-is-mac 
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil)

  (setenv "PATH" "/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/mysql/bin/")
  (setq exec-path (append exec-path '("/usr/local/bin" "/usr/local/sbin" "/usr/bin/" "/bin" "/usr/sbin" "/usr/local/mysql/bin/")))

  
  (add-to-list 'load-path "~/.emacs.d/emacs-w3m")
  (if window-system
      (require 'w3m-load)))

; default tab length
(setq-default tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                          64 68 72 76 80 84 88 92 96 100 104 108 112
                          116 120))

(setq-default python-indent 4)

(require 'cc-mode)
(require 'flymake)

; Plugin to deal with the flet deprecation
(add-to-list 'load-path "~/.emacs.d/el-x/lisp")

; cool stuff from steve Yegge's blog

; Enable C-x C-m or C-c C-m to be M-x
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

; disable the GUI

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))


; Flymake stuff
; (add-hook 'find-file-hook 'flymake-find-file-hook)

(global-font-lock-mode 1)
(setq compilation-window-height 8)

(setq c-default-style "ellemtel")

; set color for shell mode
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;disable stupid splash screen
(setq inhibit-splash-screen t)

; arc stuff
(when (or adam-is-linux adam-is-mac)
  (load-file "~/.emacs.d/arc.el")
  (load-file "~/.emacs.d/inferior-arc.el"))

; bbdb
;; (when (or adam-is-linux)
;;   (require 'bbdb-loaddefs "~/.emacs.d/bbdb/lisp/bbdb-loaddefs.el")
;;   (bbdb-initialize 'gnus 'message 'mail)
;;   (add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
;;   (bbdb-mua-auto-update-init 'gnus 'message 'mail)
;;   (setq bbdb-message-pop-up t)
;;   (setq compose-mail-user-agent-warnings nil)
;; )


;; (when (or adam-is-linux)
;;   (add-to-list 'load-path "~/.emacs.d/emacs_chrome/servers")
;;   (if (and (daemonp) (locate-library "edit-server"))
;; 	  (progn
;; 		(require 'edit-server)
;; 		(edit-server-start))))
  
; typescript stuff

(when (or adam-is-linux adam-is-mac)
  (add-to-list 'load-path "~/.emacs.d/typescript")
  (require 'typescript)
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode)))

; scala stuff
(when (or adam-is-linux adam-is-mac)
  (add-to-list 'load-path "~/.emacs.d/scala-emacs")
  (require 'scala-mode-auto)
  (add-to-list 'load-path "~/.emacs.d/ensime_2.9.2-0.9.8.1/elisp")
  (require 'ensime)
  (add-hook 'scala-mode-hook 'ensime-scala-mode-hook))

; add pointer to path to java
(when adam-is-linux
  (setenv "PATH"
 		  (concat
 		   "/opt/java/jre/bin" ":"
 		   (getenv "PATH"))))

; yaml stuff
(when (or adam-is-linux adam-is-mac)
  (add-to-list 'load-path "~/.emacs.d/yaml-mode")
  (require 'yaml-mode)
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

; slime stuff
(when (or adam-is-linux adam-is-mac)
  (add-to-list 'load-path "~/.emacs.d/slime/")
  (add-to-list 'load-path "~/.emacs.d/slime/contrib")
  
  ;; need to set the environment variables on Mac OSX
  (when adam-is-mac
    (setenv "CLOJURE_EXT" "/Users/adamd/.clojure"))


  (require 'slime-autoloads)

  (add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
  (add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
  (slime-setup '(slime-repl))

  (setq slime-lisp-implementations
	'((sbcl ("sbcl"))
	  (clisp ("clisp"))
	  (clojure ("~/bin/clojure-contrib/launchers/bash/clj-env-dir"))))

  (defmacro defslime-start (name mapping)
    `(defun ,name ()
       (interactive)
       (let ((slime-default-lisp ,mapping))
	 (slime))))

  (defslime-start sbcl 'sbcl)
  (defslime-start clojure 'clojure)
  (defslime-start clisp 'clisp)

  (add-to-list 'load-path "~/.emacs.d/clojure-mode/")
  (add-to-list 'load-path "~/.emacs.d/swank-clojure/")


  (require 'clojure-mode)

  (require 'swank-clojure)

  (setq swank-clojure-jar-path "/usr/share/java/clojure.jar"
	swank-clojure-extra-classpaths (list
					"~/.emacs.d/swank-clojure/src/main/clojure"
					"/usr/share/java/clojure-contrib.jar")))

; Hyperspec stuff
(when (or adam-is-linux adam-is-mac)	  
  (setq browse-url-browser-function 'w3m-browse-url))

(ignore-errors
  (require 'w3m-e21)
  (provide 'w3m-e23))

; remote file editing via ssh
;(add-to-list 'load-path "~/.emacs.d/tramp/lisp/")
(require 'tramp)

(when (or adam-is-linux adam-is-mac)
  (setq tramp-default-method "ssh")
  (set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:")))))



; php stuff
(load-file "~/.emacs.d/php-mode.el")
(require 'php-mode)

; git stuff
(when (or adam-is-linux)
  (when adam-is-linux 
    (setq load-path (cons (expand-file-name "/usr/share/doc/git-core/contrib/emacs") load-path)))
  (when adam-is-mac
    (setq load-path (cons (expand-file-name "/opt/local/share/doc/git-core/contrib/emacs") load-path)))
    
  (require 'vc-git)
  (when (featurep 'vc-git) (add-to-list 'vc-handled-backends 'git))
  (require 'git)
  (autoload 'git-blame-mode "git-blame"
    "Minor mode for incremental blame for Git." t))


; css stuff
;(load-file "~/.emacs.d/css-mode.el")
;(require 'css-mode)

; javascript stuff
(load-file "~/.emacs.d/js2/js2.elc")
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

; org-mode stuff
(when (or adam-is-linux adam-is-mac)
  (require 'org)
  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
  (define-key global-map "\C-ca" 'org-agenda)
  (setq org-log-done t)
  (setq org-agenda-files (list "~/research/phd.org")))

; Rails stuff
;; Interactively Do Thing
(require 'ido)
(ido-mode t)

;; Rinari
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)

;; nXhtml
;; nXhtml has a bug in in which diables latex mode, so 
;; I'm disabling it.
;(load "~/.emacs.d/nxhtml/autostart.el")

;; move autosave files to different directory
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

; Tell w3m to use cookies
(setq w3m-use-cookies t)

; Tell w3m to use title as buffer title
(setq w3m-use-title-buffer-name t)

;; ; cucumber for rails integration testing
;; (load-file "~/.emacs.d/cucumber.el/cucumber-mode.el")

; auto revert buffers when they change on disk
(global-auto-revert-mode)

; midnight mode to clean up buffers daily
(require 'midnight)

; set the font
(when adam-is-linux
  (setq default-frame-alist
	(append '((font . "-*-Menlo-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1"))
		default-frame-alist)))
  

(when (or adam-is-linux adam-is-mac)
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(org-agenda-files (quote ("~/research/phd.org"))))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   ))


; word count stuff
(defvar count-words-buffer
  nil
  "*Number of words in the buffer.")

(defun set-frame-for-hacking-group ()
  (interactive)
  (set-frame-font "-*-Menlo-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")
  (set-frame-parameter (selected-frame) 'alpha '(100 100)))

(defun set-frame-after-hacking-group ()
  (interactive)
  (set-frame-font "-*-Menlo-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1")
  (set-frame-parameter (selected-frame) 'alpha '(95 90)))

(defun wicked/update-wc ()
  (interactive)
  (setq count-words-buffer (concat (number-to-string (count-words-buffer)) " "))
  (setq adam-counting-words (adam-counting-words))
  (force-mode-line-update))

; only setup timer once
(unless count-words-buffer
  ;; seed count-words-paragraph
  ;; create timer to keep count-words-paragraph updated
  (run-with-idle-timer 1 t 'wicked/update-wc))

; add count words paragraph the mode line
(unless (memq 'count-words-buffer global-mode-string)
  (add-to-list 'global-mode-string "words: " t)
  (add-to-list 'global-mode-string 'count-words-buffer t))

(unless (memq 'adam-counting-words global-mode-string)
  (add-to-list 'global-mode-string 'adam-counting-words t))

;; count number of words in current paragraph
(defun count-words-buffer ()
  "Count the number of words in the current paragraph."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((count 0))
      (while (not (eobp))
        (forward-word 1)
        (setq count (1+ count)))
      count)))

(defvar adam-started-words nil)
(defvar adam-counting-words nil)

(defun start-counting-words ()
  (interactive)
  (set (make-local-variable 'adam-started-words) (count-words-buffer)))

(defun adam-counting-words ()
  (interactive)
  (when adam-started-words
    (let* ((initial adam-started-words)
	   (current (count-words-buffer))
	   (diff-num (- current initial))
	   (diff-str (concat (number-to-string diff-num) " ")))
      (if (< 0 diff-num)
	  (concat "+" diff-str)
	diff-str))))

(put 'narrow-to-region 'disabled nil)

; bro stuff

(load-file "~/.emacs.d/bro-mode.el")

; htmlfontify
(load-file "~/.emacs.d/htmlfontify/htmlfontify.el")
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/research/phd.org")))
 '(safe-local-variable-values (quote ((eval rename-buffer "gallery init.pp") (eval rename-buffer "mysql init.pp") (eval rename-buffer "bash init.pp") (ruby-compilation-executable . "ruby") (ruby-compilation-executable . "ruby1.8") (ruby-compilation-executable . "ruby1.9") (ruby-compilation-executable . "rbx") (ruby-compilation-executable . "jruby")))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

; markdown mode
; Add to load-path
(add-to-list 'load-path "~/.emacs.d/markdown-mode/")
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))


; EasyPG stuff
(when adam-is-linux
  (epa-file-enable))

; fullscreen on mac
(when adam-is-mac
  (define-key global-map (kbd "<M-S-return>")  'toggle-frame-fullscreen))

; gnus
(setq gc-cons-threshold 3500000)
(put 'set-goal-column 'disabled nil)

(put 'downcase-region 'disabled nil)

; Randomize region from http://www.mail-archive.com/gnu-emacs-sources@gnu.org/msg00034.html
;; Copyright (C) 2005 Joe Corneli <[EMAIL PROTECTED]>
(defun randomize-region (beg end)
  (interactive "r")
  (if (> beg end)
      (let (mid) (setq mid end end beg beg mid)))
  (save-excursion
    ;; put beg at the start of a line and end and the end of one --
    ;; the largest possible region which fits this criteria
    (goto-char beg)
    (or (bolp) (forward-line 1))
    (setq beg (point))
    (goto-char end)
    ;; the test for bolp is for those times when end is on an empty
    ;; line; it is probably not the case that the line should be
    ;; included in the reversal; it isn't difficult to add it
    ;; afterward.
    (or (and (eolp) (not (bolp)))
        (progn (forward-line -1) (end-of-line)))
    (setq end (point-marker))
    (let ((strs (shuffle-list 
                 (split-string (buffer-substring-no-properties beg end)
                             "\n"))))
      (delete-region beg end)
      (dolist (str strs)
        (insert (concat str "\n"))))))

(defun shuffle-list (list)
  "Randomly permute the elements of LIST.
All permutations equally likely."
  (let ((i 0)
  j
  temp
  (len (length list)))
    (while (< i len)
      (setq j (+ i (random (- len i))))
      (setq temp (nth i list))
      (setcar (nthcdr i list) (nth j list))
      (setcar (nthcdr j list) temp)
      (setq i (1+ i))))
  list)

(defun url-decode-region (start end)
  "Replace a region with the same contents, only URL decoded."
  (interactive "r")
  (let ((text (url-unhex-string (buffer-substring start end))))
    (delete-region start end)
    (insert text)))

(defun url-encode-region (start end)
  "Replace a region with the same contents, only URL decoded."
  (interactive "r")
  (let ((text (url-hexify-string (buffer-substring start end) ())))
    (delete-region start end)
    (insert text)))


(defun my-delete-leading-whitespace (start end)
  "Delete whitespace at the beginning of each line in region."
  (interactive "*r")
  (save-excursion
    (if (not (bolp)) (forward-line 1))
    (delete-whitespace-rectangle (point) end nil)))

; The colors blue, the colors
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0/")
(require 'color-theme)
(color-theme-initialize)
(color-theme-calm-forest)

; alpha 
(when adam-is-mac
  (set-frame-parameter (selected-frame) 'alpha '(95 90))
  (add-to-list 'default-frame-alist '(alpha 95 90)))


; thesaurus
(add-to-list 'load-path "~/.emacs.d/synonyms/")
(setq synonyms-file "~/.emacs.d/synonyms/mthesaur.txt")
(setq synonyms-cache-file "~/.emacs.d/synonyms/mthesaur.txt.cache")
(require 'synonyms)

; add minor modes to latex mode
(add-hook 'latex-mode-hook 
	  (lambda () 
	    (auto-fill-mode t)
	    (setq ispell-parser 'tex)
	    (flyspell-mode t)))

; have latex mode be the default when opening a .tex file
(add-to-list 'auto-mode-alist '("\\.tex\\'" . latex-mode))

; make sentences end with single space
(setq sentence-end-double-space nil) 

; ocaml
(add-to-list 'load-path "~/.emacs.d/tuareg-2.0.4/")
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)
(setq auto-mode-alist 
      (append '(("\\.ml[ily]?$" . tuareg-mode)
		("\\.topml$" . tuareg-mode))
	      auto-mode-alist))

; graphviz-dot-mode
(load-file "~/.emacs.d/graphviz-dot-mode.el") 
; markdown-mode  

; enable eval in local variables
(setq enable-local-eval t)

;; ; front-end for ack
;; (add-to-list 'load-path "~/.emacs.d/full-ack/")
;; (autoload 'ack-same "full-ack" nil t)
;; (autoload 'ack "full-ack" nil t)
;; (autoload 'ack-find-same-file "full-ack" nil t)
;; (autoload 'ack-find-file "full-ack" nil t)

(defun replace-html-chars-region (start end)
  "Replace “<” to “&lt;” and other chars in HTML.
This works on the current region."
  (interactive "r")
  (save-restriction 
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (search-forward "&" nil t) (replace-match "&amp;" nil t))
    (goto-char (point-min))
    (while (search-forward "<" nil t) (replace-match "&lt;" nil t))
    (goto-char (point-min))
    (while (search-forward ">" nil t) (replace-match "&gt;" nil t))
    )
  )

; Cool plugin to have multiple cursors
(add-to-list 'load-path "~/.emacs.d/multiple-cursors.el/")
(require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(put 'upcase-region 'disabled nil)

; Dockerfile mode
(add-to-list 'load-path "~/.emacs.d/dockerfile-mode/")
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

; Function to help with org-mode
(defun my-org-archive-done-tasks ()
  (interactive)
  (dotimes (i 10)
	(org-map-entries 'org-archive-subtree "/DONE" 'file)))

; abbrevs (to fix my common typos
(setq abbrev-file-name             ;; tell emacs where to read abbrev
	  "~/.emacs.d/abbrev_defs")    ;; definitions from...

(setq save-abbrevs t)              ;; save abbrevs when files are saved you will be asked before the abbreviations are saved

(add-hook 'text-mode-hook (lambda () (abbrev-mode 1))) ;; Only have abbrevs in text mode


; Use visual mode to expand to a certain number of columns regardless
; I use this to edit latex without autofilling someone else's work
(defvar visual-wrap-column nil)

(defun set-visual-wrap-column (new-wrap-column &optional buffer)
      "Force visual line wrap at NEW-WRAP-COLUMN in BUFFER (defaults
    to current buffer) by setting the right-hand margin on every
    window that displays BUFFER.  A value of NIL or 0 for
    NEW-WRAP-COLUMN disables this behavior."
      (interactive (list (read-number "New visual wrap column, 0 to disable: " (or visual-wrap-column fill-column 0))))
      (if (and (numberp new-wrap-column)
               (zerop new-wrap-column))
        (setq new-wrap-column nil))
      (with-current-buffer (or buffer (current-buffer))
        (visual-line-mode t)
        (set (make-local-variable 'visual-wrap-column) new-wrap-column)
        (add-hook 'window-configuration-change-hook 'update-visual-wrap-column nil t)
        (let ((windows (get-buffer-window-list)))
          (while windows
            (when (window-live-p (car windows))
              (with-selected-window (car windows)
                (update-visual-wrap-column)))
            (setq windows (cdr windows))))))

(defun update-visual-wrap-column ()
      (if (not visual-wrap-column)
        (set-window-margins nil nil)
        (let* ((current-margins (window-margins))
               (right-margin (or (cdr current-margins) 0))
               (current-width (window-width))
               (current-available (+ current-width right-margin)))
          (if (<= current-available visual-wrap-column)
            (set-window-margins nil (car current-margins))
            (set-window-margins nil (car current-margins)
                                (- current-available visual-wrap-column))))))


; hotcrp mode

(load-file "~/.emacs.d/hotcrp-mode.el") 
(autoload 'hotcrp-mode "hotcrp-mode" nil t)
(autoload 'hotcrp-fetch "hotcrp-mode" nil t)
(add-to-list 'magic-mode-alist
			 '("\\`==\\+== .* Paper Review Form" . hotcrp-mode))

;; Want to get auto fill mode and flyspell when hot crp editing
;; Also, to preserve a little annonymity, set fill column to random amount 

(add-hook 'hotcrp-mode-hook
	  (lambda () 
	    (auto-fill-mode t)
	    (flyspell-mode t)
		(set-fill-column (+ 70 (random 20)))))



; editing emails in mutt using emacs
(add-to-list 'auto-mode-alist '("/mutt" . mail-mode))
(server-start)

;; Want to get auto fill mode and flyspell when emailing
(add-hook 'mail-mode-hook
	  (lambda () 
	    (auto-fill-mode t)
	    (flyspell-mode t)
		(mail-text)))

;; Want to change font based on quoted level
(add-hook 'mail-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
									'(("^[ \t]*>[ \t]*>[ \t]*>.*$"
									   (0 'mail-multiply-quoted-text-face))
									  ("^[ \t]*>[ \t]*>.*$"
									   (0 'mail-double-quoted-text-face))))))



