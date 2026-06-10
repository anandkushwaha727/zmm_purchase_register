@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPurchase03 as select from I_SuplrInvcItemPurOrdRefAPI01
{   
    key SupplierInvoice as SupplierInvoice,
    key FiscalYear as FiscalYear,
//    PurchaseOrder,
//    PurchaseOrderItem,
    IsSubsequentDebitCredit as IsSubsequentDebitCredit,
    min(SupplierInvoiceItem) as SupplierInvoiceItem
}
group by SupplierInvoice,
         FiscalYear,
         IsSubsequentDebitCredit
//         PurchaseOrder,
//         PurchaseOrderItem

