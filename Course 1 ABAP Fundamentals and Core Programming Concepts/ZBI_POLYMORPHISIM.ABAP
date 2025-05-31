*&---------------------------------------------------------------------*
*& Report ZBI_POLYMORPHISM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_POLYMORPHISM.
INTERFACE lif_displayable.
  METHODS: display.
ENDINTERFACE.

CLASS lcl_employee DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_displayable.
    DATA: emp_name TYPE char50.
ENDCLASS.

CLASS lcl_employee IMPLEMENTATION.
  METHOD lif_displayable~display.
    WRITE: / 'Employee:', emp_name.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_department DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_displayable.
    DATA: dept_name TYPE char50.
ENDCLASS.

CLASS lcl_department IMPLEMENTATION.
  METHOD lif_displayable~display.
    WRITE: / 'Department:', dept_name.
  ENDMETHOD.
ENDCLASS.

DATA: lo_display TYPE REF TO lif_displayable.

START-OF-SELECTION.
  DATA(lo_employee) = NEW lcl_employee( ).
  lo_employee->emp_name = 'John Doe'.
  lo_display = lo_employee.
  lo_display->display( ). " Output: Employee: John Doe

  DATA(lo_dept) = NEW lcl_department( ).
  lo_dept->dept_name = 'IT'.
  lo_display = lo_dept.
  lo_display->display( ). " Output: Department: IT