@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPURCHASE06
  as select from    ZPurchase01           as a
    left outer join I_SupplierInvoiceAPI01 as m on  a.IRDocNumber = m.SupplierInvoice
                                                and m.FiscalYear  = a.FiscalYear
                                                and m.CompanyCode = a.CompanyCode

    left outer join ZPurchase03            as s on  m.SupplierInvoice = s.SupplierInvoice
                                                and a.FiscalYear      = s.FiscalYear

    left outer join ZPurchase04            as p on  p.AccountingDocument     = a.DocumentNumber
                                                and p.FiscalYear             = a.FiscalYear
                                                and p.CompanyCode            = a.CompanyCode
                                                and p.PurchasingDocument     = a.PO           // Added on 13.05.2025
                                                and p.PurchasingDocumentItem = a.POitem       // Added on 13.05.2025

  //    left outer join ZPurchase05            as q on  q.AccountingDocument     = a.DocumentNumber
  //                                                and q.FiscalYear             = a.FiscalYear
  //                                                and q.CompanyCode            = a.CompanyCode
  //                                                and q.PurchasingDocument     = a.Po
  //                                                and q.PurchasingDocumentItem = a.POitem

{
  key a.DocumentNumber,
      a.AD,
      a.AD1,
      a.ADItem1,
      a.WithholdingTaxCode,
      case
      when p.PurchasingDocument is not initial
      then p.PurchasingDocument
      else a.PO
      end                                                                                                   as PO,
      case
      when p.PurchasingDocumentItem is not initial
      then p.PurchasingDocumentItem
      else a.POitem
      end                                                                                                   as Poitem,
      case when p.PurchaseOrderType is not initial then p.PurchaseOrderType else a.PurchaseOrderType end    as PurchaseOrderType,
      s.SupplierInvoiceItem,
      //      r.SupplierInvoiceItem as Item,
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
      case when a.invoiceQuantity is not initial then a.invoiceQuantity else p.Quantity end                 as invoiceQuantity,
      a.IR,
      @Semantics.amount.currencyCode:'waers'
      case when a.TaxAmount is not initial then a.TaxAmount else p.TaxAmount end                            as TaxAmount,
      case when a.HSNCode is not initial then a.HSNCode else p.HSNCode end                                  as HSNCode,
      a.Vendor,
      a.VendorName,
      a.VendorGSTIN,
      a.City,
      a.Region,
      a.PAN,
      a.MaterialGroup,
      case when a.Poduct1 is not initial then a.Poduct1 else p.Product end                                  as Poduct1,
      case when a.ProductDescription is not initial then a.ProductDescription else p.ProductDescription end as ProductDescription,
      @Semantics.amount.currencyCode:'waers'
      //      case when a.CGSTAmount is not initial then a.CGSTAmount else p.CGSTAmount end                         as CGSTAmount,
      case when p.CGSTAmount is not initial then p.CGSTAmount else a.CGSTAmount end                         as CGSTAmount,
      @Semantics.amount.currencyCode:'waers'
      //      case when a.SGSTAmount is not initial then a.SGSTAmount else p.SGSTAmount end                         as SGSTAmount,
      case when p.SGSTAmount is not initial then p.SGSTAmount else a.SGSTAmount end                         as SGSTAmount,
      @Semantics.amount.currencyCode:'waers'
      //      case when a.IGSTAmount is not initial then a.IGSTAmount else p.IGSTAmount end                         as IGSTAmount,
      case when p.IGSTAmount is not initial then p.IGSTAmount else a.IGSTAmount end                         as IGSTAmount,
      //      a.Cgst,
      //      a.Sgst,
      //      a.Igst,
      case when p.Cgst is not initial then p.Cgst else a.Cgst end                                           as Cgst,   // Added on 13.05.2025
      case when p.Sgst is not initial then p.Sgst else a.Sgst end                                           as Sgst,   // Added on 13.05.2025
      case when p.Igst is not initial then p.Igst else a.Igst end                                           as Igst,   // Added on 13.05.2025
      a.Reference,
      a.Materialgroupdesc,
      @Semantics.amount.currencyCode:'waers'
      //      case when a.Total is not initial then a.Total else p.Total end                                        as Total,
      case when p.Total is not initial then p.Total else a.Total end                                        as Total,
      //      case when a.Total is not initial
      //      then a.Total
      //      when p.Total is not initial
      //      then p.Total
      //      else q.Total
      //      end                                                                                                   as Total,
      a.RegionDesc,
      a.TaxCodeDesc,
      a.IRDocNumber,
      m.IsInvoice                                                                                           as IsInvoice,
      s.IsSubsequentDebitCredit                                                                             as IsSubsequentDebitCredit,
      a.ReversedIndicator,
      a.ReversalReferenceDocument,

      case
      when m.IsInvoice = 'X' and s.IsSubsequentDebitCredit ='' then 'Invoice'
      when m.IsInvoice ='' and s.IsSubsequentDebitCredit ='' then 'Credit Memo'
      when m.IsInvoice = 'X' and s.IsSubsequentDebitCredit = 'X' then 'Subsequent Debit'
      when m.IsInvoice = '' and s.IsSubsequentDebitCredit = 'X' then 'Subsequent Credit'
      else ''
      end                                                                                                   as IRDocType,

      a.RevercedChargeFlag,
      a.DocumentType1,
      a.SupplyType,
      @Semantics.amount.currencyCode:'waers'
      a.dif,

      case a.PurchaseOrderType
      when 'ZQTY' then 'IP'
      when 'ZIMP' then 'IP'
      when 'ZLON' then 'IP'
      when 'LP' then 'IP'
      when 'ZCAP' then 'CP'
      else ' '
      end                                                                                                   as Eligibilityindicator1,

      case a.TaxCode
      when 'GH' then 'No'
      when 'GJ' then 'No'
      when 'GK' then 'No'
      when 'GL' then 'No'
      when 'GM' then 'No'
      when 'GN' then 'No'
      when 'GO' then 'No'
      when 'GP' then 'No'
      when 'GR' then 'No'
      when 'GQ' then 'No'
      when 'R1' then 'No'
      when 'R2' then 'No'
      when 'R3' then 'No'
      when 'R4' then 'No'
      when 'R5' then 'No'
      when 'R6' then 'No'
      when 'R7' then 'No'
      when 'R8' then 'No'
      when 'R9' then 'No'
      when 'RA' then 'No'
      when 'RB' then 'No'
      when 'RC' then 'No'
      when 'RD' then 'No'
      when 'RE' then 'No'
      when 'RF' then 'No'
      when 'RG' then 'No'
      when 'RH' then 'No'
      else ' '
      end                                                                                                   as Eligibilityindicator2,

      m.SupplierInvoiceIDByInvcgParty                                                                       as DCNumber,
      a.AssignmentReference //Added by Sukhwinder on 06.02.2026

}
