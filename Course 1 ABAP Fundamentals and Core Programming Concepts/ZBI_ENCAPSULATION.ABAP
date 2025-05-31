*&---------------------------------------------------------------------*
*& Report ZBI_ENCAPSULATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_ENCAPSULATION.
CLASS lcl_employee DEFINITION.
  PUBLIC SECTION.
    METHODS: set_salary IMPORTING iv_salary TYPE i.
    METHODS: get_salary RETURNING VALUE(rv_salary) TYPE i.
  PRIVATE SECTION.
    DATA: mv_salary TYPE i.
ENDCLASS.

CLASS lcl_employee IMPLEMENTATION.
  METHOD set_salary.
    IF iv_salary > 0.
      mv_salary = iv_salary.
    ENDIF.
  ENDMETHOD.
  METHOD get_salary.
    rv_salary = mv_salary.
  ENDMETHOD.
ENDCLASS.

DATA: lo_employee TYPE REF TO lcl_employee.

START-OF-SELECTION.
  CREATE OBJECT lo_employee.
  lo_employee->set_salary( 50000 ).
  WRITE: / 'Salary:', lo_employee->get_salary( ). " Output: Salary: 50000