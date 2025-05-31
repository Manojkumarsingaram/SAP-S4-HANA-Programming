*&---------------------------------------------------------------------*
*& Report ZBI_DATE_TIME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_DATE_TIME.


data : lv_date type d,
       lv_time type t,
       o_date type c LENGTH 10,
       o_time type c LENGTH 8.

lv_date = sy-datum.
lv_time = sy-timlo.


o_date = |{ lv_date+6(2) }.{ lv_date+4(2) }.{ lv_date+0(4) }|.
o_time = |{ lv_time+0(2) }:{ lv_time+2(2) }:{ lv_time+4(2) }|.


CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
  EXPORTING
    input         = lv_date
 IMPORTING
   OUTPUT        = o_date.



write /: lv_date , o_date.
write /: lv_time , o_time.