#include "share/atspre_staload.hats"

datavtype toto =
  | Titi of (string)
  | {n:nat}
    Totos of (arrayptr(toto, n), size_t n)

fun make_totos(t1: toto, t2: toto, t3: toto): arrayptr(toto, 3) =
let
  val (pf, pfgc | p) = array_ptr_alloc<toto>(i2sz(3))
  val p1 = p
  prval (pf1, pf) = array_v_uncons(pf)
  val () = ptr_set<toto>(pf1 | p1, t1)
  val p2 = ptr_succ<toto>(p1)
  prval (pf2, pf) = array_v_uncons(pf)
  val () = ptr_set<toto>(pf2 | p2, t2)
  val p3 = ptr_succ<toto>(p2)
  prval (pf3, pf) = array_v_uncons(pf)
  val () = ptr_set<toto>(pf3 | p3, t3)
  prval pf = array_v_unnil_nil{toto?,toto}(pf)
  prval pf = array_v_cons(pf1, array_v_cons (pf2, array_v_cons(pf3, pf)))
in
  arrayptr_encode(pf, pfgc | p)
end

fun printfree_toto(t:toto):void =
  case+ t of
  | ~Titi(s) => println!("-> ", s)
  | ~Totos(A, n) =>
    let
      implement array_uninitize$clear<toto>(i, t) =
        printfree_toto(t)
    in
      arrayptr_freelin(A, n)
    end

fun free_toto(t:toto):void =
  case+ t of
  | ~Titi(s) => ()
  | ~Totos(A, n) =>
    let
      implement array_uninitize$clear<toto>(i, t) =
        free_toto(t)
    in
      arrayptr_freelin(A, n)
    end


implement main0() = {
  val A = make_totos(Titi("hello"), Titi("world"), Titi("!"))
  val totos = Totos(A, i2sz(3))
//  val () = printfree_toto(totos)
  val () = free_toto(totos)
}
