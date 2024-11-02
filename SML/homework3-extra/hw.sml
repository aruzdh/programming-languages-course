(* 1) Write a function --compose_opt: ('b -> 'c option) -> ('a -> 'b option) -> 'a
* -> 'c option-- that compose two function with "optional" values. If either
* function returns NONE, then the result is NONE*)

fun compose_opt f g input =
  case g input of NONE => NONE | SOME v => f v

(* 2) Write a function --do_until: ('a -> 'a) -> ('a -> bool) -> 'a -> 'a--.
* --do_until f p x-- will apply f to x and again to that result and so on until
* p x is false.
*
* Example: do_until (fn x => x div 2) (fn x => x mod 2 <> 1) will evaluate to a
* function of type int -> int that divides its argument by 2 intil in reaches
* and odd number. In effect, it will remove all factors of 2 its argument.*)

fun do_until f p x =
  if p x then do_until f p (f x) else x

(* 3) Use do_until to implemantal --factorial--*)

fun factorial1 num= 
  let
    val (_, res) =
      do_until 
      (fn (times, acc) => (times-1, acc * (times - 1)))
      (fn (times, _) => times > 1) 
      (num, num)
  in
    res
  end
  

(* 4) Use do_until to write a function --fixed_point: (''a -> ''a) -> ''a ->
* ''a-- that given a function f and an initial value x applies f to x until f x
* = x (Notice the use of '' to indicate equality types)*)

fun fixed_point f original =
  do_until
  f
  (fn acc => original <> acc)
  (f original)


(* 5) Write a function --map2: ('a -> 'b) -> 'a * 'a -> 'b * 'b-- that given a
* function that takes 'a values to 'b values and a pair of 'a values returns the
* corresponding pair of 'b values.*)

fun map2 f (x, y) = (f x, f y)

(* 6) Write --app_all: ('b -> 'c list) -> ('a -> 'b list) -> 'a -> 'c list--, so
* that: app_all f g x vill apply f to every element of the list g x and
* concatenate the results into a single list.
* 
* Example: for -fun f n = [n, 2 * n, 3 * n], we have app_all f f 1 = [1, 2, 3, 2,
* 4, 6, 3, 6, 9].*)

fun app_all f g elem
  = foldr (fn (curr, acc) => curr @ acc)  [] (map f (g elem))

(* 7) Implement --List.foldr (see http://sml-family.org/Basis/list.html#SIG:LIST.foldr:VAL)*)

fun foldr2 f init lst =
  List.foldl (fn (x, acc) => f acc x) init (List.rev lst)

(* 8) Write a function --partition: ('a -> bool) -> 'a list -> 'a list * 'a
* list-- where the first part of the result contains the second argument
* elements for which the first element evaluates to true and the second part of
* the result contains the other second argument elements. Traverse the second
* argument only once.*)

fun partition f lst =
  let
    fun helper [] acc =  acc
      | helper (x::xs') (tr, fl) =
        if f x
        then helper xs' (x::tr, fl)
        else helper xs' (tr, x::fl)
  in
    helper lst ([], [])
  end

(* 9) Write a function --unfold: ('a -> ('b * 'a) option) -> 'a -> 'b list--
* that produces a list of 'b values given a "seed" of type 'a and a function
* that  given a seed produces SOME of a pair of a 'b values and a new seed, or
* NONE if it is done seeding.
*
* Example: here is an elaborate way to count down from 5:
* unfold (fn n => if n = 0 then NONE elese SOME(n, n-1)) 5 = [5, 4, 3, 2, 1]*)

fun unfold f seed =
  let
    fun helper sd acc =
      case f sd of 
           NONE => acc
         | SOME (curr, new_seed) => helper new_seed (acc @ [curr])
  in
    helper seed []
  end

(* 10) Use unfold and foldl to implement factorial*)

fun factorial2 num = 
  foldl
  (fn (n, acc) => n * acc)
  1
  (unfold (fn n => if n = 0 then NONE else SOME (n, n-1)) num)

(* 11) Implement --map-- using List.foldr*)

fun map3 f lst=
  List.foldr (fn (curr, acc) => (f curr) :: acc ) [] lst

(* 12) Implement --filter-- using List.foldr*)

fun filter2 f lst =
  List.foldr 
  (fn (curr, acc) => if f curr then curr::acc else acc) 
  [] lst

(* 13) Implement --foldl-- using foldr on functions (This is challenging)*)



(* 14) Define a (polymophic) type for binary trees where data is at internal
* nodes but not at leaves. Define --map-- and --fold-- functions over such
* trees. You can define --filter-- as well where we interpret a "false" as
* meaning the entire subtree rooted at the node with data that produced false
* should be replaced with a leaf.*)



