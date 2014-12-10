#include "share/atspre_staload.hats"
fun isqrt{x:nat}(x: int x): int =
  let 
    fun search
      {x,l,r:nat}
      (x: int x, l: int l, r: int r): int =
      let
        val diff = r - l
        val () = println!("l=",l, " r=",r," diff=",diff)
      in
        begin case+ 0 of
        | _ when diff > 1 =>
          let
            val m = l + (diff / 2)
          in
            if x / m < m
            then search (x, l, m)
            else search (x, m, r)
          end
        | _ => l
        end
      end
      
  in
    search (x, 0, x)
  end
/*
fun
isqrt{x:nat}
  (x: int x): int = let
//
fun search
  {x,l,r:nat | l < r} .<r-l>.
(
  x: int x, l: int l, r: int r
) : int = let
  val diff = r - l
in
  case+ 0 of
  | _ when diff > 1 => let
      val m = l + (diff / 2)
    in
      if x / m < m
      then search (x, l, m)
      else search (x, m, r)
    end // end of [if]
  | _ => l (* the result is found *)
end // end of [search]
//
in
  if x > 0 then search (x, 0, x) else 0
end // end of [isqrt]
*/

implement main0 () = {
  val n = isqrt(3)
  val () = println!(n)
}
