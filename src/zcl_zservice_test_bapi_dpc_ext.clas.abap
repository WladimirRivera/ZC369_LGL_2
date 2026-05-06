CLASS zcl_zservice_test_bapi_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zservice_test_bapi_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS salesorderset_get_entityset
        REDEFINITION .
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_zservice_test_bapi_dpc_ext IMPLEMENTATION.


  METHOD salesorderset_get_entityset.
*"Outside-In"
    DATA: ls_max_rows             TYPE if_epm_bo=>ty_query_max_rows VALUE 100,
          it_epm_so_id_range      TYPE if_epm_so_header=>tt_sel_par_header_ids,
          it_epm_buyer_name_range TYPE if_epm_so_header=>tt_sel_par_company_names,
          it_epm_product_id_range TYPE if_epm_so_header=>tt_sel_par_product_ids,
          it_epm_so_header_data   TYPE if_epm_so_header=>tt_node_data.

    TRY.
        DATA(li_epm_so_header) = CAST if_epm_so_header( cl_epm_service_facade=>get_bo( if_epm_so_header=>gc_bo_name ) ).
        DATA(li_message_buffer) = CAST if_epm_message_buffer( cl_epm_service_facade=>get_message_buffer( ) ).

        li_epm_so_header->query_by_header(
          EXPORTING
            it_sel_par_header_ids   = it_epm_so_id_range[]
            it_sel_par_company_names = it_epm_buyer_name_range[]
            it_sel_par_product_ids  = it_epm_product_id_range[]
            iv_max_rows             = ls_max_rows
          IMPORTING
            et_data                 = it_epm_so_header_data[]
        ).
        et_entityset = CORRESPONDING #( it_epm_so_header_data[] ).

      CATCH cx_epm_exception INTO DATA(lo_epm_exception).
    ENDTRY.
*    DATA: ls_max_rows    TYPE bapi_epm_max_rows,
*          lt_header_data TYPE TABLE OF bapi_epm_so_header.
*
*    ls_max_rows-bapimaxrow = 100.
*
*    CALL FUNCTION 'BAPI_EPM_SO_GET_LIST'
*      EXPORTING
*        max_rows      = ls_max_rows
*      TABLES
*        soheaderdata  = lt_header_data.
*
*    et_entityset[] = lt_header_data[].
  ENDMETHOD.
ENDCLASS.
