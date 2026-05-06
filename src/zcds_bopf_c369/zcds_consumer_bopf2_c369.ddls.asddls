@AbapCatalog.sqlViewName: 'ZCDSBOPFC369'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS - BOPF Consumtion View'
@ObjectModel:{
transactionalProcessingDelegated: true,
compositionRoot: true,
createEnabled: true,
updateEnabled: true,
deleteEnabled: true, 
semanticKey: [ 'Carrid' ]
}
@OData.publish: true
define view ZCDS_CONSUMER_BOPF2_C369 as select from ZCDS_BOPF2_C369 
{
    key Bopfkey,
    Carrid,
    Carrname,
    Currcode,
    Url
}
