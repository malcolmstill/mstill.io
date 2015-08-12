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

(provide root
	 current-date
	 date->string
	 highlight
	 make-highlight-css
	 tag-in-file?
	 get-elements
	 add-between
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

#|
Functions for typography
|#
(define (element-processing elements)
  (decode-elements elements
		   #:txexpr-elements-proc detect-paragraphs
		   #:block-txexpr-proc (compose1 hyphenate wrap-hanging-quotes)
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
(register-block-tag 'subsection)
(register-block-tag 'subsubsection)
(register-block-tag 'label)
(register-block-tag 'img)
(register-block-tag 'pre)

(define (marginalia left right . content)
  `(div [[class "flx"]]
	(div [[class "margin"]] ,(attr-set left 'class "left"))
	,@content
	(div [[class "margin"]] ,(attr-set right 'class "right"))))

(define (image width src text)
  `(div (img [[style ,(string-append "max-width:" width ";")] 
	      [src ,src] 
	      [alt ,text]])))

(define headline (make-default-tag-function 'h1))

(define (publish-date day month year)
  `(meta ((date ,(number->string (find-seconds 0 0 0 day month year))))))

(define (link url text)
  `(a [[href ,url]] ,text))

(define (background url)
  `(meta ((background ,url))))

;; Thanks to mbutterick for help with this. See https://github.com/mbutterick/pollen/issues/55
(define (make-toc [levels 6])
  `(meta (toc "true")))

(define (enable-comments)
  `(meta (comments "true")))

(define (heading->toc-entry heading)
  `(div [[class ,(string-replace (symbol->string (get-tag heading)) "h" "nav")]]
        (span ""
        (a [[href ,(string-append "#" (attr-ref heading 'id))]] ,@(get-elements heading)))))


(define (categories . tags)
  `(meta (categories (categories ,@tags))))

(define (make-tag tag)
  `(a [[href ,tag]] ,tag))

#|
Function to replace section tags after numbering
|#
(define (make-section tx heading)
  (make-txexpr heading
	       (if (attrs-have-key? tx 'id)
		   (get-attrs tx)
		   (merge-attrs (get-attrs tx) 'id (gensym)))
	       (if (attrs-have-key? tx 'data-number)
		   (append (list (attr-ref tx 'data-number) ". ") (get-elements tx))
		   (get-elements tx))))
								
#|
Function to replace figure tag after numbering
|#
(define (make-figure tx)
  (define els (get-elements tx))
  (make-txexpr 'figure
	       (merge-attrs (get-attrs tx) 'style (string-append "width:" (car els) ";"))
	       (list `(img ((src ,(cadr els))))
		     `(figcaption "Figure " ,(attr-ref tx 'data-number) ": " ,@(cddr els)))))

#|
Define counters and map of tags to counters
|#
(define section-counter (make-counter 0 number->string))
(define subsection-counter (make-counter 0 number->string section-counter))
(define subsubsection-counter (make-counter 0 number->string subsection-counter))
(define figure-counter (make-counter 0 number->string))
(define footnote-counter (make-counter 0 number->string))
(define tag-counters (hash 'section section-counter
			   'subsection subsection-counter
			   'subsubsection subsubsection-counter
			   'figure figure-counter
			   'footnote footnote-counter))

#|
Root function automatically applied to .pm files
|#
(define (root . xs)
  (map (λ (counter) (counter 'reset)) (list section-counter
					    subsection-counter
					    subsubsection-counter
					    figure-counter
					    footnote-counter))
  ;; Strip out h1 from elements
  (define-values (xs-nohead headline)
    (splitf-txexpr `(body ,@xs)
                   (λ (x) 
                     (and (txexpr? x)
                          (member (car x) '(h1))))))
  (define refd (number-and-xref tag-counters xs-nohead))

  (define-values (xs-rep none)
    (splitf-txexpr refd
		   (λ (x) (and (txexpr? x) (member (car x) '(section
							     subsection
							     subsubsection
							     figure))))
		   (λ (x)
		     (match (car x)
		       ['section (make-section x 'h2)]
		       ['subsection (make-section x 'h3)]
		       ['subsubsection (make-section x 'h4)]
		       ['figure (make-figure x)]))))
  
  ;; Pull out h2 - h7s into headings
  (define-values (_ headings)
    (splitf-txexpr xs-rep
                   (λ (x)
                     (and (txexpr? x)
                          (member (car x) '(h2 h3 h4))))))
  ;; Generate txexprs for ToC
  (define toc-entries (map heading->toc-entry headings))
  ;; Generate doc with headline, body, and ToC entries
  `(root
    ,(typofy-with-tag 'headline headline)
    ,(typofy xs-rep)
    ,(typofy-with-tag 'toc-entries toc-entries)))



