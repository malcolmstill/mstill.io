#lang pollen/markup

◊headline{Shen infix notation}
◊define-meta[publish-date]{20/03/2013}
◊define-meta[categories]{shen, programming}
◊define-meta[comments]{true}

Here's an implementation of infix notation for Shen; it's effectively ◊link["http://en.wikipedia.org/wiki/Shunting-yard_algorithm"]{Dijkstra's shunting-yard algorithm}.

Custom precedence can be defined by setting ◊code{prec}.

◊highlight['newlisp]{(define prec
    ** -> 4
    * -> 3
    / -> 3
    + -> 2
    - -> 2)

\* power is defined in the maths library *\    
(define **
    X Y -> (power X Y))

(define shunt
    [] Output [] -> Output
    [] [] [X Op Y | Rest] -> (shunt [Op] [(shunt [] [] Y) (shunt [] [] X)] Rest) where (element? Op [+ - * / **])
    [] [] X -> X
    [Op | Ops] [Y X] [] -> (shunt Ops [Op X Y] [])
    [Op2 | Ops] [Y X | R] [Op1 Z | Rest] ->
        (let Nout (if (> (prec Op1) (prec Op2))
                    [[Op1 Y (shunt [] [] Z)] X | R]
                    [(shunt [] [] Z) [Op2 X Y] | R])
            Nops (if (> (prec Op1) (prec Op2))
                    [Op2 | Ops]
                    [Op1 | Ops])
            (shunt Nops Nout Rest)) where (element? Op1 [+ - * / **]))

(defmacro infix-macro
    [in | X] -> (shunt [] [] X))
}

It can be called as follows:

◊highlight['newlisp]{
(in (2 + 3) * 4)
}
