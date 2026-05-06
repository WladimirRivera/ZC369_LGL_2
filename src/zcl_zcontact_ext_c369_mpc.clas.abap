class ZCL_ZCONTACT_EXT_C369_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  types:
      CT_ADDRESS type /IWBEP/S_GWS_BASIC_ADDRESS .
  types:
   begin of ts_text_element,
      artifact_name  type c length 40,       " technical name
      artifact_type  type c length 4,
      parent_artifact_name type c length 40, " technical name
      parent_artifact_type type c length 4,
      text_symbol    type textpoolky,
   end of ts_text_element .
  types:
         tt_text_elements type standard table of ts_text_element with key text_symbol .
  types:
    begin of CT_STRING,
        STRING type string,
    end of CT_STRING .
  types:
    begin of TS_REGENERATEALLDATA,
        NOOFSALESORDERS type I,
    end of TS_REGENERATEALLDATA .
  types:
    begin of TS_SALESORDER_CONFIRM,
        SALESORDERID type C length 10,
    end of TS_SALESORDER_CONFIRM .
  types:
    begin of TS_SALESORDER_CANCEL,
        SALESORDERID type C length 10,
    end of TS_SALESORDER_CANCEL .
  types:
    begin of TS_SALESORDER_INVOICECREATED,
        SALESORDERID type C length 10,
    end of TS_SALESORDER_INVOICECREATED .
  types:
    begin of TS_SALESORDER_GOODSISSUECREATE,
        SALESORDERID type C length 10,
    end of TS_SALESORDER_GOODSISSUECREATE .
  types:
     TS_BUSINESSPARTNER type /IWBEP/S_GWS_BASIC_BP .
  types:
TT_BUSINESSPARTNER type standard table of TS_BUSINESSPARTNER .
  types:
     TS_CONTACT type /IWBEP/S_GWS_BASIC_BP_CONTACT .
  types:
TT_CONTACT type standard table of TS_CONTACT .
  types:
     TS_PRODUCT type /IWBEP/S_GWS_BASIC_PRODUCT .
  types:
TT_PRODUCT type standard table of TS_PRODUCT .
  types:
     TS_SALESORDER type /IWBEP/S_GWS_BASIC_SO_HEADER .
  types:
TT_SALESORDER type standard table of TS_SALESORDER .
  types:
     TS_SALESORDERLINEITEM type /IWBEP/S_GWS_BASIC_SO_ITEM .
  types:
TT_SALESORDERLINEITEM type standard table of TS_SALESORDERLINEITEM .
  types:
  begin of TS_VH_ADDRESSTYPE,
     ADDRESS_TYPE type C length 2,
     SHORTTEXT type C length 60,
  end of TS_VH_ADDRESSTYPE .
  types:
TT_VH_ADDRESSTYPE type standard table of TS_VH_ADDRESSTYPE .
  types:
  begin of TS_VH_BPROLE,
     BP_ROLE type C length 3,
     SHORTTEXT type C length 60,
  end of TS_VH_BPROLE .
  types:
TT_VH_BPROLE type standard table of TS_VH_BPROLE .
  types:
  begin of TS_VH_CATEGORY,
     CATEGORY type C length 40,
  end of TS_VH_CATEGORY .
  types:
TT_VH_CATEGORY type standard table of TS_VH_CATEGORY .
  types:
  begin of TS_VH_COUNTRY,
     LAND1 type C length 3,
     LANDX type C length 15,
     NATIO type C length 15,
  end of TS_VH_COUNTRY .
  types:
TT_VH_COUNTRY type standard table of TS_VH_COUNTRY .
  types:
  begin of TS_VH_CURRENCY,
     WAERS type C length 5,
     LTEXT type C length 40,
  end of TS_VH_CURRENCY .
  types:
TT_VH_CURRENCY type standard table of TS_VH_CURRENCY .
  types:
  begin of TS_VH_LANGUAGE,
     SPRAS type C length 2,
     SPTXT type C length 16,
  end of TS_VH_LANGUAGE .
  types:
TT_VH_LANGUAGE type standard table of TS_VH_LANGUAGE .
  types:
  begin of TS_VH_PRODUCTTYPECODE,
     TYPE_CODE type C length 2,
     SHORTTEXT type C length 60,
  end of TS_VH_PRODUCTTYPECODE .
  types:
TT_VH_PRODUCTTYPECODE type standard table of TS_VH_PRODUCTTYPECODE .
  types:
  begin of TS_VH_SEX,
     SEX type C length 1,
     SHORTTEXT type C length 60,
  end of TS_VH_SEX .
  types:
TT_VH_SEX type standard table of TS_VH_SEX .
  types:
  begin of TS_VH_UNITLENGTH,
     MSEHI type C length 3,
     MSEHL type C length 30,
  end of TS_VH_UNITLENGTH .
  types:
TT_VH_UNITLENGTH type standard table of TS_VH_UNITLENGTH .
  types:
  begin of TS_VH_UNITQUANTITY,
     MSEHI type C length 3,
     MSEHL type C length 30,
  end of TS_VH_UNITQUANTITY .
  types:
TT_VH_UNITQUANTITY type standard table of TS_VH_UNITQUANTITY .
  types:
  begin of TS_VH_UNITWEIGHT,
     MSEHI type C length 3,
     MSEHL type C length 30,
  end of TS_VH_UNITWEIGHT .
  types:
