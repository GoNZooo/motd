#lang racket

(require net/url
         "datatypes.rkt")

(provide get-obj-data)

(define (get-obj-data uri)
  (define (get-remote-data source)
    (call/input-url (string->url source)
                    get-pure-port
                    read
                    '("Cache-Control: no-cache")))

  (define (get-local-data source)
    (call-with-input-file source read))

  (match uri
    [(pregexp #px"^http://(.*)" (list fm sm)) (get-remote-data sm)]
    [(pregexp #px"^file://(.*)" (list fm sm)) (get-local-data sm)]
    [_ (paragraph "Unable to access obj file; invalid protocol.")]))
