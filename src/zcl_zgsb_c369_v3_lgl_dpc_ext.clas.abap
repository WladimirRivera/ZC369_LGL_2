CLASS zcl_zgsb_c369_v3_lgl_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zsoa262_01_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
* Methods aditional functions
    METHODS /iwbep/if_mgw_appl_srv_runtime~execute_action REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~create_deep_entity REDEFINITION.

* Methods for batch
    METHODS /iwbep/if_mgw_appl_srv_runtime~changeset_begin REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~changeset_end REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~changeset_process REDEFINITION.

* Methods for files
    METHODS /iwbep/if_mgw_appl_srv_runtime~create_stream REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~update_stream REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~delete_stream REDEFINITION.

  PROTECTED SECTION.
*  Methods for entities
    METHODS filesset_get_entityset REDEFINITION.
    METHODS salesorderset_get_entityset REDEFINITION.
    METHODS orderlistset_get_entityset REDEFINITION.

    METHODS customersset_create_entity REDEFINITION.
    METHODS customersset_get_entity REDEFINITION.
    METHODS customersset_get_entityset REDEFINITION.
    METHODS customersset_update_entity REDEFINITION.
    METHODS customersset_delete_entity REDEFINITION.

    METHODS payments001set_get_entity REDEFINITION.
    METHODS payments001set_get_entityset REDEFINITION.
    METHODS payments001set_create_entity REDEFINITION.
    METHODS payments001set_update_entity REDEFINITION.
    METHODS payments001set_delete_entity REDEFINITION.

    METHODS orders001set_get_entityset REDEFINITION.
    METHODS orders001set_get_entity REDEFINITION.
    METHODS orders001set_create_entity REDEFINITION.
    METHODS orders001set_update_entity REDEFINITION.
    METHODS orderlistset_update_entity REDEFINITION.
    METHODS orderlistset_delete_entity REDEFINITION.


*    METHODS filesset_get_entityset REDEFINITION.
  PRIVATE SECTION.
    METHODS: order_data IMPORTING it_order       TYPE /iwbep/t_mgw_sorting_order
                                  iv_entity_name TYPE string
                        CHANGING  et_entityset   TYPE table
                        RAISING   /iwbep/cx_mgw_busi_exception.
ENDCLASS.

CLASS zcl_zgsb_c369_v3_lgl_dpc_ext IMPLEMENTATION.


  METHOD salesorderset_get_entityset.
    DATA: ls_max_rows       TYPE bapi_epm_max_rows,
          lt_so_header_data TYPE TABLE OF bapi_epm_so_header.

    ls_max_rows-bapimaxrow = 5.

    CALL FUNCTION 'BAPI_EPM_SO_GET_LIST'
      EXPORTING
        max_rows     = ls_max_rows
      TABLES
        soheaderdata = lt_so_header_data
*       soitemdata   =
*       selparamsoid =
*       selparambuyername =
*       selparamproductid =
*       return       =
      .
    et_entityset[] = lt_so_header_data[].

  ENDMETHOD.

  METHOD orderlistset_get_entityset.

