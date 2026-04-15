;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ==========================================
;; 1. USER IDENTITY & FONTS
;; ==========================================
;;(setq user-full-name "My Name"
;;      user-mail-address "private@email.com")
(load! "secrets.el" nil t)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 14)
      doom-theme 'doom-one)

(setq display-line-numbers-type t
      org-directory "~/org/")

;; ==========================================
;; 2. MODELINE & SYSTEM STATUS
;; ==========================================
(doom-modeline-mode 1)
(display-battery-mode 1)
(display-time-mode 1)
(after! doom-modeline
  (setq display-time-24hr-format t
        display-time-day-and-date t
        display-time-default-load-average nil))

;; ==========================================
;; 3. EXWM CONFIGURATION (Logic & Keys)
;; ==========================================
(after! exwm
  (setq exwm-workspace-number 4)

  ;; standard exwm-modeline setup
  (add-hook 'exwm-init-hook #'exwm-modeline-mode)

  ;; This ensures the segment is available to Doom
  (exwm-modeline-mode 1)

  ;; Helper to run shell commands
  (defun my/exwm-exec (command)
    (start-process-shell-command "exwm-exec" nil command))

  ;; Global keybindings
  (setq exwm-input-global-keys
        `(([?\s-w] . exwm-workspace-switch)
          ;; Application Launcher (s-&)
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))
          ;; Workspace switching (s-0 through s-9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda () (interactive) (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  ;; X270 Hardware Keys (Volume/Brightness)
  (exwm-input-set-key (kbd "<XF86AudioRaiseVolume>") (lambda () (interactive) (my/exwm-exec "pactl set-sink-volume @DEFAULT_SINK@ +5%")))
  (exwm-input-set-key (kbd "<XF86AudioLowerVolume>") (lambda () (interactive) (my/exwm-exec "pactl set-sink-volume @DEFAULT_SINK@ -5%")))
  (exwm-input-set-key (kbd "<XF86AudioMute>")        (lambda () (interactive) (my/exwm-exec "pactl set-sink-mute @DEFAULT_SINK@ toggle")))
  (exwm-input-set-key (kbd "S-<XF86AudioMicMute>")   (lambda () (interactive) (my/exwm-exec "pactl set-source-volume @DEFAULT_SOURCE@ +5%")))
  (exwm-input-set-key (kbd "C-<XF86AudioMicMute>")   (lambda () (interactive) (my/exwm-exec "pactl set-source-volume @DEFAULT_SOURCE@ -5%")))
  (exwm-input-set-key (kbd "<XF86AudioMicMute>")     (lambda () (interactive) (my/exwm-exec "pactl set-source-mute @DEFAULT_SOURCE@ toggle")))
  (exwm-input-set-key (kbd "<XF86MonBrightnessUp>")   (lambda () (interactive) (my/exwm-exec "brightnessctl set +10%")))
  (exwm-input-set-key (kbd "<XF86MonBrightnessDown>") (lambda () (interactive) (my/exwm-exec "brightnessctl set 10%-")))

  ;; Quick Launch
  (exwm-input-set-key (kbd "s-q") (lambda () (interactive) (start-process "qutebrowser" nil "qutebrowser")))

  ;; Browser/App Simulation Keys (Emacs navigation in external apps)
  (setq exwm-input-simulation-keys
        '(([?\C-b] . left) ([?\C-f] . right) ([?\C-p] . up) ([?\C-n] . down)
          ([?\C-a] . home) ([?\C-e] . end) ([?\C-v] . next) ([?\M-v] . prior)
          ([?\C-d] . delete) ([?\C-k] . (S-end delete)) ([?\C-w] . [?\C-x])
          ([?\M-w] . [?\C-c]) ([?\C-y] . [?\C-v]) ([?\C-s] . [?\C-f]))))


;; ==========================================
;; 4. EXWM ACTIVATION
;; ==========================================
;; Start EXWM if not already running
(unless (bound-and-true-p exwm-wm-mode)
  (require 'exwm)
  (exwm-wm-mode 1))

;; ==========================================
;; 5. DATA SCIENCE / R (ESS)
;; ==========================================
(after! ess
  (setq ess-eval-visibility 'nowait)

  (defun +ess-open-rstudio-layout ()
    "Start R and set up a 2-column layout (Code | Console)."
    (unless (get-buffer "*R*") (R))
    (delete-other-windows)
    (split-window-right)
    (other-window 1)
    (switch-to-buffer "*R*")
    (other-window -1))

  (add-hook 'ess-r-mode-hook #'+ess-open-rstudio-layout))
