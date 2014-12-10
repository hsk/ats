#include
"share/atspre_staload.hats"

datavtype
weekday_vt =
| Monday_vt of ()
| Tuesday_vt of ()
| Wednesday_vt of ()
| Thursday_vt of ()
| Friday_vt of ()

val-~Monday_vt () = Monday_vt ()
val-~Tuesday_vt () = Tuesday_vt ()
val-~Wednesday_vt () = Wednesday_vt ()
val-~Thursday_vt () = Thursday_vt ()
val-~Friday_vt () = Friday_vt ()

implement main0 () = ()

