@AbapCatalog.sqlViewName: 'ZV_FLIGHTS_C369'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition - Flights'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
@OData.entitySet.name: 'Flight' // Alias
define view zdd_flights_c369
  as select from sflight as sflight
    inner join   spfli   as spfli on  sflight.carrid = spfli.carrid
                                  and sflight.connid = spfli.connid
//  association [0..1] to scarr as _scarr on _scarr.carrid = $projection.Carrid
  association [0..1] to ZI_SCARR as _scarr on _scarr.Carrid = $projection.Carrid
{
  key sflight.carrid as Carrid,
  key sflight.connid as Connid,
  key fldate         as Fldate,
      spfli.airpfrom as Airpfrom,
      spfli.airpto   as Airpto,
      currency       as Currency,
      price          as Price,
      planetype      as Planetype,
      seatsmax       as Seatsmax,
      seatsocc       as Seatsocc,
      paymentsum     as Paymentsum,
      seatsmax_b     as SeatsmaxB,
      seatsocc_b     as SeatsoccB,
//      seatsmax_f     as SeatsmaxF,
//      seatsocc_f     as SeatsoccF,
//      num_puerta     as NumPuerta,
//      _scarr.Carrname as CarrName,
      _scarr
}
