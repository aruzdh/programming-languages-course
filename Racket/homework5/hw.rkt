#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; This homework has to do with mupl (a Made Up Programming Language). mupl programs are written directly in Racket by
;; using the constructors defined by the structs defined at the beginning of hw5.rkt. This is the definition of mupl’s
;; syntax:
;;
;; • If s is a Racket string, then (var s) is a mupl expression (a variable use).
;;
;; • If n is a Racket integer, then (int n) is a mupl expression (a constant).
;;
;; • If e1 and e2 are mupl expressions, then (add e1 e2) is a mupl expression (an addition).
;;
;; • If s1 and s2 are Racket strings and e is a mupl expression, then (fun s1 s2 e) is a mupl expression (a function).
;;  In e, s1 is bound to the function itself (for recursion) and s2 is bound to the (one) argument. Also, (fun #f s2 e)
;;  is allowed for anonymous nonrecursive functions.
;;
;; • If e1, e2, and e3, and e4 are mupl expressions, then (ifgreater e1 e2 e3 e4) is a mupl expression. It is a
;;  conditional where the result is e3 if e1 is strictly greater than e2 else the result is e4. Only one of e3 and e4
;;  is evaluated.
;;
;; • If e1 and e2 are mupl expressions, then (call e1 e2) is a mupl expression (a function call).
;;
;; • If s is a Racket string and e1 and e2 are mupl expressions, then (mlet s e1 e2) is a mupl expression (a let
;;  expression where the value resulting e1 is bound to s in the evaluation of e2).
;;
;; • If e1 and e2 are mupl expressions, then (apair e1 e2) is a mupl expression (a pair-creator).
;;
;; • If e1 is a mupl expression, then (fst e1) is a mupl expression (getting the first part of a pair).
;;
;; • If e1 is a mupl expression, then (snd e1) is a mupl expression (getting the second part of a pair).
;;
;; • (aunit) is a mupl expression (holding no data, much like () in ML or null in Racket). Notice (aunit) is a mupl
;; expression, but aunit is not.
;;
;; • If e1 is a mupl expression, then (isaunit e1) is a mupl expression (testing for (aunit)).
;;
;; • (closure env f ) is a mupl value where f is mupl function (an expression made from fun) and env is an environment
;; mapping variables to values. Closures do not appear in source programs; they result from evaluating functions.
;;
;; A mupl value is a mupl integer constant, a mupl closure, a mupl aunit, or a mupl pair of mupl values. Similar to
;; Racket, we can build list values out of nested pair values that end with a mupl aunit. Such a mupl value is called
;; a mupl list.
;;
;; You should assume mupl programs are syntactically correct (e.g., do not worry about wrong things like (int "hi")
;; or (int (int 37)). But do not assume mupl programs are free of type errors like (add (aunit) (int 7)) or
;; (fst (int 7)).
;;
;; In particular, replace occurrences of "CHANGE" to complete the problems.
;; Do not use any mutation (set!, set-mcar!, etc.) anywhere in the assignment.
;;
;; definition of structures for MUPL programs - Do NOT change

(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body)
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent)

;; Problem 1 - Warm-Up:

;; (a) Write a Racket function racketlist->mupllist that takes a Racket list (presumably of mupl values but that
;;  will not affect your solution) and produces an analogous mupl list with the same elements in the same order.

(define (racketlist->mupllist rl)
  (cond
    [(empty? rl) (aunit)]
    [else (apair (first rl) (racketlist->mupllist (cdr rl)))]))

;; (b) Write a Racket function mupllist->racketlist that takes a mupl list (presumably of mupl values but that will
;;  not affect your solution) and produces an analogous Racket list (of mupl values) with the same elements in the
;;  same order.
;;

(define (mupllist->racketlist ml)
  (cond
    [(aunit? ml) empty]
    [else (cons (apair-e1 ml) (mupllist->racketlist (apair-e2 ml)))]))

;; Problem 2 - Implementing the mupl Language:
;;
;; Write a mupl interpreter, i.e., a Racket function eval-exp that takes a mupl expression e and either returns the
;; mupl value that e evaluates to under the empty environment or calls Racket’s error if evaluation encounters a
;; run-time mupl type error or unbound mupl variable.
;;
;; A mupl expression is evaluated under an environment (for
;; evaluating variables, as usual). In your interpreter, use a Racket list of Racket pairs to represent this
;; environment (which is initially empty) so that you can use without modification the provided envlookup function.
;; Here is a description of the semantics of mupl expressions:
;;
;; • All values (including closures) evaluate to themselves. For example, (eval-exp (int 17)) would return (int 17),
;;  not 17.
;;
;; • A variable evaluates to the value associated with it in the environment.
;;
;; • An addition evaluates its subexpressions and assuming they both produce integers, produces the integer that is
;;  their sum. (Note this case is done for you to get you pointed in the right direction.)
;;
;; • Functions are lexically scoped: A function evaluates to a closure holding the function and the current
;;  environment.
;;
;; • An ifgreater evaluates its first two subexpressions to values v1 and v2 respectively. If both values are
;;  integers, it evaluates its third subexpression if v1 is a strictly greater integer than v2 else it evaluates its
;;  fourth subexpression.
;;
;; • An mlet expression evaluates its first expression to a value v. Then it evaluates the second expression to a
;;  value, in an environment extended to map the name in the mlet expression to v.
;;
;; • A call evaluates its first and second subexpressions to values. If the first is not a closure, it is an error.
;;  Else, it evaluates the closure’s function’s body in the closure’s environment extended to map the function’s name
;;  to the closure (unless the name field is #f) and the function’s argument-name (i.e., the parameter name) to the
;;  result of the second subexpression.
;;
;; • A pair expression evaluates its two subexpressions and produces a (new) pair holding the results.
;;
;; • A fst expression evaluates its subexpression. If the result for the subexpression is a pair, then the result for
;;  the fst expression is the e1 field in the pair.
;;
;; • A snd expression evaluates its subexpression. If the result for the subexpression is a pair, then the result for
;;  the snd expression is the e2 field in the pair.
;;
;; • An isaunit expression evaluates its subexpression. If the result is an aunit expression, then the result for the
;;  isaunit expression is the mupl value (int 1), else the result is the mupl value (int 0).
;;
;; Hint: The call case is the most complicated. In the sample solution, no case is more than 12 lines and several are
;;  1 line.
;;
;; lookup a variable in an environment
;; Do NOT change this function

(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.

#| TODO: All values (including closures) evaluate to themselves.
         For example, (eval-exp (int 17)) would return (int 17), not 17.  |#

(define (eval-under-env e env)
  (cond
    [(int? e) e]
    [(var? e) (envlookup env (var-string e))]
    [(add? e)
     (define v1 (eval-under-env (add-e1 e) env))
     (define v2 (eval-under-env (add-e2 e) env))
     (if (and (int? v1) (int? v2))
         (int (+ (int-num v1) (int-num v2)))
         (error "MUPL addition applied to non-number"))]
    [(fun? e) (closure env e)]
    [(ifgreater? e)
     (define v1 (ifgreater-e1 e))
     (define v2 (ifgreater-e2 e))
     (if (and (int? v1) (int? v2))
         (if (> (int-num v1) (int-num v2)) (ifgreater-e3 e) (ifgreater-e4 e))
         (error "MUPL e1 or e2 are not MUPL int"))]
    [(mlet? e)
     (define v (mlet-e e))
     (eval-under-env (mlet-body e) (cons (cons (mlet-var e) v) env))]
    [(call? e)
     (define fnx (call-funexp e))
     (define act (call-actual e))
     (if (closure? fnx)
         (letrec
             [(closure-fn (closure-fun fnx))
              (body (fun-body closure-fn))
              (fn-name (fun-nameopt closure-fn))
              (new-env1(if fn-name (cons (cons (fn-name closure-fn) fnx) env) env))
              (new-env2 (cons (fun-formal closure-fn) act))]
           (eval-under-env body (cons new-env2 new-env1)))
         (error "The first argument is not a closure"))]
    [(apair? e) (apair (eval-under-env (apair-e1 e) env) (eval-under-env (apair-e2) env))]
    [(fst? e)
     (define sube (fst-e e))
     (if (apair? sube)
         (apair-e1 sube)
         (error "The argument is not an apair"))]
    [(snd? e)
     (define sube (snd-e e))
     (if (apair? sube)
         (apair-e2 sube)
         (error "The argument is not an apair"))]
    [(isaunit? e)
     (define poss-unit (isaunit-e e))
     (if (unit? poss-unit) (int 1) (int 0))]
    [else (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))

;; Problem 3 - Expanding the Language:
;;
;; mupl is a small language, but we can write Racket functions that act like mupl macros so that users of these
;; functions feel like mupl is larger. The Racket functions produce mupl expressions that could then be put inside
;; larger mupl expressions or passed to eval-exp. In implementing these Racket functions, do not use closure (which is
;; used only internally in eval-exp). Also do not use eval-exp (we are creating a program, not running it).
;;
;; (a) Write a Racket function ifaunit that takes three mupl expressions e1, e2, and e3. It returns a mupl expression
;;  that when run evaluates e1 and if the result is mupl’s aunit then it evaluates e2 and that is the overall result,
;;  else it evaluates e3 and that is the overall result. Sample solution: 1 line.
;;
;; (b) Write a Racket function mlet* that takes a Racket list of Racket
;;  pairs ’((s1 . e1) . . . (si . ei) . . . (sn . en)) and a final mupl expression en+1. In each pair, assume si is a
;;  Racket string and ei is a mupl expression. mlet* returns a mupl expression whose value is en+1 evaluated in an
;;  environment where each si is a variable bound to the result of evaluating the corresponding ei for 1 ≤ i ≤ n.
;;  The bindings are done sequentially, so that each ei is evaluated in an environment where s1 through si−1 have been
;;  previously bound to the values e1 through ei−1.
;;
;; (c) Write a Racket function ifeq that takes four mupl expressions e1, e2, e3, and e4 and returns a mupl expression
;;  that acts like ifgreater except e3 is evaluated if and only if e1 and e2 are equal integers. Assume none of the
;;  arguments to ifeq use the mupl variables _x or _y. Use this assumption so that when an expression returned from
;;  ifeq is evaluated, e1 and e2 are evaluated exactly once each.

(define (ifaunit e1 e2 e3) "CHANGE")

(define (mlet* lstlst e2) "CHANGE")

(define (ifeq e1 e2 e3 e4) "CHANGE")

;; Problem 4 - Using the Language:
;;
;; We can write mupl expressions directly in Racket using the constructors for the structs and (for convenience) the
;; functions we wrote in the previous problem.
;;
;; (a) Bind to the Racket variable mupl-map a mupl function that acts like map (as we used extensively in ML). Your
;;  function should be curried: it should take a mupl function and return a mupl function that takes a mupl list and
;;  applies the function to every element of the list returning a new mupl list. Recall a mupl list is aunit or a pair
;;  where the second component is a mupl list.
;;
;; (b) Bind to the Racket variable mupl-mapAddN a mupl function that takes an mupl integer i and returns a mupl
;;  function that takes a mupl list of mupl integers and returns a new mupl list of mupl integers that adds i to every
;;  element of the list. Use mupl-map (a use of mlet is given to you to make this easier).

(define mupl-map "CHANGE")

(define mupl-mapAddN
  (mlet "map" mupl-map
        "CHANGE (notice map is now in MUPL scope)"))

;; Challenge Problem:
;;
;; Write a second version of eval-exp (bound to eval-exp-c) that builds closures with smaller
;; environments: When building a closure, it uses an environment that is like the current environment but holds only
;; variables that are free variables in the function part of the closure. (A free variable is a variable that appears
;; in the function without being under some shadowing binding for the same variable.)
;;
;; Avoid computing a function’s free variables more than once. Do this by writing a function compute-free-vars that
;; takes an expression and returns a different expression that uses fun-challenge everywhere in place of fun. The new
;; struct fun-challenge (provided to you; do not change it) has a field freevars to store exactly the set of free
;; variables for the function. Store this set as a Racket set of Racket strings. (Sets are predefined in Racket’s
;; standard library; consult the documentation for useful functions such as set, set-add, set-member?, set-remove,
;; set-union, and any other functions you wish.)
;;
;; You must have a top-level function compute-free-vars that works as just described — storing the free variables of
;; each function in the freevars field — so the grader can test it directly. Then write a new “main part” of the
;; interpreter that expects the sort of mupl expression that compute-free-vars returns. The case for function
;; definitions is the interesting one.

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e) "CHANGE")

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
