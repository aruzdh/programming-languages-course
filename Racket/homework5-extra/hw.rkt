#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

; Racket structs

; A binary tree is either (btree-leaf) or a Racket value built from btree-node where the left and right fields are
; both binary trees.

(struct btree-leaf () #:transparent)
(struct btree-node (value left right) #:transparent)

; BTrees

(define tree1
  (btree-node 10
              (btree-node 5
                          (btree-leaf)
                          (btree-node 2 (btree-leaf) (btree-leaf) ))
              (btree-node 2
                          (btree-leaf)
                          (btree-node 9 (btree-leaf) (btree-leaf) ))))

(define tree2
  (btree-node 4
              (btree-node 5
                          (btree-leaf)
                          (btree-node 3 (btree-leaf) (btree-leaf)))
              (btree-leaf)))

(define tree3
  (btree-node 4
              (btree-node 5
                          (btree-leaf)
                          (btree-leaf)) (btree-leaf)))

; 1) Write a function tree-height that accepts a binary tree and evaluates to a height of this tree. The height of a
; tree is the lenght of the longest path to a leaf. Thus the height of a leaf is 0

(define (tree-height bt)
  (if (btree-leaf? bt) 0
      (+ 1 (max (tree-height (btree-node-left bt)) (tree-height (btree-node-right bt))))))

; 2) Write a function sum-tree that takes binary tree and sums all the values in all the nodes. (Assume the values
; fields all hold numbers, i.e., values that can pass to +)

(define (sum-tree bt)
  (if (btree-leaf? bt) 0
      (+ (btree-node-value bt) (sum-tree (btree-node-left bt)) (sum-tree (btree-node-right bt)))))

; 3) Write prune-at-v that takes a binary tree t and a value v and produces a new binary tree with structure the same
; as t except any node with value equal to v (use Racket's equal?) is replaced (along with all its descendants) by a
; leaf

(define (prune-at-v bt v)
  (if (or (btree-leaf? bt)(equal? (btree-node-value bt) v)) (btree-leaf)
      (btree-node (btree-node-value bt)
                  (prune-at-v (btree-node-left bt) v)
                  (prune-at-v (btree-node-right bt) v))))

; 4) Write a function well-formed-tree? that takes any value and returns #t if and only if the value is legal binary
; tree as defined above

(define (well-formed-tree val)
  (cond
    [(btree-leaf? val) #t]
    [(btree-node? val) (and (well-formed-tree (btree-node-left val)) (well-formed-tree (btree-node-right val)))]
    [else #f]))

; 5) Write a function fold-tree that takes a two-argument function, an initial accumulator, and a binary tree and
; implements a fold over the tree, applying the function to all the values.
;
; For example:
; (fold-tree (lambda (x y) (+ x y 1)) 7
;   (btree-node 4 (btree-node 5 (btree-leaf) (btree-leaf)) (btree-leaf)))
; would evaluates to 18. You can traverse the tree in any order you like (though it does affect the result af a call
; to fold-tree if the function passed isn't associative)

(define (fold-tree fn acc bt)
  (if (btree-leaf? bt) acc
      (fn (btree-node-value bt)
          (fold-tree fn (fold-tree fn acc (btree-node-left bt)) (btree-node-right bt)))))

; 6) Reimplement fold-tree as a curried function

(define (fold-tree-curried fn)
  (lambda (acc)
    (lambda (bt)
      (if (btree-leaf? bt) acc
          (fn (btree-node-value bt)
              (fold-tree fn (fold-tree fn acc (btree-node-left bt)) (btree-node-right bt)))))))

#| (define f ((fold-tree-curried (lambda (x y) (+ (* 2 x) y))) 0)) |#
#| (f tree1) |#

; Dynamic typing

; 7) Write a function crazy-sum that takes a list of numbers and adds all together, starting from the left. There's a
; twist, however. The list is allowed to contain functions in addition to numbers. Whenever an element of a list is a
; function, you should start using it to combine all the following numbers in a list instead of +. You may assume that
; the list is non-empty and contains only numbers and binary functions suitable for operating on two numbers. Further
; assume the first list element is a number.
;
; For example:
; (crazy-sum (list 10 * 6 / 5 -3)) evaluates to 9. Note: it may superficially look like the function implements infix
; syntax for arithmetic expressions, but that's not really the case




; 8) Write a function either-fold that is like fold for lists of brinay trees as defined above except that it works
; for both of them. Given an appropiate errer message if the third argument to either-fold is neither a list or a
; binary-tree



; 9) Write a function flatten that takes a list and flattens its internal structure, merging all the lists inside into
; a single flat list. This should work for lists nested to arbitrary depth.
;
; For example:
; (flatten (list 1 2 (list (list 3 4) 5 (list (list 6) 7 8)) 9 (list 10))) should evaluate to
; (list 1 2 3 4 5 6 7 8 9 10)


