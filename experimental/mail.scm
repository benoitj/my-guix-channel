;;; Copyright © 2021 Benoit Joly <benoit@benoitj.ca>

(define-module (experimental mail)
  #:use-module (gnu packages golang)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system go))

(define-public go-gitlab.com-shackra-goimapnotify
  (let ((commit "832bc7112db9b28e28d69e90b91ea6c005244c9b")
        (revision "0"))
    (package
      (name "go-gitlab.com-shackra-goimapnotify")
      (version (git-version "0.0.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://gitlab.com/shackra/goimapnotify")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1h27kshx4vwl5k6vc2szsq3d701fzs4gczjypz907f8hj0lrnjmy"))))
      (build-system go-build-system)
      (arguments
       `(#:import-path "gitlab.com/shackra/goimapnotify"))
      (propagated-inputs
       `(("go-github-com-emersion-go-imap" ,go-github-com-emersion-go-imap)
         ("go-github-com-emersion-go-imap-idle" ,go-github-com-emersion-go-imap-idle)
         ("go-github-com-emersion-go-sasl" ,go-github-com-emersion-go-sasl)
         ("go-github-com-sirupsen-logrus" ,go-github-com-sirupsen-logrus)
         ("go-golang-org-x-text" ,go-golang-org-x-text)))
      (synopsis "Execute scripts on IMAP mailbox changes.")
      (description
       "Execute scripts on IMAP mailbox changes (new/deleted/updated messages) using IDLE, golang version.")
      (home-page "https://gitlab.com/shackra/goimapnotify")
      (license license:gpl3+))))
