*&---------------------------------------------------------------------*
*& Report ZBI_EXCEPTION_HANDLING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_EXCEPTION_HANDLING.
CLASS lcl_calculator DEFINITION.
  PUBLIC SECTION.
    METHODS: divide IMPORTING iv_num1 TYPE i
                             iv_num2 TYPE i
                    RAISING  cx_sy_zerodivide.
ENDCLASS.

CLASS lcl_calculator IMPLEMENTATION.
  METHOD divide.
    IF iv_num2 = 0.
      RAISE EXCEPTION TYPE cx_sy_zerodivide.
    ENDIF.
    data(num3) = iv_num1 / iv_num2.
    WRITE: / 'Result:', num3.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lo_calc TYPE REF TO lcl_calculator.
  CREATE OBJECT lo_calc.
  TRY.
    lo_calc->divide( iv_num1 = 10 iv_num2 = 0 ).
  CATCH cx_sy_zerodivide.
    WRITE: / 'Error: Division by zero'.
  ENDTRY.