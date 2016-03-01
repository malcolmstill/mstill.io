#lang pollen

◊headline{Enjoy the Racket}
◊define-meta[publish-date]{10/09/2015}
◊define-meta[categories]{racket, programming}
◊define-meta[comments]{true}

◊link["https://en.wikipedia.org/wiki/Scheme_(programming_language)"]{Schemes} are often regarded as not being practical languages due to their minimal implementations and perceived use purely for teaching. I'm guilty of buying into that perception too. Or I ◊em{was} when I first looked at ◊link["http://www.racket-lang.org"]{Racket}.

I took a look at Racket a number of times before giving it a real chance. Firing up DrRacket it's easy to dismiss Racket as a teaching language with references to teachpacks, etc.

One thing that did pique my interest was ◊link["http://docs.racket-lang.org/ts-guide/"]{Typed Racket}. Those who follow this blog (or the previous incarnation at the now-defunct klltkr.com) know that I've looked at ◊link["http://shenlanguage.org/"]{Shen} a lot in the past. The cool things about Shen are the type system and pattern matching that you don't normally see in a lisp. Having played around with OCaml I know the power of a language with a strong type system: the benefit of the type system helping you write correct code outweighs the odd issue with satisifying the type checker. Shen however suffers from a rather complicated type system, one that is itself programmable, and is so free-form that the type errors don't necessarily help.

This is where Typed Racket comes in. You get all the lisp goodness (REPL, macros, etc.) ◊em{and} an ML-like type system.

Moreover, Racket is a batteries-included lisp. You're not typically going to find yourself reïnventing the proverbial wheel for some operation on lists, say.

And that's when I understood the name change from PLT Scheme to Racket. Racket ◊em{isn't} a scheme in the traditional sense alluded to in the opening paragraph. It's a practical batteries-included lisp on par with Common Lisp (and surpassing it in many ways in my opinion). There are ◊link["http://pollenpub.com"]{killer apps} written in Racket and it's encouraging to see ◊link["https://twitter.com/ID_AA_Carmack/status/577877590070919168"]{John Carmack} using it.

One of the cool things about Racket is the built-in GUI system; something that Common Lisp struggles with (though I do have high hopes for Qt with ◊link["https://github.com/drmeister/clasp"]{Clasp}!).

Now for some fun: I threw together ◊link["https://github.com/malcolmstill/gol"]{a wee implementation} of ◊link["https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life"]{Conway's Game of Life} in Racket.

◊image["349px" "images/gol.gif"]{Game of Life in Racket}
