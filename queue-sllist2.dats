absvtype queue_vtype(a:viewt@ype+, n:int) = ptr

vtypedef queue(a:vt0p, n:int) = queue_vtype(a, n)

extern praxi lemma_queue_param{a:vt0p}{n:int}(x: !queue(INV(a), n)
): [n >= 0]void

// 空のキューを生成
extern fun{}queue_make_nil{a:vt0p}(): queue(a, 0)
// キューを解放
extern fun{}queue_free_nil{a:vt0p}(que: queue(a, 0)): void

// 空チェック
extern fun{}queue_is_empty{a:vt0p}{n:int}(que: !queue(INV(a), n)
): bool(n==0)

// 空でないチェック
extern fun{}queue_isnot_empty{a:vt0p}{n:int}(que: !queue(INV(a), n)
): bool(n > 0)

// キューに追加
extern fun{a:vt0p}queue_push{n:int}(
  que: !queue(INV(a), n) >> queue(a, n+1), x: a
): void

// キューから値を取得
extern fun{a:vt0p}queue_pop{n:pos}(
  que: !queue(INV(a), n) >> queue(a, n-1)
): (a)

local

  staload "libats/SATS/sllist.sats"

  dataviewtype queue1(a:viewt@ype+, n:int) =
    {f,r:nat | f+r==n}
    QUEUE of (sllist(a, f), sllist(a, r))

  assume queue_vtype(a, n) = queue1(a, n)

in

  implement{}queue_make_nil() =
    QUEUE(sllist_nil(), sllist_nil())

  implement{}queue_free_nil(que) = {
    val+~QUEUE(f, r) = que

    prval () = lemma_sllist_param(f)
    prval () = lemma_sllist_param(r)

    prval () = sllist_free_nil(f)
    prval () = sllist_free_nil(r)
  }

  implement{}queue_is_empty(que) = 
  let
    val+QUEUE(f, r) = que
  in
    if sllist_is_nil(f)
    then sllist_is_nil(r)
    else false
  end

  implement{}queue_isnot_empty(que) =
  let
    val+QUEUE(f, r) = que
  in
    if sllist_is_cons(f)
    then true
    else sllist_is_cons(r)
  end

  implement{a}queue_push(que, x) = {
    val+@QUEUE(f, r) = que
    val () = r := sllist_cons(x, r)
    prval () = fold@(que)
  }

  implement{a}queue_pop(que) =
  let
    val+@QUEUE(f, r) = que

    prval () = lemma_sllist_param(f)
    prval () = lemma_sllist_param(r)

    val iscons = sllist_is_cons(f)
  in
    if iscons then
      let
        val x = sllist_uncons(f)
        prval () = fold@(que)
      in
        x
      end
    else
      let
        prval () = sllist_free_nil(f)
        val () = f := sllist_reverse(r)
        val () = r := sllist_nil{a}()
        val x = sllist_uncons(f)
        prval () = fold@(que)
      in
        x
      end
  end

end

#include "share/atspre_staload.hats"
staload _ = "libats/DATS/gnode.dats"
staload _ = "libats/DATS/sllist.dats"

implement main0() = {

  typedef T = int

  val Q = queue_make_nil{T}()

  val () = queue_push(Q, 0)
  val () = queue_push(Q, 1)
  val () = println!("Q[hd] = ", queue_pop(Q))
  val () = println!("Q[hd] = ", queue_pop(Q))

  val () = queue_push(Q, 2)
  val () = queue_push(Q, 3)
  val () = queue_push(Q, 4)
  val () = println!("Q[hd] = ", queue_pop(Q))
  val () = println!("Q[hd] = ", queue_pop(Q))
  val () = println!("Q[hd] = ", queue_pop(Q))

  val () = queue_free_nil(Q)

}
