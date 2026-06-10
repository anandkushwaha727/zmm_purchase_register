@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPurchase02
  as select from    ZPURCHASE06          as a

    left outer join ZPurchase05          as q on  q.AccountingDocument     = a.DocumentNumber
                                              and q.FiscalYear             = a.FiscalYear
                                              and q.CompanyCode            = a.CompanyCode
                                              and q.PurchasingDocument     = a.PO
                                              and q.PurchasingDocumentItem = a.Poitem

    left outer join I_Withholdingtaxitem as e on  a.AD1        = e.AccountingDocument
                                              and a.WithholdingTaxCode = e.WithholdingTaxCode
                                              and a.ADItem1 = e.AccountingDocumentItem
                                                  and a.TaxCode                = e.WithholdingTaxCode
                                              and a.FiscalYear             = e.FiscalYear

  //    left outer join ZPurchase07 as b on b.PurchaseOrder = a.PO

{
  key a.DocumentNumber,
      a.AD,
      a.PO,
      a.Poitem,
      a.PurchaseOrderType,
      a.SupplierInvoiceItem,
      a.DocumentType,
      a.Plant,
      a.DocumentDate,
      a.CompanyCode,
      a.FiscalYear,
      a.FiscalPeriod,
      a.PostingDate,
      a.DCIndictor,
      a.TaxCode,
      a.meins,
      a.waers,
      a.AccountingDocumentItem,
      a.invoiceQuantity,
      a.IR,
      @Semantics.amount.currencyCode:'waers'
      a.TaxAmount,
      a.HSNCode,
      a.PAN,
      a.Vendor,
      a.VendorName,
      a.VendorGSTIN,
      a.City,
      a.Region,
      a.MaterialGroup,
      a.Poduct1,
      a.ProductDescription,
      @Semantics.amount.currencyCode:'waers'
      a.CGSTAmount,
      @Semantics.amount.currencyCode:'waers'
      a.SGSTAmount,
      @Semantics.amount.currencyCode:'waers'
      a.IGSTAmount,
      a.Cgst,
      a.Sgst,
      a.Igst,
      a.Reference,
      a.Materialgroupdesc,
      @Semantics.amount.currencyCode:'waers'
      case when a.Total is not initial then a.Total else q.Total end as Total,
      a.RegionDesc,
      a.TaxCodeDesc,
      a.IRDocNumber,
      a.IsInvoice                                                    as IsInvoice,
      a.IsSubsequentDebitCredit                                      as IsSubsequentDebitCredit,
      a.ReversedIndicator,
      a.ReversalReferenceDocument,
      a.IRDocType,
      a.RevercedChargeFlag,
      a.DocumentType1,
      a.SupplyType,
      @Semantics.amount.currencyCode:'waers'
      a.dif,
      case when a.Eligibilityindicator2 is not initial
      then a.Eligibilityindicator2
      else a.Eligibilityindicator1
      end                                                            as Eligibilityindicator,
      a.DCNumber,
      //      e.WithholdingTaxCode                                           as TaxCode,
      @Semantics.amount.currencyCode:'waers'
      @Aggregation.default: #SUM
      e.WhldgTaxAmtInCoCodeCrcy                                      as WithholdingTaxAmount,
      e.WithholdingTaxCode                                           as WithholdingTaxCode,
      
      a.AssignmentReference //Added by Sukhwinder on 06.02.2026
}

