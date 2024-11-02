(*
  Write a function alternate : int list -> int that takes a list of numbers and adds them with alternating sign.
  For example: alternate [1, 2, 3, 4] = 1 - 2 + 3 - 4 = -2
*)

fun alternate (numbers: int list) =
  if null numbers
  then 0
  else if null (tl numbers) 
       then hd numbers
       else 
         let 
           val first = hd numbers
           val rest = tl numbers
         in 
           if null (tl rest) 
           then first - hd rest 
           else first - hd rest + alternate (tl rest)
         end

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function min_max : int list -> int * int that takes a non-empty list of
  numbers, and returns a pair (min, max) of the minimun and maximum of the
  numbers in the list.
*)

(*
   TODO: improve this func to just iterate once.
*)
fun min_or_max (f: int * int -> bool, numbers: int list) : int =
  if null numbers
  then 0
  else if null (tl numbers)
       then hd numbers
       else if f (hd numbers, hd (tl numbers))
            then min_or_max (f, hd numbers :: tl (tl numbers))
            else min_or_max (f, tl numbers)

fun max (x: int, y: int) = x > y 
fun min (x: int, y: int) = x < y 

fun min_max (numbers: int list) =
  (min_or_max(min, numbers), min_or_max(max, numbers))

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function cumsum : int list -> int list that takes a list of numbers
  and returns a list of the partial sums of those numbers.
  For example: cumsum [1, 4, 20] = [1, 5, 25]
*)


fun cumsum (numbers: int list) = 
    let fun counter (prev: int, rest: int list) =
        if null rest
        then []
        else let val curr = hd rest + prev
            in curr::counter (curr, tl rest)
            end
    in counter (0, numbers) end

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function greeting : string option -> string that given a string option
  SOME name returns the string "HEllo there, ... !" where the dots would be
  replaced by name. Note that the name is given as an option, so if it is NONE
  then replace the dots with "you"
*)

fun greeting (name: string option ) =
  if (isSome name)
  then "Hello there, " ^ valOf name
  else "Hello there, you"

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function repeat : int list * int list -> int list that given a list of
  integers and another list of nonnegative integers, repeats the integers
  in the first list according to the numbers indicated by the second list.
  For example: repeat ([1, 2, 3], [4, 0, 3]) = [1, 1, 1, 1, 3, 3, 3]
*)

fun duplicate (integer : int, times : int) =
  if times = 0
  then []
  else integer::duplicate(integer, times - 1)

fun repeat (integers : int list, nonnegative : int list) =
  if null integers orelse null nonnegative
  then []
  else duplicate (hd integers, hd nonnegative) @ repeat (tl integers, tl nonnegative)

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function addOpt: int option * int option -> int option that given two
  "optional" integers, adds them if they are both present (returning SOME of
  their sum), or returns NONE if at least one of the two arguments is NONE.
*)

fun addOpt (integer1: int option, integer2: int option) =
  if isSome integer1 andalso isSome integer2
  then SOME (valOf integer1 + valOf integer2)
  else NONE

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function addAllOpt : int option list -> int option that given a list
  of "optinal" integers, adds those integers that are there (i.e. adds all the
  SOME i).
  For example: addAllOpt ([SOME 1, NONE, SOME 3]) = SOME 4.
  If the list does not contain any SOME is in it, i.e. they are all NONE or the
  list is empty, the function should return NONE.
*)

fun addAllOptAux (integers : int option list) =
  if null integers
  then 0
  else if isSome (hd integers)
       then valOf (hd integers) + addAllOptAux (tl integers)  
       else addAllOptAux (tl integers)

fun addAllOpt (integers : int option list) =
  if null integers
  then NONE
  else SOME (addAllOptAux integers)


(*----------------------------------------------------------------------------------------------*)

(*
  Write a function any : bool list -> bool that given a list of booleans returns
  true if there is at least one of them that is true, otherwise returns false.
  If the list is empty it should return false because there is no true.
*)

fun any (booleans : bool list) =
  if null booleans
  then false
  else hd booleans orelse any (tl booleans)

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function all: bool list -> bool that given a list of booleans returns
  true if all of them true, otherwise false.
  If the list is empty is should return true because there is no false
*)

