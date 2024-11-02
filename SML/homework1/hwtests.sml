use "hw.sml";

(* Homework1 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)


(* val test0 = is_older ((1,2,3),(2,3,4)) = true
val test1 = is_older((2023, 5, 20), (2023, 5, 21)) = true
val test2 = is_older((2022, 5, 20), (2023, 5, 20)) = true 
val test3 = is_older((2023, 4, 20), (2023, 5, 20)) = true 
val test4 = is_older((2023, 5, 20), (2023, 5, 20)) = false
val test5 = is_older((2023, 5, 21), (2023, 5, 20)) = false
val test6 = is_older((2029, 5, 21), (2023, 5, 20)) = false *)

(* val edge1 = is_older((2023, 12, 31), (2024, 1, 1)) = true
val edge2 = is_older((2023, 5, 31), (2023, 6, 1)) = true
val edge3 = is_older((2023, 5, 1), (2023, 5, 31)) = true *)

(* val difficult1 = is_older((1899, 12, 31), (1900, 1, 1)) = true
val difficult2 = is_older((2020, 2, 29), (2021, 2, 28)) = true
val difficult3 = is_older((2022, 5, 21), (2023, 5, 21)) = true
val difficult4 = is_older((2019, 2, 28), (2020, 2, 29)) = true
val difficult5 = is_older((2021, 1, 1), (2021, 12, 31)) = true
val difficult6 = is_older((1999, 12, 31), (2000, 1, 1)) = true
val difficult7 = is_older((2020, 2, 29), (2020, 3, 1)) = true
val difficult8 = is_older((2023, 5, 31), (2023, 6, 1)) = true
val difficult9 = is_older((2023, 6, 30), (2023, 7, 1)) = true
val difficult10 = is_older((1923, 9, 23), (2023, 9, 23)) = true *)

(* val test1 = number_in_month ([(2021,1,15),(2021,1,20),(2021,2,10)], 1) = 2
val test2 = number_in_month ([(2021,3,15),(2021,4,20),(2021,5,10)], 2) = 0
val test3 = number_in_month ([(2012,2,28),(2013,12,1)], 1) = 0
val test4 = number_in_month ([(2020,6,15),(2020,6,20),(2020,6,25)], 6) = 3
val test5 = number_in_month ([(2019,7,15),(2019,8,20),(2019,9,10)], 8) = 1
val test6 = number_in_month ([], 1) = 0
val test7 = number_in_month ([(2021,1,1),(2021,1,1),(2021,1,1)], 1) = 3 *)

(* val test3 = number_in_months_challenge([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,2,2,2,3,4,4,4]) = 3
val test4 =  number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28), (2000,2,10)],[2,3,4]) = 4
val test5 =  number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28), (2000,2,10)],[1,9,9,9,8]) = 0 *)

(* val test4 = dates_in_month ([(2012,2,28),(2013,12,1), (1011,5,1), (1000,2,52)],2) = [(2012,2,28), (1000,2,52)]
val test5 = dates_in_month ([(2012,2,28),(2013,12,1), (1011,5,1), (1000,2,52)],8) = [] *)

(* val test5 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]
val test6 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28), (100,2,8)],[2,3,4]) = [(2012,2,28),(100,2,8),(2011,3,31),(2011,4,28)] *)

(* val test6 = get_nth (["hi", "there", "how", "are", "you"], 2) = "there"
val test7 = get_nth (["hi", "there", "how", "are", "you"], 5) = "you"
val test8 = get_nth (["hi", "there", "how", "are", "you"], 1) = "hi" *)

(* val test1 = date_to_string (2021, 1, 15) = "January 15, 2021"
val test2 = date_to_string (2020, 2, 29) = "February 29, 2020"
val test3 = date_to_string (2019, 3, 10) = "March 10, 2019"
val test4 = date_to_string (2018, 4, 5) = "April 5, 2018"
val test5 = date_to_string (2017, 5, 20) = "May 20, 2017"
val test6 = date_to_string (2016, 6, 30) = "June 30, 2016"
val test7 = date_to_string (2015, 7, 4) = "July 4, 2015"
val test8 = date_to_string (2014, 8, 15) = "August 15, 2014"
val test9 = date_to_string (2013, 9, 1) = "September 1, 2013"
val test10 = date_to_string (2012, 10, 31) = "October 31, 2012"
val test11 = date_to_string (2011, 11, 11) = "November 11, 2011"
val test12 = date_to_string (2010, 12, 25) = "December 25, 2010" *)

(* val test1 = number_before_reaching_sum (15, [1,2,3,4,5]) = 4
val test2 = number_before_reaching_sum (5, [1,2,3,4,5]) = 2
val test3 = number_before_reaching_sum (0, [1,2,3,4,5]) = 0
val test4 = number_before_reaching_sum (10, [10,1,1,1,1]) = 0
val test5 = number_before_reaching_sum (3, [1,1,1,1,1]) = 2
val test6 = number_before_reaching_sum (7, [2,2,2,2,2]) = 3
val test7 = number_before_reaching_sum (20, [5,5,5,5,5]) = 3
val test8 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3
val test9 = number_before_reaching_sum (1, [1,1,1,1,1]) = 0
val test10 = number_before_reaching_sum (100, [10,20,30,39,50]) = 4 *)

