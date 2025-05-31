*&---------------------------------------------------------------------*
*& Report  ZAM_UPLOAD_EXCEL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zbi_excel_upload.
*&---------------------------------------------------------------------*
*&      Data Definition
*&---------------------------------------------------------------------*
TYPES : BEGIN OF ty_excel ,

          bukrs        TYPE bukrs,
          werks        TYPE  werks_d,
          working_date TYPE dats,
          userid       TYPE  char12,
          date         TYPE  dats,
        END OF ty_excel .

CONSTANTS : column  TYPE i VALUE 17 .

DATA      : i_excel TYPE TABLE OF ty_excel .
DATA      : i_excel_1 TYPE TABLE OF ty_excel .

*&---------------------------------------------------------------------*
*&      Selection Screen
*&---------------------------------------------------------------------*
PARAMETERS : p_file TYPE char255  DEFAULT 'C:\' OBLIGATORY .

*&---------------------------------------------------------------------*
*&      AT SELECTION-SCREEN
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .
  PERFORM browse_file .

AT SELECTION-SCREEN .
  PERFORM check_file_exist .

*&---------------------------------------------------------------------*
*&      Start of Selection
*&---------------------------------------------------------------------*
START-OF-SELECTION .
  PERFORM upload_data  .

*&---------------------------------------------------------------------*
*&      Form  browse_file
*&---------------------------------------------------------------------*
FORM browse_file .

  DATA : i_files  TYPE filetable,
         ls_file  TYPE file_table,
         lv_subrc TYPE i,
         lv_user  TYPE i,
         lv_def   TYPE string.

  lv_def = p_file .

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = 'Select file to upload'
      default_extension       = 'XLS'
      default_filename        = lv_def
      initial_directory       = 'D:\'
    CHANGING
      file_table              = i_files
      rc                      = lv_subrc
      user_action             = lv_user
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK lv_user IS INITIAL .
  CHECK i_files IS NOT INITIAL .
  READ TABLE i_files INTO ls_file INDEX 1.
  p_file = ls_file-filename.

ENDFORM .                    "browse_file


*&---------------------------------------------------------------------*
*&      Form  check_file_exist
*&---------------------------------------------------------------------*

FORM check_file_exist .

  DATA : lv_file   TYPE string,
         lv_result TYPE abap_bool.

  lv_file = p_file .

  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file                 = lv_file
    RECEIVING
      result               = lv_result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF lv_result = abap_false .
    MESSAGE e003(z001) WITH 'File' p_file 'does not exist' .
  ENDIF.

ENDFORM .                    "check_file_exist


*&---------------------------------------------------------------------*
*&      Form  upload_data
*&---------------------------------------------------------------------*

FORM upload_data  .

  DATA : i_raw    TYPE TABLE OF alsmex_tabline,
         lv_file  TYPE rlgrap-filename,
         lv_name  TYPE string,
         ls_raw   TYPE alsmex_tabline,
         ls_excel TYPE ty_excel.

  "FIELD-SYMBOLS :  TYPE ANY .

  FIELD-SYMBOLS : <fs_1> TYPE ANY TABLE,
                  <fs_2> ,
                  <fs_3>.

  DATA : begin_col TYPE  i VALUE 1,
         begin_row TYPE  i VALUE 1,
         end_col   TYPE  i VALUE column,
         end_row   TYPE  i VALUE 200.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Uploading Excel File ...'.

  lv_file = p_file .

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = lv_file
      i_begin_col             = begin_col
      i_begin_row             = begin_row
      i_end_col               = end_col
      i_end_row               = end_row
    TABLES
      intern                  = i_raw
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'I'      NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    LEAVE LIST-PROCESSING .
  ENDIF.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      text = 'Extracting data from Excel File ...'.

  SORT i_raw BY row col.

  LOOP AT i_raw INTO ls_raw .
    AT NEW row .
      CLEAR ls_excel .
    ENDAT.

    CASE ls_raw-col.
      WHEN '0001'.
        ls_excel-bukrs = ls_raw-value.
      WHEN '0002'.
        ls_excel-werks = ls_raw-value.
      WHEN '0003'.

        ls_excel-working_date = |{ ls_raw-value+6(4) }{ ls_raw-value+3(2) }{ ls_raw-value+0(2) }|.
      WHEN '0004'.
        ls_excel-userid = ls_raw-value.
      WHEN '0005'.
        ls_excel-date = |{ ls_raw-value+6(4) }{ ls_raw-value+3(2) }{ ls_raw-value+0(2) }|.
    ENDCASE.
    AT END OF row.
      APPEND ls_excel TO i_excel .
    ENDAT .
  ENDLOOP.

  LOOP AT i_excel INTO ls_excel.
    WRITE /: ls_excel-bukrs, ls_excel-werks, ls_excel-working_date, ls_excel-userid, ls_excel-date.
  ENDLOOP.