fun all (booleans : bool list) =
  if null booleans
  then true
  else hd booleans andalso all (tl booleans)

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function zip : int list * int list -> int * int list that given two
  lists of integers creates consecutive pairs, ands stops when one of the list
  is empty.
  For example: zip ([1, 2, 3], [4, 6]) = [(1, 4), (2,6)]
*)

fun zip (integers1: int list, integers2: int list) =
  if null integers1 orelse null integers2
  then []
  else (hd integers1, hd integers2):: zip(tl integers1, tl integers2)

(*----------------------------------------------------------------------------------------------*)

(*
  Challenge: Write a version zipRecycle of zip, where when one list is empty is
  starts recycling from its start until the other list completes.
  For example: zipRecycle ([1, 2, 3], [1, 2, 3, 4, 5, 6, 7]) = [(1,1), (2,2), (3, 3), (1,4), (2,5), (3,6), (1,7)]
*)

fun zipRecycle (integers1: int list, integers2: int list) =
  []
(*----------------------------------------------------------------------------------------------*)

(*
  Less Challenge: Write a version zipOpt of zip with return type (int * int)
  list option. This version should return SOME of a list when the original lists
  have the same lenght, and NONE if the do not.
*)

fun zipOpt (integers1: int list, integers2: int list) =
  []

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function lookup: (string * int) list * string -> int option that takes
  a list of pairs (s, i) and also a string s2 to look up. It then goes through
  the list of pairs looking for the string s2 in the first component. If it
  finds a match with corresponding number i, then ir returns SOME i. If it does
  not, it retunrs NONE
*)

fun lookup (pairs: (string * int) list, search: string) =
  if null pairs
  then NONE
  else if #1 (hd pairs) = search
       then SOME (#2 (hd pairs))
       else lookup (tl pairs, search)

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function splitup : int list -> int list * int list that given a list
  of integers creates two lists of integers, one containing the non-negative
  entries, the other containing the negative entries. Relative order must be
  preserved: All non-negative entries must appear in the same order in which
  they were on the original list , and similarly for the negative entries.
*)

fun fil(pred: int -> bool, integers: int list) =
  if null integers
  then []
  else if pred (hd integers)
       then hd integers::fil(pred, tl integers)
       else fil(pred, tl integers)

fun isNeg(integer: int) = integer < 0
fun isPos(integer: int) = integer > ~1

fun splitup (integers: int list) =
  if null integers
  then []
  else [fil(isPos, integers), fil(isNeg, integers)]

(*----------------------------------------------------------------------------------------------*)

(*
  Write a verison splitA : int list * int -> int list * int list of the previous
  function that takes an extra "threshold" parameter, and uses that instead of 0
  as the separating point for the two resulting lists.
*)


fun splitA (integers: int list, thr: int) =
  if null integers
  then []
  else let 
          fun isLess(integer: int) = integer < thr
          fun isGreater(integer: int) = integer >= thr
        in [fil(isLess, integers), fil(isGreater, integers)]
        end

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function isSorted : int list -> boolean that given a list of integers
  determines whether the list is sorted in increasing order.
*)

fun compare(curr: int, integers: int list) =
  if null integers
  then true
  else curr <= (hd integers) andalso compare (hd integers, tl integers)

fun isSorted(integers: int list) =
  if null integers
  then true
  else compare(hd integers, tl integers)

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function isAnySorted : int list -> boolean, that given a list of
  integers determines whether the list is sorted in either increasing or
  decreasing order.
*)

fun increasing(curr: int, integers: int list) =
  if null integers
  then true
  else curr <= (hd integers) andalso increasing (hd integers, tl integers)

fun decreasing(curr: int, integers: int list) =
  if null integers
  then true
  else curr >= (hd integers) andalso decreasing (hd integers, tl integers)

fun isAnySorted (integers: int list) =
  if null integers
  then true
  else increasing(hd integers, tl integers) orelse decreasing(hd integers, tl integers)

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function sortedMerge : int list * int list -> list that takes two
  lists of integers that are each sorted from smallest to larges, and merges
  them into one sorted list.
  For example: sortedMerge ([1, 4, 7], [5, 8, 9]) = [1, 4, 5, 7, 8, 9]
*)

fun sortedMerge (first: int list, second: int list) =
  if null first orelse null second
  then first @ second
  else if hd first <= hd second
      then hd first :: sortedMerge(tl first, second)
      else hd second :: sortedMerge (first, tl second)

(*----------------------------------------------------------------------------------------------*)

