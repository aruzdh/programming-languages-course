use "hw.sml";

(* val test1 = only_capitals ["A","B","C"] = ["A","B","C"] *)
(* val test2 = only_capitals ["A","B","C", "i"] = ["A","B","C"] *)
(* val test3 = only_capitals ["A","B","C", "h", "H"] = ["A","B","C", "H"] *)

(* val test1 = longest_string1 ["A","bc","C"] = "bc" *)
(* val test2 = longest_string1 ["A","bc","C", "hn"] = "bc" *)
(* val test3 = longest_string1 ["A","bcy","C", "htht", "zzzz"] = "htht" *)


(* val test1 = longest_string2 ["A","bc","C"] = "bc" *)
(* val test2 = longest_string2 ["A","bc","C", "hn"] = "hn" *)
(* val test3 = longest_string2 ["A","bcy","C", "htht", "zzzz"] = "zzzz" *)

(* val test4a = longest_string3 ["A","bc","C"] = "bc" *)

(* val test4b = longest_string4 ["A","B","C"] = "C" *)

(* val test1 = longest_capitalized ["A","bc","C"] = "A" *)
(* val test2 = longest_capitalized ["A","bc","C", "Moroco"] = "Moroco" *)
(* val test3 = longest_capitalized ["A","bc","C", "Moroco", "Txxxx"] = "Moroco" *)
(* val test4 = longest_capitalized ["A","Bbbbbbb","C", "Moroco", "Txxxx"] = "Bbbbbbb" *)

(* val test6 = rev_string "abc" = "cba" *)

(* val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4 *)

(* val test8 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE *)
(* val test9 = all_answers (fn x => if x <> 1 then SOME [x] else NONE) [2,3,4,5,6,7] = SOME [7,6,5,4,3,2] *)
(* val test10 = all_answers (fn x => if x <> 1 then SOME [x] else NONE) [] = SOME [] *)

(* val test9a = count_wildcards Wildcard = 1 *)

(* val test9b = count_wild_and_variable_lengths (Variable "a") = 1 *)

(* val test9c = count_some_var ("x", Variable "x") = 1 *)

(* val test9a_1 = count_wildcards Wildcard = 1 *)
(* val test9a_2 = count_wildcards (Variable "x") = 0 *)
(* val test9a_3 = count_wildcards (TupleP [Wildcard, Variable "x", ConstP 5]) = 1 *)
(* val test9a_4 = count_wildcards (TupleP [Wildcard, TupleP [Wildcard, ConstP 3]]) = 2 *)
(* val test9a_5 = count_wildcards (ConstructorP ("Some", Variable "x")) = 0 *)

(* val test9b_1 = count_wild_and_variable_lengths (Variable "a") = 1 *)
(* val test9b_2 = count_wild_and_variable_lengths Wildcard = 1 *)
(* val test9b_3 = count_wild_and_variable_lengths (TupleP [Variable "a", Wildcard]) = 2 *)
(* val test9b_4 = count_wild_and_variable_lengths (TupleP [Variable "abc", Wildcard]) = 4 *)
(* val test9b_5 = count_wild_and_variable_lengths (TupleP [Variable "x", TupleP [Wildcard, Variable "abcd"]]) = 6 *)

(* val test9c_1 = count_some_var ("x", Variable "x") = 1 *)
(* val test9c_2 = count_some_var ("y", Variable "x") = 0 *)
(* val test9c_3 = count_some_var ("x", Wildcard) = 0 *)
(* val test9c_4 = count_some_var ("x", TupleP [Variable "x", ConstP 5]) = 1 *)
(* val test9c_5 = count_some_var ("x", TupleP [Variable "x", TupleP [Variable "x", ConstP 3]]) = 2 *)
(* val test9c_6 = count_some_var ("x", ConstructorP ("Some", Variable "x")) = 1 *)
(* val test9c_7 = count_some_var ("y", ConstructorP ("Some", Variable "x")) = 0 *)


(* val test1 = check_pat Wildcard = true *)
(* val test2 = check_pat (Variable "x") = true *)
(* val test3 = check_pat (TupleP [Variable "x", Variable "y"]) = true *)
(* val test4 = check_pat (TupleP [Variable "x", Variable "x"]) = false *)
(* val test5 = check_pat (ConstructorP ("Some", TupleP [Variable "a", Variable "b"])) = true *)
(* val test6 = check_pat (ConstructorP ("Some", TupleP [Variable "a", Variable "a"])) = false *)

(* val test10 = check_pat (Variable("x")) = true *)

(* val test11 = match (Const(1), UnitP) = NONE *)

(* Test case 1: Matching a wildcard pattern *)

(* val test1 = match (Unit, Wildcard) = SOME [] *)
(* val test2 = match (Const 5, Variable "x") = SOME [("x", Const 5)] *)
(* val test3 = match (Unit, UnitP) = SOME [] *)
(* val test4 = match (Const 42, ConstP 42) = SOME [] *)
(* val test5 = match (Const 5, ConstP 10) = NONE  (* Different constants should not match *) *)
(* val test6 = match (Tuple [Const 1, Const 2], TupleP [ConstP 1, ConstP 2]) = SOME [] *)
(* val test7 = match (Tuple [Const 3, Const 4], TupleP [Variable "x", ConstP 4]) = SOME [("x", Const 3)] *)
(* val test8 = match (Tuple [Const 3], TupleP [ConstP 3, ConstP 4]) = NONE  (* Length mismatch *) *)
(* val test9 = match (Constructor ("Some", Const 1), ConstructorP ("Some", ConstP 1)) = SOME [] *)
(* val test10 = match (Constructor ("Some", Unit), ConstructorP ("None", UnitP)) * = NONE *)
(* val test11 = match (Constructor ("Pair", Tuple [Const 1, Unit]), ConstructorP ("Pair", TupleP [Variable "x", UnitP])) = SOME [("x", Const 1)] *)
(* val test12 = match 
     (Tuple [Constructor ("A", Const 1), Constructor ("B", Const 2)], TupleP [ConstructorP ("A", ConstP 1), ConstructorP ("B", ConstP 2)]) = SOME [] *)

(* val test12 = first_match Unit [UnitP] = SOME [] *)

(* val test1 = first_match (Const 42) [Wildcard] = SOME [] *)
(* val test2 = first_match (Const 42) [Variable "x"] = SOME [("x", Const 42)] *)
(* val test3 = first_match Unit [UnitP] = SOME [] *)
(* val test4 = first_match (Const 17) [ConstP 17] = SOME [] *)
(* val test5 = first_match (Tuple [Const 1, Const 2]) [TupleP [ConstP 1, ConstP 3]] = NONE *)
(* val test6 = first_match (Tuple [Const 1, Const 2]) [TupleP [ConstP 1, ConstP 2]] = SOME [] *)
(* val test7 = first_match (Constructor ("Some", Const 42)) [ConstructorP ("Some", Variable "x")] = SOME [("x", Const 42)] *)
(* val test8 = first_match (Const 10) [TupleP [Variable "y"], ConstP 10] = SOME [] *)
(* val test9 = first_match (Tuple [Const 1]) [TupleP [ConstP 2]] = NONE *)
(* val test10 = first_match (Tuple [Constructor ("Some", Const 1), Unit])  *)
(*                 [TupleP [ConstructorP ("Some", Variable "z"), UnitP]] = SOME [("z", Const 1)] *)
