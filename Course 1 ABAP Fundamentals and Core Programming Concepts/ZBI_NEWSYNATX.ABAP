report zbi_newsyntax.

"____________________________________________________________________________________________ " Inline declaration
DATA: lv_var1 TYPE char5.
lv_var1 = 'ABC'.
WRITE: / lv_var1.


DATA(lv_var2) = 'ABC'. " Inline declaration
WRITE: / lv_var2.

"_____________________________________________________________________________________________" Table expression
DATA: lt_vbap TYPE TABLE OF vbap,
      ls_vbap TYPE vbap.
SELECT * FROM vbap UP TO 50 ROWS INTO TABLE lt_vbap.
READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = '0000000123'.
IF sy-subrc = 0.
  WRITE: / ls_vbap-vbeln.
ENDIF.


SELECT * FROM vbap UP TO 50 ROWS INTO TABLE @DATA(lt_vbap1).
DATA(ls_vbap1) = VALUE #( lt_vbap1[ vbeln = '0000000123' ] OPTIONAL ). " Table expression
WRITE: / ls_vbap1-vbeln.


TRY.
  DATA(lv_vbeln) = lt_vbap1[ vbeln = '0000000020' ]-vbeln.    "_________________________________ " Access specific field
  WRITE: / lv_vbeln.
CATCH cx_sy_itab_line_not_found.
  WRITE: / 'Record not found.'.
ENDTRY.


"______________________________________________________________________________________________ " Inline table population
TYPES: BEGIN OF ty_data,
         col1 TYPE i,
         col2 TYPE string,
       END OF ty_data.
DATA: lt_table TYPE TABLE OF ty_data,
      ls_data  TYPE ty_data.
ls_data-col1 = 1.
ls_data-col2 = 'Test'.
APPEND ls_data TO lt_table.


TYPES: BEGIN OF ty_data1,
         col1 TYPE i,
         col2 TYPE string,
       END OF ty_data1.

 TYPES: ty_data_t TYPE TABLE OF ty_data1 WITH DEFAULT KEY.

DATA(lt_table1) = VALUE ty_data_t( ( col1 = 1 col2 = 'Test' )
                                  ( col1 = 2 col2 = 'Demo' ) ). " Inline table population

LOOP AT lt_table INTO DATA(ls_data1).
  WRITE: / ls_data-col1, ls_data-col2.
ENDLOOP.

"__________________________________________________________________________________________________Corresponding

TYPES: BEGIN OF ty_source,
         fld1 TYPE i,
         fld2 TYPE string,
         fld3 TYPE c LENGTH 1,
       END OF ty_source.
TYPES: BEGIN OF ty_target,
         fld1 TYPE i,
         fld2 TYPE string,
       END OF ty_target.
data : ls_target type ty_target,
      lt_target type STANDARD TABLE OF ty_target.

 TYPES: ty_source_t TYPE TABLE OF ty_source WITH DEFAULT KEY.
 TYPES: ty_target_t TYPE TABLE OF ty_target WITH DEFAULT KEY.

DATA(lt_source) = VALUE ty_source_t( ( fld1 = 1 fld2 = 'A' fld3 = 'X' )
                                     ( fld1 = 2 fld2 = 'B' fld3 = 'Y' ) ).

LOOP AT lt_source INTO data(ls_source).
  ls_target-fld1 = ls_source-fld1.
  ls_target-fld2 = ls_source-fld2.
  APPEND ls_target TO lt_target.
ENDLOOP.


DATA(lt_target_n) = CORRESPONDING ty_target_t( lt_source ). " Maps matching fields

LOOP AT lt_target_n INTO DATA(ls_target_n).
  WRITE: / ls_target_n-fld1, ls_target_n-fld2.
ENDLOOP.

"_______________________________________________________________________________________FOR expression
TYPES: BEGIN OF ty_final,
         ebeln TYPE ebeln,
         ebelp TYPE ebelp,
       END OF ty_final.
DATA: lt_ekpo  TYPE TABLE OF ekpo,
      lt_final TYPE TABLE OF ty_final,
      ls_final TYPE ty_final.

TYPES: ty_final_t TYPE TABLE OF ty_final WITH DEFAULT KEY.

SELECT * FROM ekpo UP TO 10 ROWS INTO TABLE @lt_ekpo.

LOOP AT lt_ekpo INTO DATA(ls_ekpo).
  ls_final-ebeln = ls_ekpo-ebeln.
  ls_final-ebelp = ls_ekpo-ebelp.
  APPEND ls_final TO lt_final.
ENDLOOP.



lt_final = VALUE ty_final_t(
                   FOR ls_ekpo_1 IN lt_ekpo ( ebeln = ls_ekpo_1-ebeln ebelp = ls_ekpo_1-ebelp )
                    ).


LOOP AT lt_final INTO ls_final.
  WRITE: / ls_final-ebeln, ls_final-ebelp.
ENDLOOP.

"_________________________________________________________________________________________" String template
DATA: lv_string TYPE string,
      lv_var    TYPE char10 VALUE 'Test'.
CONCATENATE 'Value is' lv_var INTO lv_string SEPARATED BY space.
WRITE: / lv_string.


lv_var = 'Test'.
lv_string = |Value is { lv_var }|. " String template
WRITE: / lv_string.

"_________________________________________________________________________________________COND & SWITCH
DATA: lv_score TYPE i VALUE 85,
      lv_result TYPE string.
IF lv_score >= 50.
  lv_result = 'Passed'.
ELSE.
  lv_result = 'Failed'.
ENDIF.
WRITE: / lv_result.



DATA(lv_result11) = COND string( WHEN lv_score >= 50 THEN 'Passed' ELSE 'Failed' ).
WRITE: / lv_result11.

" Using SWITCH
DATA(lv_grade) = SWITCH string( lv_score
                                WHEN 90 THEN 'A'
                                WHEN 80 THEN 'B'
                                WHEN 70 THEN 'C'
                                ELSE 'D' ).
WRITE: / lv_grade.
"______________________________________________________________________________________________