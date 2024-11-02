use "hw.sml";

(* val test1 = all_except_option ("string", ["string"]) = SOME [] *)
(* val test2 = all_except_option ("string", ["sting"]) = NONE *)
(* val test3 = all_except_option ("last", ["Hey", "string", "last"]) = SOME ["Hey", "string"] *)
(* val test4 = all_except_option ("string", ["Hey", "string", "last"]) = SOME ["Hey", "last"] *)

(* val test2 = get_substitutions2 ([["foo"],["there"]], "foo") = [] *)
(**)
(* val test3 = get_substitutions2([["Fred","Fredrick"], *)
(*                                        ["Elizabeth","Betty"], *)
(*                                        ["Freddie","Fred","F"]],"Fred") = ["Fredrick","Freddie","F"] *)
(**)
(* val test4 = get_substitutions2([["Fred","Fredrick"], *)
(*                                        ["Jeff","Jeffrey"], *)
(*                                        ["Geoff","Jeff","Jeffrey"]], "Jeff") = ["Jeffrey","Geoff","Jeffrey"] *)
(* val test3 = get_substitutions2 ([["foo"],["there"]], "foo") = [] *)

(* val test4 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], {first="Fred", middle="W", last="Smith"}) = *)
(* 	    [{first="Fred", last="Smith", middle="W"}, {first="Fredrick", last="Smith", middle="W"}, *)
(* 	     {first="Freddie", last="Smith", middle="W"}, {first="F", last="Smith", middle="W"}] *)
(**)
(* val test5 = similar_names ([["Carlos"],["Fred","Fredrick", "Fein"],["Elizabeth","Betty"],["Freddie","Fred","F"]], {first="Fred", middle="W", last="Smith"}) = *)
(* 	    [{first="Fred", last="Smith", middle="W"}, {first="Fredrick", last="Smith", middle="W"}, *)
(*        {first="Fein", last="Smith", middle="W"}, *)
(* 	     {first="Freddie", last="Smith", middle="W"}, {first="F", last="Smith", middle="W"}] *)

(* val test5 = card_color (Clubs, Num 2) = Black *)

(* val test6 = card_value (Clubs, Num 2) = 2 *)
(* val test7 = card_value (Clubs, Ace) = 11 *)
(* val test8 = card_value (Clubs, Queen) = 10 *)

(* val test7 = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = [] *)
(* val test8 = remove_card ([(Hearts, Ace), (Spades, Num 4)], (Hearts, Ace), IllegalMove) = [(Spades, Num 4)] *)
(* val test9 = remove_card ([(Hearts, Ace), (Spades, Num 4), (Hearts, Ace)], *)
(* (Hearts, Ace), IllegalMove) = [(Spades, Num 4), (Hearts, Ace)] *)

(* val test1 = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true *)
(* val test2 = all_same_color [(Hearts, Ace), (Spades, Jack)] = false *)
(* val test3 = all_same_color [(Hearts, Ace), (Hearts, Ace), (Hearts, Num *)
(* 3), (Hearts, Queen), (Hearts, Num 5)] = true *)
(* val test4 = all_same_color [(Hearts, Ace)] = true *)
(* val test5 = all_same_color [] = true *)

(* val test9 = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4 *)

(* val test10 = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4 *)
(* val test11 = score ([(Hearts, Num 2),(Hearts, Num 4)],10) = 2 *)
(* val test12 = score ([(Hearts, Num 2),(Clubs, Num 4)], 2) = 3 * (6 - 2) *)
(* val test13 = score ([(Hearts, Num 2),(Hearts, Num 4)], 2) = (3 * (6 - 2)) div 2 *)

val test11 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6

val test12 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw,Draw],
                        42) = 3

val test13 = ((officiate([(Clubs,Jack),(Spades,Num 8)],
                         [Draw,Discard(Hearts,Jack)],
                         42);
               false) 
              handle IllegalMove => true)

val test14 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace), (Spades, Num 5)],
                        [Draw,Draw,Draw,Draw,Discard(Spades, Ace)],
                        42) = 3

val test15 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace), (Spades, Num 5)],
                        [Draw,Draw,Draw,Draw,Discard(Spades, Ace)],
                        45) = 6

val test16 = officiate ([(Diamonds,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw,Draw],
                        45) = 1

val test17 = officiate ([(Diamonds,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace), (Spades, Num 5)],
                        [Draw,Draw,Draw,Draw, Discard(Spades,Ace)],
                        45) = 12

val test18 = officiate ([(Diamonds,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw, Discard(Spades,Ace)],
                        45) = 12

val test19 = officiate ([(Diamonds,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw, Draw],
                        45) = 1
