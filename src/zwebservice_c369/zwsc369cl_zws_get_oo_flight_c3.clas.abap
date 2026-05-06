CLASS zwsc369cl_zws_get_oo_flight_c3 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zwsc369iiw_zws_get_oo_flight_c .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zwsc369cl_zws_get_oo_flight_c3 IMPLEMENTATION.


  METHOD zwsc369iiw_zws_get_oo_flight_c~zfm_ws_signature_c369.
*** **** INSERT IMPLEMENTATION HERE **** ***
    SELECT FROM sflight
      FIELDS
        *
      WHERE carrid EQ @input-carrid
        AND connid EQ @input-connid
      INTO TABLE @DATA(gt_flights).

    IF sy-subrc EQ 0.
      LOOP AT gt_flights ASSIGNING FIELD-SYMBOL(<lv_flights>).

        APPEND INITIAL LINE TO output-flights-item ASSIGNING FIELD-SYMBOL(<ls_output>).
        MOVE-CORRESPONDING <lv_flights> TO <ls_output>.

*indicamos la fecha en el formato de la base de datos ejecutando una conversión
        <ls_output>-fldate = |{ <lv_flights>-fldate(4) }-{ <lv_flights>-fldate+4(2) }-{ <lv_flights>-fldate+6(2) }|.

      ENDLOOP.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
