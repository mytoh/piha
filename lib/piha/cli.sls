(library (piha cli)
    (export
      runner)
  (import
    (silta base)
    (silta write)
    (loitsu cli)
    (prefix (piha commands)
            command:))

  (begin

    (define (help)
      (display
          "piha <command> <args>

commands:
    generate
"))

    (define (runner args)
      (cond ((< (length args) 2)
             (help))
        (else
            (match-short-command (cadr args)
              ("generate"
               (command:generate (cddr args)))))))

    ))
