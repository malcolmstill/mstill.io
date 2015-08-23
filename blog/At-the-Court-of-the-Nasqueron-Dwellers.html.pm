#lang pollen/markup

◊headline{At the Court of the Nasqueron Dwellers}
◊define-meta[publish-date]{26/11/2011}
◊define-meta[categories]{shen, programming}
◊define-meta[comments]{true}

More Shen macros today. In the previous post I promised an explanation for why we don't have/need quasiquote, unquote and unquote-splicing in Shen.

Let's look at a Common Lisp example: a single place let. This would typically be written as:

◊highlight['lisp]{
(defmacro let-one ((loc val) &rest body)
  `(let ((,loc ,val))
    ,@body))
}

...using quasiquote, unquote and unquote-splicing. This is actually short hand for the following:

◊highlight['lisp]{
(defmacro let-one ((loc val) &rest body)
  (append (list 'let (list (list loc val)))
        body))
}

I think everyone would agree that this second form is harder to read. In the first form everything is quoted as default unless unquoted. That means you can write (...) in place of (list ...) improving readability. Where the macro needs to evaluate, instead of quoting, unquote is used. Without quoting as default, symbols have to quoted as in the second form (e.g. 'let).

We can now see why Shen doesn't require quasiquote, unquote or unquote-splicing. Firstly, Shen already gives us a shorthand for building lists: [a b] is equivalent to (cons a (cons b ())). Secondly, Shen -- unlike Common Lisp -- doesn't require the quoting of symbols and therefore we can simply write let instead of 'let. Concerning unquote-splicing, if in our pattern match we have a list [x0 | xs] the same behaviour as unquote-splicing is achieved simply by removing the square brackets: x0 | xs.

Now for a very useful example straight out of Common Lisp. The with-open-file macro:

◊highlight['lisp]{
(defmacro with-open-file-macro
  [with-open-file [S Path Dir]] -> [let S [open file Path Dir]
                                     [do [close S]
                                         nil]]
  [with-open-file [S Path Dir] | [B | Bs]] -> (let R (gensym r)
                                                [let S [open file Path Dir]
                                                     R [run B | Bs]
                                                  [do [close S]
                                                      R]]))
}

REPL example:

◊highlight['lisp]{
(29-) (with-open-file (S "file.txt" in)
        (read-byte S))
72
}

The macro uses two pattern matches:

The first matches when no forms are supplied (after the [S Path Dir] form). Why would we still want to open the file if we aren't doing anything with it? There may still may be some side effects; (with-open-file (S "blank" out)) will create an empty file "blank" in the current directory. The macro binds S to the stream returned by [open file Path Dir], closes the stream and returns nil. The second matches in the much more likely case that one or more forms are supplied to the macro. Again S is bound to the returned stream. The result of running the supplied forms is bound (to a gensym'd variable as R doesn't appear on the left hand side) so that the last form can be returned after the stream S is closed. The macro run provides a version of do that works on 0, 1 or more forms:

◊highlight['lisp]{
(defmacro run-macro
  [run] -> nil
  [run X] -> X
  [run X | Y] -> [do X | Y])
}

That's it for today. I'd like to say thanks for the positive feedback I've had so far. Please leave comments agreeing/disagreeing/correcting my mistakes; I'd like to hear your views.

◊em{Post title from The Algebraist by Iain M. Banks}
