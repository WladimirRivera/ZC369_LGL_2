*&---------------------------------------------------------------------*
*& Report Z_RCF_CALL_C262V2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_RCF_CALL_C369V2.
data: lv_requtext TYPE syst_lisel VALUE 'Llamada RFC',
      lv_resptext TYPE syst_lisel,
      lv_echotext type syst_lisel.

CALL FUNCTION 'STFC_CONNECTION_BACK'
DESTINATION 'S4H_C262'
  EXPORTING
    requtext = lv_requtext
  IMPORTING
    echotext = lv_echotext
    resptext = lv_requtext
  .

cl_demo_output=>begin_section( 'echotext' ).
cl_demo_output=>write_data( lv_echotext ).
cl_demo_output=>next_section( 'resptext' ).
cl_demo_output=>display_data( lv_requtext ).
