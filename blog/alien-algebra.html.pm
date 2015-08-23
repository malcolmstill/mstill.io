#lang pollen/markup

◊headline{Alien algebra}
◊define-meta[publish-date]{23/11/2011}
◊define-meta[categories]{shen, programming}
◊define-meta[comments]{true}

In this post I'm going to concentrate on Shen macros; some familiarity with basic Shen and Common Lisp macros is assumed.

In Shen, as in traditional Lisp style, code is data and data is code. Shen code is read in as a list datastructure: (+ 1 2) becomes [+ 1 2]. Shen macros are functions that pattern match on the list representation of code at read time in order to rewrite it. This pattern matching is very similar to some Scheme macro systems (which I've not used before) though in Shen our macro language is the same as our language for function definition.

The syntax for a Shen macro is as follows:

◊highlight['lisp]{
\* defmacro syntax *\
(defmacro macro-name
    \* 1st pattern match *\ -> \* rewrite rule 1 *\
    \* 2nd pattern match *\ -> \* rewrite rule 2 *\
    \* ... *\)
}

The first argument to defmacro is the macro's name. This is not the same as a Common Lisp defmacro where the name is used to indentify where the macro should expand, i.e. (macro-of-great-justice ...) but is the name of the function that operates at read time on the list representation of the code. Then, using identical syntax to define, a number of pattern matches with associated rewrite rules can be supplied.

In this first example I'll show something reasonably useful: a pipe operator. This operator is used in F# (and trivial to implement in OCaml) and Clojure with slightly different syntax. In normal S-expression function application the inner S-exp is the first to be evaluated with evaluation moving outwards. The textual representation is 'backwards' compared to the order of the computation. A pipe operator allows us to write out a computation in the order we would consider it occuring. For example, if we want to apply (in order) functions A, B, C and D to x we would typically write: (D (C (B (A x)))). In F# with the pipe operator we could rewrite this as x |> A |> B |> C |> D and in clojure (-> x A B C D). For the Shen pipe operator I will use the following syntax (>> x A B C D). The code for this macro is shown below.

◊highlight['lisp]{
(defmacro pipe
    [>> X F] -> [F X]
    [>> X F | Fs] -> [>> [F X] | Fs])
}

The macro is given the name pipe but again this name will not be used when we want to use the operator. The macro operates thus:

The first line states that if we see an S-expression starting with >> and two arguments (here we use the place holder symbols X and F) we want to rewrite that S-expression to give the application of F to X, i.e. [F X]. The second line states if we see an S-expression starting with >> and three or more arguments (X, F, Fs) we want to rewrite that S-expression to apply the pipe operator to the value [F X] and some other functions Fs. If more than one function is supplied the macro will recur on the second rule until a single function remains at which point the first rule triggers and the macro expansion is complete. Using this in the repl:

◊highlight['lisp]{
(1-) (define sq X -> (* X X))
sq

(2-) (>> 2 sq sq sq)
256}

As I mentioned above the first argument to defmacro names the read time function operating on the list representation of the Shen code. This really is a function and can be called as such: calling (pipe [>> 2 sq sq]) will yield the first iteration of the pipe macro. Shen provides the function macroexpand which will output to completion the macroexpansion of a form using all the currently loaded macros (in Common Lisp a similar thing is achieved with macroexpand-1).

◊highlight['lisp]{
(3-) (pipe [>> 2 sq sq])
[>> [sq 2] sq]

(4-) (pipe (pipe [>> 2 sq sq]))
[sq [sq 2]]
}

I'm tempted to claim (and please correct me if I'm wrong) that Shen macros are slightly more general than Common Lisp defmacros because they can be triggered on an arbitrary pattern match of code instead of being triggered by a macro name in the 1st position of a sexp as in Common Lisp. Here's an example, we can rewrite the pipe macro to work infix as in F# with the following code1.

◊highlight['lisp]{
(defmacro pipe-infix
  [X >> F] -> [F X]
  [X >> F >> | Fs] -> [[F X] >> | Fs])
}

In the repl:

◊highlight['lisp]{
(2-) (2 >> sq >> sq >> sq)
256
}

I hope you've found these basic examples helpful. In future I would like to talk more about the differences between Shen macros and Common Lisp macros (e.g. why Shen doesn't have quasiquote/unquote/unquote-splicing).

◊em{Post title from The Algebraist by Iain M. Banks}
