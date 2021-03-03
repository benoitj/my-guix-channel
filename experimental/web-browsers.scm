;; -*- mode: guix-scheme-*-

(define-module
  (experimental web-browsers)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages suckless)
  #:use-module (gnu packages web-browsers)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages xorg)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix build-system python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages qt))

(define-public qutebrowser-2
  (package
   (name "qutebrowser")
   (version "2.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/qutebrowser/"
                           "qutebrowser/releases/download/v" version "/"
                           "qutebrowser-" version ".tar.gz"))
       (sha256
        (base32 "0fxkazz4ykmkiww27l92yr96hq00qn5vvjmknxcy4cl97d2pxa28"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-attrs" ,python-attrs))) ; for tests
    (inputs
     `(("python-colorama" ,python-colorama)
       ("python-cssutils" ,python-cssutils)
       ("python-jinja2" ,python-jinja2)
       ("python-markupsafe" ,python-markupsafe)
       ("python-pygments" ,python-pygments)
       ("python-pypeg2" ,python-pypeg2)
       ("python-pyyaml" ,python-pyyaml)
       ("python-importlib-resources" ,python-importlib-resources)
       ;; FIXME: python-pyqtwebengine needs to come before python-pyqt so
       ;; that it's __init__.py is used first.
       ("python-pyqtwebengine" ,python-pyqtwebengine)
       ("python-pyqt" ,python-pyqt)
       ;; While qtwebengine is provided by python-pyqtwebengine, it's
       ;; included here so we can wrap QTWEBENGINEPROCESS_PATH.
       ("qtwebengine" ,qtwebengine)))
    (arguments
     `(;; FIXME: With the existance of qtwebengine, tests can now run.  But
       ;; they are still disabled because test phase hangs.  It's not readily
       ;; apparent as to why.
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-before 'check 'set-env-offscreen
           (lambda _
             (setenv "QT_QPA_PLATFORM" "offscreen")
             #t))
         (add-after 'install 'install-more
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (app (string-append out "/share/applications"))
                    (hicolor (string-append out "/share/icons/hicolor")))
               (install-file "doc/qutebrowser.1"
                             (string-append out "/share/man/man1"))
               (for-each
                (lambda (i)
                  (let ((src  (format #f "icons/qutebrowser-~dx~d.png" i i))
                        (dest (format #f "~a/~dx~d/apps/qutebrowser.png"
                                      hicolor i i)))
                    (mkdir-p (dirname dest))
                    (copy-file src dest)))
                '(16 24 32 48 64 128 256 512))
               (install-file "icons/qutebrowser.svg"
                             (string-append hicolor "/scalable/apps"))
               (substitute* "misc/org.qutebrowser.qutebrowser.desktop"
                 (("Exec=qutebrowser")
                  (string-append "Exec=" out "/bin/qutebrowser")))
               (install-file "misc/org.qutebrowser.qutebrowser.desktop" app)
               #t)))
         (add-after 'wrap 'wrap-qt-process-path
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin/qutebrowser"))
                    (qt-process-path (string-append
                                      (assoc-ref inputs "qtwebengine")
                                      "/lib/qt5/libexec/QtWebEngineProcess")))
               (wrap-program bin
                 `("QTWEBENGINEPROCESS_PATH" = (,qt-process-path)))
               #t))))))
    (home-page "https://qutebrowser.org/")
    (synopsis "Minimal, keyboard-focused, vim-like web browser")
    (description "qutebrowser is a keyboard-focused browser with a minimal
GUI.  It is based on PyQt5 and QtWebEngine.")
    (license license:gpl3+)))