* NO IMPLEMENTAR
  ENDMETHOD.

  METHOD orders001set_get_entityset.
    DATA it_orders TYPE TABLE OF zorders.

    DATA(lv_osql_where_clause) = io_tech_request_context->get_osql_where_clause( ).

    IF NOT lv_osql_where_clause IS INITIAL.

      lv_osql_where_clause = replace( val = lv_osql_where_clause
                                      sub = 'SHIPADDRESS-'
                                      with = '').

      SELECT FROM zorders FIELDS *
             WHERE (lv_osql_where_clause)
             INTO TABLE @it_orders.
    ELSE.

      SELECT FROM zorders
             FIELDS *
             INTO TABLE @it_orders.
    ENDIF.

    et_entityset = VALUE #( FOR ls_order IN it_orders (
                    orderid                   = ls_order-orderid
                    customerid                = ls_order-customerid
                    paymentid                 = ls_order-paymentid
                    orderdate                 = ls_order-orderdate
                    shipdate                  = ls_order-shipdate
                    shipvia                   = ls_order-shipvia
                    shipaddress-city          = ls_order-city
                    shipaddress-street        = ls_order-street
                    shipaddress-postalcode    = ls_order-postalcode
                    shipaddress-buildernumber = ls_order-buildernumber
                    shipaddress-country       = ls_order-country
                    documentorder             = ls_order-documentorder ) ).


  ENDMETHOD.

  METHOD orders001set_create_entity.
    DATA: ls_order     TYPE zcl_zsoa262_01_mpc=>ts_orders,
          ls_order_ins TYPE zorders.
    TRY.
        io_data_provider->read_entry_data( IMPORTING es_data = ls_order ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.
    ls_order_ins = VALUE #( orderid       = ls_order-orderid
                            customerid    = ls_order-customerid
                            paymentid     = ls_order-paymentid
                            orderdate     = ls_order-orderdate
                            shipdate      = ls_order-shipdate
                            shipvia       = ls_order-shipvia
                            city          = ls_order-shipaddress-city
                            street        = ls_order-shipaddress-street
                            postalcode    = ls_order-shipaddress-postalcode
                            buildernumber = ls_order-shipaddress-buildernumber
                            country       = ls_order-shipaddress-country
                            documentorder = ls_order-documentorder ).


    INSERT zorders FROM ls_order_ins.
    IF sy-subrc EQ '0'.

      er_entity = VALUE #( orderid = ls_order-orderid
                           customerid = ls_order-customerid
                           paymentid =  ls_order-paymentid
                           orderdate = ls_order-orderdate
                           shipdate = ls_order-shipdate
                           shipvia = ls_order-shipvia
                           shipaddress =  ls_order-shipaddress
                           documentorder = ls_order-documentorder ).


    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '001'
                                            attr1 = 'INSERT error' ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid = ls_message.

    ENDIF.

  ENDMETHOD.

  METHOD customersset_create_entity.

    DATA:   ls_customers TYPE zcustomers.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_customers ).

    INSERT zcustomers FROM ls_customers.

    IF sy-subcs EQ 0.
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

  METHOD payments001set_create_entity.
    DATA: ls_payments     TYPE zcl_zsoa262_01_mpc=>ts_payments.
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

  METHOD customersset_get_entity.

    DATA(lv_customer_id) = it_key_tab[ name = 'Customerid' ]-value.

    SELECT SINGLE FROM zcustomers
           FIELDS *
           WHERE customerid EQ @lv_customer_id
           INTO @er_entity.

  ENDMETHOD.

  METHOD orders001set_get_entity.
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


      er_entity = VALUE #(  orderid = ls_order-orderid
                          customerid = ls_order-customerid
                          paymentid =  ls_order-paymentid
                          orderdate = ls_order-orderdate
                          shipdate = ls_order-shipdate
                          shipvia = ls_order-shipvia
                          shipaddress =  ls_ship_address
                          documentorder = ls_order-documentorder ).
    ENDIF.
  ENDMETHOD.

  METHOD payments001set_get_entity.

    IF NOT it_navigation_path IS INITIAL.

      TRY.

          DATA(lv_nav_path) = it_navigation_path[ nav_prop = 'OrdersToPaymentsNav'
                                                  target_type = 'Payments' ]-nav_prop.

        CATCH cx_sy_itab_line_not_found INTO DATA(lx_itab_line_not_fount).
          DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                              msgno = '003'
                                              attr1 = lx_itab_line_not_fount->get_text(  ) ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              textid = ls_message.

      ENDTRY.

      DATA(lv_orderid) = it_key_tab[ name = 'Orderid' ]-value.

      CASE lv_nav_path.

        WHEN 'OrdersToPaymentsNav'.

          SELECT SINGLE FROM zpayments
             FIELDS *
             WHERE orderid EQ @lv_orderid
             INTO @er_entity.

      ENDCASE.


    ELSE.

      DATA(lv_paymentid) = it_key_tab[ name = 'Paymentid' ]-value.

      SELECT SINGLE FROM zpayments
           FIELDS *
           WHERE paymentid EQ @lv_paymentid
           INTO @er_entity.
    ENDIF.
  ENDMETHOD.

  METHOD customersset_get_entityset.


    SELECT FROM zcustomers
         FIELDS *
         INTO TABLE @et_entityset.
    CHECK NOT it_order IS INITIAL.
    TRY.
        order_data( EXPORTING
                    it_order = it_order
                    iv_entity_name = iv_entity_name
                    CHANGING
                    et_entityset = et_entityset ).

      CATCH /iwbep/cx_mgw_busi_exception INTO DATA(cx_mgw_busi).
    ENDTRY.
  ENDMETHOD.

  METHOD payments001set_get_entityset.

    IF NOT is_paging IS INITIAL.

      SELECT FROM zpayments
      FIELDS *
      ORDER BY paymentid
      INTO TABLE @et_entityset
      OFFSET @is_paging-skip
      UP TO @is_paging-top ROWS.
    ELSE.

      SELECT FROM zpayments
           FIELDS *
           INTO TABLE @et_entityset.
    ENDIF.
  ENDMETHOD.

  METHOD customersset_update_entity.

    DATA ls_customers_odata TYPE zcustomers.
    DATA(lv_customerid) = it_key_tab[ name = 'Customerid' ]-value.

    SELECT SINGLE * FROM zcustomers
    WHERE customerid EQ @lv_customerid
    INTO @DATA(ls_customers_ddbb).

    IF sy-subrc EQ 0.

      io_data_provider->read_entry_data( IMPORTING es_data = ls_customers_odata ).

      DATA(ls_customers_update) = VALUE zcustomers( customerid = lv_customerid
            orderid = COND #( WHEN ls_customers_odata-orderid IS NOT INITIAL                                                                     THEN ls_customers_odata-orderid
                              ELSE ls_customers_ddbb-orderid )
                 name = COND #( WHEN ls_customers_odata-name IS NOT INITIAL                                                                      THEN ls_customers_odata-name                                                                      ELSE
                                     ls_customers_ddbb-name )
                                address = COND #( WHEN ls_customers_odata-address IS NOT INITIAL
                           THEN ls_customers_odata-address
                           ELSE ls_customers_ddbb-address )
            city = COND #( WHEN ls_customers_odata-city IS NOT INITIAL
                          THEN ls_customers_odata-city
                          ELSE ls_customers_ddbb-city  )

            postalcode = COND #( WHEN ls_customers_odata-postalcode  IS NOT INITIAL
                                THEN ls_customers_odata-postalcode
                                ELSE ls_customers_ddbb-postalcode )
            phone = COND #( WHEN ls_customers_odata-phone IS NOT INITIAL
                                 THEN ls_customers_odata-phone
                                  ELSE ls_customers_ddbb-phone )  ).

      UPDATE zcustomers FROM ls_customers_update.
      IF sy-subrc EQ 0.
        er_entity = ls_customers_update.
      ELSE.
        DATA(lv_rase_exception) = abap_true.
      ENDIF.
    ELSE.
      lv_rase_exception = abap_true.
    ENDIF.


    IF lv_rase_exception EQ abap_true.
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'UPDATE error' ).
      RAISE EXCEPTION TYPE /iwbep/cx_epm_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.



  ENDMETHOD.

  METHOD orderlistset_update_entity.
