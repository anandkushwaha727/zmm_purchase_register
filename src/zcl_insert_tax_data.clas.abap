CLASS zcl_insert_tax_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS ZCL_INSERT_TAX_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_tax TYPE TABLE OF zz1_tax_code1.

    lt_tax = VALUE #(
    ( client = '080' tax_code = 'R6' cgst = '2.5000000000000000E+00' sgst = '2.5000000000000000E+00' igst = '0.0000000000000000E+00' )
( client = '080' tax_code = 'R7' cgst = '6.0000000000000000E+00' sgst = '6.0000000000000000E+00' igst = '0.0000000000000000E+00' )
( client = '080' tax_code = 'R8' cgst = '9.0000000000000000E+00' sgst = '9.0000000000000000E+00' igst = '0.0000000000000000E+00' )
( client = '080' tax_code = 'R9' cgst = '1.4000000000000000E+01' sgst = '1.4000000000000000E+01' igst = '0.0000000000000000E+00' )
( client = '080' tax_code = 'RA' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '5.0000000000000000E+00' )
( client = '080' tax_code = 'RB' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '1.2000000000000000E+01' )
( client = '080' tax_code = 'RC' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '1.8000000000000000E+01' )
( client = '080' tax_code = 'RD' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '2.8000000000000000E+01' )
( client = '080' tax_code = 'RE' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '5.0000000000000000E+00' )
( client = '080' tax_code = 'RF' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '1.2000000000000000E+01' )
( client = '080' tax_code = 'RG' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '1.8000000000000000E+01' )
( client = '080' tax_code = 'RH' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '2.8000000000000000E+01' )
( client = '080' tax_code = 'S1' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '0.0000000000000000E+00' )
( client = '080' tax_code = 'S2' cgst = '5.0000000000000003E-02' sgst = '5.0000000000000003E-02' igst = '0.0000000000000000E+00' )
( client = '080' tax_code = 'S3' cgst = '2.5000000000000000E+00' sgst = '2.5000000000000000E+00' igst = '0.0000000000000000E+00' )
( client = '080' tax_code = 'S4' cgst = '6.0000000000000000E+00' sgst = '6.0000000000000000E+00' igst = '0.0000000000000000E+00' )
( client = '080' tax_code = 'S5' cgst = '9.0000000000000000E+00' sgst = '9.0000000000000000E+00' igst = '0.0000000000000000E+00' )
( client = '080' tax_code = 'S6' cgst = '1.4000000000000000E+01' sgst = '1.4000000000000000E+01' igst = '0.0000000000000000E+00' )
( client = '080' tax_code = 'S7' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '5.0000000000000000E+00' )
( client = '080' tax_code = 'S8' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '1.2000000000000000E+01' )
( client = '080' tax_code = 'S9' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '1.8000000000000000E+01' )
( client = '080' tax_code = 'SA' cgst = '0.0000000000000000E+00' sgst = '0.0000000000000000E+00' igst = '2.8000000000000000E+01' )


    ).

    INSERT zz1_tax_code1 FROM TABLE @lt_tax.

    IF sy-subrc = 0.
      out->write( 'Records inserted successfully' ).
    ELSE.
      out->write( 'Insertion failed' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
