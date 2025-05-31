*&---------------------------------------------------------------------*
*& Report ZBI_MULTIPLE_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_MULTIPLE_ALV.

* Data declarations
TYPES: BEGIN OF ty_sflight,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         price     TYPE sflight-price,
       END OF ty_sflight,
       BEGIN OF ty_spfli,
         carrid    TYPE spfli-carrid,
         connid    TYPE spfli-connid,
         countryfr TYPE spfli-countryfr,
         cityfrom  TYPE spfli-cityfrom,
         countryto TYPE spfli-countryto,
         cityto    TYPE spfli-cityto,
       END OF ty_spfli.

DATA: lt_sflight      TYPE TABLE OF ty_sflight,
      lt_spfli        TYPE TABLE OF ty_spfli,
      lt_fieldcat1    TYPE lvc_t_fcat,
      lt_fieldcat2    TYPE lvc_t_fcat,
      lr_grid1        TYPE REF TO cl_gui_alv_grid,
      lr_grid2        TYPE REF TO cl_gui_alv_grid,
      lr_container1   TYPE REF TO cl_gui_custom_container,
      lr_container2   TYPE REF TO cl_gui_custom_container.


CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS: handle_double_click
      FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no.
ENDCLASS.

class lcl_event_handler IMPLEMENTATION.

  method handle_double_click.
        DATA: ls_sflight TYPE ty_sflight.
    CLEAR lt_spfli.

* Read selected row
    READ TABLE lt_sflight INTO ls_sflight INDEX e_row-index.
    IF sy-subrc = 0.
* Fetch related SPFLI data
      SELECT carrid connid countryfr cityfrom countryto cityto
        INTO TABLE lt_spfli
        FROM spfli
        WHERE carrid = ls_sflight-carrid
          AND connid = ls_sflight-connid.

* Create second container and grid if not already created
      IF lr_container2 IS NOT BOUND.
        CREATE OBJECT lr_container2
          EXPORTING
            container_name = 'CONTAINER2'.
        CREATE OBJECT lr_grid2
          EXPORTING
            i_parent = lr_container2.
      ENDIF.

* Create field catalog for SPFLI
      CLEAR lt_fieldcat2.
     lt_fieldcat2 = VALUE #(
     ( fieldname = 'CARRID' tabname = 'LT_SPFLI' scrtext_l = 'carrier id' )
   ( FIELDNAME = 'CONNID'   tabname = 'LT_SPFLI' scrtext_l = 'connection id' )
   ( FIELDNAME = 'COUNTRYFR' tabname = 'LT_SPFLI' scrtext_l = 'country from' )
   ( FIELDNAME = 'CITYFROM' tabname = 'LT_SPFLI' scrtext_l = 'city from' )
   ( FIELDNAME = 'COUNTRYTO' tabname = 'LT_SPFLI' scrtext_l = 'country to' )
   ( FIELDNAME = 'CITYTO'   tabname = 'LT_SPFLI' scrtext_l = 'city to' )
     ).

* Display second ALV
      CALL METHOD lr_grid2->set_table_for_first_display
        CHANGING
          it_outtab       = lt_spfli
          it_fieldcatalog = lt_fieldcat2.
    ENDIF.

  ENDMETHOD.


ENDCLASS.

START-OF-SELECTION.
* Sample data for first ALV
  SELECT carrid connid fldate price
    INTO TABLE lt_sflight
    FROM sflight
    UP TO 20 ROWS.

* Create field catalog for SFLIGHT
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      ct_fieldcat      = lt_fieldcat1.

* Create container and grid for first ALV
  CREATE OBJECT lr_container1
    EXPORTING
      container_name = 'CONTAINER1'.

  CREATE OBJECT lr_grid1
    EXPORTING
      i_parent = lr_container1.


* Register double-click event
  DATA: lr_event_handler TYPE REF TO lcl_event_handler.
  CREATE OBJECT lr_event_handler.
  SET HANDLER lr_event_handler->handle_double_click FOR lr_grid1.


* Display first ALV
  CALL METHOD lr_grid1->set_table_for_first_display
    CHANGING
      it_outtab       = lt_sflight
      it_fieldcatalog = lt_fieldcat1.

* Call screen
  CALL SCREEN 0100.

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