* No implementar
  ENDMETHOD.

  METHOD payments001set_update_entity.

    DATA ls_payments_odata TYPE zpayments.
    DATA(lv_paymentid) = it_key_tab[ name = 'Paymentid' ]-value.

    SELECT SINGLE * FROM  zpayments
    WHERE paymentid EQ @lv_paymentid
    INTO @DATA(ls_payments_bbdd).

    io_data_provider->read_entry_data( IMPORTING es_data = ls_payments_odata ).

    DATA(ls_payments_update) = VALUE zpayments( paymentid = lv_paymentid
    orderid   = COND #( WHEN ls_payments_odata-orderid IS NOT INITIAL
    THEN ls_payments_odata-orderid
    ELSE ls_payments_bbdd-orderid )

    paymentmethod   = COND #( WHEN ls_payments_odata-paymentmethod IS NOT INITIAL
    THEN ls_payments_odata-paymentmethod
    ELSE ls_payments_bbdd-paymentmethod )

    amount   = COND #( WHEN ls_payments_odata-amount IS NOT INITIAL
    THEN ls_payments_odata-amount
    ELSE ls_payments_bbdd-amount )

    dateor   = COND #( WHEN ls_payments_odata-dateor IS NOT INITIAL
    THEN ls_payments_odata-dateor
    ELSE ls_payments_bbdd-dateor )

    status   = COND #( WHEN ls_payments_odata-status IS NOT INITIAL
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

  METHOD orders001set_update_entity.
    DATA: ls_order_odata TYPE zsorder.
    DATA(lv_order_id) = it_key_tab[ name = 'Orderid' ]-value.

    SELECT SINGLE FROM zorders
        FIELDS *
        WHERE orderid EQ @lv_order_id
        INTO @DATA(ls_orders_ddbb).

    io_data_provider->read_entry_data( IMPORTING es_data = ls_order_odata ).

    DATA(ls_order_ins) = VALUE zorders( orderid       = lv_order_id

        customerid = COND #( WHEN ls_order_odata-customerid IS NOT INITIAL
        THEN ls_order_odata-customerid
        ELSE ls_orders_ddbb-customerid )

        paymentid = COND #( WHEN ls_order_odata-paymentid IS NOT INITIAL
        THEN ls_order_odata-paymentid
        ELSE ls_orders_ddbb-paymentid )

        orderdate = COND #( WHEN ls_order_odata-orderdate IS NOT INITIAL
        THEN ls_order_odata-orderdate
        ELSE ls_orders_ddbb-orderdate )

        shipdate = COND #( WHEN ls_order_odata-shipdate IS NOT INITIAL
        THEN ls_order_odata-shipdate
        ELSE ls_orders_ddbb-shipdate )

        shipvia = COND #( WHEN ls_order_odata-shipvia IS NOT INITIAL
        THEN ls_order_odata-shipvia
        ELSE ls_orders_ddbb-shipvia )

        city = COND #( WHEN ls_order_odata-shipaddress-city IS NOT INITIAL
        THEN ls_order_odata-shipaddress-city
        ELSE ls_orders_ddbb-city )

        street = COND #( WHEN ls_order_odata-shipaddress-street IS NOT INITIAL
        THEN ls_order_odata-shipaddress-street
        ELSE ls_orders_ddbb-street )

        postalcode = COND #( WHEN ls_order_odata-shipaddress-postalcode IS NOT INITIAL
        THEN ls_order_odata-shipaddress-postalcode
        ELSE ls_orders_ddbb-postalcode )

        buildernumber = COND #( WHEN ls_order_odata-shipaddress-buildernumber IS NOT INITIAL
        THEN ls_order_odata-shipaddress-buildernumber
        ELSE
        ls_orders_ddbb-buildernumber )

        country = COND #( WHEN ls_order_odata-shipaddress-country IS NOT INITIAL
        THEN ls_order_odata-shipaddress-country
        ELSE ls_orders_ddbb-country )

        documentorder = COND #( WHEN ls_order_odata-documentorder IS NOT INITIAL
         THEN ls_order_odata-documentorder
        ELSE ls_orders_ddbb-documentorder ) ).

    UPDATE zorders FROM ls_order_ins.

    IF sy-subrc EQ 0.
      er_entity = ls_order_odata.
    ELSE.

      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'UPDATE Order Error  ' ).
      RAISE EXCEPTION TYPE /iwbep/cx_epm_busi_exception
        EXPORTING
          textid = ls_message.
    ENDIF.


  ENDMETHOD.

  METHOD customersset_delete_entity.
    DATA(lt_keys) = io_tech_request_context->get_keys( ).

    DATA(lv_customerid) = lt_keys[ name = 'CUSTOMERID' ]-value.

    DELETE FROM zcustomers WHERE customerid EQ lv_customerid.

    CHECK sy-subrc NE 0.

    DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                         msgno = '007'
                                         attr1 = 'DELETE Customers error' ).

    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
      EXPORTING
        textid = ls_message.

  ENDMETHOD.

  METHOD orderlistset_delete_entity.
    DATA(lt_keys) = io_tech_request_context->get_keys( ).

    DATA(lv_orderid) = it_key_tab[ name = 'Orderid' ]-value.

    DELETE FROM zorders WHERE orderid EQ lv_orderid.

    CHECK sy-subrc NE 0.

    DATA(ls_message) = VALUE scx_t100key( msgid = 'ZSALERORDERS'
                                           msgno = '007'
                                           attr1 = 'Orders'
                                           attr2 = 'Error Delete Action').

    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
      EXPORTING
        textid = ls_message.

  ENDMETHOD.

  METHOD payments001set_delete_entity.
    DATA(lt_keys) = io_tech_request_context->get_keys( ).

    DATA(lv_paymentid) = it_key_tab[ name = 'Paymentid' ]-value.

    DELETE FROM zpayments WHERE paymentid EQ lv_paymentid.

    CHECK sy-subrc NE 0.

    DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                           msgno = '007'
                                           attr1 = 'Delete Payments error').

    RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
      EXPORTING
        textid = ls_message.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    CASE iv_action_name.
      WHEN 'PaymentStatus'.
        DATA(lv_paymentid) = it_parameter[ name = 'paymentid' ]-value.
        DATA(lv_status) = it_parameter[ name = 'Status' ]-value.
        CHECK NOT lv_paymentid IS INITIAL.

        UPDATE zpayments SET status = lv_status
                         WHERE paymentid = lv_paymentid.
        DATA(ls_entity) = VALUE zcl_zsoa262_01_mpc=>ts_payments( status = lv_status paymentid = lv_paymentid
        dateor = sy-datum ).

        me->copy_data_to_ref( EXPORTING is_data = ls_entity
                              CHANGING cr_data = er_data ).
    ENDCASE.


  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.
    CASE iv_entity_set_name.
      WHEN 'CustomersSet'.

        SELECT FROM zcustomers FIELDS * INTO TABLE @DATA(lt_customers).
        IF sy-subrc EQ 0.
          me->copy_data_to_ref( EXPORTING is_data = lt_customers CHANGING cr_data = er_entityset ).

        ENDIF.
      WHEN 'Orders001Set'.
        DATA(lv_customerid) = it_key_tab[ name = 'Customerid' ]-value.

        SELECT FROM zorders FIELDS * WHERE customerid EQ @lv_customerid INTO TABLE @DATA(lt_orders).
        IF sy-subrc EQ 0.

          me->copy_data_to_ref( EXPORTING is_data = lt_orders CHANGING cr_data = er_entityset ).

        ENDIF.

    ENDCASE.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
    DATA: ls_depp_entity TYPE zcl_zgsb_c369_v3_lgl_mpc_ext=>ts_deep_entity,
          ls_customers   TYPE zcustomers,
          it_orders      TYPE TABLE OF zorders.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_depp_entity ).

    CASE iv_entity_name.
      WHEN 'Customers'.

        ls_customers = CORRESPONDING #( ls_depp_entity ).

        it_orders = VALUE #( FOR ls_order IN ls_depp_entity-customertoordersnav (
                                    orderid       = ls_order-orderid
                                    customerid    = ls_order-customerid
                                    paymentid     = ls_order-paymentid
                                    orderdate     = ls_order-orderdate
                                    shipdate      = ls_order-shipdate
                                    shipvia       = ls_order-shipvia
                                    city          = ls_order-shipaddress-city
                                    street        = ls_order-shipaddress-street
                                    postalcode    = ls_order-shipaddress-postalcode
                                    buildernumber = ls_order-shipaddress-buildernumber
                                    country       = ls_order-shipaddress-country
                                    documentorder = ls_order-documentorder ) ).

        IF ls_customers IS NOT INITIAL.
          INSERT zcustomers FROM ls_customers.
          IF sy-subrc EQ 0.
            INSERT zorders FROM TABLE it_orders.
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
      DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                            msgno = '002'
                                            attr1 = 'Deep Insert ERROR ').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
        EXPORTING
          textid = ls_message.
    ENDIF.
  ENDMETHOD.

  METHOD order_data.
    DATA(lt_entity_props) = CAST /iwbep/cl_mgw_dp_facade(  me->/iwbep/if_mgw_conv_srv_runtime~get_dp_facade( )
                                                        )->/iwbep/if_mgw_dp_int_facade~get_model(
                                                        )->get_entity_type( CONV /iwbep/med_external_name( iv_entity_name )
                                                        )->get_properties( ).
    DATA(lt_sortorder) = VALUE abap_sortorder_tab(
                                                 FOR <ls_sortorder> IN it_order (
                                                  name = VALUE #( lt_entity_props[ name = <ls_sortorder>-property ]-technical_name )
                                                  descending = COND #( WHEN to_upper( <ls_sortorder>-order ) = 'DESC'
                                                  THEN abap_true
                                                  ELSE abap_false ) ) ).
    CHECK lines( lt_sortorder ) GT 0.

    SORT et_entityset BY (lt_sortorder).

  ENDMETHOD.


