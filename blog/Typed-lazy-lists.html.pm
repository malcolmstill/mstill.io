#lang pollen/markup

◊headline{Typed lazy lists}
◊define-meta[publish-date]{05/12/2011}
◊define-meta[categories]{shen, programming}
◊define-meta[comments]{true}

Today I'm going to visit two topics that I've not covered yet: lazy evaluation and types. Personally, the type system is the hardest thing to get my head around and I hope to write a lot more on the subject.

Lazy evaluation allows for the delay of evaluation until a required time. In Shen, lazy evalation is controlled with two functions: freeze and thaw. As the names suggest freeze delays evaluation and thaw evaluates a frozen expression.

Let's jump into a REPL and try these out:

◊highlight['lisp]{
(0-) (freeze 1)
#&lt;FUNCTION \:LAMBDA NIL 1>

(1-) (thaw (freeze 1))
1
}

Note that ◊code{(freeze ...)} returns a function which is evaluated with thaw. This is almost the behaviour we get with a lambda (/.) except the returned function takes no parameters.

What I want to try here is to implement Clojure-like lazy-sequences in Shen. I'm not fully versed in how Clojure lazy-sequences work but I should be able to at least achieve some approximation of their behaviour.

The first function I'm going to implement is a lazy iterate. Iterate takes a function ◊code{F} and a value ◊code{X} and returns a lazy sequence of F applied to the previous value in the sequence: ◊code{[X (F X) (F (F X)) (F (F (F X))) ...]}. The definition of iterate is as follows:

◊highlight['lisp]{
(define iterate
  F X -> (freeze (cons X (iterate F (F X)))))
}

The ◊code{(freeze (cons ...))} pattern will be common to these lazy sequence generators so let's clarify the notation with a macro:

◊highlight['lisp]{
(defmacro lazy-cons-macro
  [lazy-cons X Y] -> [freeze [cons X Y]])
}

The definition of iterate then becomes:

◊highlight['lisp]{
(define iterate
  F X -> (lazy-cons X (iterate F (F X))))

}
This version operates differently to Clojure's iterate in that if I evaluate ◊code{(iterate sq 2)} in Clojure the REPL will hang as it tries to evaluate and print an infinite list; in the Shen version iterate just returns a function.

◊highlight['lisp]{
(5-) (iterate (+ 1) 0)
#<COMPILED-FUNCTION iterate-1>
}

Now that we have a working iterate it would be useful to be able to take values from our infinite lists. We define take to do just this:

◊highlight['lisp]{
(define take-rec
  0 X Acc -> (reverse Acc)
  N X Acc -> (let TX (thaw X)
               (take-rec (- N 1) (tail TX) [(head TX) | Acc])))

(define take
  N X -> (take-rec N X []))
}

◊highlight['lisp]{
(8-) (take 10 (iterate (+ 1) 0))
[0 1 2 3 4 5 6 7 8 9]
}

Cool...but we can do better than that. Turning on the type checker will yield type errors as we've not supplied any type declarations. As lazy lists are something you might want to use in typed code it is sensible to supply types.

Let's introduce a recursive type ◊code{lazy-seq}. ◊code{lazy-seq} will be polymorphic so that we have, for example, ◊code{(lazy-seq number)}, ◊code{(lazy-seq string)}. The definition of ◊code{lazy-seq} is:

◊highlight['lisp]{
(datatype lazy-seq-type

  X : (lazy (list A));
  ___________________
  X : (lazy-seq A);

  X : A; Y : (lazy-seq A);
  _______________________
  (freeze (cons X Y)) : (lazy-seq A);)
}

◊highlight['lisp]{
(11+) (freeze (cons 1 (freeze (cons 2 ()))))
#<FUNCTION :LAMBDA NIL (CONS 1 (freeze (CONS 2 NIL)))> : (lazy-seq number)
}

Now we can define a typed version of iterate:

◊highlight['lisp]{
(define iterate
  { (A --> A) --> A --> (lazy-seq A) }
  F X -> (lazy-cons X (iterate F (F X))))
}

Similarly, we can redefine ◊code{take-rec}:

◊highlight['lisp]{
(define take-rec
  { number --> (lazy-seq A) --> (list A) --> (list A) }
  0 X Acc -> (reverse Acc)
  N X Acc -> (let TX (thaw X)
               (take-rec (- N 1) (tail TX) [(head TX) | Acc])))
}