data : x_file type string.
data : p_filename type string.
move p_file to x_file.
move p_file to p_filename.
CONCATENATE x_file sy-timlo '.XLS' into x_file.


CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename                      = p_filename
   FILETYPE                      = 'ASC'
   HAS_FIELD_SEPARATOR           = '|'
*   HEADER_LENGTH                 = 0
*   READ_BY_LINE                  = 'X'
*   DAT_MODE                      = ' '
*   CODEPAGE                      = ' '
*   IGNORE_CERR                   = ABAP_TRUE
*   REPLACEMENT                   = '#'
*   CHECK_BOM                     = ' '
*   VIRUS_SCAN_PROFILE            =
*   NO_AUTH_CHECK                 = ' '
* IMPORTING
*   FILELENGTH                    =
*   HEADER                        =
  tables
    data_tab                      = i_excel_1
* CHANGING
*   ISSCANPERFORMED               = ' '
 EXCEPTIONS
   FILE_OPEN_ERROR               = 1
   FILE_READ_ERROR               = 2
   NO_BATCH                      = 3
   GUI_REFUSE_FILETRANSFER       = 4
   INVALID_TYPE                  = 5
   NO_AUTHORITY                  = 6
   UNKNOWN_ERROR                 = 7
   BAD_DATA_FORMAT               = 8
   HEADER_NOT_ALLOWED            = 9
   SEPARATOR_NOT_ALLOWED         = 10
   HEADER_TOO_LONG               = 11
   UNKNOWN_DP_ERROR              = 12
   ACCESS_DENIED                 = 13
   DP_OUT_OF_MEMORY              = 14
   DISK_FULL                     = 15
   DP_TIMEOUT                    = 16
   OTHERS                        = 17
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.



  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE                    =
      filename                        = x_file
     FILETYPE                        = 'ASC'
*     APPEND                          = ' '
*     WRITE_FIELD_SEPARATOR           = ' '
*     HEADER                          = '00'
*     TRUNC_TRAILING_BLANKS           = ' '
*     WRITE_LF                        = 'X'
*     COL_SELECT                      = ' '
*     COL_SELECT_MASK                 = ' '
*     DAT_MODE                        = ' '
*     CONFIRM_OVERWRITE               = ' '
*     NO_AUTH_CHECK                   = ' '
*     CODEPAGE                        = ' '
*     IGNORE_CERR                     = ABAP_TRUE
*     REPLACEMENT                     = '#'
*     WRITE_BOM                       = ' '
*     TRUNC_TRAILING_BLANKS_EOL       = 'X'
*     WK1_N_FORMAT                    = ' '
*     WK1_N_SIZE                      = ' '
*     WK1_T_FORMAT                    = ' '
*     WK1_T_SIZE                      = ' '
*     WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
*     SHOW_TRANSFER_STATUS            = ABAP_TRUE
*     VIRUS_SCAN_PROFILE              = '/SCET/GUI_DOWNLOAD'
*   IMPORTING
*     FILELENGTH                      =
    tables
      data_tab                        = i_excel
*     FIELDNAMES                      =
   EXCEPTIONS
     FILE_WRITE_ERROR                = 1
     NO_BATCH                        = 2
     GUI_REFUSE_FILETRANSFER         = 3
     INVALID_TYPE                    = 4
     NO_AUTHORITY                    = 5
     UNKNOWN_ERROR                   = 6
     HEADER_NOT_ALLOWED              = 7
     SEPARATOR_NOT_ALLOWED           = 8
     FILESIZE_NOT_ALLOWED            = 9
     HEADER_TOO_LONG                 = 10
     DP_ERROR_CREATE                 = 11
     DP_ERROR_SEND                   = 12
     DP_ERROR_WRITE                  = 13
     UNKNOWN_DP_ERROR                = 14
     ACCESS_DENIED                   = 15
     DP_OUT_OF_MEMORY                = 16
     DISK_FULL                       = 17
     DP_TIMEOUT                      = 18
     FILE_NOT_FOUND                  = 19
     DATAPROVIDER_EXCEPTION          = 20
     CONTROL_FLUSH_ERROR             = 21
     OTHERS                          = 22
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.                    "upload_data