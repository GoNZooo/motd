#lang racket/gui

(require "dl.rkt")
(require "remote-data.rkt") ; Provides remote-location = url-string

(define top-frame (new frame% [label "Hey, You. :)"]))

(define (make-font [size 12] [face "Courier"] [family 'roman] [style 'normal]
                   [weight 'normal] [underline? #f] [font-smoothing 'default])
  (make-object font% size face family style weight underline? font-smoothing))

(define title-panel (new horizontal-panel% [parent top-frame]
                         [vert-margin 16]
                         [alignment '(center top)]
                         [stretchable-width #f]
                         [stretchable-height #f]))

(define paragraph-panel (new horizontal-panel% [parent top-frame]
                             [alignment '(center top)]
                             [horiz-margin 24]))

(define paragraph-text (new text% [auto-wrap #t] [line-spacing 5]))
(define (add-paragraph paragraph-content)
  (send paragraph-text insert (string-append paragraph-content "\n\n")))


;; Eventually the font stuff is supposed to be dealt with on a objs-spec basis
(define title-font (make-font 14 "Courier" 'roman 'normal 'bold))

;; Styles (fonts, etc.) in editors are managed with a style/style-delta system
;; and what's done here is we create a style delta object that we set changes
;; for and then we apply those changes to the editor, paragraph-text
(define courier-roman-delta (make-object style-delta%))
(send courier-roman-delta set-delta-face "Courier" 'roman)
(send courier-roman-delta set-delta 'change-size 12)
(send paragraph-text change-style courier-roman-delta)

; Originally I'd planned to use a transparent canvas, but it ended up messing up some
; stuff with kerning and the like. Weird spaces in the middle of words started showing up.
(define paragraph-canvas (new editor-canvas% [parent paragraph-panel]
                              [editor paragraph-text]
                              [style '(no-border auto-hscroll auto-vscroll)]
                              [enabled #f]))

;; Anything from this point on is supposed to be dynamically read from
;; whatever source we use. The source is supposed to supply
;; the frontend with content.
(define title-msg (new message% [parent title-panel]
                       [label "This is a test. Do not turn off your TV set."]
                       [font title-font]))

(add-paragraph "Jag testar att sitta och skriva här ett tag så märker jag sen om det blir konstig kerning. Personligen tror jag inte att den pallar med allt när man ska köra en transparent editor-canvas. En lösning vore väl att köra en grå bakgrund på själva canvasen, men jag vet inte exakt hur jag skulle göra det. Det känns inte så himla relevant i slutändan, så jag vet inte.")

(add-paragraph "Ännu en paragraf, bara för att fylla skiten med text. Det är otroligt svårt att bara skriva för att skriva, har jag märkt. Man måste ju ha något att säga, oftast, vilket sällan kommer på beställning så här. En bra grej med det är att man kan få idén att skriva om hur svårt det är att bara komma på något att skriva, så då löser det ju sig självt, kan man säga.")

(send top-frame show #t)