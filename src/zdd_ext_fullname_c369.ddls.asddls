@AbapCatalog.sqlViewAppendName: 'ZEXTENDNAME'
@EndUserText.label: 'Extended view - fullname'
extend view SEPM_C_RAMP_Product with zdd_ext_Fullname_c369
{
    Supplier._PrimaryContactPerson.FullName as Fullname3
}
