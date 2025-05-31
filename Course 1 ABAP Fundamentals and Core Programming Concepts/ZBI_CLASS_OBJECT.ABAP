*&---------------------------------------------------------------------*
*& Report ZBI_CLASS_OBJECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_CLASS_OBJECT.

CLASS lcl_employee DEFINITION.
  PUBLIC SECTION.
    DATA: emp_id TYPE i,
          emp_name TYPE char50.
    METHODS: display_info.
ENDCLASS.

CLASS lcl_employee IMPLEMENTATION.
  METHOD display_info.
    WRITE: / 'ID:', emp_id, 'Name:', emp_name.
  ENDMETHOD.
ENDCLASS.

DATA: lo_employee TYPE REF TO lcl_employee.

START-OF-SELECTION.
  CREATE OBJECT lo_employee.
  lo_employee->emp_id = 1.
  lo_employee->emp_name = 'John Doe'.
  lo_employee->display_info( ). " Output: ID: 1 Name: John Doe