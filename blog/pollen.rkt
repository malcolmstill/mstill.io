#lang racket/base
(require pollen/decode 
	 txexpr
	 pollen/tag
	 racket/list
	 racket/string
	 racket/date
	 racket/match
         pollen/core
	 pollen/unstable/pygments
	 pollen/template
	 hyphenate
	 racket/function
	 pollen-count)

(provide highlight
	 make-highlight-css
	 get-elements
	 add-between)
(provide (all-defined-out))

(module setup racket/base
  (provide (all-defined-out))
  (require pollen/setup)
  (define block-tags (append '(subsection subsubsection label img pre) default-block-tags)))

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
             (cat-string->list (select-from-metas 'categories file)))
      #f))

(define (select-element tag container location)
  (findf (lambda (x)
           (and (list? x) (equal? (car x) 'p)))
	 (select* container location)))

(define (category->link category)
  `(a [[href ,(string-append "http://mstill.io/blog/category/" category ".html")]]
      ,category))

(define (cat-string->list string)
  (map (λ (tag)
         (apply string-append tag))
       (map (λ (tag)
              (add-between tag " "))
            (map string-split (map string-trim (string-split string ","))))))

(define (format-cats cats)
  (add-between (map category->link (cat-string->list cats)) ", "))

(define (remove-supref txexpr)
  (define-values (stripped _)
    (splitf-txexpr txexpr
		   (λ (x) 
		     (and (txexpr? x)
			  (and (attrs-have-key? x 'class)
			       (equal? (attr-ref x 'class) "supref"))))))
  stripped)

#|
Functions for typography
|#

#|
See https://github.com/malcolmstill/mstill.io/issues/1
|#
(define (my-hyphenate tx)
  (define (omitter tx)
    (or (equal? (car tx) 'code) ; 'code tags
        (and (equal? (car tx) 'span) ; 'span tags that also have class="no-hyphens"
             (attrs-have-key? tx 'class) 
             (equal? (attr-ref tx 'class) "no-hyphens"))))

  (if (member (car tx) '(p aside)) ; only hyphenate 'p or 'aside tags
      (hyphenate #:omit-txexpr omitter tx)
      tx))

(define (element-processing elements)
  (decode-elements elements
		   #:txexpr-elements-proc detect-paragraphs
		   #:block-txexpr-proc (compose1 my-hyphenate
						 wrap-hanging-quotes)
		   #:exclude-tags '(style script pre)
		   #:string-proc (compose smart-quotes smart-dashes)))

(define (typofy-with-tag tag elements)
   (make-txexpr tag null (element-processing elements)))
(define (typofy txexpr)
  (make-txexpr (get-tag txexpr)
               (get-attrs txexpr)
               (element-processing (get-elements txexpr))))

#|
Register the following blocks so they're ignored by detect-paragraphs
|#
;(register-block-tag 'subsection)
;(register-block-tag 'subsubsection)
;(register-block-tag 'label)
;(register-block-tag 'img)
;(register-block-tag 'pre)

(define (marginalia left right . content)
  `(div [[class "flx"]]
	(div [[class "margin"]] ,(attr-set left 'class "left"))
	,@content
	(div [[class "margin"]] ,(attr-set right 'class "right"))))

(define (image width src text)
  `(figure [[style ,(string-append "max-width:" width ";")]]
	   (img [[src ,src] 
		 [alt ,text]])))

(define (strike . text)
  `(span ((class "strike")) ,@text))

(define (datestring->date datetime)
  (match (string-split datetime)
    [(list date time) (match (map string->number (append (string-split date "/") (string-split time ":")))
                        [(list day month year hour minutes) (date->string (seconds->date (find-seconds 0
                                                                                                       minutes
                                                                                                       hour
                                                                                                       day
                                                                                                       month
                                                                                                       year)))])]
    [(list date) (match (map string->number (string-split date "/"))
                   [(list day month year) (date->string (seconds->date (find-seconds 0
                                                                                     0
                                                                                     0
                                                                                     day
                                                                                     month
                                                                                     year)))])]))

(define headline (make-default-tag-function 'h1))

(define (format-date string)
  (match (string-split (datestring->date string))
    [(list day month date year) `(,day " " ,month " " (span ((class "ord")) ,date) " " ,year)]))

(define (link url . text)
  `(a [[href ,url]] ,@text))

(define (supref . text)
  `(span ((class "supref")) ,@text))

;; Thanks to mbutterick for help with this. See https://github.com/mbutterick/pollen/issues/55

(define (heading->toc-entry heading)
  `(div [[class ,(string-replace (symbol->string (get-tag heading)) "h" "nav")]]
        (span ""
        (a [[href ,(string-append "#" (attr-ref heading 'id))]] ,@(get-elements heading)))))

(define (nosection . xs)
  `(h2 ((id ,(symbol->string (gensym)))) ,@xs))

#|
Define section, subsection, subsubsection and figure tags. We give the section tags gensym'd ids. If the section is labelled the id will be overwritten with the label.
|#
(define-countable-tag (section . xs) (0 number->string #f ".") (count)
  `(h2 ((id ,(symbol->string (gensym)))) ,count ". " ,@xs))

(define-countable-tag (subsection . xs) (0 number->string section ".") (count)
  `(h3 ((id ,(symbol->string (gensym)))) ,count ". " ,@xs))

(define-countable-tag (subsubsection . xs) (0 number->string subsection ".") (count)
  `(h4 ((id ,(symbol->string (gensym)))) ,count ". " ,@xs))

(define-countable-tag (footnote . xs) (0 number->string #f ".") (count)
  `(p ((class "footnote")) ,count ". " ,@xs))

#|
(define-countable-tag (figure src #:width [width "90%"] . xs) (0 number->string #f ".") (count)
  `(figure [[style ,(string-append "max-width:" width ";")]]
    (img ((src ,src)))
    (figcaption "Figure " ,count ": " ,@xs)))
|#

(define-countable-tag (figure src #:width [width "90%"] . xs) (0 number->string #f ".") (count)
  `(figure ;; [[style ,(string-append "max-width:" width ";")]]
    (img ((src ,src)))
    (figcaption "Figure " ,count ": " ,@xs)))

(define-countable-tag (listing lang cap . xs) (0 number->string #f ".") (count)
  `(figure ((class "listing"))
    ,(apply highlight lang xs)
    (figcaption "Listing ",count ": " ,cap)))

#|
Root function automatically applied to .pm files
|#
(define (root . xs)
  (reset-counter section)
  (reset-counter subsection)
  (reset-counter subsubsection)
  (reset-counter footnote)
  (reset-counter figure)

  ;; Strip out h1 from elements
  (define-values (xs-nohead headline)
    (splitf-txexpr `(body ,@xs)
                   (λ (x) 
                     (and (txexpr? x)
                          (member (car x) '(h1))))))
  
  (define refd (cross-reference xs-nohead))
  
  ;; Pull out h2 - h7s into headings
  (define-values (_ headings)
    (splitf-txexpr refd
                   (λ (x)
                     (and (txexpr? x)
                          (member (car x) '(h2 h3 h4))))))
  
  ;; Generate txexprs for ToC
  (define toc-entries (map heading->toc-entry headings))
  ;; Generate doc with headline, body, and ToC entries
  `(root
    ,(typofy-with-tag 'headline headline)
    ,(typofy refd)
    ,(typofy-with-tag 'toc-entries toc-entries)))



