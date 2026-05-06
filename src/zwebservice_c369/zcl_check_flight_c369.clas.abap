class ZCL_CHECK_FLIGHT_C369 definition
  public
  final
  create public .

public section.
INTERFACES IF_HTTP_EXTENSION.
protected section.
private section.
ENDCLASS.

CLASS ZCL_CHECK_FLIGHT_C369 IMPLEMENTATION.

  method IF_HTTP_EXTENSION~HANDLE_REQUEST.
  DATA lv_x_xml type xstring.

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
    INTO TABLE @data(lt_available_flights).

  data(lv_xml_out) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).
  call TRANSFORMATION id source lt_available_flights = lt_available_flights[] RESULT XML lv_xml_out.
  DATA(lv_xml_response) = cl_abap_codepage=>convert_from( lv_xml_out->get_output( ) ).

  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
    EXPORTING
      text      = lv_xml_response
      MIMETYPE  = ''
      ENCODING  = ''
    IMPORTING
      BUFFER    = lv_x_xml
    EXCEPTIONS
      FAILED    = 1
      OTHERS    = 2.

  if sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  server->response->set_header_field( name = 'Content-Type' value = 'application/xml' ).
  server->response->set_header_field( name = 'encoding' value = 'UTF-8' ).
  server->response->set_data( data = lv_x_xml ).
  endmethod.
ENDCLASS.
