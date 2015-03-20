#lang racket/base

(require racket/gui
         "dl.rkt"
         "datatypes.rkt")

(provide make-objects)

(define (make-title-font [size 14] [face "Courier"] [family 'roman]
                         [style 'normal] [weight 'normal]
                         [underline? #f] [font-smoothing 'default])
  (make-object font% size face family style weight underline? font-smoothing))

(define (make-paragraph-font [size 12] [face "Courier"] [family 'roman]
                             [style 'normal] [weight 'normal]
                             [underline? #f] [font-smoothing 'default])
  (let ([style-delta (make-object style-delta%)])
    (send style-delta set-delta-face face family)
    (send style-delta set-delta 'change-size size)
    (send style-delta set-delta 'change-style style)
    (send style-delta set-delta 'change-weight weight)
    (send style-delta set-delta 'change-underline underline?)
    (send style-delta set-delta 'change-smoothing font-smoothing)
    style-delta))

(define (process-object obj)
  (match obj
    [(list 'title (list 'font size face family style weight) text)
     (title (make-title-font size face family style weight)
            text)]
    [(list 'style-data (list 'delta size face family style weight))
     (style-data (make-paragraph-font size face family style weight))]
    [(list 'paragraph text) (paragraph text)]))

(define (make-objects uri)
  (map process-object (get-obj-data uri)))

(module+ main
  (make-objects "file://motd.obj"))
