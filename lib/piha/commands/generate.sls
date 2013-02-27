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

    ;;; generates

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

    (define (content-library name exports imports body)
      (let ((imps (string-join (map (lambda (x) (string-append "(" x ")"))
                                 imports)
                    "\n")))
        (string-join
            `(,(string-append "(library (" name ")")
              ,(string-append "(export " exports ")")
              ,(string-append "(import " imps ")")
              "(begin"
              ,body
              "))")
          "\n")))

    (define (content-lib-cli root)
      (let ((name (string-append root " " "cli"))
            (exports "runner")
            (imports `("silta base"))
            (body (string-join '("(define (runner args)"
                                 "(cadr args))") "\n")))
        (content-library name exports imports body)))

    (define (content-lib-root root)
      (let ((name root)
            (exports root)
            (imports `("silta base"))
            (body (string-join `(,(string-append "(define (" root ")")
                                 "'dummy)") "\n")))
        (content-library name exports imports body)))


    ;;; main

    (define (generate args)
      (let ((root (car args)))
        (generate-all root)))

    ))
