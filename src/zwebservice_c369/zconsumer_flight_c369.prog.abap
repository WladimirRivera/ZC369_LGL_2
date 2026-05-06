*&---------------------------------------------------------------------*
*& Report ZCONSUMER_FLIGHT_C369
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zconsumer_flight_c369.

DATA: gr_object TYPE REF TO ZSC_CO_ZWS_CHECK_FLIGHT_C369,
      gr_excep  TYPE REF TO cx_root,
      gp_input  TYPE ZWSC369ZFM_CHECK_FLIGHT_C369,
      gp_output TYPE ZWSC369ZFM_CHECK_FLIGHT_C369RE.

PARAMETERS: p_fldate TYPE s_date,
            p_carrid TYPE s_carr_id,
            p_connid TYPE s_conn_id.

START-OF-SELECTION.

  TRY.

      CREATE OBJECT gr_object
        EXPORTING
          logical_port_name = 'ZASAS'.

      gp_input-fldate = |{ p_fldate+0(4) }-{ p_fldate+4(2) }-{ p_fldate+6(2) }|.
      gp_input-carrid = p_carrid.
      gp_input-connid = p_connid.

      gr_object->zfm_check_flight_c369(
        EXPORTING
          input = gp_input
        IMPORTING
          output = gp_output
      ).

      MESSAGE 'Exito al consumir el servicio' TYPE 'S'.
    CATCH cx_root INTO gr_excep.
      MESSAGE gr_excep TYPE 'I'.
  ENDTRY.
