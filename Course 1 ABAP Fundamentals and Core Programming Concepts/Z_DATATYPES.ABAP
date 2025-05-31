*&---------------------------------------------------------------------*
*& Report Z_DATATYPES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DATATYPES.

* Declaration of Elementary Data Types
DATA: lv_name      TYPE c LENGTH 20,        " Character field (fixed length)
      lv_cust_id   TYPE n LENGTH 10,        " Numeric character (e.g., customer ID)
      lv_date      TYPE d,                  " Date (YYYYMMDD)
      lv_time      TYPE t,                  " Time (HHMMSS)
      lv_age       TYPE i,                  " Integer
      lv_price     TYPE p LENGTH 8 DECIMALS 2, " Packed number (decimal)
      lv_float     TYPE f,                  " Floating point
      lv_hex       TYPE x LENGTH 4,         " Hexadecimal
      lv_string    TYPE string.             " Variable-length string

* Assigning values
lv_name    = 'John Doe'.
lv_cust_id = '0001234567'.
lv_date    = sy-datum.                   " Current system date
lv_time    = sy-uzeit.                   " Current system time
lv_age     = 30.
lv_price   = '12345.67'.
lv_float   = '123.456789'.
lv_hex     = '48656C6C'.                " Hex for 'Hell'
lv_string  = 'Dynamic text content'.

* Displaying values
WRITE: / 'Name:', lv_name,
       / 'Customer ID:', lv_cust_id,
       / 'Date:', lv_date,
       / 'Time:', lv_time,
       / 'Age:', lv_age,
       / 'Price:', lv_price,
       / 'Float:', lv_float,
       / 'Hex:', lv_hex,
       / 'String:', lv_string.