CLASS zcl_zgsb_c369_test__01_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zgsb_c369_test__01_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~execute_action REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~create_deep_entity REDEFINITION.

  PROTECTED SECTION.
*  Odata Crud Customers
    METHODS customersset_get_entityset REDEFINITION. " GET Multiple Keys
    METHODS customersset_get_entity    REDEFINITION. " GET Single Key
    METHODS customersset_create_entity REDEFINITION. " POST
    METHODS customersset_update_entity REDEFINITION. " PUT
    METHODS customersset_delete_entity REDEFINITION. " DELETE

*  Odata Crud Payments
    METHODS paymentsset_get_entity REDEFINITION.    " GET Single Key
    METHODS paymentsset_get_entityset REDEFINITION. " GET Multiple Keys
    METHODS paymentsset_create_entity REDEFINITION. " POST
    METHODS paymentsset_update_entity REDEFINITION. " PUT
    METHODS paymentsset_delete_entity REDEFINITION. " DELETE

*  Odata Crud Order
    METHODS ordersset_get_entity REDEFINITION.      " GET Single Key
    METHODS ordersset_get_entityset REDEFINITION.   " GET Multiple Keys
    METHODS ordersset_create_entity REDEFINITION.   " POST
    METHODS ordersset_update_entity REDEFINITION.   " PUT
    METHODS ordersset_delete_entity REDEFINITION.   " DELETE
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_zgsb_c369_test__01_dpc_ext IMPLEMENTATION.
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
    DATA: ls_customers TYPE zcl_zgsb_c369_lgl_mpc=>ts_customers.

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

  METHOD paymentsset_create_entity.
    DATA: ls_payments TYPE zcl_zsoa262_01_mpc=>ts_payments.
    TRY.
        io_data_provider->read_entry_data( IMPORTING es_data = ls_payments ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    INSERT zpayments FROM ls_payments.

    IF sy-subrc EQ 0.
      er_entity = ls_payments .
    ELSE.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '003'
                                            attr1 = 'INSERT error' ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.
  ENDMETHOD.

  METHOD paymentsset_delete_entity.
    DATA(lt_keys) = io_tech_request_context->get_keys( ).
    DATA(lv_customerid) = lt_keys[ name = 'Paymentid' ]-value.
    DELETE FROM zpayments WHERE Paymentid EQ lv_customerid.
    CHECK sy-subrc NE 0.
    DATA(ls_message) = VALUE scx_t100key( msgid = 'SY' msgno = '007' attr1 = 'DELETE Payment error' ).
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception EXPORTING textid = ls_message.
  ENDMETHOD.

  METHOD paymentsset_update_entity.
    DATA ls_payments_odata TYPE zpayments.
    DATA(lv_paymentid) = it_key_tab[ name = 'Paymentid' ]-value.

    SELECT SINGLE * FROM zpayments
    WHERE paymentid EQ @lv_paymentid
    INTO @DATA(ls_payments_bbdd).

    io_data_provider->read_entry_data( IMPORTING es_data = ls_payments_odata ).

    DATA(ls_payments_update) = VALUE zpayments( paymentid = lv_paymentid
    orderid = COND #( WHEN ls_payments_odata-orderid IS NOT INITIAL
    THEN ls_payments_odata-orderid
    ELSE ls_payments_bbdd-orderid )

                                           paymentmethod = COND #( WHEN ls_payments_odata-paymentmethod IS NOT INITIAL
                                                                 THEN ls_payments_odata-paymentmethod
                                                                 ELSE ls_payments_bbdd-paymentmethod )

                                           amount = COND #( WHEN ls_payments_odata-amount IS NOT INITIAL
                                                            THEN ls_payments_odata-amount
                                                            ELSE ls_payments_bbdd-amount )

                                           dateor = COND #( WHEN ls_payments_odata-dateor IS NOT INITIAL
                                                            THEN ls_payments_odata-dateor
                                                            ELSE ls_payments_bbdd-dateor )

                                           status = COND #( WHEN ls_payments_odata-status IS NOT INITIAL
                                                            THEN ls_payments_odata-status
                                                            ELSE ls_payments_bbdd-status ) ).
    UPDATE zpayments FROM ls_payments_update.
    IF sy-subrc EQ 0.
      er_entity = ls_payments_odata.
    ELSE.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '003'
                                            attr1 = 'UPDATE Payments error' ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
        EXPORTING
          textid = ls_message.

    ENDIF.
  ENDMETHOD.

  METHOD ordersset_create_entity.
    DATA: ls_order     TYPE zcl_zsoa262_01_mpc=>ts_orders,
          ls_order_ins TYPE zorders.

    TRY.
        io_data_provider->read_entry_data( IMPORTING es_data = ls_order ).
      CATCH /iwbep/cx_mgw_busi_exception.
    ENDTRY.

    ls_order_ins = VALUE #( orderid = ls_order-orderid
                            customerid = ls_order-customerid
                            paymentid = ls_order-paymentid
                            orderdate = ls_order-orderdate
                            shipdate = ls_order-shipdate
                            shipvia = ls_order-shipvia
                            city = ls_order-shipaddress-city
                            street = ls_order-shipaddress-street
                            postalcode = ls_order-shipaddress-postalcode
                            buildernumber = ls_order-shipaddress-buildernumber
                            country = ls_order-shipaddress-country
                            documentorder = ls_order-documentorder ).

    INSERT zorders FROM ls_order_ins.

    IF sy-subrc EQ '0'.
      er_entity = VALUE #( orderid = ls_order-orderid
                           customerid = ls_order-customerid
                           paymentid = ls_order-paymentid
                           orderdate = ls_order-orderdate
                           shipdate = ls_order-shipdate
                           shipvia = ls_order-shipvia
                           shipaddress = ls_order-shipaddress
                           documentorder = ls_order-documentorder ).
    ELSE.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'INSERT error' ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.
  ENDMETHOD.

  METHOD ordersset_delete_entity.
    DATA(lt_keys) = io_tech_request_context->get_keys( ).
    DATA(lv_customerid) = lt_keys[ name = 'orderid' ]-value.
    DELETE FROM zorders WHERE orderid EQ lv_customerid.
    CHECK sy-subrc NE 0.
    DATA(ls_message) = VALUE scx_t100key( msgid = 'SY' msgno = '007' attr1 = 'DELETE Order error' ).
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception EXPORTING textid = ls_message.
  ENDMETHOD.


  METHOD ordersset_update_entity.
    DATA ls_order_odata TYPE zcl_zgsb_c369_test__01_mpc=>ts_orders.
    DATA(lv_order_id) = it_key_tab[ name = 'Orderid' ]-value.

    SELECT SINGLE FROM zorders
    FIELDS *
    WHERE orderid EQ @lv_order_id
    INTO @DATA(ls_orders_ddbb).

    io_data_provider->read_entry_data( IMPORTING es_data = ls_order_odata ).

    DATA(ls_order_ins) = VALUE zorders( orderid   = lv_order_id

                                    customerid = COND #( WHEN ls_order_odata-customerid IS NOT INITIAL
                                                          THEN ls_order_odata-customerid
                                                          ELSE ls_orders_ddbb-customerid )

                                    paymentid = COND #( WHEN ls_order_odata-paymentid IS NOT INITIAL
                                                        THEN ls_order_odata-paymentid
                                                        ELSE ls_orders_ddbb-paymentid )

                                    orderdate = COND #( WHEN ls_order_odata-orderdate IS NOT INITIAL
                                                        THEN ls_order_odata-orderdate
                                                        ELSE ls_orders_ddbb-orderdate )

                                    shipdate  = COND #( WHEN ls_order_odata-shipdate IS NOT INITIAL
                                                        THEN ls_order_odata-shipdate
                                                        ELSE ls_orders_ddbb-shipdate )

                                    shipvia   = COND #( WHEN ls_order_odata-shipvia IS NOT INITIAL
                                                        THEN ls_order_odata-shipvia
                                                        ELSE ls_orders_ddbb-shipvia )
