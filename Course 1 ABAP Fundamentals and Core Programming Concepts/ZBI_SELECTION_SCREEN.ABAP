*&---------------------------------------------------------------------*
*& Report ZBI_SELECTION_SCREEN
*&---------------------------------------------------------------------*
*&

REPORT z_selection_screen_demo.

* Define data structures
TYPES: BEGIN OF ty_employee,
         emp_id TYPE i,
         emp_name TYPE char50,
         emp_dept TYPE char30,
       END OF ty_employee.

DATA: lt_employees TYPE TABLE OF ty_employee,
      ls_employee  TYPE ty_employee.

* Selection screen parameters
SELECTION-SCREEN : begin of block b1 WITH FRAME TITLE text-001.
PARAMETERS: p_comp TYPE char4 OBLIGATORY . "DEFAULT '1000'. " Company code
SELECT-OPTIONS: s_empid FOR ls_employee-emp_id . " Employee ID range
SELECTION-SCREEN : end of block b1.

* Initialization event
INITIALIZATION.
  p_comp = ''." '1000'. " Set default company code
  s_empid-low = 1.  " Default employee ID range
  s_empid-high = 100.
  APPEND s_empid.

* Modify screen attributes before display
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    " Make company code field read-only if it starts with '1'
    IF screen-name = 'P_COMP' AND p_comp CP '1*'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

* Validate user input after selection screen
AT SELECTION-SCREEN.
  " Check if company code is valid
  IF p_comp NA '1234567890'.
    MESSAGE 'Company code must contain only numbers' TYPE 'E'.
  ENDIF.

* Validate specific field (Employee ID)
AT SELECTION-SCREEN ON s_empid.
  IF s_empid IS NOT INITIAL.
    IF s_empid-low < 1 OR s_empid-high > 1000.
      MESSAGE 'Employee ID must be between 1 and 1000' TYPE 'E'.
    ENDIF.
  ENDIF.

* Main processing after validation
START-OF-SELECTION.
  " Sample data population
  CLEAR lt_employees.
  ls_employee-emp_id = 1.
  ls_employee-emp_name = 'John Doe'.
  ls_employee-emp_dept = 'IT'.
  APPEND ls_employee TO lt_employees.

  ls_employee-emp_id = 2.
  ls_employee-emp_name = 'Jane Smith'.
  ls_employee-emp_dept = 'HR'.
  APPEND ls_employee TO lt_employees.

  ls_employee-emp_id = 3.
  ls_employee-emp_name = 'Mike Johnson'.
  ls_employee-emp_dept = 'Finance'.
  APPEND ls_employee TO lt_employees.

  " Display employees based on selection
  WRITE: / 'Company Code:', p_comp.
  WRITE: / 'Employee Report', /.
  WRITE: / 'ID', 10 'Name', 30 'Department'.

  LOOP AT lt_employees INTO ls_employee
    WHERE emp_id IN s_empid.
    WRITE: / ls_employee-emp_id,
             10 ls_employee-emp_name,
             30 ls_employee-emp_dept.
  ENDLOOP.

* End of processing
END-OF-SELECTION.
  WRITE: / 'Report processing completed.'.