; Using lambda-calculus ideas to remove features form MUPL programs

; Like Racket itself, MUPL (the programming language from this section's homework assignment) is essentially a
; superset of untyped lambda calculus. "Lambda calculus" may sound scary, but it's essentially a very simple
; programming language -- it really doesn't have anything in it, apart from anonymous functions and functions calls!
; Of course, that makes it very inconvenient to program in, which is also why real programming languages usually
; supply all sorts of bells and whistels, liki additional language constructs and data types like booleans and numbers
;
; Nonetheless, untyped lambda calculus is Turing-complete, so we can actually represent things like numbers and
; booleans using nothing but functions. In these problems we'll do some of that in MUPL.

; 10) Notice that MUPL doesn't need mlet: Anywhere we have (mlet name e body), we can use (call (fun #f name body) e)
; instead and get the same result. Write a Racket function remove-lets that takes a MUPL program and produces an
; equivalent MUPL program that does not contain mlet



; 11) [more challenging] Now we will do something even more clever: remove pairs by using closures environments as
; another way to "hold" two pieces of data. Instead of using (apair e1 e2), we can use
; (mlet "_x" e1 (mlet "_y" e2 (fun #f "_f" (call (call (var "_f" (var "_x")) (var "_y"))))))
; (assuming "_x" isn't already used in e2 -- we will assume that). This will evaluate to a closure that has the result
; of evaluating e1 and e2 in its environment. When the closure is called with a function, that function will be caled
; with the result of evaluating e1 and e2 (in curried form). So if we replace every pair expression as described above,
; then we can, rather cleverly, replace (fst e) with (call e (fun #f "x" (fun #f "y" (var "x")))). Extend your
; remove-lets, renaming it remove-lets-and-pairs so that it removes all uses of pair, fst, and snd. We are leaving it
; to you to figure out how to replace (snd e).
;
; Note 1: Remember you need to remove things recusively inside of apair,
; fst, etc., else an expression like (fst (std (var "x"))) won't have the snd removed.
;
; Note 2: The resulting program should produce the same result when evaluated if the (original) result doesn't contain
; any pair values. If the original result does contain pair values, the result after removal will contain corresponding
; closures.
;
; Note 3: A slightly more challenging approach is to change how apair is removed so that we do not need to assume "_y"
; is not used in e2



; More MUPL functions

; In the first problem, we treat (int 1) as true in MUPL and (int 0) as false in MUPL

; 12) Define a Racket binding mupl-all that holds a MUPL function that takes a MUPL list and evaluates to (MUPL) true
; uf all the list elements are (MUPL) true, else it evaluates to (MUPL) false



; 13) Define a Rakcet binding mupl-append that holds a MUPL function that takes two MUPL lists (in curried form) and
; appends them



; 14) Define a binding mupl-zip that holds a MUPL function that takes MUPL lists (in curried form) and retuns a list
; of pairs (much like ML's zip). If the MUPL lists are different lenghts, ignore a suffix of the longer list (so the
; returned list of pairs has a lenght equal to the shorter of the argument lenghts)



; 15) Redo the previous two problems with the MUPL function taking a pair with the arguments rather that using
; currying



; 16) Define a Racket binding mupl-curry that holds a MUPL function that is like ML's fun curry
; f = (fx x y => f (x, y))



; 17) Define a Racket binding mupl-uncurry that holds a MUPL function that is like ML's
; fun uncurry = (fn (x, y) => f x y)



; More MUPL macros

; As above, as needed, we treat (int 1) as true in MUPL and (int 0) as false in MUPL

; 18) Define a Racket binding if-greater3 that is a MUPL macro (a Racket function) that takes 5 MUPL expressions and
; produces a MUPL program that, whet evaluated, evaluates the 4th subexpression as the result if the 1st subexpression
; is greater that the 2nd and the 2nd is greater that the 3rd. else in evaluates the 5th expression as the result.
; When the MUPL program is evaluated, it should always evaluate the 1st, 2nd, and 3rd subexpressions exactly once each
; and then the 4th subexpression or 5th subexpression but not both




; 19) Define a  Racket binding call-curried that is a MUPL macro (a Racket function) that takes a MUPL expression e1
; and a Racket list of MUPL expression e2 and produces a MUPL program that, when evaluated, calls the result of
; evaluating e1 as a curried function with all of the results of evaluating the expression in e2
;
; For example, instead of writing (call (call e1 ea) eb), you can write (call-curried e1 (list ea eb))



