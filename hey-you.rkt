#lang racket/gui

(require "dl.rkt")
(require "remote-data.rkt") ; Provides remote-location = url-string

(define top-frame (new frame% [label "Hey, You. :)"]))

;; Anything from this point on is supposed to be dynamically read from
;; whatever remote source we use. The source is, as such, supposed to supply
;; the frontend with object-specifications that it can follow.

(define title-panel (new horizontal-panel% [parent top-frame]
                         [vert-margin 16]
                         [alignment '(center top)]
                         [stretchable-width #f]
                         [stretchable-height #f]))
(define title-font (make-object font% 14 "Courier" 'roman 'normal 'bold))
(define title-msg (new message% [parent title-panel]
                       [label "Title here"]
                       [font title-font]))

(define paragraph-panel (new horizontal-panel% [parent top-frame]
                             [alignment '(center top)]
                             [horiz-margin 25])) ;; For proper framing.
(define paragraph-font (make-object font% 12 "Courier" 'roman 'normal 'normal))
(define paragraph-text (new text% [auto-wrap #t] [line-spacing 5]))

(define (add-paragraph text-object paragraph-content)
  (send text-object insert (string-append paragraph-content "\n\n\t")))

(add-paragraph paragraph-text "This is a very short test-paragraph. It can be added to. How much is a very interesting thing, and I think that it'll be quite a lot when I use an editor-canvas.")
(add-paragraph paragraph-text "This is the second paragraph and because I'm not feeling very creative it's not going to be very long. I feel like it doesn't matter, though, since to some extent it's going to show what's happening anyway.")
(define paragraph-editor (new editor-canvas% [parent paragraph-panel]
                              [editor paragraph-text]
                              [style '(no-border auto-hscroll auto-vscroll)]
                              [enabled #f]))
(send paragraph-editor set-editor paragraph-text)

(send top-frame show #t)