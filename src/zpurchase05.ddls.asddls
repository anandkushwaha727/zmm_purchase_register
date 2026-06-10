@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPurchase05
  as select from    I_OperationalAcctgDocItem as a
    left outer join I_OperationalAcctgDocItem as b on  b.AccountingDocument           = a.AccountingDocument
                                                   and b.FiscalYear                   = a.FiscalYear
                                                   and b.CompanyCode                  = a.CompanyCode
                                                   and b.TransactionTypeDetermination = 'EGK'
{
  key a.AccountingDocument,
  key a.FiscalYear,
      a.CompanyCode,
      b.PurchasingDocument,
      b.PurchasingDocumentItem,
      cast(b.Quantity as abap.dec(13,2)) as Quantity,
      b.CompanyCodeCurrency              as waers,
      b.IN_HSNOrSACCode                  as HSNCode,
      b.Plant,
      b.DocumentDate,
      @Semantics.amount.currencyCode: 'waers'
      b.AmountInFunctionalCurrency       as Total

}
where
  (
       a.AccountingDocumentType = 'KG'
    or a.AccountingDocumentType = 'KR'
  )
  and  a.AccountingDocumentItem = '001'
