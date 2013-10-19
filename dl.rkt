#lang racket

(require net/url)
(provide get-binary-data
         get-text-data
         get-obj-data
         download-file)

(define (get-binary-data url)
  (call/input-url (string->url url) get-pure-port port->bytes))

(define (get-text-data url)
  (call/input-url (string->url url) get-pure-port port->string))

(define (get-obj-data url)
  (call/input-url (string->url url) get-pure-port read))

(define (download-file url type)
  (define base-filename (last (string-split url "/")))

  (define (download-binary-file)      
    (call-with-output-file base-filename
      (lambda (op) (write-bytes (get-binary-data url) op))
      #:mode 'binary #:exists 'replace))
  (define (download-text-file)
    (call-with-output-file base-filename
      (lambda (op) (write-string (get-text-data url) op))
      #:exists 'replace))

  (cond
    [(equal? type 'text) (download-text-file)]
    [(equal? type 'binary) (download-binary-file)]
    [else #f]))

