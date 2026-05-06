class ZSC_CO_ZWS_CHECK_FLIGHT_C369 definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods ZFM_CHECK_FLIGHT_C369
    importing
      !INPUT type ZWSC369ZFM_CHECK_FLIGHT_C369
    exporting
      !OUTPUT type ZWSC369ZFM_CHECK_FLIGHT_C369RE
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZSC_CO_ZWS_CHECK_FLIGHT_C369 IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZSC_CO_ZWS_CHECK_FLIGHT_C369'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method ZFM_CHECK_FLIGHT_C369.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'ZFM_CHECK_FLIGHT_C369'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
