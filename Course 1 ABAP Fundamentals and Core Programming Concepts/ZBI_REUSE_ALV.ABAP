*&---------------------------------------------------------------------*
*& Report ZBI_RESUE_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbi_resue_alv.


TABLES : bkpf.


SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : p_bukrs FOR bkpf-bukrs NO INTERVALS NO-EXTENSION DEFAULT '1710' OBLIGATORY,
                   s_belnr FOR bkpf-belnr,
                   s_gjahr FOR bkpf-gjahr OBLIGATORY.

SELECTION-SCREEN : END OF BLOCK b1.

DATA : ref_grid TYPE REF TO cl_gui_alv_grid.

TYPES : BEGIN OF ty_bkpf,
          check  TYPE c,
          bukrs  TYPE bkpf-bukrs,
          belnr  TYPE bkpf-belnr,
          gjahr  TYPE bkpf-gjahr,
          blart  TYPE bkpf-blart,
          budat  TYPE bkpf-budat,
          tcode  TYPE bkpf-tcode,
          bktxt  TYPE bkpf-bktxt,
          status TYPE bkpf-bktxt,
        END OF ty_bkpf.

DATA : it_bkpf TYPE STANDARD TABLE OF ty_bkpf,
       wa_bkpf TYPE ty_bkpf.

START-OF-SELECTION.

  SELECT * FROM bkpf INTO CORRESPONDING FIELDS OF TABLE @it_bkpf WHERE bukrs IN @p_bukrs AND belnr IN @s_belnr AND gjahr IN @s_gjahr.
  IF sy-subrc <> 0.
    MESSAGE 'No Data Found' TYPE 'E'.
  ENDIF.

  DATA(it_fieldcat) = VALUE slis_t_fieldcat_alv(
  ( fieldname = 'CHECK' tabname = 'IT_BKPF' seltext_l = 'Select' col_pos = '1' edit = 'X'  checkbox = 'X' )
  ( fieldname = 'BUKRS' tabname = 'IT_BKPF' seltext_l = 'Company Code' col_pos = '2' )
  ( fieldname = 'BELNR' tabname = 'IT_BKPF' seltext_l = 'Document Number' col_pos = '3' hotspot = 'X' )
  ( fieldname = 'GJAHR'  tabname = 'IT_BKPF' seltext_l = 'Fiscal Year' col_pos = '4' )
  ( fieldname = 'BLART' tabname = 'IT_BKPF' seltext_l = 'Document Type' col_pos = '5' )
  ( fieldname = 'BUDAT' tabname = 'IT_BKPF' seltext_l = 'Posting Date' col_pos = '6' )
  ( fieldname = 'TCODE' tabname = 'IT_BKPF' seltext_l = 'Transaction Code' col_pos = '7' )
  ( fieldname = 'BKTXT' tabname = 'IT_BKPF' seltext_l = 'Remarks' col_pos = '8' edit = 'X' outputlen = '15'  )
  ( fieldname = 'STATUS' tabname = 'IT_BKPF' seltext_l = 'Status' col_pos = '9' outputlen = '10' )

  ).

  DATA(ls_layout) = VALUE slis_layout_alv( colwidth_optimize = 'X' ).

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'PF_STATUS'
      i_callback_user_command  = 'USER_COMMAND'
      is_layout                = ls_layout
      it_fieldcat              = it_fieldcat
    TABLES
      t_outtab                 = it_bkpf
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

FORM user_command USING rs_ucomm TYPE sy-ucomm
                        rs_selfield TYPE slis_selfield.


  CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = ref_grid.

  IF ref_grid IS NOT INITIAL.
    DATA(lv_refresh) = 'X'.

    CALL METHOD ref_grid->check_changed_Data
      CHANGING
        c_refresh = lv_refresh.
  ENDIF.

  CASE rs_ucomm.
    WHEN '&DISPLAY'.

      READ TABLE it_bkpf INTO wa_bkpf INDEX rs_selfield-tabindex.
      IF sy-subrc = 0.

        SET PARAMETER ID 'BUK' FIELD wa_bkpf-bukrs.
        SET PARAMETER ID 'BLN' FIELD wa_bkpf-belnr.
        SET PARAMETER ID 'GJR' FIELD wa_bkpf-gjahr.

        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.

      ENDIF.

    WHEN '&IC1'.

      READ TABLE it_bkpf INTO wa_bkpf INDEX rs_selfield-tabindex.
      IF sy-subrc = 0.

        SET PARAMETER ID 'BUK' FIELD wa_bkpf-bukrs.
        SET PARAMETER ID 'BLN' FIELD wa_bkpf-belnr.
        SET PARAMETER ID 'GJR' FIELD wa_bkpf-gjahr.

        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.

      ENDIF.

    WHEN '&APPR'.

      LOOP AT it_bkpf ASSIGNING FIELD-SYMBOL(<fs_appr>) WHERE check = 'X'.
        <fs_appr>-status = 'Approved'.
      ENDLOOP.


    WHEN '&REJ'.
      LOOP AT it_bkpf ASSIGNING FIELD-SYMBOL(<fs_rej>) WHERE check = 'X'.
        <fs_rej>-status = 'Rejected'.
      ENDLOOP.

      CALL METHOD ref_grid->refresh_table_display( ).
  ENDCASE.

  rs_selfield-refresh = 'X'.
  RS_sELFIELD-col_stable = 'X'.
  rs_selfield-row_stable = 'X'.


ENDFORM.

FORM pf_status USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'ZSTATUS'.

ENDFORM.