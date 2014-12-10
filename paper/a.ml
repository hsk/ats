open Printf

type b =
  | Type
  | Bool

type sorts =
  | SB of b
  | SFun of sorts * sorts
type a = string
type s =
  | Var of a
  | Sc of s list
  | Lam of a * sorts * s
  | App of s * s
type ctx =
  | Ctx of (a * sorts) list
type sign =
  | Sig of (sorts list) * b
(* 置換 *)
type subst =
  | Subst of (a * s) list

let _ =
  printf "%d\n" 10

