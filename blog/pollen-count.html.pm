#lang pollen

◊headline{pollen-count}
◊define-meta[publish-date]{12/08/2015}
◊define-meta[categories]{pollen, racket, programming}
◊define-meta[toc]{true}
◊define-meta[comments]{true}

◊section{Introducing pollen-count}

◊link["https://github.com/malcolmstill/pollen-count"]{◊code{pollen-count}} is a ◊link["http://racket-lang.org"]{Racket} library for use with ◊link["http://pollenpub.com/"]{Pollen}. It allows for numbering of sections, figures, tables, etc. and cross references to these numbers. The source code is ◊link["https://github.com/malcolmstill/pollen-count"]{available on Github}.

◊section[#:label "sec:enum"]{Enumerations}

◊link["https://github.com/malcolmstill/pollen-count"]{◊code{pollen-count}} is designed to enumerate sections, figures, tables, etc. To do this the required number of counters is defined along with a hashmap of tags and counters. Any time a tag in the hashmap is encountered its associated counter will be incremented and the new value stored with that instance of the tag.

Counters can specify a parent counter. A ◊code{print} function associated with the counter will concatenate its number with its parent's number with a specified separator. The function to make a counter is ◊code{make-counter}, its argument list is defined as follows:

◊highlight['racket]{
(make-counter initial render [parent #f] [separator "."])
}

◊code{initial} is a ◊code{number} (this will likely always be ◊code{0}), ◊code{render} is a function taking a ◊code{number} and returning a ◊code{string} (used when the count is printed: typically you'll use ◊code{number->string} but you might want to use ◊code{Alpha} to replace, for example, the number ◊code{1} with "A"), ◊code{parent} is another ◊code{counter}, and ◊code{separator} is an optional ◊code{string} to use between this counter's count and its parent's when printed.

Example code for making counters:

◊highlight['racket]{
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

◊section{References}

The other function of ◊link["https://github.com/malcolmstill/pollen-count"]{◊code{pollen-count}} is to references. The library will recognise two tags ◊code{ref} and ◊code{hyperref}, examples are shown below:

◊highlight['racket]{
See Figure ◊"◊"ref{fig:tree}. See also ◊"◊"hyperref["Figure "]{fig:tree2}.
}

The difference between the two is that ◊code{ref} is simply replaced by the number associated with ◊code{fig:tree} whereas ◊code{hyperref} generates a hyperlink with some additional specified text (so that the word "Figure" is also included as part of the link).

You are now asking where ◊code{fig:tree} and ◊code{fig:tree2} are specified. The other half of references are labels. The library recognise the tag ◊code{label}. For example, in this blog I specify sections with the ◊code{section} tag. If I want to then ◊code{ref} this section I add a ◊code{label} within this section:

◊highlight['racket]{
◊"◊"section{Introduction ◊"◊"label{sec:intro}}
}

Somewhere else in the document I can then reference the introduction:

◊highlight['racket]{
As stated in ◊"◊"hyperref["Section "]{sec:intro}...
}

◊section{Generation}

The enumerations and references will typically be applied in the ◊code{root} function specified in ◊code{directory-require.rkt}. The function ◊code{numebr-and-xref} is provided by ◊link["https://github.com/malcolmstill/pollen-count"]{◊code{pollen-count}}. It takes as arguments the hashmap of tags to counters as explained in ◊hyperref["Section "]{sec:enum} and the document ◊code{txexpr} and returns another ◊code{txexpr} which includes the substituted references. For example:

◊highlight['racket]{
  (define refd (number-and-xref tag-counters xs-nohead))
}

At that point ◊code{refd} has not replaced the text of the ◊code{section} tag with the numbered equivalent. The number is stored as an attribute called ◊code{data-number}. In my blog code I then replace the ◊code{section} tag with an appropriate ◊code{h} tag and modify the text to include the generated number. The following function takes care of this but it is not part of ◊link["https://github.com/malcolmstill/pollen-count"]{◊code{pollen-count}}.

◊highlight['racket]{
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
}

◊section{Installation}

The library can be installed with the following command:

◊highlight['bash]{
raco pkg install git://github.com/malcolmstill/pollen-count
}

I have also uploaded the library to ◊link["http://pkgs.racket-lang.org/"]{http://pkgs.racket-lang.org/} so it should be available at some point in the package catalog (though this is the first time I'm trying to do this so I could well have made a mistake).

◊section{To do}
There are a number of improvements for the library that I have in mind and I need to put together some scribble documentation. If you have any issues or suggestions please use the issues page on Github.

◊section{Further reading}

The source code for this blog is ◊link["https://github.com/malcolmstill/mstill.io"]{available on Github}. This may be useful for understanding the usage outlined above.
