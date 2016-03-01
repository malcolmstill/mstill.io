#lang pollen

◊headline{racket-quandl: Racket for fun and profit}
◊define-meta[publish-date]{29/02/2016}
◊define-meta[categories]{programming, racket, Quandl, finance}
◊define-meta[comments]{true}

Today I was extracting some commodity spot prices from ◊link["https://www.quandl.com"]{Quandl}  with both python and Matlab. I knew it couldn't be hard to obtain the same data via ◊link["https://racket-lang.org/"]{racket} so I threw together a very small library called ◊link["https://github.com/malcolmstill/racket-quandl"]{racket-quandl} to do just that.

◊hyperref["Listing "]{code:racket-quandl} shows a basic example of using ◊link["https://github.com/malcolmstill/racket-quandl"]{racket-quandl} to pull down historic commodity prices. It's as simple as calling ◊code{get} with the code for the required data set. Using racket's fantastic ◊code{plot} library these data can be shown graphically. If you have a ◊link["https://www.quandl.com"]{Quandl} key, this can be set by passing it to ◊code{set-auth-token} before calling ◊code{get}.

◊listing['racket "racket-quandl example" #:label "code:racket-quandl"]{
#lang racket

(require racket-quandl)
(require plot)
(require plot/utils)

; Set Quandl auth token from file
(set-auth-token (string-normalize-spaces (file->string "quandlkey.txt")))

; Grab daily spot prices from Quandl (EIA dataset)
(define crude (get "EIA/PET_RWTC_D")) ; WTI crude 
(define gasoline (get "EIA/PET_EER_EPMRU_PF4_Y35NY_DPG_D")) ; RBOB gasoline
(define nat-gas (get "EIA/NG_RNGWHHD_D")) ; Henry hub natural gas

; Plot the historic price
(parameterize
      ([plot-x-ticks (date-ticks)]
       [plot-x-label "Date"]
       [plot-y-label "Price ($/unit)"])
  (plot (list
         (lines
          (map vector (map datetime->real (map car crude)) (map cadr crude))
          #:color 6 #:label "WTI crude")
         (lines
          (map vector (map datetime->real (map car gasoline)) (map cadr gasoline))
          #:color 7 #:label "RBOB gasoline")
         (lines
          (map vector (map datetime->real (map car nat-gas)) (map cadr nat-gas))
          #:color 8 #:label "Natural gas"))))
}

Output from the code is shown in ◊hyperref["Figure "]{fig:plot}.
◊figure["images/quandl.svg" #:width "500px" #:label "fig:plot"]{Commodity spot prices pulled form Quandl with racket}
