*&---------------------------------------------------------------------*
*& Report ZBI_COMPLEX_DATATYPES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_COMPLEX_DATATYPES.

data : lv_string type string value 1234,
       lv_int type i,
       lv_date type d,
       lv_pack type p LENGTH 3 DECIMALS 2.

lv_string = '1234'.
       lv_int = lv_String.
       lv_date = lv_string.

write /:lv_int.
write /:lv_date.

lv_string = 'ABCD'.
try.
lv_int = lv_string.
lv_pack = lv_string.

CATCH cx_sy_conversion_error.

ENDTRY.


write /:lv_int.
write /:lv_pack.