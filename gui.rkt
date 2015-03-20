#lang racket/gui

(require "dl.rkt"
         "remote-data.rkt" ; Exports 'remote-location' of type string, URI
         "obj-maker.rkt"
         "datatypes.rkt")

(provide motd)

(define (motd window-title window-height window-width)
  ;; Set up a future
  ;; This might not be run in parallel because futures apparently
  ;; don't handle some operations very well.
  ;; So the remote fetch might end up being run straight up instead.
  (define future-objects (future (lambda ()
                                   (make-objects remote-location))))

  (define (spawn-objects object-blob)
    (define (spawn-object obj)
      (match obj
        [(title font text) (new message% [parent title-panel]
                                [label text]
                                [font font])]
        [(style-data delta) (send paragraph-editor
                                  change-style
                                  delta)]
        [(paragraph text) (add-paragraph text)]))
    
    (for-each spawn-object object-blob))

  (define top-frame (new frame% [label window-title]
                         [min-height window-height] [min-width window-width]))

  (define title-panel (new horizontal-panel% [parent top-frame]
                           [vert-margin 8] [alignment '(center top)]
                           [stretchable-width #f] [stretchable-height #f]))

  (define paragraph-panel (new horizontal-panel% [parent top-frame]
                               [alignment '(center top)] [horiz-margin 24]))

  (define paragraph-editor (new text% [auto-wrap #t]))

  (define (add-paragraph paragraph-content)
    (send paragraph-editor insert (string-append paragraph-content "\n\n")))

  (define paragraph-canvas (new editor-canvas% [parent paragraph-panel]
                                [editor paragraph-editor] [enabled #t]
                                [style '(no-border
                                         no-focus
                                         auto-hscroll
                                         auto-vscroll)]))

  (spawn-objects (touch future-objects))

  (send top-frame show #t))

(module+ main
  (motd "Hey, you. :)" 550 550))
