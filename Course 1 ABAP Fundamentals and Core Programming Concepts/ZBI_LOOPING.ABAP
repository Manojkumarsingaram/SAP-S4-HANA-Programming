REPORT z_looping.

* Define structure for employee data
TYPES: BEGIN OF ty_employee,
         emp_id TYPE char10,
         name   TYPE char30,
         salary TYPE zsalary,  " String for '5000.00' etc.
       END OF ty_employee.

* Define table type for internal table
TYPES: ty_employee_t TYPE STANDARD TABLE OF ty_employee WITH DEFAULT KEY.

* Initialize internal table with string salary values
DATA(lt_employees) = VALUE ty_employee_t(
  ( emp_id = '1001' name = 'John Doe' salary = '5000.00' )
  ( emp_id = '1002' name = 'Jane Smith' salary = '6000.00' )
  ( emp_id = '1003' name = 'Mike Brown' salary = '5500.00' ) ).

* LOOP AT: Iterate over internal table with inline declaration
WRITE: / 'LOOP AT Example (High Salary Employees):'.
LOOP AT lt_employees INTO data(ls_employee) WHERE salary > '5500.00' .
  WRITE: / ls_employee-emp_id, ls_employee-name, ls_employee-salary.
ENDLOOP.

* DO: Counter-based loop (unchanged, no amounts involved)
WRITE: / 'DO Example (5 Iterations):'.
DO 5 TIMES.
  WRITE: / 'Iteration:', sy-index.
ENDDO.

* WHILE: Condition-based loop with string balance
DATA(lv_balance) = '1000.00'.  " String amount
WRITE: / 'WHILE Example (Balance Reduction):'.
WHILE lv_balance > '0.00'.
  DATA(lv_numeric_balance) = CONV decfloat34( lv_balance ).  " Use decfloat34 for robust conversion
  lv_numeric_balance = lv_numeric_balance - CONV decfloat34( '200.00' ).
  lv_balance = |{ lv_numeric_balance DECIMALS = 2 ALIGN = RIGHT WIDTH = 7 }|.  " Format as 'xxxx.xx'
  WRITE: / 'Remaining balance:', lv_balance.
ENDWHILE.

DATA(lv_budget) = '1000.00'.

* Start DO loop to deduct '100.00' each time
WRITE: / 'Starting Budget:', lv_budget.
DO.
* Convert budget string to a number for calculation
  DATA(lv_number_budget) = CONV decfloat34( lv_budget ).

* Subtract '100.00' (converted to number)
  lv_number_budget = lv_number_budget - CONV decfloat34( '100.00' ).

* Convert result back to string with format 'xxxx.xx'
  lv_budget = |{ lv_number_budget DECIMALS = 2 ALIGN = RIGHT WIDTH = 7 }|.
  CONDENSE lv_budget.

* Show current budget
  WRITE: / 'After spending 100.00, Budget is:', lv_budget.

* Check if budget is below '300.00' to stop the loop
  IF lv_budget < '300.00'.
    WRITE: / 'Budget is too low! Stopping now.'.
    EXIT.  " Abort the loop
  ENDIF.
ENDDO.

LOOP AT lt_employees ASSIGNING FIELD-SYMBOL(<fs_employee>).
  IF <fs_employee> IS ASSIGNED.
    IF <fs_employee>-salary < '6000.00'.
      " Convert string salary to number, add '1000.00', convert back to string
      DATA(lv_numeric_salary) = CONV decfloat34( <fs_employee>-salary ).
      lv_numeric_salary = lv_numeric_salary + CONV decfloat34( '1000.00' ).
      <fs_employee>-salary = |{ lv_numeric_salary DECIMALS = 2 ALIGN = RIGHT WIDTH = 7 }|.
    ENDIF.
  ENDIF.
ENDLOOP.