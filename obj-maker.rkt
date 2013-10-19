#lang racket

(require racket/gui
         "dl.rkt")

(provide (struct-out title)
         (struct-out paragraph)
         (struct-out style-data)
         make-objects)

(struct title (font text))
(struct paragraph (text))
(struct style-data (delta))

(define (make-title-font [size 14] [face "Courier"] [family 'roman] [style 'normal]
                   [weight 'normal] [underline? #f] [font-smoothing 'default])
  (make-object font% size face family style weight underline? font-smoothing))

(define (make-paragraph-font [size 12] [face "Courier"] [family 'roman] [style 'normal]
                             [weight 'normal] [underline? #f] [font-smoothing 'default])
  (let ([style-delta (make-object style-delta%)])
    (send style-delta set-delta-face face family)
    (send style-delta set-delta 'change-size size)
    (send style-delta set-delta 'change-style style)
    (send style-delta set-delta 'change-weight weight)
    (send style-delta set-delta 'change-underline underline?)
    (send style-delta set-delta 'change-smoothing font-smoothing)
    style-delta))

(define (process-object obj)
  (let ([type (first obj)])
    (case type
      [(title) (let* ([font (second obj)]
                      [font-size (first font)]
                      [font-face (second font)]
                      [font-family (third font)]
                      [font-style (fourth font)]
                      [font-weight (fifth font)]
                      [text (third obj)])
                 (title (make-title-font font-size font-face font-family font-style font-weight) text))]
      [(paragraph) (let ([text (second obj)])
                     (paragraph text))]
      [(style-data) (let* ([font (second obj)]
                           [font-size (first font)]
                           [font-face (second font)]
                           [font-family (third font)]
                           [font-style (fourth font)]
                           [font-weight (fifth font)])
                      (style-data (make-paragraph-font font-size font-face font-family font-style font-weight)))])))

(define (make-objects [url 'test])
  (if (equal? url 'test)
      (let ([data (call-with-input-file "test.objs" read)])
        (map process-object data))
      (let ([data (get-text-data url)])
        (map process-object data))))

(module+ main
  (make-objects))