*&---------------------------------------------------------------------*
*& Report Z_RCF_CALL_C262
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_RCF_CALL_C369.

CONSTANTS: gc_destination_sh4 type ad_logdest VALUE 'S4H_C262',
           gc_destination_sh413 type ad_logdest VALUE 'DESTINO_SCH'.

data: gv_result type string,
     gv_msj type c length 255.

data(got_out) = cl_demo_output=>new( ).

CALL FUNCTION 'Z_GR_GET_RESULT_V2'  DESTINATION gc_destination_sh413
  EXPORTING
    iv_user   =  'G11542'               " User Name
  IMPORTING
    ev_result = gv_result
  EXCEPTIONS
    SYSTEM_FAILURE = 1 MESSAGE gv_msj
    COMMUNICATION_FAILURE = 2 MESSAGE gv_msj
    OTHERS = 3  .

CASE sy-subrc.
  WHEN 1.
    got_out->write( |EXCEPTIONS SYSTEM_FAILURE | && gv_msj ).
  WHEN 2.
    got_out->write( |EXCEPTIONS COMMUNICATION_FAILURE | && gv_msj ).
  WHEN 3.
      got_out->write( |EXCEPTIONS others | && gv_msj ).
  WHEN OTHERS.
ENDCASE.

if not gv_msj  is INITIAL.
  got_out->display( ).
  RETURN.
ENDIF.


WRITE gv_result.
