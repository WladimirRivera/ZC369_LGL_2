*&---------------------------------------------------------------------*
*& Report Z_REST_JSON_WS_CONSUMER_C369
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_REST_JSON_WS_CONSUMER_C369.


DATA: http_client TYPE REF TO if_http_client.

DATA: w_string TYPE string,
      w_result TYPE string.

DATA: gv_user TYPE string VALUE 's_s369',
      gv_password TYPE string VALUE 'Logali123*'.

w_string = 'http://s4hana2020.support.com:8007/logali/ws_flyjson_c369?sap-client=800&lv_date=20241029'.

cl_http_client=>create_by_url(
  EXPORTING
    url                    =  w_string                " URL
  IMPORTING
    client                 = http_client                 " HTTP Client Abstraction
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

http_client->authenticate(
  EXPORTING
*    proxy_authentication = ' '              " Proxy Logon (= 'X')
*    client               =                  " R/3 system (client number from logon)
    username             = 'wribera'  "gv_user           " ABAP System, User Logon Name
    password             = 'LogaliSap123*' "gv_password       " Logon ID
*    language             =                  " SAP System, Current Language
).
IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

http_client->send(
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

http_client->receive(
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

w_result = http_client->response->get_cdata( ).
cl_demo_output=>display_text( w_result ).
