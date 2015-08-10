#lang racket

(require pollen/pagetree
	 pollen/render
	 txexpr
	 rackjure
         pollen/template
         rackunit)

(define tag-dir "category/")

(define (make-index title)
  (define out (open-output-file (string-append title ".html.pm")
                                #:mode 'binary
                                #:exists 'replace))
  (display (string-append "#lang pollen/markup
◊meta['template: \"index-template.html\"]
◊meta['title: \"" title "\"]") out)
  (close-output-port out))

(define (make-tag-index title)
  (define out (open-output-file (string-append tag-dir title ".html.pm")
                                #:mode 'binary
                                #:exists 'replace))
  (display (string-append "#lang pollen/markup
◊meta['template: \"tag-template.html\"]
◊meta['title: \"" title "\"]") out)
  (close-output-port out))

(define (list-pms directory)
  (filter (λ (file) 
	     (and (not (equal? (path->string file) "index.html.pm"))
                  (regexp-match #rx"\\.pm" (path->string file))))
	  (directory-list directory)))

(define (pm->html file)
  (string-trim (path->string file) ".pm"
	       #:left? #f #:repeat? #f))

(define (pm->html-symbol file)
  (string->symbol (string-trim (path->string file) ".pm"
                               #:left? #f #:repeat? #f)))

(define (file-date file)
  (if (select-from-metas 'date file)
      (select-from-metas 'date file)
      "0"))

(define (order-by-date files)
  (sort files
        (λ (file1 file2)
          (string>? (file-date file1)
                    (file-date file2)))
        #:cache-keys? #t))

(define (tag-in-file? tag file)
  (if (select-from-metas 'categories file)
      (findf (λ (x)
               (equal? x tag))
             (get-elements (select-from-metas 'categories file)))
      #f))

(define (find-tags files)
  (~> (map (λ (file)
             (if (select-from-metas 'categories file)
                 (get-elements (select-from-metas 'categories file))
                 #f))
           files)
      ((λ (x) (filter identity x)))
      flatten
      remove-duplicates))

;; Extract all categories from files
;; For each category find all files that are tagged with it
;; Generate index page with those files
(define (generate-categories files)
  (define tags (find-tags files))
  (map (λ (tag)
	 (make-tag-index tag)
	 (cons (string->symbol (string-append tag ".html"))
               (map pm->html-symbol
                    (filter (λ (file)
                              (tag-in-file? tag file)) files))))
       tags))

;; Temp until render-pagetree fixed
(define (generate-cats tags)
  (apply string-append (map (λ (tag)
			      (make-tag-index tag)
			      (string-append tag-dir tag ".html\n"))
			    tags)))

(define (make-.ptree post-files tags)
  (define out (open-output-file "index.ptree" #:exists 'replace))
  (define st
    (string-append "#lang pollen\n◊index.html{"
		   (apply string-append
			  (map (λ (x)
				 (string-append (pm->html x) "\n")) post-files))
		   "}\n" (generate-cats tags)))
  (display st out)
  (close-output-port out))
;; end temp

      
(define (make-pagetree post-files)
  `((pagetree-root
     (index.html ,@(map pm->html-symbol post-files)))
    ,@(map (λ (tag)
	     `(pagetree-root ,tag))
	   (generate-categories post-files))))

(define post-files (order-by-date (list-pms "./")))
(define tags (find-tags post-files))
(make-.ptree post-files tags)
;(render-pagetree "index.ptree")