TT_VH_UNITWEIGHT type standard table of TS_VH_UNITWEIGHT .

  constants GC_BUSINESSPARTNER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'BusinessPartner' ##NO_TEXT.
  constants GC_CONTACT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Contact' ##NO_TEXT.
  constants GC_CT_ADDRESS type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'CT_Address' ##NO_TEXT.
  constants GC_CT_STRING type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'CT_String' ##NO_TEXT.
  constants GC_PRODUCT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'Product' ##NO_TEXT.
  constants GC_SALESORDER type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SalesOrder' ##NO_TEXT.
  constants GC_SALESORDERLINEITEM type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'SalesOrderLineItem' ##NO_TEXT.
  constants GC_VH_ADDRESSTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_AddressType' ##NO_TEXT.
  constants GC_VH_BPROLE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_BPRole' ##NO_TEXT.
  constants GC_VH_CATEGORY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_Category' ##NO_TEXT.
  constants GC_VH_COUNTRY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_Country' ##NO_TEXT.
  constants GC_VH_CURRENCY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_Currency' ##NO_TEXT.
  constants GC_VH_LANGUAGE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_Language' ##NO_TEXT.
  constants GC_VH_PRODUCTTYPECODE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_ProductTypeCode' ##NO_TEXT.
  constants GC_VH_SEX type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_Sex' ##NO_TEXT.
  constants GC_VH_UNITLENGTH type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_UnitLength' ##NO_TEXT.
  constants GC_VH_UNITQUANTITY type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_UnitQuantity' ##NO_TEXT.
  constants GC_VH_UNITWEIGHT type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'VH_UnitWeight' ##NO_TEXT.

  methods GET_EXTENDED_MODEL
  final
    exporting
      !EV_EXTENDED_SERVICE type /IWBEP/MED_GRP_TECHNICAL_NAME
      !EV_EXT_SERVICE_VERSION type /IWBEP/MED_GRP_VERSION
      !EV_EXTENDED_MODEL type /IWBEP/MED_MDL_TECHNICAL_NAME
      !EV_EXT_MODEL_VERSION type /IWBEP/MED_MDL_VERSION
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods LOAD_TEXT_ELEMENTS
  final
    returning
      value(RT_TEXT_ELEMENTS) type TT_TEXT_ELEMENTS
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZCONTACT_EXT_C369_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


data:
  lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ, "#EC NEEDED
  lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type, "#EC NEEDED
  lo_property       type ref to /iwbep/if_mgw_odata_property, "#EC NEEDED
  lo_association    type ref to /iwbep/if_mgw_odata_assoc,  "#EC NEEDED
  lo_assoc_set      type ref to /iwbep/if_mgw_odata_assoc_set, "#EC NEEDED
  lo_ref_constraint type ref to /iwbep/if_mgw_odata_ref_constr, "#EC NEEDED
  lo_nav_property   type ref to /iwbep/if_mgw_odata_nav_prop, "#EC NEEDED
  lo_action         type ref to /iwbep/if_mgw_odata_action, "#EC NEEDED
  lo_parameter      type ref to /iwbep/if_mgw_odata_property, "#EC NEEDED
  lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set, "#EC NEEDED
  lo_complex_prop   type ref to /iwbep/if_mgw_odata_cmplx_prop. "#EC NEEDED

* Extend the model
model->extend_model( iv_model_name = '/IWBEP/GWSAMPLE_BASIC_MDL' iv_model_version = '0001' ). "#EC NOTEXT

model->set_schema_namespace( 'GWSAMPLE_BASIC' ).
  endmethod.


  method GET_EXTENDED_MODEL.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*



ev_extended_service  = '/IWBEP/GWSAMPLE_BASIC'.                "#EC NOTEXT
ev_ext_service_version = '0001'.               "#EC NOTEXT
ev_extended_model    = '/IWBEP/GWSAMPLE_BASIC_MDL'.                    "#EC NOTEXT
ev_ext_model_version = '0001'.                   "#EC NOTEXT
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  constants: lc_gen_date_time type timestamp value '20250607113220'. "#EC NOTEXT
rv_last_modified = super->get_last_modified( ).
IF rv_last_modified LT lc_gen_date_time.
  rv_last_modified = lc_gen_date_time.
ENDIF.
  endmethod.


  method LOAD_TEXT_ELEMENTS.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*


data:
  lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ,           "#EC NEEDED
  lo_complex_type   type ref to /iwbep/if_mgw_odata_cmplx_type,           "#EC NEEDED
  lo_property       type ref to /iwbep/if_mgw_odata_property,             "#EC NEEDED
  lo_association    type ref to /iwbep/if_mgw_odata_assoc,                "#EC NEEDED
  lo_assoc_set      type ref to /iwbep/if_mgw_odata_assoc_set,            "#EC NEEDED
  lo_ref_constraint type ref to /iwbep/if_mgw_odata_ref_constr,           "#EC NEEDED
  lo_nav_property   type ref to /iwbep/if_mgw_odata_nav_prop,             "#EC NEEDED
  lo_action         type ref to /iwbep/if_mgw_odata_action,               "#EC NEEDED
  lo_parameter      type ref to /iwbep/if_mgw_odata_property,             "#EC NEEDED
  lo_entity_set     type ref to /iwbep/if_mgw_odata_entity_set.           "#EC NEEDED


DATA:
     ls_text_element TYPE ts_text_element.                   "#EC NEEDED
  endmethod.
ENDCLASS.
