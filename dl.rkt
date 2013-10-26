#lang racket

(require net/url)
(provide get-obj-data)

(define (get-obj-data url)
  (call/input-url (string->url url)
                  get-pure-port
                  read
                  '("Cache-Control: no-cache")))
