#lang racket/gui

(require "dl.rkt"
         "remote-data.rkt" ; remote-location = url-string, obscured for git-repo
         "obj-maker.rkt")

(define (spawn-objects object-blob)
  (define (spawn-object obj)
    (cond
     [(title? obj) (new message% [parent title-panel] [label (title-text obj)]
                        [font (title-font obj)])]
     [(style-data? obj)
      (send paragraph-editor change-style (style-data-delta obj))]
     [(paragraph? obj) (add-paragraph (paragraph-text obj))]))
  (for-each spawn-object object-blob))

(define top-frame (new frame% [label "Hey, You. :)"]
                       [min-height 640] [min-width 480]))

(define title-panel (new horizontal-panel% [parent top-frame] [vert-margin 8]
                         [alignment '(center top)]
                         [stretchable-width #f] [stretchable-height #f]))

(define paragraph-panel (new horizontal-panel% [parent top-frame]
                             [alignment '(center top)] [horiz-margin 24]))

(define paragraph-editor (new text% [auto-wrap #t] [line-spacing 5]))

(define (add-paragraph paragraph-content)
  (send paragraph-editor insert (string-append paragraph-content "\n\n")))

(define paragraph-canvas (new editor-canvas% [parent paragraph-panel]
                              [editor paragraph-editor]
                              [style '(no-border auto-hscroll auto-vscroll)]
                              [enabled #f]))

(spawn-objects (make-objects remote-location))

(send top-frame show #t)