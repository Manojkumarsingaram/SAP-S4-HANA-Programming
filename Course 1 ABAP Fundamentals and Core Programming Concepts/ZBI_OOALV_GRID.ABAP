*&---------------------------------------------------------------------*
*& Report ZBI_OOALV_GRID
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_OOALV_GRID.

* Data declarations
TYPES: BEGIN OF ty_data,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         price     TYPE sflight-price,
       END OF ty_data.

DATA: lt_data      TYPE TABLE OF ty_data,
      lt_fieldcat  TYPE lvc_t_fcat,
      lr_grid      TYPE REF TO cl_gui_alv_grid,
      lr_container TYPE REF TO cl_gui_custom_container.

* Event handler class for double-click
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS: handle_double_click
      FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_double_click.
    DATA: ls_data TYPE ty_data.
    READ TABLE lt_data INTO ls_data INDEX e_row-index.
    IF sy-subrc = 0.
      MESSAGE i000(8) WITH 'Double-clicked on Carrier:' ls_data-carrid
                           'Connection:' ls_data-connid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
* Sample data
  SELECT carrid connid fldate price
    INTO TABLE lt_data
    FROM sflight
    UP TO 20 ROWS.

* Create field catalog
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      ct_fieldcat      = lt_fieldcat.

* Create container and grid
  CREATE OBJECT lr_container
    EXPORTING
      container_name = 'CONTAINER'.

  CREATE OBJECT lr_grid
    EXPORTING
      i_parent = lr_container.

* Register the double-click event
  DATA: lr_event_handler TYPE REF TO lcl_event_handler.
  CREATE OBJECT lr_event_handler.
  SET HANDLER lr_event_handler->handle_double_click FOR lr_grid.

* Display ALV
  CALL METHOD lr_grid->set_table_for_first_display
    CHANGING
      it_outtab       = lt_data
      it_fieldcatalog = lt_fieldcat.

* Create screen and call it
  CALL SCREEN 100.

* PBO module for screen 100
MODULE pbo OUTPUT.
  SET PF-STATUS 'STANDARD'.
  SET TITLEBAR 'TITLE'.
ENDMODULE.

* PAI module for screen 100
MODULE pai INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.
ENDMODULE.