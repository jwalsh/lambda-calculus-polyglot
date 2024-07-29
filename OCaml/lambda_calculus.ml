(* File: lambda_calculus.ml
   Author: Claude (Anthropic AI model)
   Date: 2024-07-29
   Description: Lambda Calculus implementation in OCaml
   Usage: Run with `ocaml lambda_calculus.ml` *)

(* Step 1: Understand Lambda Expressions *)

(* Identity function *)
let identity x = x

(* Apply a lambda expression to an argument *)
let apply f x = f x

(* Step 2: Implement Church Booleans *)

let lc_true x y = x
let lc_false x y = y
let lc_if condition then_clause else_clause = condition then_clause else_clause

(* Step 3: Implement Basic Combinators *)

let i_combinator x = x
let k_combinator x y = x
let ki_combinator x y = y

(* Step 4: Create Church Numerals *)

let lc_zero f x = x
let lc_succ n f x = f (n f x)

let church_to_int n = n (fun x -> x + 1) 0

(* Step 5: Implement Basic Arithmetic *)

let lc_add m n f x = m f (n f x)
let lc_mult m n f = m (n f)

let lc_one = lc_succ lc_zero
let lc_two = lc_succ lc_one

(* Step 6: Implement Pairs *)

let lc_pair x y f = f x y
let lc_first p = p (fun x y -> x)
let lc_second p = p (fun x y -> y)

(* Step 7: Build Lists Using Pairs *)

let lc_nil = lc_pair lc_true lc_true
let lc_cons head tail = lc_pair lc_false (lc_pair head tail)
let lc_is_nil list = lc_first list
let lc_head list = lc_first (lc_second list)
let lc_tail list = lc_second (lc_second list)

(* Step 8: Implement Comparison Operations *)

let lc_is_zero n = n (fun _ -> lc_false) lc_true

let lc_leq m n = 
  lc_is_zero (lc_sub m n)

let lc_eq m n = 
  lc_and (lc_leq m n) (lc_leq n m)

(* Helper functions for Step 8 *)
and lc_sub m n = 
  n (fun f -> f lc_pred) (fun x -> x) m

and lc_pred n f x = 
  n (fun g h -> h (g f)) (fun _ -> x) (fun u -> u)

and lc_and a b = 
  lc_if a b lc_false

(* Step 9: Implement Higher-Order List Operations *)

let rec lc_map f list = 
  lc_if (lc_is_nil list)
    lc_nil
    (lc_cons (f (lc_head list)) (lc_map f (lc_tail list)))

let rec lc_filter pred list = 
  lc_if (lc_is_nil list)
    lc_nil
    (lc_if (pred (lc_head list))
      (lc_cons (lc_head list) (lc_filter pred (lc_tail list)))
      (lc_filter pred (lc_tail list)))

let rec lc_fold f acc list = 
  lc_if (lc_is_nil list)
    acc
    (lc_fold f (f acc (lc_head list)) (lc_tail list))

(* Step 10: Explore Recursion and Fixed-Point Combinators *)

let y_combinator f = 
  (fun x -> f (fun y -> x x y))
  (fun x -> f (fun y -> x x y))

let lc_factorial = 
  y_combinator (fun f n -> 
    lc_if (lc_is_zero n)
      lc_one
      (lc_mult n (f (lc_pred n))))

(* Example usage *)
let () =
  let three = lc_add lc_one lc_two in
  Printf.printf "1 + 2 = %d\n" (church_to_int three);

  let fact_5 = church_to_int (lc_factorial lc_five) in
  Printf.printf "5! = %d\n" fact_5
