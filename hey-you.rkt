#lang racket/gui

(require "dl.rkt"
         "remote-data.rkt" ; Provides remote-location = url-string
         "obj-maker.rkt")

(define (spawn-object obj)
  (cond
   [(title? obj) (new message% [parent title-panel] [label (title-text obj)] [font (title-font obj)])]
   [(style-data? obj) (send paragraph-editor change-style (style-data-delta obj))]
   [(paragraph? obj) (add-paragraph (paragraph-text obj))]))

(define top-frame (new frame% [label "Hey, You. :)"]))

(define title-panel (new horizontal-panel% [parent top-frame]
                         [vert-margin 8]
                         [alignment '(center top)]
                         [stretchable-width #f]
                         [stretchable-height #f]))

(define paragraph-panel (new horizontal-panel% [parent top-frame]
                             [alignment '(center top)]
                             [horiz-margin 24]))

(define paragraph-editor (new text% [auto-wrap #t] [line-spacing 5]))
(define (add-paragraph paragraph-content)
  (send paragraph-editor insert (string-append paragraph-content "\n\n")))

; Originally I'd planned to use a transparent canvas, but it ended up messing up some
; stuff with kerning and the like. Weird spaces in the middle of words started showing up.
(define paragraph-canvas (new editor-canvas% [parent paragraph-panel]
                              [editor paragraph-editor]
                              [style '(no-border auto-hscroll auto-vscroll)]
                              [enabled #f]))

(for-each spawn-object (make-objects remote-location))

(send top-frame show #t)