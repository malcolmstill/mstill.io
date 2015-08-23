#lang pollen

◊headline{Update: pollen-count}
◊define-meta[publish-date]{15/08/2015}
◊define-meta[categories]{pollen, racket, programming}
◊define-meta[toc]{true}
◊define-meta[comments]{true}

◊section{Feedback}

◊link["https://twitter.com/mbutterick"]{Matthew} gave me ◊link["https://github.com/malcolmstill/pollen-count/issues/1"]{some good feedback} on the initial commit. He suggested that the use of a macro could simplify things by doing the counting and label gathering together before even hitting ◊code{root}. Macros are one of the coolest and most powerful features of lisps. There's a bit more to Racket macros than the Common Lisp equivalent with which I'm familiar; this change has allowed me to investigate Racket macros a bit more but I'll admit I'm not grokking them fully yet◊supref{◊hyperref{foot:macro}}.

Previously you had to manually set up the counters and define a map of tags to counters as shown in ◊hyperref["Listing "]{code:old}.

◊listing['racket "Old setup" #:label "code:old"]{
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
}

Furthermore, as can be seen in ◊hyperref["Listing "]{code:root}, the code to replace section tags with HTML headings within the ◊code{root} function wasn't pretty.

◊listing['racket "More setup. My eyes!" #:label "code:root"]{
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
}

◊section{Macros to the rescue!}

With the new macro we define our countable tags, somewhere in ◊code{directory-require.rkt}, as per ◊hyperref["Listing "]{code:defctag}. You can think about this as defining a function to replace a tag as you would otherwise in Pollen.

◊listing['racket "Cool!" #:label "code:defctag"]{
#|
Define section, subsection, subsubsection and figure tags.
We give the section tags gensym'd ids. If the section is
labelled the id will be overwritten with the label.
|#
(define-countable-tag (section . xs) (0 number->string #f ".") (count)
  `(h2 ((id ,(symbol->string (gensym)))) ,count ". " ,@xs))

(define-countable-tag (subsection . xs) (0 number->string section ".") (count)
  `(h3 ((id ,(symbol->string (gensym)))) ,count ". " ,@xs))

(define-countable-tag (subsubsection . xs) (0 number->string subsection ".") (count)
  `(h4 ((id ,(symbol->string (gensym)))) ,count ". " ,@xs))

(define-countable-tag (footnote . xs) (0 number->string #f ".") (count)
  `(p ((class "footnote")) ,count ". " ,@xs))

(define-countable-tag (figure src #:width [width "90%"] . xs) (0 number->string #f ".") (count)
  `(figure
    (img ((width ,width) (src ,src)))
    (figcaption ,count ": " ,@xs)))

(define-countable-tag (listing lang cap . xs) (0 number->string #f ".") (count)
  `(figure ((class "listing"))
    ,(apply highlight lang xs)
    (figcaption "Listing ",count ": " ,cap)))
}

The only thing left to do in ◊code{root} is to call ◊code{cross-reference} on the document ◊code{txexpr}◊supref{◊hyperref{foot:lie}}.

◊nosection{Footnotes}

◊footnote[#:label "foot:macro"]{Useful references for macros are Greg Hendershott's ◊link["http://www.greghendershott.com/fear-of-macros/index.html"]{◊em{Fear of Macros}}, ◊link["https://www.youtube.com/watch?v=Z4qn9NFfb9s"]{this talk by Matthew Flatt} and, of course, the ◊link["http://docs.racket-lang.org/guide/macros.html"]{Racket documentation}.}
◊footnote[#:label "foot:lie"]{Actually I lied! There's another bit of house keeping we need to do: reset all the counters with the ◊code{reset-counter} macro. See my ◊link["https://github.com/malcolmstill/mstill.io/blob/master/blog/pollen.rkt"]{◊code{◊strike{directory-require.rkt}pollen.rkt}}.}
