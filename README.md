# my-guix-channel
guix related packages not yet in guix, or that will not be in guix

add this to your channels.scm file:

```scheme
       (channel
        (name 'benoitj)
        (url "https://github.com/benoitj/my-guix-channel.git")
	(branch "main")
        (introduction
         (make-channel-introduction
          "724e80321be1ef48dd56254a3ed7ef3b523bedaf"
          (openpgp-fingerprint
           "EFD0 C2C5 8A1B 9549 FD6F  45B5 5EBD C9DD 393D 3897"))))
```
