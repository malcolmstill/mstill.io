#lang racket

(require pollen/pagetree
	 pollen/render
	 txexpr
	 racket/date
	 rackjure
         pollen/template
         pollen/core
         rackunit)

(define tag-dir "category/")

(define (make-index title)
  (define out (open-output-file (string-append title ".html.pm")
                                #:mode 'binary
                                #:exists 'replace))
  (display (string-append "#lang pollen/markup
◊define-meta[template]{index-template.html}
◊define-meta[title]{" title "}") out)
  (close-output-port out))

(define (make-tag-index title)
  (define out (open-output-file (string-append tag-dir title ".html.pm")
                                #:mode 'binary
                                #:exists 'replace))
  (display (string-append "#lang pollen/markup
◊define-meta[template]{tag-template.html}
◊define-meta[title]{" title "}") out)
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

(define (datestring->seconds datetime)
  (match (string-split datetime)
    [(list date time) (match (map string->number (append (string-split date "/") (string-split time ":")))
                        [(list day month year hour minutes) (find-seconds 0
									  minutes
									  hour
									  day
									  month
									  year)])]
    [(list date) (match (map string->number (string-split date "/"))
                   [(list day month year) (find-seconds 0
							0
							0
							day
							month
							year)])]))

(define (file-date-in-seconds file)
  (if (select-from-metas 'publish-date file)
      (datestring->seconds (select-from-metas 'publish-date file))
      0))

(define (order-by-date files)
  (sort files
        (λ (file1 file2)
          (> (file-date-in-seconds file1)
	     (file-date-in-seconds file2)))
        #:cache-keys? #t))

(define (cat-string->list string)
  (map (λ (tag)
         (apply string-append tag))
       (map (λ (tag)
              (add-between tag " "))
            (map string-split (map string-trim (string-split string ","))))))

(define (tag-in-file? tag file)
  (if (select-from-metas 'categories file)
      (findf (λ (x)
               (equal? x tag))
             (cat-string->list (select-from-metas 'categories file)))
      #f))

#|
find-tags: find categories metadata in all files
|#
(define (find-tags files)
  (~> (map (λ (file)
             (if (select-from-metas 'categories file)
                 (cat-string->list (select-from-metas 'categories file))
                 #f))
           files)
      ((λ (x) (filter identity x))) ; remove #f
      flatten
      remove-duplicates))

;; Extract all categories from files
;; For each category find all files that are tagged with it
;; Generate index page with those files
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

(define post-files (order-by-date (list-pms "./")))
(define tags (find-tags post-files))
(make-.ptree post-files tags)

