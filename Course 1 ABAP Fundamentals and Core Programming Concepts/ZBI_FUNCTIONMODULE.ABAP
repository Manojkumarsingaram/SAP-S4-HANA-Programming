*&---------------------------------------------------------------------*
*& Report ZBI_FUNCTIONMODULE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_FUNCTIONMODULE.

data : in_1 type i VALUE '1'.
data : in_2 type i VALUE '2'.
data : out type i.

CALL FUNCTION 'ZBI_SUM'
  EXPORTING
    in_1              = in_1
    in_2              = in_2
 IMPORTING
   OUT               = out
 EXCEPTIONS
   ERROR_OCCUR       = 1
   OTHERS            = 2
          .
IF sy-subrc = 1.
MESSAGE 'Error Occured' type 'E'.
else.
  write /: out.
ENDIF.