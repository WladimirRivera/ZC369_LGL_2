*&---------------------------------------------------------------------*
*& Report Z_REST_JSON_WS_CONSUMER_C262
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_REST_XML_WS_CONSUMER_C369.



DATA: gv_string TYPE string VALUE 'http://s4h22.sap4practice.com:8007/logali/get_flight_xml?sap-client=800&fecha=20221203',
      gv_user TYPE string VALUE 's_c262',
      gv_password TYPE string VALUE 'Caracas.2023'.


cl_http_client=>create_by_url(
  EXPORTING
    url                    =  gv_string              " URL
  IMPORTING
    client                 = DATA(gr_if_http_client)                " HTTP Client Abstraction
  EXCEPTIONS
    argument_not_found     = 1                " Communication parameter (host or service) not available
    plugin_not_active      = 2                " HTTP/HTTPS communication not available
    internal_error         = 3                " Internal error (e.g. name too long)
    pse_not_found          = 4                " PSE not found
    pse_not_distrib        = 5                " PSE not distributed
    pse_errors             = 6                " General PSE error
    others                 = 7
).
IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

gr_if_http_client->authenticate(
  EXPORTING
*    proxy_authentication = ' '              " Proxy Logon (= 'X')
*    client               =                  " R/3 system (client number from logon)
    username             = gv_user                 " ABAP System, User Logon Name
    password             = gv_password                " Logon ID
*    language             =                  " SAP System, Current Language
).
IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

gr_if_http_client->send(
*  EXPORTING
*    timeout                    = co_timeout_default " Timeout of Answer Waiting Time
  EXCEPTIONS
    http_communication_failure = 1                  " Communication Error
    http_invalid_state         = 2                  " Invalid state
    http_processing_failed     = 3                  " Error when processing method
    http_invalid_timeout       = 4                  " Invalid Time Entry
    others                     = 5
).
IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

gr_if_http_client->receive(
  EXCEPTIONS
    http_communication_failure = 1                " Communication Error
    http_invalid_state         = 2                " Invalid state
    http_processing_failed     = 3                " Error when processing method
    others                     = 4
).
IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

cl_demo_output=>display_xml( gr_if_http_client->response->get_cdata( ) ).