*
                                    city      = COND #( WHEN ls_order_odata-shipaddress-city IS NOT INITIAL
                                                        THEN ls_order_odata-shipaddress-city
                                                        ELSE ls_orders_ddbb-city )

                                    street    = COND #( WHEN ls_order_odata-shipaddress-street IS NOT INITIAL
                                                        THEN ls_order_odata-shipaddress-street
                                                        ELSE ls_orders_ddbb-street )

                                    postalcode = COND #( WHEN ls_order_odata-shipaddress-postalcode IS NOT INITIAL
                                                         THEN ls_order_odata-shipaddress-postalcode
                                                         ELSE ls_orders_ddbb-postalcode )

                                    buildernumber = COND #( WHEN ls_order_odata-shipaddress-buildernumber IS NOT INITIAL
                                                            THEN ls_order_odata-shipaddress-buildernumber
                                                            ELSE ls_orders_ddbb-buildernumber )

                                    country   = COND #( WHEN ls_order_odata-shipaddress-country IS NOT INITIAL
                                                        THEN ls_order_odata-shipaddress-country
                                                        ELSE ls_orders_ddbb-country )

                                    documentorder = COND #( WHEN ls_order_odata-documentorder IS NOT INITIAL
                                                            THEN ls_order_odata-documentorder
                                                            ELSE ls_orders_ddbb-documentorder ) ).
    IF sy-subrc EQ 0.
      er_entity = ls_order_odata.
    ELSE.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
      msgno = '002'
      attr1 = 'UPDATE Order Error' ).

      RAISE EXCEPTION TYPE /iwbep/cx_epm_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    CASE iv_action_name.
      WHEN 'PaymentStatus'.
        DATA(lv_paymentid) = it_parameter[ name = 'paymentid' ]-value.
        DATA(lv_status) = it_parameter[ name = 'Status' ]-value.
        CHECK NOT lv_paymentid IS INITIAL.
        UPDATE zpayments SET status = lv_status
                           WHERE paymentid = lv_paymentid.
        DATA(ls_entity) = VALUE zcl_zgsb_c369_test__01_mpc=>ts_payments( status = lv_status paymentid = lv_paymentid
                                                               dateor = sy-datum ).
        me->copy_data_to_ref( EXPORTING is_data = ls_entity
                              CHANGING  cr_data = er_data ).
    ENDCASE.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.
    CASE iv_entity_set_name.
      WHEN 'CustomersSet'.
        SELECT FROM zcustomers FIELDS * INTO TABLE @DATA(lt_customers).
        IF sy-subrc EQ 0.
          me->copy_data_to_ref( EXPORTING is_data = lt_customers CHANGING cr_data = er_entityset ).
        ENDIF.
      WHEN 'OrdersSet'.
        DATA(lv_customerid) = it_key_tab[ name = 'Customerid' ]-value.
        SELECT FROM zorders FIELDS * WHERE customerid EQ @lv_customerid INTO TABLE @DATA(lt_orders).
        IF sy-subrc EQ 0.
          me->copy_data_to_ref( EXPORTING is_data = lt_orders CHANGING cr_data = er_entityset ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
    DATA: ls_depp_entity TYPE zcl_zgsb_c369_test__01_mpc_ext=>ts_deep_entity,
          ls_customers   TYPE zcustomers,
          lt_orders      TYPE TABLE OF zorders.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_depp_entity ).

    CASE iv_entity_name.
      WHEN 'Customers'.
        ls_customers = CORRESPONDING #( ls_depp_entity ).
        lt_orders = VALUE #( FOR ls_order IN ls_depp_entity-customertoordersnav (
                              orderid         = ls_order-orderid
                              customerid      = ls_order-customerid
                              paymentid       = ls_order-paymentid
                              orderdate       = ls_order-orderdate
                              shipdate        = ls_order-shipdate
                              shipvia         = ls_order-shipvia
                              city            = ls_order-shipaddress-city
                              street          = ls_order-shipaddress-street
                              postalcode      = ls_order-shipaddress-postalcode
                              buildernumber   = ls_order-shipaddress-buildernumber
                              country         = ls_order-shipaddress-country
                              documentorder   = ls_order-documentorder ) ).
        IF ls_customers IS NOT INITIAL.
          INSERT zcustomers FROM ls_customers.
          IF sy-subrc EQ 0.
            INSERT zorders FROM TABLE lt_orders.
            IF sy-subrc EQ 0.
              me->copy_data_to_ref( EXPORTING is_data = ls_depp_entity
                                    CHANGING cr_data = er_deep_entity ).
            ELSE.
              DATA(lv_error) = abap_true.
            ENDIF.
          ELSE.
            lv_error = abap_true.
          ENDIF.
        ENDIF.
    ENDCASE.
    IF lv_error EQ abap_true.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY' msgno = '002' attr1 = 'Deep Insert ERROR' ).
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception EXPORTING textid = ls_message.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
