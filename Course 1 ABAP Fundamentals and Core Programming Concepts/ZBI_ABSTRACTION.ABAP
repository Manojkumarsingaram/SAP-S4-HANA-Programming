*&---------------------------------------------------------------------*
*& Report ZBI_ABSTRACION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBI_ABSTRACION.
CLASS lcl_vehicle DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: start ABSTRACT.
ENDCLASS.

CLASS lcl_car DEFINITION INHERITING FROM lcl_vehicle.
  PUBLIC SECTION.
    METHODS: start REDEFINITION.
ENDCLASS.

CLASS lcl_car IMPLEMENTATION.
  METHOD start.
    WRITE: / 'Car engine started'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

data(lo_car) = new lcl_car( ).

lo_Car->start( ).

"Which using super class, in child class Abstract class must be redefined. " mandatory