...but we have a problem. This doesn't type check because head and tail are typed to work only with ◊code{(list A)} types and thaw will only accept ◊code{(lazy A)} types. We need to promise the type checker that thaw can be applied to a ◊code{lazy-seq} and that head and tail can be applied to a thawed ◊code{lazy-seq}. ◊code{lazy-seq} can be redefined as follows:

◊highlight['lisp]{
(datatype lazy-seq-type

  X : (lazy (list A));
  ___________________
  X : (lazy-seq A);

  X : A; Y : (lazy-seq A);
  _______________________
  (freeze (cons X Y)) : (lazy-seq A);

  X : (lazy-seq A);
  ________________
  (thaw X) : (thawed-seq A);

  X : (thawed-seq A);
  __________________
  (head X) : A;

  X : (thawed-seq A);
  __________________
  (tail X) : (lazy-seq A);

  X : (lazy-seq A);
  ________________
  (= (thaw X) []) : boolean;)
}

◊highlight['lisp]{
(15+) (thaw (iterate (+ 1) 0))
[0 | #<COMPILED-FUNCTION iterate-1>] : (thawed-seq number)
}

The important thing to realise is that Shen doesn't just accept types for data structures but that any expression can be typed. The previous definition of ◊code{take-rec} now type checks and we define take as:

◊highlight['lisp]{
(define take
  { number --> (lazy-seq A) --> (list A) }
  N X -> (take-rec N X []))
}

◊highlight['lisp]{
(19+) (take 10 (iterate (+ 1) 0))
[0 1 2 3 4 5 6 7 8 9] : (list number)
}

Great! Let's try a lazy map:

◊highlight['lisp]{
(define lmap
  { (A --> B) --> (lazy-seq A) --> (lazy-seq B) }
  F X -> (lazy-cons (F (head (thaw X))) (lmap F (tail (thaw X)))))
}

◊highlight['lisp]{
(21+) (take 10 (lmap (* 2) (iterate (+ 1) 0)))
[0 2 4 6 8 10 12 14 16 18] : (list number)
}

The problem with ◊code{take} and ◊code{lmap} so far is that they only work with lazy sequences. What we'd really like is to apply take and lmap to lists as well as lazy sequences. To do this we'll introduce a new datatype seq that encompasses both ◊code{list} and ◊code{lazy-seq} types.

◊highlight['lisp]{
(datatype seq-type

  X : (list A);
  ___________
  X : (seq A);

  X : (seq A);
  ____________
  (head X) : A;

  X : (seq A);
  ___________________
  (tail X) : (list A);

  X : (lazy-seq A);
  ___________
  X : (seq A);

  X : (seq A);
  ___________________
  (head (thaw X)) : A;

  X : (seq A);
  _______________________________
  (tail (thaw X)) : (lazy-seq A);)
}

Let's use this definition to define ◊code{seq} equivalents to ◊code{head} and ◊code{tail}; I'll call them ◊code{first} and ◊code{rest}. They are defined as follows:

◊highlight['lisp]{
(define first
  { (seq A) --> A }
  X -> (head X) where (cons? X)
  X -> (head (thaw X)))

(define rest
  { (seq A) --> (seq A) }
  X -> (tail X) where (cons? X)
  X -> (tail (thaw X)))
}

◊highlight['lisp]{
(25+) (first (iterate (+ 1) 0))
0 : number

(26+) (first [0 1 2 3])
0 : number
}

There is an issue with the above in that ◊code{(head X)} and ◊code{(head (thaw X))} will type check for either a ◊code{list} or a ◊code{lazy-seq}. This will yield a run-time error if we try, for example, ◊code{(head (iterate (+ 1) 0))} or ◊code{(head (thaw [1 2 3]))}. Here's a more type-secure definition of ◊code{seq} using verified objects:

◊highlight['lisp]{
(datatype seq-type

  ____________________________________
  (cons? X) : verified >> X : (list A);

  X : (list A);
  ___________
  X : (seq A);

  ____________________________________
  (notcons? X) : verified >> X : (lazy-seq A);

  X : (lazy-seq A);
  ___________
  X : (seq A);)

(define notcons?
  { A --> boolean }
  X -> (not (cons? X)))
}

I've removed the ◊code{(head X)} an ◊code{(head (thaw X))} types for a ◊code{(seq A)} and replaced them with a verified type for lists and lazy sequences. This allows the following redefined ◊code{first} and ◊code{rest} to type check:

◊highlight['lisp]{
(define first
  { (seq A) --> A }
  X -> (head X) where (cons? X)
  X -> (head (thaw X)) where (notcons? X))

(define rest
  { (seq A) --> (seq A) }
  X -> (tail X) where (cons? X)
  X -> (tail (thaw X)) where (notcons? X))
}

We can now go back and redefine ◊code{take-rec}, ◊code{take} and ◊code{lmap} to work on ◊code{seq}:

◊highlight['lisp]{
(define take-rec
  { number --> (seq A) --> (list A) --> (list A) }
  0 X Acc -> (reverse Acc)
  N [] Acc -> (reverse Acc)
  N X Acc -> (take-rec (- N 1) (rest X) [(first X) | Acc]))

(define take
  { number --> (seq A) --> (list A) }
  N X -> (take-rec N X []))

(define lmap
  { (A --> B) --> (seq A) --> (lazy-seq B) }
  F X -> (lazy-cons (F (first X)) (lmap F (rest X))))
}

◊highlight['lisp]{
(34+) (take 2 [1 2 3])
[1 2] : (list number)

(35+) (take 2 (iterate (+ 1) 1))
[1 2] : (list number)
}

There is a remaining issue where attempting to take N elements of a lazy-mapped list where N is greater than the length of the list will yield an error. We redefine ◊code{rest} to check if we have more elements or not and offer a new definition of ◊code{lmap}:

◊highlight['lisp]{
(define rest-lazy-seq
  { (lazy-seq A) --> (seq A) }
  X -> [] where (= (thaw (tail (thaw X))) [])
  X -> (tail (thaw X)))

(define rest
  { (seq A) --> (seq A) }
  [] -> []
  X -> (tail X) where (cons? X)
  X -> (rest-lazy-seq X) where (notcons? X))

(define lmap
  { (A --> B) --> (seq A) --> (lazy-seq B) }
  F [] -> (freeze [])
  F X -> (lazy-cons (F (first X)) (lmap F (rest X))))
}

◊highlight['lisp]{
(39+) (take 10 [1 2 3])
[1 2 3] : (list number)

(40+) (take 10 (lmap (* 2) [1 2 3]))
[2 4 6] : (list number)
}

Here's the final version of our lazy list code:

◊highlight['lisp]{
(defmacro lazy-cons-macro
  [lazy-cons X Y] -> [freeze [cons X Y]])

(datatype lazy-seq-type

  X : (lazy (list A));
  ___________________
  X : (lazy-seq A);

  X : A; Y : (lazy-seq A);
  _______________________
  (freeze (cons X Y)) : (lazy-seq A);

  X : (lazy-seq A);
  ________________
  (thaw X) : (thawed-seq A);

  X : (thawed-seq A);
  __________________
  (head X) : A;

  X : (thawed-seq A);
  __________________
  (tail X) : (lazy-seq A);

  X : (lazy-seq A);
  ________________
  (= (thaw X) []) : boolean;)

(datatype seq-type

  ____________________________________
  (cons? X) : verified >> X : (list A);

  X : (list A);
  ___________
  X : (seq A);

  ____________________________________
  (notcons? X) : verified >> X : (lazy-seq A);

  X : (lazy-seq A);
  ___________
  X : (seq A);)

(define notcons?
  { A --> boolean }
  X -> (not (cons? X)))

(define first
  { (seq A) --> A }
  X -> (head X) where (cons? X)
  X -> (head (thaw X)) where (notcons? X))

(define rest-lazy-seq
  { (lazy-seq A) --> (seq A) }
  X -> [] where (= (thaw (tail (thaw X))) [])
  X -> (tail (thaw X)))

(define rest
  { (seq A) --> (seq A) }
  [] -> []
  X -> (tail X) where (cons? X)
  X -> (rest-lazy-seq X) where (notcons? X))

(define take-rec
  { number --> (seq A) --> (list A) --> (list A) }
  0 X Acc -> (reverse Acc)
  N [] Acc -> (reverse Acc)
  N X Acc -> (take-rec (- N 1) (rest X) [(first X) | Acc]))

(define take
  { number --> (seq A) --> (list A) }
  N X -> (take-rec N X []))

(define lmap
  { (A --> B) --> (seq A) --> (lazy-seq B) }
  F [] -> (freeze [])
  F X -> (lazy-cons (F (first X)) (lmap F (rest X))))
}

There we have it, a basic implementation of typed lazy lists with a Clojure-like interface. I'm beginning to get a better feel for the type system and I hope this post will be of use to others. As always, let me know what you think in the comments below.

◊em{Update: You can find the code for this post on my github page which includes changes suggested by Mark Thom.}