(* val test1 = what_month 1 = 1
val test2 = what_month 31 = 1
val test3 = what_month 32 = 2
val test4 = what_month 59 = 2
val test5 = what_month 60 = 3
val test6 = what_month 90 = 3
val test7 = what_month 91 = 4
val test8 = what_month 120 = 4
val test9 = what_month 121 = 5
val test10 = what_month 151 = 5
val test11 = what_month 152 = 6
val test12 = what_month 181 = 6
val test13 = what_month 182 = 7
val test14 = what_month 212 = 7
val test15 = what_month 213 = 8
val test16 = what_month 243 = 8
val test17 = what_month 244 = 9
val test18 = what_month 273 = 9
val test19 = what_month 274 = 10
val test20 = what_month 304 = 10
val test21 = what_month 305 = 11
val test22 = what_month 334 = 11
val test23 = what_month 335 = 12
val test24 = what_month 365 = 12 *)

(* val test1 = month_range (1, 1) = [1]
val test2 = month_range (1, 31) = List.tabulate(31, fn _ => 1)
val test3 = month_range (32, 59) = List.tabulate(28, fn _ => 2)
val test4 = month_range (60, 90) = List.tabulate(31, fn _ => 3)
val test5 = month_range (91, 120) = List.tabulate(30, fn _ => 4)
val test6 = month_range (121, 151) = List.tabulate(31, fn _ => 5)
val test7 = month_range (152, 181) = List.tabulate(30, fn _ => 6)
val test8 = month_range (182, 212) = List.tabulate(31, fn _ => 7)
val test9 = month_range (213, 243) = List.tabulate(31, fn _ => 8)
val test10 = month_range (244, 273) = List.tabulate(30, fn _ => 9)
val test11 = month_range (274, 304) = List.tabulate(31, fn _ => 10)
val test12 = month_range (305, 334) = List.tabulate(30, fn _ => 11)
val test13 = month_range (335, 365) = List.tabulate(31, fn _ => 12)
val test14 = month_range (31, 34) = [1, 2, 2, 2]
val test15 = month_range (60, 65) = [3, 3, 3, 3, 3, 3]
val test16 = month_range (120, 125) = [4, 5,5,5,5,5]
val test17 = month_range (181, 185) = [6, 7, 7, 7, 7]
val test18 = month_range (243, 245) = [8, 9, 9]
val test19 = month_range (304, 306) = [10, 11, 11]
val test20 = month_range (334, 336) = [11, 12, 12] *)

(* val test1 = oldest([(2021,1,15),(2020,1,15),(2019,1,15)]) = SOME (2019,1,15)
val test2 = oldest([(2021,12,31),(2021,12,30),(2021,12,29)]) = SOME (2021,12,29)
val test3 = oldest([(2020,2,29),(2020,2,28),(2020,3,1)]) = SOME (2020,2,28)
val test4 = oldest([(2018,4,5),(2018,4,4),(2018,4,3)]) = SOME (2018,4,3)
val test5 = oldest([(2017,5,20),(2017,5,19),(2017,5,18)]) = SOME (2017,5,18)
val test6 = oldest([(2016,6,30),(2016,6,29),(2016,6,28)]) = SOME (2016,6,28)
val test7 = oldest([(2015,7,4),(2015,7,3),(2015,7,2)]) = SOME (2015,7,2)
val test8 = oldest([(2014,8,15),(2014,8,14),(2014,8,13)]) = SOME (2014,8,13)
val test9 = oldest([(2013,9,1),(2013,8,31),(2013,8,30)]) = SOME (2013,8,30)
val test10 = oldest([(2012,10,31),(2012,10,30),(2012,10,29)]) = SOME (2012,10,29)
val test11 = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)
val test12 = oldest([(2011,11,11),(2011,11,10),(2011,11,9)]) = SOME (2011,11,9)
val test13 = oldest([(2010,12,25),(2010,12,24),(2010,12,23)]) = SOME (2010,12,23)
val test14 = oldest([(2021,1,1)]) = SOME (2021,1,1)
val test15 = oldest([]) = NONE *)

(* val test0 = reasonable_date((2004, 1, 6)) = true
val test1 = reasonable_date((2004, 1, 40)) = false 
val test2 = reasonable_date((2004, 12, 31)) = true 
val test3 = reasonable_date((2004, 12, 32)) = false 
val test4 = reasonable_date((2024, 2, 29)) = true 


val test10 = what_month(60) = 2 *)

 (* val days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] 
val test0 = from_month_to_day(31, 12, days_in_months) = 365  *)
