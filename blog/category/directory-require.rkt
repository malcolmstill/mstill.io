#lang racket/base
(require pollen/decode 
	 txexpr
	 pollen/tag
	 racket/list
	 racket/string
	 racket/date
	 racket/match
	 pollen/pygments
	 pollen/template
	 hyphenate
	 racket/function
	 pollen-count)

(provide tag-in-file?
	 get-elements
	 add-between
	 date->string
	 seconds->date
	 format-cats)
(provide (all-defined-out))


#|
Functions for use in template: remove-tags, tag-in-file?, select-element, format-cat
|#
;; Function to remove tags from txexpr (used, for example, in setting the title of an HTML page stripping out any italics etc.
(define (remove-tags txexpr)
  (map (λ (x)
         (if (txexpr? x)
             (remove-tags x)
             x)) (get-elements txexpr)))

(define (tag-in-file? tag file)
  (if (select-from-metas 'categories file)
      (findf (λ (x)
	       (equal? x tag))
	     (get-elements (select-from-metas 'categories file)))
      #f))

(define (select-element tag container location)
  (findf (lambda (x)
           (and (list? x) (equal? (car x) 'p)))
	 (select* container location)))

(define (category->link category)
  `(a [[href ,(string-append "category/" category ".html")]]
      ,category))


(define (format-cats cats)
  (add-between (map category->link (get-elements cats)) ", "))