(*
  Write a sorting function qsort : int list -> int list that works as follows:
  Takes the first element out, and uses it as the "threshold" for splitA. It
  then recursively sorts the two lists produced by splitA. Finally it brings the
  two lists together.
  Don't forget that element you took out, it needs to get back in at some point.
  You could use sortedMerge for the "bring together" part, but you do not need
  to as all the numbers in one list are less than all the numbers in the other.
*)

fun qsort (integers: int list) =
  if null integers orelse null (tl integers)
  then integers
  else
    let val parts = splitA(tl integers, hd integers)
    in qsort (hd parts) @ hd integers :: qsort (hd (tl parts))
    end

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function divide : int list -> int list * int list that takes a list of
  integers and produces two lists by alternating elements between the two
  lists.
  For example: divide ([1, 2, 3, 4, 5, 6, 7]) = ([1, 3, 5, 7], [2, 4, 6])
*)
fun altOdd (integers: int list) =
  if null integers orelse null (tl integers)
  then integers
  else hd integers :: altOdd (tl (tl integers))


fun altEven (integers: int list) =
  if null integers orelse null (tl integers)
  then []
  else hd (tl integers) :: altEven (tl (tl integers))

fun divide (integers: int list) =
  (altOdd integers, altEven integers)

(*----------------------------------------------------------------------------------------------*)

(*
  Write another sorting function not_so_quick_sort : int list -> int list that
  works as follow:
  Given the inital list of integers, splits it in two lists using divide, then
  recursively sorts those two lists, then merges then together with sortedMerge
*)

fun not_so_quick_sort (integers: int list) =
  if null integers orelse null (tl integers)
  then integers
  else let
          val parts = divide integers
          val left = #1 parts
          val right = #2 parts
        in sortedMerge (not_so_quick_sort left, not_so_quick_sort right)
        end
(*----------------------------------------------------------------------------------------------*)

(*
  Write a function fullDivide : int * int -> int * int that given two numbers k
  and n it attempts to evenly divide k into n as many times as possible, and
  returns a pair (d, n2) where d is the number of times while n2 is the resulting
  n after all those divisions.
  For example: fullDivide (2, 40) = (3, 5) because 2*2*2*5 = 40
  For example: fullDivide (3, 10) = (0, 10) because 3 ods not divide 10
*)
fun howMany (k: int, n: int) =
  if n mod k = 0
  then 1 + howMany(k, n div k)
  else 0

fun total (k: int, n: int) =
  if n mod k = 0
  then total(k, n div k)
  else n

fun fullDivide (k: int, n: int) = 
  let 
    val hm = howMany (k, n)
    val res = total(k, n)
  in (hm, res)
  end

(*----------------------------------------------------------------------------------------------*)

(*
  Using fullDivide, write a function factorize : int -> (int * int) list that
  given a number n returns a list of pairs (d, k) where d is a prime number
  dividing n and k is the number of times it fits. The pairs should be in
  increasing order of prime factor, and the process should stop when the
  divisor considered surpasses the square root of n. If you make sure to use
  the reduced number n2 given by into n, it msut be prime. If it had prime
  factors, they would have been ealier prime factors of n and thus reduced
  earlier.
  For example: factorize (20) = [(2, 2), (5, 1)]
  For example: factorize (36) = [(2, 2), (3, 2)]
  For example: factorize (1) = []
*)

(*...*)

(*----------------------------------------------------------------------------------------------*)

(*
  Write a function multiply : (int * int) list -> int that given a factorization
  of a number n as described in the previous problem computes back the number n.
  So this should do the opposite of factorize
*)

fun multiply (factors: (int * int) list) =
  if null factors
  then 1
  else #1 (hd factors) * #2 (hd factors) * multiply (tl factors)

(*----------------------------------------------------------------------------------------------*)

(*
  Challenge (hard): Write a function all_products: (int * int) list -> int list
  that given a factorization list result from factorize creates a list all of
  possibles products produced from using some or all of those prime factors
  no more than the number of times they are available. This should end up
  being a list of all the divisors of the number n that gave rise to the
  list.
  For example: all_products ([(2, 2), (5, 1)]) = [1, 2, 4, 5, 10, 20].
  For extra challenge, your recursive process should return the numbers in this
  order, as opposed to sorting them afterwards.
*)

(*...*)


