@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Aggregation.allowPrecisionLoss: true


define view entity ZPURCHASE
  as select from ZPurchase02 as _Pur
{
  key _Pur.DocumentNumber,
  key _Pur.CompanyCode,
  key _Pur.FiscalYear,
  key _Pur.AccountingDocumentItem,
  key _Pur.IRDocNumber,
  key _Pur.Poitem,
      @Semantics.amount.currencyCode:'waers'
//      @Aggregation.default: #SUM
   _Pur.TaxAmount,
      _Pur.PO,
      //      _Pur.Poitem,
      _Pur.PurchaseOrderType,
      _Pur.SupplierInvoiceItem,
      _Pur.DocumentType,
      _Pur.Plant,
      _Pur.DocumentDate,
      _Pur.FiscalPeriod,
      _Pur.PostingDate,
      _Pur.DCIndictor,
      _Pur.TaxCode,
      _Pur.meins,
     // @UI.hidden: true
      _Pur.waers,
      _Pur.invoiceQuantity,
      _Pur.IR,
            //@Semantics.amount.currencyCode:'waers'
           // @Aggregation.default: #SUM
         //  _Pur.TaxAmount,
      _Pur.HSNCode,
      _Pur.Vendor,
      _Pur.VendorName,
      _Pur.VendorGSTIN,
      _Pur.City,
      _Pur.Region,
      _Pur.PAN,
      _Pur.MaterialGroup,
      _Pur.Poduct1,
      _Pur.ProductDescription,
      @Semantics.amount.currencyCode:'waers'
      @Aggregation.default: #SUM
      _Pur.CGSTAmount,
      @Semantics.amount.currencyCode:'waers'
      @Aggregation.default: #SUM
      _Pur.SGSTAmount,
      @Semantics.amount.currencyCode:'waers'
      @Aggregation.default: #SUM
      _Pur.IGSTAmount,
      _Pur.Cgst,
      _Pur.Sgst,
      _Pur.Igst,
      _Pur.Reference,
      _Pur.Materialgroupdesc,
      @Semantics.amount.currencyCode:'waers'
      @Aggregation.default: #SUM
      _Pur.Total,
      _Pur.RegionDesc,
      _Pur.TaxCodeDesc,
      @UI.hidden: true
      _Pur.IsInvoice,
      @UI.hidden: true
      _Pur.IsSubsequentDebitCredit,
      _Pur.ReversedIndicator,
      _Pur.ReversalReferenceDocument,
      _Pur.IRDocType,
      _Pur.RevercedChargeFlag,
      _Pur.DocumentType1,
      _Pur.SupplyType,
      @Semantics.amount.currencyCode:'waers'
      _Pur.dif,
      _Pur.Eligibilityindicator,
      //      _Pur.DCNumber,
      @Semantics.amount.currencyCode:'waers'
      @Aggregation.default: #SUM
      _Pur.WithholdingTaxAmount,
      _Pur.WithholdingTaxCode
}
where
     _Pur.PurchaseOrderType <> 'ZSER'
  or _Pur.PurchaseOrderType is null
  
  