****
  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.
    CASE iv_entity_name.
      WHEN 'files'.
        CHECK iv_slug IS NOT INITIAL.

        DATA(ls_file) = VALUE zfile( filename = iv_slug
                                     value = is_media_resource-value
                                     mimetype = is_media_resource-mime_type
                                     sydate = sy-datum
                                     sytime = sy-uzeit ).
        INSERT INTO zfile VALUES ls_file.
        IF sy-subrc EQ 0.
          me->copy_data_to_ref(  EXPORTING is_data = ls_file
                                 CHANGING cr_data = er_entity ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD filesset_get_entityset.

    SELECT FROM zfile
    FIELDS *
    INTO TABLE @et_entityset.

  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA(lv_filename) = it_key_tab[ name = 'Filename' ]-value.

    SELECT SINGLE FROM zfile
           FIELDS mimetype, value
           WHERE filename EQ @lv_filename
           INTO @DATA(ls_file).
    IF sy-subrc EQ 0.
      DATA(ls_stream) = VALUE ty_s_media_resource(  value = ls_file-value mime_type = ls_file-mimetype ).
      me->copy_data_to_ref( EXPORTING is_data = ls_stream
                            CHANGING cr_data = er_stream ).
    ENDIF.

  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~update_stream.
    CASE iv_entity_name.
      WHEN 'files'.
        DATA(lv_filename) = it_key_tab[ name = 'Filename' ]-value.

        UPDATE zfile
        SET value = @is_media_resource-value,
            mimetype = @is_media_resource-mime_type
        WHERE filename EQ @lv_filename.

        IF sy-subrc NE 0.

          DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                              msgno = '002'
                                              attr1 = 'File name was not updated or doesnt exists').

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              textid = ls_message.

        ENDIF.

    ENDCASE.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~delete_stream.
    CASE iv_entity_name.
      WHEN 'files'.
        DATA(lv_filename) = it_key_tab[ name = 'Filename' ]-value.

        DELETE FROM zfile WHERE filename EQ @lv_filename.

        IF sy-subrc NE 0.
          DATA(ls_message) = VALUE scx_t100key( msgid = 'SY'
                                        msgno = '002'
                                        attr1 = 'File name was not deleted or doesnt exists').

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              textid = ls_message.

        ENDIF.

    ENDCASE.
  ENDMETHOD.
  METHOD /iwbep/if_mgw_appl_srv_runtime~changeset_begin.
*    BREAK-POINT.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~changeset_end.
*    BREAK-POINT.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~changeset_process.
*    BREAK-POINT.
  ENDMETHOD.

ENDCLASS.
