CLASS zcl_zgsb_c369_test__01_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zgsb_c369_test__01_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_deep_entity, customerid TYPE /bi0/oiobjectid,
    orderid TYPE /bi0/oiobjectid,
     name TYPE /iwbep/mgw_gen_entity_set_name,
     address TYPE /iwbep/mgw_gen_entity_set_name,
      city TYPE /sapquery/s_city,
      country TYPE iw_country,
      postalcode TYPE wdr_test_adr_postalcode,
      phone TYPE demo_cr_telephone_number,
       CustomerToOrdersNav TYPE TABLE OF zcl_zsalesorder_mpc=>ts_orders WITH DEFAULT KEY, END OF ts_deep_entity.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zgsb_c369_test__01_mpc_ext IMPLEMENTATION.
ENDCLASS.
