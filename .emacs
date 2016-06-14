;; show trailing whitespace
(setq show-trailing-whitespace t)

;; Visual feedback on selections
(setq-default transient-mark-mode t)

;; don't make tilde files
(setq backup-inhibited t)

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, don't just add lines forever
(setq next-line-add-newlines nil)

;; set various filename -> mode mappings
(setq auto-mode-alist
      (append '(("/mutt-" . mail-mode)
		("\\.m\\'" . matlab-mode))
	      auto-mode-alist))

;; make mail-mode a little fancier
(add-hook 'mail-mode-hook
	  (lambda ()
	    (font-lock-mode)
	    (flyspell-mode)
	    (setq fill-paragraph-function mail-mode-fill-paragraph)))

;; text mode stuff
(add-hook 'text-mode-hook
	  (lambda ()
	    (progn
	      (turn-on-auto-fill)
	      (local-unset-key "\M-s"))))

;; python mode stuff
(add-hook 'python-mode-hook
	  (lambda ()
	    (progn
	      (setq py-smart-indentation nil)
	      (setq indent-tabs-mode nil))))

;; emacs21-specific prettiness stuff
(when (eq emacs-major-version 21)
  (blink-cursor-mode nil)
  (setq font-lock-maximum-decoration t)
  (global-font-lock-mode t)
  (tool-bar-mode nil))

;; M-g-l: _G_o to _L_ine
(global-unset-key "\M-g\M-l")
(global-set-key "\M-g\M-l" 'goto-line)

;; don't show the startup message every time, I know I'm using emacs
(setq inhibit-startup-message t)

;; show time in the status bar
(load "time")
(display-time)

;; always show unified diffs; hope for GNU diff
(setq diff-switches "-u")

;; text mode stuff
(add-hook 'text-mode-hook
	  (lambda ()
	    (progn
	      (turn-on-auto-fill)
	      (local-unset-key "\M-s"))))

;; run the server so that we can do emacsclient from elsewhere
;(server-start)

(defun insert-timestamp () (interactive)
  "Insert a timestamp [user datetime] at the cursor location."
  (let ((time-date (current-time-string)))
    (insert (format "[%s %s]" user-login-name time-date))))
(global-set-key "\M-s" 'insert-timestamp)

; don't show annoying toolbar
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode 0))

(defun list-contains (haystack needle)
  "Returns t if haystack contains needle."
  (if (null haystack) nil
    (if (= needle (car haystack)) t
      (list-contains (cdr haystack) needle))))

(defun for-each (fn items)
  "Applies fn to each item in items.  Returns nil."
  (if (null items)
      nil
    (while items
      (funcall fn (car items))
      (setq items (cdr items)))))

(defun filter (fn items)
  "Returns a list of things from items for which fn returned t."
  (cond ((null items) nil)
	((funcall fn (car items))
	 (cons (car items) (filter fn (cdr items))))
	(t (filter fn (cdr items)))))

(defun add-to-load-path (path)
  "Adds a directory to the load-path."
  (message (format "Adding %s to load-path" path))
  (setq load-path (cons path load-path)))

;; add each subdirectory of ~/.site-lisp/ to the load-path
(setq my-site-lisp (concat (getenv "HOME") "/.site-lisp"))
(when (file-directory-p my-site-lisp)
  (let* ((base-dir (concat my-site-lisp "/"))
	 (dir-names
	  (mapcar (lambda (f) (concat base-dir f))
		  (filter (lambda (str) (not (string-match "^\\.\\.?$" str)))
			  (directory-files base-dir)))))
    (progn
      (for-each 'add-to-load-path dir-names)
      (add-to-load-path base-dir))))

;; load local modifications, if they exist, from $HOME/.emacs.local
(let ((my-own-dot-emacs (concat (getenv "HOME") "/.emacs.local")))
  (if (file-readable-p my-own-dot-emacs)
      (progn
	(message (format "Loading %s" my-own-dot-emacs))
	(load-file my-own-dot-emacs))))

;; emacs colors are in [0 .. (2^16)-1]
(setq max-color-value 65535)
(defun pct-to-intensity-value (pct)
  (round (* max-color-value (/ pct 100.0))))

;; the highlight line for hl-line-mode will be pct % lighter than the
;; background color
(setq my-hl-line-face-lighten-pct 10.0)
(defun lighten (color)
  "Lightens a color (3-tuple of ints) by a certain percentage
   of the maximum color value.  For example, '(0 0 0) lightened
   by 10% is '(6554 6554 6554)"
  (let* ((pct my-hl-line-face-lighten-pct)
	 (intensity-modulus (+ 1 max-color-value))
	 (lightness-delta (mod intensity-modulus
			       (pct-to-intensity-value pct))))
    (if (sequencep color)
	(mapcar (lambda (x) (+ x lightness-delta)) color)
      (+ color lightness-delta))))

(setq my-hl-line-face-background-color
      (let* ((color (or (x-color-values (face-attribute 'default :background))
			'(0 0 0)))
	     (lightened-color (format "#%04x%04x%04x"
				      (lighten (nth 0 color))
				      (lighten (nth 1 color))
				      (lighten (nth 2 color)))))
	(progn
	  (message (format "(lighten \"%s\") -> \"%s\""
			   color
			   lightened-color))
	  lightened-color)))

;; face for highlighting the current line in hl-line-mode
(defface my-hl-line-face
  `((t (:background "gray")))
  "Face for highlighted line in hl-line-mode"
  :group 'hl-line)

(set-face-attribute 'my-hl-line-face nil
		    :background my-hl-line-face-background-color)

; (setq hl-line-face 'my-hl-line-face)

;; if we're in X or, say, Windows, use hl-line-mode
(when window-system
  (mouse-wheel-mode t)
  (global-hl-line-mode t))

(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)

;; make backspace work in iterm (ugh)
(keyboard-translate ?\C-h ?\C-?)

;; color scheme
(load-theme 'wombat t)

;; web-mode
(if (require 'web-mode nil t)
    (progn
      (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
            (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))))
