(* 1) Write a function pass_or_fail of type {grade: int option, id: 'a} -> pass_fail
* that takes a final_grade (or, ao the type indicates, a more general type) and
* returns pass if the grade field contains SOME i for i >= 75 (else fail)*)

datatype pass_fail = pass | fail

fun pass_or_fail {grade=SOME grd, id=_} = if grd >= 75 then pass else fail
  | pass_or_fail {grade=NONE, id= _} = fail

(* 2) Using pass_or_fail as a helper function, write a function has_passed of type
* {grade: int option, id: 'a} -> bool that returns true if and only if the grade
* field contains SOME i for an i >= 75*)

fun has_passed student = pass_or_fail student = pass

(* 3) Using has_passed as a helper function, write a function number_passed that
* takes a list of type final_grade (or a more general) and returns how many list
* elements have passing (again, >= 75) grades*)

fun number_passed grades =
  let
    fun helper ([], acc) = acc
      | helper (x::xs', acc) =
        if has_passed x
        then helper (xs', acc + 1)
        else helper (xs', acc)
  in
    helper (grades, 0)
  end

(* 4) Write a function number_misgraded of type (pass_fail * final_grade) list ->
* int that indicates how many list elements are "mislabeled" where mislabeling
* means a pair (pass, x) where has_passed x is false of (fail, x) where
* has_passed x is true*)

fun number_misgraded pairs =
  let
    fun helper ([], acc) = acc
      | helper ((result, fg)::xs', acc) =
        if (result = pass andalso not (has_passed fg)) orelse
           (result = fail andalso has_passed fg)
        then helper (xs', acc + 1)
        else helper (xs', acc)
  in
    helper (pairs, 0)
  end

(*Problems 5-7 use these type definitions*)

datatype 'a tree = leaf
                 | node of {value: 'a, left: 'a tree, right: 'a tree}
datatype flag = leave_me_alone | prune_me

(* 5) Write a function tree_height that accepts an 'a tree and evaluates to a height
* of this tree. The height af a tree is the lenght of the longest path to a
* leaf. Thus the height of a leaf is 0*)

fun tree_height leaf = 0
  | tree_height (node {value=_, left=lft, right=rht}) = 
    1 + Int.max(tree_height lft, tree_height rht)

(* 6) Write a function sum_tree that takes an int tree and evaluates to the sum of
* all values in the nodes*)

fun sum_tree leaf = 0
  | sum_tree (node {value=vl, left=lft, right=rht}) =
    vl + sum_tree lft + sum_tree rht

(* 7) Write a function gardener of type tree -> flag tree such that its structure is
* identical to the original tree except all nodes of the input containing
* prune_me are (along with all their descendants replaced with a leaf)*)

fun gardener (node {value=prune_me, left=_, right=_}) = leaf
  | gardener (node {value=vl, left=lft, right=rht}) =
    node {value=vl, left=gardener lft, right=gardener rht}
  | gardener leaf = leaf

(* 8) Re-implement various functions provided in the SML standard libraries for
* lists and option: last, take, drop, concat, getOpt, and join
* http://sml-family.org/Basis/list.html
* http://sml-family.org/Basis/option.html
* *)

fun last [] = raise Empty
  | last (x::[]) = x
  | last (_::xs') = last xs'

fun take ([], _) = []
  | take (_, 0) = []
  | take (x::xs', i) = 
    if i < 0 orelse i > length (x::xs')
    then raise Subscript
    else x::take(xs', i - 1) 

fun drop ([], _) = []
  | drop (l, 0) = l
  | drop (x::xs', i) =
    if i < 0 orelse i > length (x::xs')
    then raise Subscript
    else drop (xs', i - 1)

fun concat [] = []
  | concat (x::xs') = x @ concat xs'

fun getOpt (NONE, a) = a
  | getOpt (SOME v, _) = v

fun join NONE = NONE
  | join (SOME v) = v 

(*Problems 9-16 use this type definition for natural numbers*)

datatype nat = ZERO | SUCC of nat

(*A "natural" number is either zero, or the "succesor" of another integer. So
* for examples the number 1 is just SUCC ZERO, the number 2 is SUCC (SUCC ZERO),
* and so on.*)

(* 9) Write is_positive: nat -> bool, which given a "natural number" returns whether
* that number is positive (i.ei not zero)*)

fun is_positive ZERO = false
  | is_positive _ = true

(* 10) Write pred: nat -> nat, which given a "natural number" returns its
* predecessor. Since 0 does not have a predecessor in the natural numbers, throw
* an exception Negative (will need to define it first)*)

exception Negative

fun pred ZERO = raise Negative
  | pred (SUCC n) = n

(* 11) Write nat_to_int: nat -> int, which given a "natural number" returns the
* corresponding int. For example, nat_to_int (SUCC (SUCC ZERO) = 2 (Do not use
* this function for problems 13-16 it makes them too easy)*)

fun nat_to_int n =
 let
   fun helper (nt, curr, res) =
     if nt = curr
     then res
     else helper (nt, SUCC curr, res + 1)
  in
    helper (n, ZERO, 0)
  end

(* 12) Write int_to_nat: int -> nat, which given a integer returns a "natural number"
* representation for it, or throws a Negative exception if the integer was
* negative. (Again, do not use this function in the next few problems)*)

fun int_to_nat num =
  if num < 0 then raise Negative
  else let
    fun helper (0, curr) = curr
      | helper (n, curr) = helper (n - 1, SUCC curr)
  in
    helper (num, ZERO)
  end

(* 13) Write add: nat * nat -> nat to perform addition*)

fun add (ZERO, n) = n
  | add (SUCC n, m) = SUCC (add (n, m))

(* 14) Write sub: nat * nat -> nat to perform substraction (Hint: Use pred)*)

fun sub (another, ZERO) = another
  | sub (left, right) = sub (pred left, pred right)

(* 15) Write mult: nat * nat -> nat to perform multiplication (Hint: Use add)*)

fun mult (left, right) =
  let
    fun helper (_, ZERO, _) = ZERO
      | helper (ZERO, _, _) = ZERO
      | helper (curr, SUCC ZERO, _) = curr
      | helper (curr, times, addition) = helper (add (curr, addition), pred times, addition)
  in
    helper (left, right, left)
  end

(* 16) Write less_than: nat * nat -> bool to return true when the first argument is
* less than the second*)

fun less_than (_, ZERO) = false
  | less_than (ZERO, _) = true
  | less_than (lf, rt) = less_than (pred lf, pred rt)

(* The remaining problems use this datatype, which represent sets of integers*)

datatype intSet =
  Elems of int list (*list of integers, possibly with duplicates to be ignored*)
| Range of {from: int, to: int} (*integers from one number to another*)
| Union of intSet * intSet (*Union of the two sets*)
| Intersection of intSet * intSet (*intersection of the two sets*)

(* 17) Write isEmpty: intSet -> bool that determines if the set is empty or not*)

fun isEmpty (Elems []) = true
  | isEmpty (Elems _) = false
  | isEmpty (Range {from, to}) = from > to
  | isEmpty (Union (left, right)) = isEmpty left andalso isEmpty right
  | isEmpty (Intersection (Elems left, Elems right)) = 
      List.null (List.filter (fn x => List.exists (fn y => x = y) right) left)
  | isEmpty (Intersection (left, right)) = isEmpty left orelse isEmpty right

(* 18) Write contains: intSet * int -> bool that retuns whether the set contains a
* certian element or not*)

fun contains (Elems [], _) = false
  | contains (Elems (x::xs'), target) = x = target orelse contains (Elems xs', target)
  | contains (Range {from, to}, target) = target >= from andalso target <= to
  | contains (Union (left, right), target) = contains (left, target) orelse contains (right, target)
  | contains (Intersection (left, right), target) = contains (left, target) andalso contains (right, target)

(* 19) Write toList: intSet -> int list that returns a list with set's elements,
* without duplicates*)

fun toList (Elems []) = []
  | toList (Elems (x::xs)) = 
    let 
      val rest = toList (Elems xs)
    in
      if List.exists (fn y => x = y) rest then rest else x::rest
    end
  | toList (Range {from, to}) = 
    if from > to
    then []
    else if from = to then [from] else from::toList (Range {from=from+1, to=to})
  | toList (Union (l, r)) = 
    let
      val listL = toList l
      val listR = toList r
    in
      List.foldl (fn (x, acc) => if List.exists (fn y => x = y) acc then acc else x::acc) listL listR
    end
  | toList (Intersection (Elems l, Elems r)) =
    toList (Elems (List.filter (fn x => List.exists (fn y => x = y) r) l))
  | toList (Intersection (l, r)) = 
    let 
      val listL = toList l
      val listR = toList r
    in
      List.filter (fn x => List.exists (fn y => x = y) listR) listL
    end
