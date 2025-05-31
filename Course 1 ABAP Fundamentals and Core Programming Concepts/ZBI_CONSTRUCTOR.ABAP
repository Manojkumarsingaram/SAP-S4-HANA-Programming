*&---------------------------------------------------------------------*
*& Report ZBI_CONSTRUCTOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_CONSTRUCTOR.
CLASS lcl_employee DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: counter TYPE i.
    DATA: emp_id TYPE i.
    METHODS: constructor.
    CLASS-METHODS: class_constructor.
ENDCLASS.

CLASS lcl_employee IMPLEMENTATION.
  METHOD class_constructor.
    counter = 0.
    WRITE: / 'Static counter initialized'.
  ENDMETHOD.
  METHOD constructor.
    counter = counter + 1.
    emp_id = counter.
    WRITE: / 'Employee created with ID:', emp_id.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lo_emp1 TYPE REF TO lcl_employee,
        lo_emp2 TYPE REF TO lcl_employee.
  CREATE OBJECT lo_emp1. " Output: Static counter initialized, Employee created with ID: 1
  CREATE OBJECT lo_emp2. " Output: Employee created with ID: 2