;;; piha --- generate project files -*- lexical-binding: t -*-

(library (piha commands generate)
    (export
      generate)
  (import
    (silta base)
    (silta write)
    (only (srfi :13)
          string-join)
    (srfi :48 intermediate-format-strings)
    (loitsu file)
    (loitsu maali))

  (begin

      ;;; utility

      (define (spit-file path content)
        (format #t "\t created ~a" (paint path "#adff2f"))
        (newline)
        (spit path content))

    (define (generate-library root)
      (let ((lib-root (build-path root "lib")))
        (make-directory* lib-root)
        (make-directory* (build-path lib-root root))
        (generate-library-files root)))

    (define (generate-library-files root)
      (spit-file (build-path root "lib" root "cli.sls")
                 (content-lib-cli root))
      (spit-file (build-path root "lib" (string-append root ".sls"))
                 (content-lib-root root)))

    (define (generate-main-directory root)
      (cond
          ((file-exists? root)
           (display "directory exists!")
           (newline))
        (else
            (make-directory* root))))

    (define (generate-all root)
      (generate-main-directory root)
      (generate-library root))


    ;;; contents

    (define (content-lib-cli root)
      (string-join
       `(,(string-append "(library (" root " cli)")
         "(export runner)"
         "(import (silta base))"
         "(begin"
         "(define (runner args)"
         "(cadr args))"
         "))")
       "\n"))

    (define (content-lib-root root)
      (string-join
       `(,(string-append "(library (" root ")")
         "(export " root ")"
         "(import (silta base))"
         "(begin"
         ,(string-append "(define (" root ")")
         "'dummy)"
         "))")
       "\n"))


    (define (generate args)
      (let ((root (car args)))
        (generate-all root)))

    ))
