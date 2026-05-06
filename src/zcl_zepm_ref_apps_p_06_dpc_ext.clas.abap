CLASS zcl_zepm_ref_apps_p_06_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zepm_ref_apps_p_06_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
    METHODS products_get_entityset REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_zepm_ref_apps_p_06_dpc_ext IMPLEMENTATION.
  METHOD products_get_entityset.

    super->products_get_entityset(
      EXPORTING
        iv_entity_name           = iv_entity_name
        iv_entity_set_name       = iv_entity_set_name
        iv_source_name           = iv_source_name
        it_filter_select_options = it_filter_select_options
        is_paging                = is_paging
        it_key_tab               = it_key_tab
        it_navigation_path       = it_navigation_path
        it_order                 = it_order
        iv_filter_string         = iv_filter_string
        iv_search_string         = iv_search_string
        io_tech_request_context  = io_tech_request_context
      IMPORTING
        et_entityset             = et_entityset
        es_response_context      = es_response_context
    ).
*CATCH /iwbep/cx_mgw_busi_exception.
*CATCH /iwbep/cx_mgw_tech_exception.

    LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<ls_entityset>).
      <ls_entityset>-fullname3 = 'Wladimir'.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
