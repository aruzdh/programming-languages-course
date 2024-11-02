(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* a) Write a function all_except_option, which takes a string and a string list. Return NONE if the
string is not in the list, else return SOME lst where lst is identical to the argument list except the string
is not in it. You may assume the string is in the list at most once. Use same_string, provided to you,
to compare strings. Sample solution is around 8 lines.*)

fun all_except_option (str, strs ) =
  let 
    fun remove_str (_, []) = []
    | remove_str (target, x::xs') =
        if same_string(x, target)
        then xs'
        else x :: remove_str(str, xs')
    val computated = remove_str (str, strs)
  in
    if computated = strs then NONE else SOME computated
  end

(* b) Write a function get_substitutions1, which takes a string list list (a list of list of strings, the
substitutions) and a string s and returns a string list. The result has all the strings that are in
some list in substitutions that also has s, but s itself should not be in the result. Example:
get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],
                     "Fred")
(* answer: ["Fredrick","Freddie","F"] *)
Assume each list in substitutions has no repeats. The result will have repeats if s and another string are
both in more than one list in substitutions. Example:
get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]],
"Jeff")
(* answer: ["Jeffrey","Geoff","Jeffrey"] *)
Use part (a) and ML’s list-append (@) but no other helper functions. Sample solution is around 6 lines.*)

fun get_substitutions1 ([], _) = []
  | get_substitutions1 (x::xs',str) =
      case all_except_option (str, x) of
          NONE => get_substitutions1(xs', str)
        | SOME lst => lst @ get_substitutions1 (xs', str)

(* c) Write a function get_substitutions2, which is like get_substitutions1 except it uses a tail-recursive
local helper function.*)

fun get_substitutions2 (strs, str) =
  let
    fun aux([], _, acc) = acc
    | aux (x::xs', name, acc) = 
      case all_except_option (str, x) of
          NONE => aux (xs', name, acc)
        | SOME lst => aux (xs', name, acc @ lst)
  in
    aux (strs, str, [])
  end

(* d) Write a function similar_names, which takes a string list list of substitutions (as in parts (b) and
(c)) and a full name of type {first:string,middle:string,last:string} and returns a list of full
names (type {first:string,middle:string,last:string} list). The result is all the full names you
can produce by substituting for the first name (and only the first name) using substitutions and parts (b)
or (c). The answer should begin with the original name (then have 0 or more other names). 

Example:
similar_names([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],
{first="Fred", middle="W", last="Smith"})
(* answer: [{first="Fred", last="Smith", middle="W"},
{first="Fredrick", last="Smith", middle="W"},
{first="Freddie", last="Smith", middle="W"},
{first="F", last="Smith", middle="W"}] *)

Do not eliminate duplicates from the answer. Hint: Use a local helper function. Sample solution is
around 10 lines.*)

fun similar_names (substitutions, full_name) =
  let
    val {first=fst, middle=mid, last=lst} = full_name

    fun generate []= []
      | generate (x::xs') = {first=x, middle=mid, last=lst} :: generate xs'

  in
    full_name :: generate (get_substitutions2 (substitutions, fst))
  end

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(*Write a function card_color, which takes a card and returns its color (spades and clubs are black,
diamonds and hearts are red). Note: One case-expression is enough.*)

fun card_color (Spades, _ : rank) = Black
  | card_color (Clubs, _: rank) = Black
  | card_color _ = Red

(*Write a function card_value, which takes a card and returns its value (numbered cards have their
number as the value, aces are 11, everything else is 10). Note: One case-expression is enough.*)

fun card_value (_: suit, Ace) = 11
  | card_value (_, Num num) = num
  | card_value (_, _) = 10

(*Write a function remove_card, which takes a list of cards cs, a card c, and an exception e. It returns a
list that has all the elements of cs except c. If c is in the list more than once, remove only the first one.
If c is not in the list, raise the exception e. You can compare cards with=*)

fun remove_card (cs, c, e) =
  let
    fun remove ([], _) = []
      | remove (x::xs', card) = if x = card then xs' else x :: remove (xs', card)
    val cards = remove (cs, c)
  in
    if cards = cs
    then raise e
    else cards
  end

(*Write a function all_same_color, which takes a list of cards and returns true if all the cards in the
list are the same color. Hint: An elegant solution is very similar to one of the functions using nested
pattern-matching in the lectures.*)

fun all_same_color [] = true
  | all_same_color (_::[]) = true
  | all_same_color (x::y::xs') = (card_color x = card_color y) andalso all_same_color (y::xs')

(*Write a function sum_cards, which takes a list of cards and returns the sum of their values. Use a locally
defined helper function that is tail recursive. (Take “calls use a constant amount of stack space” as a
requirement for this problem.)*)

fun sum_cards cards =
  let
    fun aux ([], acc) = acc
      | aux (x::xs', acc) = aux (xs', acc + card_value x) 
  in
    aux (cards, 0)
  end

(*Write a function score, which takes a card list (the held-cards) and an int (the goal) and computes
the score as described above.*)

fun score ([], goal) = goal
  | score (cards, goal) =
    let 
      val sum = sum_cards cards
      val pre =  if sum > goal then 3 * (sum - goal) else (goal - sum)
      val same_c = all_same_color cards
    in
      if same_c then pre div 2 else pre
    end

(*Write a function officiate, which “runs a game.” It takes a card list (the card-list) a move list
(what the player “does” at each point), and an int (the goal) and returns the score at the end of the
game after processing (some or all of) the moves in the move list in order. Use a locally defined recursive
helper function that takes several arguments that together represent the current state of the game. As
described above:

• The game starts with the held-cards being the empty list.
• The game ends if there are no more moves. (The player chose to stop since the move list is empty.)
• If the player discards some card c, play continues (i.e., make a recursive call) with the held-cards
not having c and the card-list unchanged. If c is not in the held-cards, raise the IllegalMove
exception.
• If the player draws and the card-list is (already) empty, the game is over. Else if drawing causes
the sum of the held-cards to exceed the goal, the game is over (after drawing). Else play continues
with a larger held-cards and a smaller card-list.

Sample solution for (g) is under 20 lines.*)

fun officiate (cds, mvs, gl) =
  let
    fun game (held, _, [], goal) = score (held, goal)
      | game (held, c::cs', m::ms', goal) =
        if sum_cards held <= goal
        then
          case m of
              Discard cd => game (remove_card (held, cd, IllegalMove), c::cs', ms', goal)
            | Draw => game (c::held, cs', ms', goal)
        else score (held, goal)
      | game (held, [], (Discard c)::[], goal) = score (remove_card(held, c, IllegalMove), goal)
      | game (held, [], _, goal) = score (held, goal)
  in
    game ([], cds, mvs, gl)
  end

