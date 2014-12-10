// patscc -DATS_MEM_ALLOC_LIBC funmap.dats
#include "share/atspre_staload.hats"

staload UN = "prelude/SATS/unsafe.sats"
staload "libats/ML/SATS/list0.sats"
staload "libats/ML/SATS/funmap.sats"
staload _ = "libats/ML/DATS/funmap.dats"
staload _ = "libats/DATS/funmap_avltree.dats"

implement main0 () = {

  typedef key = int
  typedef itm = string
  typedef map = map (key, itm)

  var map           = funmap_make_nil {key,itm} ()
  val-~None_vt()    = funmap_insert (map, 0, "a")
  val-~Some_vt("a") = funmap_insert (map, 0, "a")
  val-~None_vt()    = funmap_insert (map, 1, "b")
  val-~None_vt()    = funmap_insert (map, 2, "c")
  val ()            = assert (funmap_size (map) = 3)
  val ()            = assert (funmap_remove(map, 0))
  val-~None_vt()    = funmap_takeout (map, 0)
  val-~Some_vt("b") = funmap_takeout (map, 1)
  val-~Some_vt("c") = funmap_takeout (map, 2)
  val ()            = assert (funmap_size (map) = 0)
}
