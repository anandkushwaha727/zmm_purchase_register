@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZPurchase04
  as select from    I_OperationalAcctgDocItem as a
    left outer join I_OperationalAcctgDocItem as b on  b.AccountingDocument         = a.AccountingDocument
                                                   and b.FiscalYear                 = a.FiscalYear
                                                   and b.CompanyCode                = a.CompanyCode
                                                   and b.AccountingDocumentItemType = 'S'
                                                   and b.AssetTransactionType       is not initial

    left outer join I_OperationalAcctgDocItem as c on  c.AccountingDocument           = a.AccountingDocument
                                                   and c.FiscalYear                   = a.FiscalYear
                                                   and c.CompanyCode                  = a.CompanyCode
                                                   and c.TransactionTypeDetermination = 'JIC'
                                                   and c.TaxItemGroup                 = b.TaxItemGroup

    left outer join I_OperationalAcctgDocItem as d on  d.AccountingDocument           = a.AccountingDocument
                                                   and d.FiscalYear                   = a.FiscalYear
                                                   and d.CompanyCode                  = a.CompanyCode
                                                   and d.TransactionTypeDetermination = 'JIS'
                                                   and d.TaxItemGroup                 = b.TaxItemGroup

    left outer join I_OperationalAcctgDocItem as e on  e.AccountingDocument           = a.AccountingDocument
                                                   and e.FiscalYear                   = a.FiscalYear
                                                   and e.CompanyCode                  = a.CompanyCode
                                                   and e.TransactionTypeDetermination = 'JII'
                                                   and e.TaxItemGroup                 = b.TaxItemGroup

    left outer join I_ProductDescription      as f on b.Product = f.Product

    left outer join I_PurchaseOrderAPI01      as o on o.PurchaseOrder = b.PurchasingDocument 

    left outer join zz1_tax_code1             as k on b.TaxCode = k.tax_code   // Added on 13.05.2025

{
  key a.AccountingDocument, //Added key on 03.11.2025
      a.FiscalYear,
      a.CompanyCode,
      b.PurchasingDocument,
      b.PurchasingDocumentItem,
      o.PurchaseOrderType,
      cast(b.Quantity as abap.dec(13,2)) as Quantity,
      b.CompanyCodeCurrency              as waers,
      b.Product,
      b.IN_HSNOrSACCode                  as HSNCode,
      b.Plant,
      b.DocumentDate,
      f.ProductDescription,
      @Semantics.amount.currencyCode: 'waers'
      b.AmountInFunctionalCurrency       as TaxAmount,
      @Semantics.amount.currencyCode: 'waers'
      c.AmountInTransactionCurrency      as CGSTAmount,
      @Semantics.amount.currencyCode: 'waers'
      d.AmountInTransactionCurrency      as SGSTAmount,
      @Semantics.amount.currencyCode: 'waers'
      e.AmountInTransactionCurrency      as IGSTAmount,

      k.cgst                             as Cgst,
      cast(k.sgst as abap.fltp(16,2))    as Sgst,
      cast(k.igst as abap.fltp(16,2))    as Igst,

      @Semantics.amount.currencyCode:'waers'
      case e.TransactionTypeDetermination
      when 'JII'
      then
      cast(coalesce(get_numeric_value(b.AmountInFunctionalCurrency),0)as abap.curr( 16, 2 )) + cast(coalesce(get_numeric_value(e.AmountInTransactionCurrency),0)as abap.curr( 16, 2 ))
      else
      cast(coalesce(get_numeric_value(b.AmountInFunctionalCurrency),0)as abap.curr( 16, 2 )) + cast(coalesce(get_numeric_value(c.AmountInTransactionCurrency),0)as abap.curr( 16, 2 )) + cast(coalesce(get_numeric_value(d.AmountInTransactionCurrency),0)as abap.curr( 16, 2 ))
      end                                as Total
}
where
      a.AccountingDocumentType = 'RE'
  and a.AccountingDocumentItem = '001'
