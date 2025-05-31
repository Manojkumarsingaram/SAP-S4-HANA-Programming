*&---------------------------------------------------------------------*
*& Report ZBI_CONDITIONAL_STATEMENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_CONDITIONAL_STATEMENTS.

* Data declarations
DATA: lv_salary    TYPE p DECIMALS 2 VALUE '5500.00',
      lv_department TYPE char10 VALUE 'IT',
      lv_status    TYPE char10 VALUE 'ACTIVE'.

* IF-ELSE Example
IF lv_salary > '6000.00' AND lv_status = 'ACTIVE'.
  WRITE: / 'Employee is eligible for bonus.'.
ELSEIF lv_salary BETWEEN '4000.00' AND '6000.00'.
  WRITE: / 'Employee is eligible for partial bonus.'.
ELSE.
  WRITE: / 'No bonus eligibility.'.
ENDIF.

* CASE Example
CASE lv_department.
  WHEN 'IT'.
    WRITE: / 'Department: Information Technology'.
  WHEN 'HR'.
    WRITE: / 'Department: Human Resources'.
  WHEN OTHERS.
    WRITE: / 'Department: Other'.
ENDCASE.

DATA(lv_bonus) = COND string(
  WHEN lv_salary > '6000.00' AND lv_status = 'ACTIVE' THEN 'Employee is eligible for bonus.'
  WHEN lv_salary BETWEEN '4000.00' AND '6000.00' THEN 'Employee is eligible for partial bonus.'
  ELSE 'No bonus eligibility.'
).
WRITE: / lv_bonus.