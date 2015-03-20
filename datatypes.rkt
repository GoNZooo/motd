#lang racket/base

(provide (struct-out title)
         (struct-out paragraph)
         (struct-out style-data)
         (struct-out font)
         (struct-out delta))

(struct font (size face family style weight) #:transparent)
(struct title (font text) #:transparent)
(struct paragraph (text) #:transparent)
(struct delta (size face family style weight) #:transparent)
(struct style-data (delta) #:transparent)
