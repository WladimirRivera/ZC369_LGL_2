FUNCTION Z_FM_CHECK_FLIGHT_C369.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(CARRID) TYPE  S_CARR_ID
*"     VALUE(CONNID) TYPE  S_CONN_ID
*"     VALUE(FLDATE) TYPE  S_DATE
*"  EXPORTING
*"     VALUE(PAYMENTSUM) TYPE  S_SUM
*"     VALUE(DETAIL_FLIGHT) TYPE  ZSTR_AIRLINE_INFO_C369
*"     VALUE(MSG_RETURN) TYPE  STRING
*"     VALUE(AVAILABLE_FLIGHT) TYPE  ZTT_FLIGHT_C369
*"----------------------------------------------------------------------
*
SELECT SINGLE FROM sflight
    FIELDS paymentsum
    WHERE carrid EQ @carrid
    AND connid EQ @connid
    AND fldate EQ @fldate
    INTO @paymentsum.

  IF sy-subrc EQ 0.

    SELECT SINGLE FROM sflight AS a
      JOIN spfli AS b
      ON a~connid EQ b~connid
      FIELDS fldate, price, countryfr, cityfrom, airpfrom,countryto,
      cityto, airpto, planetype,seatsmax, seatsocc, seatsmax_b,seatsocc_b, seatsmax_f, seatsocc_f
      WHERE a~carrid EQ @carrid
       AND  a~connid EQ @connid
       AND  a~fldate EQ @fldate
      INTO @detail_flight.

  ELSE.
    msg_return = 'No existen vuelos con los datos proporcionados'.
  ENDIF.


  SELECT FROM sflight AS a
    JOIN spfli AS b
    ON a~connid EQ b~connid
    FIELDS fldate, price, countryfr, cityfrom, airpfrom,countryto,
    cityto, airpto, planetype,seatsmax, seatsocc, seatsmax_b,seatsocc_b, seatsmax_f, seatsocc_f
    WHERE a~carrid EQ @carrid
     AND  a~connid EQ @connid
     AND  a~fldate GE @fldate
    INTO TABLE @available_flight.

    IF sy-subrc EQ 0.
      msg_return = 'No existen vuelos posteriores a la fecha consultada'.
    ENDIF.

ENDFUNCTION.
