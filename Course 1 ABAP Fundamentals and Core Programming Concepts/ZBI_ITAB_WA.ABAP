*&---------------------------------------------------------------------*
*& Report ZBI_ITAB_WA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_ITAB_WA.

* Define a structure for employee data
TYPES: BEGIN OF ty_employee,
         emp_id TYPE char10,    " Employee ID
         name   TYPE char30,    " Employee Name
         salary TYPE p DECIMALS 2, " Employee Salary
       END OF ty_employee.

* Define internal table and work area
DATA: lt_employees TYPE TABLE OF ty_employee, " Standard internal table
      ls_employee  TYPE ty_employee.         " Work area

* Initialization: Populate internal table using APPEND
START-OF-SELECTION.
  CLEAR ls_employee.
  ls_employee-emp_id = '1001'.
  ls_employee-name = 'John Doe'.
  ls_employee-salary = '5000.00'.
  APPEND ls_employee TO lt_employees.

  CLEAR ls_employee.
  ls_employee-emp_id = '1002'.
  ls_employee-name = 'Jane Smith'.
  ls_employee-salary = '6000.00'.
  APPEND ls_employee TO lt_employees.

  CLEAR ls_employee.
  ls_employee-emp_id = '1003'.
  ls_employee-name = 'Mike Brown'.
  ls_employee-salary = '5500.00'.
  APPEND ls_employee TO lt_employees.

* READ: Access a single record using work area
  CLEAR ls_employee.
  READ TABLE lt_employees INTO ls_employee WITH KEY emp_id = '1002'.
  IF sy-subrc = 0.
    WRITE: / 'READ Result:', ls_employee-emp_id, ls_employee-name, ls_employee-salary.
  ELSE.
    WRITE: / 'Employee not found.'.
  ENDIF.

* LOOP: Iterate through internal table using work area
  WRITE: / 'All Employees:'.
  LOOP AT lt_employees INTO ls_employee.
    WRITE: / ls_employee-emp_id, ls_employee-name, ls_employee-salary.
  ENDLOOP.

* MODIFY: Update a record using work area
  CLEAR ls_employee.
  ls_employee-emp_id = '1002'.
  ls_employee-name = 'Jane Wilson'.
  ls_employee-salary = '6500.00'.
  MODIFY lt_employees FROM ls_employee TRANSPORTING name salary WHERE emp_id = '1002'.
  WRITE: / 'After MODIFY for emp_id 1002:'.
  READ TABLE lt_employees INTO ls_employee WITH KEY emp_id = '1002'.
  WRITE: / ls_employee-emp_id, ls_employee-name, ls_employee-salary.

* DELETE: Remove a record
  DELETE lt_employees WHERE emp_id = '1003'.
  WRITE: / 'After DELETE for emp_id 1003:'.
  LOOP AT lt_employees INTO ls_employee.
    WRITE: / ls_employee-emp_id, ls_employee-name, ls_employee-salary.
  ENDLOOP.