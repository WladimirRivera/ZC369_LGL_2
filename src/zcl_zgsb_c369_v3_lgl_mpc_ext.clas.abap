CLASS zcl_zgsb_c369_v3_lgl_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zgsb_c369_v3_lgl_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_deep_entity,
             customerid          TYPE /bi0/oiobjectid,
             orderid             TYPE /bi0/oiobjectid,
             name                TYPE /iwbep/mgw_gen_entity_set_name,
             address             TYPE /iwbep/mgw_gen_entity_set_name,
             city                TYPE /sapquery/s_city,
             country             TYPE iw_country,
             postalcode          TYPE wdr_test_adr_postalcode,
             phone               TYPE demo_cr_telephone_number,
             CustomerToOrdersNav TYPE TABLE OF zcl_zsalesorder_mpc=>ts_orders WITH DEFAULT KEY,
           END OF ts_deep_entity.

    METHODS define REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_zgsb_c369_v3_lgl_mpc_ext IMPLEMENTATION.
  METHOD define.
    super->define(  ).
    DATA(lo_entity_type) = model->get_entity_type(  iv_entity_name = 'files' ).

    IF lo_entity_type IS BOUND.

      lo_entity_type->get_property( iv_property_name = 'Filename' )->set_as_content_type(  ).

    ENDIF.
  ENDMETHOD.
ENDCLASS.
