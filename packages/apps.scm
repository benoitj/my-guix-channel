(define-module (packages apps)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system cargo)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-graphics)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control))


(define-public ncspot
  (package
    (name "ncspot")
    (version "0.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri name version))
        (file-name
         (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "0n84n4yshifd5wvqrh9w4mkrycbw4v2hwb6wdw05mg3ycvw642jh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/hrkfdn/ncspot")
    (synopsis "ncurses Spotify client written in Rust using librespot")
    (description
     "ncurses Spotify client written in Rust using librespot library.")
    (license license:bsd-2)))
