CLASS zcl_zgsb_c369_lgl_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zgsb_c369_lgl_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
*  Odata Crud Customers
    METHODS customersset_get_entityset REDEFINITION. " GET
    METHODS customersset_get_entity REDEFINITION.    " GET
    METHODS customersset_create_entity REDEFINITION. " POST
    METHODS customersset_update_entity REDEFINITION. " PUT
    METHODS customersset_delete_entity REDEFINITION. " DELETE

*  Odata Crud Payments
    METHODS paymentsset_get_entity REDEFINITION.
    METHODS paymentsset_get_entityset REDEFINITION.

*  Odata Crud Order
    METHODS ordersset_get_entity REDEFINITION.
    METHODS ordersset_get_entityset REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_zgsb_c369_lgl_dpc_ext IMPLEMENTATION.
  METHOD customersset_get_entityset.
    SELECT FROM zcustomers
        FIELDS *
         WHERE customerid IS NOT INITIAL
          INTO TABLE @et_entityset.
  ENDMETHOD.

  METHOD customersset_get_entity.
    DATA(lv_customer_id) = it_key_tab[ name = 'Customerid' ]-value.
    DATA(lv_order_id) = it_key_tab[ name = 'Orderid' ]-value.
    SELECT SINGLE FROM zcustomers
      FIELDS *
      WHERE customerid EQ @lv_customer_id
      AND  orderid EQ @lv_order_id
      INTO @er_entity.
  ENDMETHOD.

  METHOD ordersset_get_entity.
    DATA(lv_orderid) = it_key_tab[ name = 'Orderid' ]-value.

    SELECT SINGLE FROM zorders
      FIELDS *
      WHERE orderid EQ @lv_orderid
      INTO @DATA(ls_order).
    IF sy-subrc EQ 0.
      DATA(ls_ship_address) = VALUE zcl_zsoa262_01_mpc=>ts_orders-shipaddress(
                                   city = ls_order-city
                                   street = ls_order-street
                                   postalcode = ls_order-postalcode
                                   buildernumber = ls_order-buildernumber
                                   country = ls_order-country
                                 ).

      er_entity = VALUE #( orderid = ls_order-orderid
                           customerid = ls_order-customerid
                           paymentid = ls_order-paymentid
                           orderdate = ls_order-orderdate
                           shipdate = ls_order-shipdate
                           shipvia = ls_order-shipvia
                           shipaddress = ls_ship_address
                           documentorder = ls_order-documentorder ).

    ENDIF.
  ENDMETHOD.

  METHOD ordersset_get_entityset.
    SELECT FROM zorders
    FIELDS *
    INTO TABLE @DATA(lt_orders).

    CHECK sy-subrc EQ 0.
    et_entityset = VALUE #( FOR ls_order IN lt_orders (
    orderid = ls_order-orderid
    customerid = ls_order-customerid
    paymentid = ls_order-paymentid
    orderdate = ls_order-orderdate
    shipdate = ls_order-shipdate
    shipvia = ls_order-shipvia
    shipaddress-city = ls_order-city
    shipaddress-street = ls_order-street
    shipaddress-postalcode = ls_order-postalcode
    shipaddress-buildernumber = ls_order-buildernumber
    shipaddress-country = ls_order-country
    documentorder = ls_order-documentorder ) ).
  ENDMETHOD.

  METHOD paymentsset_get_entity.
    DATA(lv_payment_id) = it_key_tab[ name = 'Paymentid' ]-value.

    SELECT SINGLE FROM zpayments
      FIELDS *
      WHERE paymentid EQ @lv_payment_id

      INTO @er_entity.
  ENDMETHOD.

  METHOD paymentsset_get_entityset.
    SELECT FROM zpayments
        FIELDS *
         WHERE paymentid IS NOT INITIAL
          INTO TABLE @et_entityset.
  ENDMETHOD.

  METHOD customersset_create_entity.
*    DATA: ls_customers TYPE zcustomers.
    DATA: ls_customers TYPE ZCL_ZGSB_C369_LGL_MPC=>TS_CUSTOMERS.

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
