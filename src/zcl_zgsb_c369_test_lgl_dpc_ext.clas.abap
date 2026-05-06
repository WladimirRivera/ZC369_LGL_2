CLASS zcl_zgsb_c369_test_lgl_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zgsb_c369_test_lgl_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
    METHODS customersset_get_entityset REDEFINITION.
    METHODS customersset_get_entity REDEFINITION.
    METHODS customersset_create_entity REDEFINITION.
    METHODS customersset_update_entity REDEFINITION.
    METHODS customersset_delete_entity REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_zgsb_c369_test_lgl_dpc_ext IMPLEMENTATION.

  METHOD customersset_get_entity.
    DATA(lv_customer_id) = it_key_tab[ name = 'Customerid' ]-value.
    DATA(lv_order_id) = it_key_tab[ name = 'Orderid' ]-value.
    SELECT SINGLE FROM zcustomers
      FIELDS *
      WHERE customerid EQ @lv_customer_id
       AND  orderid EQ @lv_order_id
      INTO @er_entity.
  ENDMETHOD.

  METHOD customersset_get_entityset.
    SELECT FROM zcustomers
        FIELDS *
         WHERE customerid IS NOT INITIAL
          INTO TABLE @et_entityset.
  ENDMETHOD.

  METHOD customersset_create_entity.
    DATA: ls_customers TYPE zcustomers.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_customers ).

    INSERT zcustomers FROM ls_customers.

    IF sy-subrc EQ 0.
      er_entity = ls_customers.
    ELSE.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'INSERT error' ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.
  ENDMETHOD.

  METHOD customersset_update_entity.
    DATA ls_customers_odata TYPE zcustomers.
    DATA(lv_customerid) = it_key_tab[ name = 'Customerid' ]-value.

    SELECT SINGLE * FROM zcustomers WHERE customerid EQ @lv_customerid
    INTO @DATA(ls_customers_ddbb).

    IF sy-subrc EQ 0.
      io_data_provider->read_entry_data( IMPORTING es_data = ls_customers_odata ).


      DATA(ls_customers_update) = VALUE zcustomers(
      customerid = lv_customerid
      orderid = COND #( WHEN ls_customers_odata-orderid IS NOT INITIAL
                        THEN ls_customers_odata-orderid
                        ELSE ls_customers_ddbb-orderid )
      name = COND #( WHEN ls_customers_odata-name IS NOT INITIAL
                           THEN ls_customers_odata-name
                           ELSE ls_customers_ddbb-name )
      address = COND #( WHEN ls_customers_odata-address IS NOT INITIAL
                           THEN ls_customers_odata-address
                           ELSE ls_customers_ddbb-address )
      city = COND #( WHEN ls_customers_odata-city IS NOT INITIAL
                     THEN ls_customers_odata-city
                     ELSE ls_customers_ddbb-city )
      postalcode = COND #( WHEN ls_customers_odata-postalcode IS NOT INITIAL
                     THEN ls_customers_odata-postalcode
                     ELSE ls_customers_ddbb-postalcode )
      phone = COND #( WHEN ls_customers_odata-phone IS NOT INITIAL
                      THEN ls_customers_odata-phone
                      ELSE ls_customers_ddbb-phone ) ).
    ENDIF.

    UPDATE zcustomers FROM ls_customers_update.
    IF sy-subrc EQ 0.
      er_entity = ls_customers_update.
    ELSE.
      DATA(lv_rase_exception) = abap_true.
    ENDIF.
    IF lv_rase_exception EQ abap_true.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY' msgno = '002' attr1 = 'UPDATE error' ).
      RAISE EXCEPTION TYPE /iwbep/cx_epm_busi_exception EXPORTING textid = ls_message.
    ENDIF.
  ENDMETHOD.

  METHOD customersset_delete_entity.
    DATA(lt_keys) = io_tech_request_context->get_keys( ).
    DATA(lv_customerid) = lt_keys[ name = 'CUSTOMERID' ]-value.
    DELETE FROM zcustomers WHERE customerid EQ lv_customerid.
    CHECK sy-subrc NE 0.
    DATA(ls_message) = VALUE scx_t100key( msgid = 'SY' msgno = '007' attr1 = 'DELETE Customers error' ).
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception EXPORTING textid = ls_message.
  ENDMETHOD.

ENDCLASS.
