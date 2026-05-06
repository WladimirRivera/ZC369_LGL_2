CLASS zcl_check_flight_json_c369 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_extension.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_check_flight_json_c369 IMPLEMENTATION.

  METHOD if_http_extension~handle_request.
    DATA lv_x_json TYPE xstring.

    DATA(lv_date) = server->request->get_form_field( name = 'lv_date'  ).

    SELECT FROM sflight AS a
      JOIN spfli AS b
        ON a~connid EQ b~connid
      FIELDS fldate, price, countryfr, cityfrom, airpfrom, countryto,
             cityto, airpto, planetype,seatsmax, seatsocc, seatsmax_b,
             seatsocc_b, seatsmax_f, seatsocc_f
      WHERE a~carrid EQ b~carrid
        AND a~connid EQ b~connid
        AND a~fldate LE @lv_date
      INTO TABLE @DATA(lt_available_flights).

    DATA(lv_json_out) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE lt_available_flights = lt_available_flights[] RESULT XML lv_json_out.
    DATA(lv_json_response) = cl_abap_codepage=>convert_from( lv_json_out->get_output( ) ).

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text     = lv_json_response
        mimetype = ''
        encoding = ''
      IMPORTING
        buffer   = lv_x_json
      EXCEPTIONS
        failed   = 1
        OTHERS   = 2.

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    server->response->set_header_field( name = 'Content-Type' value = 'application/json' ).
    server->response->set_header_field( name = 'encoding' value = 'UTF-8' ).
    server->response->set_data( data = lv_x_json ).
  ENDMETHOD.
ENDCLASS.
