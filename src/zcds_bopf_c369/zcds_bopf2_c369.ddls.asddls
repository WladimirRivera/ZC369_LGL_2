@AbapCatalog.sqlViewName: 'ZCDSCONBOPFC369'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Airlines'
@ObjectModel: {
   transactionalProcessingEnabled: true,
   usageType.dataClass: #TRANSACTIONAL,
   modelCategory: #BUSINESS_OBJECT,
   compositionRoot: true,
   createEnabled: true,
   updateEnabled: true,
   deleteEnabled: true,
   writeActivePersistence: 'zscarr_c369',
   semanticKey: ['Carrid']
}
define view ZCDS_BOPF2_C369 
           as select from zscarr_c369
{
@ObjectModel.readOnly: true
    key bopfkey as Bopfkey,
    carrid as Carrid,
    carrname as Carrname,
    currcode as Currcode,
    url as Url
}
