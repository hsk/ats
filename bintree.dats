staload _ = "prelude/DATS/integer.dats"

datavtype bin(a:t@ype) =
  | Bnil of ()
  | Bcons of (bin a, a, bin a)

fun{a:t@ype}bin_size(bt: !bin a): int = (
  case+ bt of
  | Bnil() => 0
  | Bcons(bt1, _, bt2) => 1 + (bin_size(bt1) + bin_size(bt2))
)

fun{a:t@ype}bin_height(bt: !bin a): int = (
  case+ bt of
  | Bnil() => 0
  | Bcons(bt1, _, bt2) => 1 + max(bin_height(bt1), bin_height(bt2))
)

fun{a:t@ype}bin_copy(bt: !bin a): bin a = (
  case+ bt of
  | Bnil() => Bnil{a}()
  | Bcons(bt1, x, bt2) => Bcons(bin_copy(bt1), x, bin_copy(bt2))
)

fun{a:t@ype}bin_free(bt: bin a): void = (
  case+ bt of
  | ~Bnil() => ()
  | ~Bcons(bt1, _, bt2) => (bin_free bt1; bin_free bt2)
)

implement main0() = {

  typedef T = int

  val bt0 = Bnil{T}()
  val bt0_2 = bin_copy(bt0)
  val bt1 = Bcons{T}(bt0, 1, bt0_2)
  val bt1_2 = bin_copy(bt1)
  val bt2 = Bcons{T}(bt1, 2, bt1_2)

  val () = assertloc(bin_size(bt2) = 3)
  val () = assertloc(bin_height(bt2) = 2)
  val () = bin_free(bt2)
}
