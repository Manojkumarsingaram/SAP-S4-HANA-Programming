*&---------------------------------------------------------------------*
*& Report ZBI_STATIC_INSTANCE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_STATIC_INSTANCE.
CLASS lcl_company DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: company_name TYPE char50.
    CLASS-METHODS: set_company_name IMPORTING iv_name TYPE char50.
    DATA: emp_count TYPE i.
    METHODS: add_employee.
ENDCLASS.

CLASS lcl_company IMPLEMENTATION.
  METHOD set_company_name.
    company_name = iv_name.
  ENDMETHOD.
  METHOD add_employee.
    emp_count = emp_count + 1.
    WRITE: / 'Employee added to', company_name, 'Total:', emp_count.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  lcl_company=>set_company_name( 'ABC Corp' ).
  DATA(lo_company) = NEW lcl_company( ).
  lo_company->add_employee( ). " Output: Employee added to ABC Corp Total: 1
  DATA(lo_company2) = NEW lcl_company( ).
  lo_company2->add_employee( ). " Output: Employee added to ABC Corp Total: 1