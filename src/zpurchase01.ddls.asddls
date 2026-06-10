@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPurchase01
  as select from    I_OperationalAcctgDocItem                     as a
    left outer join I_OperationalAcctgDocItem                     as b  on  a.AccountingDocument                = b.AccountingDocument
                                                                        and a.FiscalYear                        = b.FiscalYear
                                                                        and a.CompanyCode                       = b.CompanyCode
                                                                        and (
                                                                           b.AccountingDocumentItemType         = 'W'
                                                                           //                                                                           or b.CostCenter                 is not initial
//                                                                           or b.AccountingDocumentItemType      = 'M'
                                                                           or b.AccountingDocumentItem          = '002'
                                                                           or b.AccountingDocumentItemType      = 'F'
                                                                           or(
                                                                             b.AccountingDocumentItemType       = 'S'
                                                                             and b.TransactionTypeDetermination = 'KBS'
                                                                           )
                                                                           or( // Added on 13.05.2025
                                                                             b.AccountingDocumentItemType       = 'S'  
                                                                             and b.TransactionTypeDetermination = 'ANL'
                                                                           )
                                                                         )

    left outer join I_Supplier                                    as c  on a.Supplier = c.Supplier

    left outer join I_Product                                     as d  on b.Product = d.Product

    left outer join I_ProductDescription                          as e  on d.Product = e.Product

    left outer join I_ProductPlantBasic                           as f  on  b.Product = f.Product
                                                                        and b.Plant   = f.Plant

    left outer join I_OperationalAcctgDocItem                     as g  on  a.AccountingDocument           = g.AccountingDocument
                                                                        and a.FiscalYear                   = g.FiscalYear
                                                                        and a.CompanyCode                  = g.CompanyCode
                                                                        and g.TransactionTypeDetermination = 'JIC'
                                                                        and b.TaxItemGroup                 = g.TaxItemGroup

    left outer join I_OperationalAcctgDocItem                     as H  on  a.AccountingDocument           = H.AccountingDocument
                                                                        and a.FiscalYear                   = H.FiscalYear
                                                                        and a.CompanyCode                  = H.CompanyCode
                                                                        and H.TransactionTypeDetermination = 'JIS'
                                                                        and b.TaxItemGroup                 = H.TaxItemGroup

    left outer join I_OperationalAcctgDocItem                     as z  on  a.AccountingDocument         = z.AccountingDocument
                                                                        and a.FiscalYear                 = z.FiscalYear
                                                                        and a.CompanyCode                = z.CompanyCode
                                                                        and b.TaxItemGroup               = z.TaxItemGroup
                                                                        and z.AccountingDocumentItemType = 'W'

    left outer join I_OperationalAcctgDocItem                     as zz on  a.AccountingDocument      = zz.AccountingDocument
                                                                        and a.FiscalYear              = zz.FiscalYear
                                                                        and a.CompanyCode             = zz.CompanyCode
                                                                        and b.TaxItemGroup            = zz.TaxItemGroup
                                                                        and a.FiscalYear              = zz.FiscalYear
                                                                        and zz.AccountingDocumentItem = '002'

    left outer join I_OperationalAcctgDocItem                     as I  on  a.AccountingDocument           = I.AccountingDocument
                                                                        and a.FiscalYear                   = I.FiscalYear
                                                                        and a.CompanyCode                  = I.CompanyCode
                                                                        and I.TransactionTypeDetermination = 'JII'
                                                                        and b.TaxItemGroup                 = I.TaxItemGroup

    left outer join I_OperationalAcctgDocItem                     as q  on  a.AccountingDocument           = q.AccountingDocument
                                                                        and a.FiscalYear                   = q.FiscalYear
                                                                        and a.CompanyCode                  = q.CompanyCode
                                                                        and q.TransactionTypeDetermination = 'DIF'
  //                                                                        and b.TaxItemGroup                 = I.TaxItemGroup

    left outer join zz1_tax_code1                                 as k  on zz.TaxCode = k.tax_code

    left outer join I_JournalEntry                                as l  on  a.AccountingDocument    = l.AccountingDocument
                                                                        and l.ReferenceDocumentType = 'RMRP'
                                                                        and a.FiscalYear            = l.FiscalYear

    left outer join I_JournalEntry                                as r  on  a.AccountingDocument = r.AccountingDocument
                                                                        and a.FiscalYear         = r.FiscalYear
                                                                        and a.CompanyCode        = r.CompanyCode

    left outer join I_ProductGroupText_2                          as p  on d.ProductGroup = p.ProductGroup

    left outer join I_AccountingDocumentJournal( P_Language:'E' ) as j  on  a.AccountingDocument = j.AccountingDocument
                                                                        and j.LedgerGLLineItem   = '000001'
                                                                        and j.Ledger             = '0L'
                                                                        and a.FiscalYear         = j.FiscalYear
                                                                        and a.CompanyCode        = j.CompanyCode

    left outer join I_GLAccountText                               as n  on b.GLAccount = n.GLAccount

    left outer join I_PurchaseOrderAPI01                          as o  on o.PurchaseOrder = b.PurchasingDocument

    left outer join I_SchedgagrmthdrApi01                         as pp on pp.SchedulingAgreement = b.PurchasingDocument

    left outer join I_OperationalAcctgDocItem                     as zq on  a.AccountingDocument            = zq.AccountingDocument
                                                                        and a.FiscalYear                    = zq.FiscalYear
                                                                        and a.CompanyCode                   = zq.CompanyCode
    //                                                                        and b.TaxItemGroup               = z.TaxItemGroup
                                                                        and zq.TransactionTypeDetermination = 'WIT'


{
  key   a.AccountingDocument                            as DocumentNumber,
  key   a.CompanyCode                                   as CompanyCode,
  key   a.FiscalYear                                    as FiscalYear,
        @Semantics.amount.currencyCode:'waers'
        b.AmountInTransactionCurrency,
        zq.WithholdingTaxCode                           as WithholdingTaxCode,
        zq.AccountingDocument                           as AD1,
        zq.AccountingDocumentItem                       as ADItem1,
        case when o.PurchaseOrderType is not initial
        then o.PurchaseOrderType
        else pp.PurchasingDocumentType end              as PurchaseOrderType,
        b.AccountingDocument                            as AD,
        b.PurchasingDocument                            as PO,
        b.PurchasingDocumentItem                        as POitem,
        //        cast(l.OriginalReferenceDocument as abap.char( 10 )) as IRDocNumber,
        substring( l.OriginalReferenceDocument, 1, 10 ) as IRDocNumber,
        b.Plant                                         as Plant,
        b.DocumentDate                                  as DocumentDate,
        a.FiscalPeriod                                  as FiscalPeriod,
        a.AccountingDocumentType                        as DocumentType,
        a.PostingDate                                   as PostingDate,
        a.DebitCreditCode                               as DCIndictor,
        //        a.TaxCode                                            as TaxCode,
        b.TaxCode                                       as TaxCode,
        b.BaseUnit                                      as meins,
        b.GLAccount                                     as GLAccount1,
        a.CompanyCodeCurrency                           as waers,
        z.AccountingDocumentItem                        as AccountingDocumentItem,
        cast(b.Quantity as abap.dec(13,2))              as invoiceQuantity,
        @Semantics.amount.currencyCode:'waers'
        b.AmountInFunctionalCurrency                    as TaxAmount,
        b.IN_HSNOrSACCode                               as HSNCode,
        c.Supplier                                      as Vendor,
        c.SupplierName                                  as VendorName,
        c.TaxNumber3                                    as VendorGSTIN,
        c.BPAddrCityName                                as City,
        c.Region                                        as Region,
        c.BusinessPartnerPanNumber                      as PAN,
        d.ProductGroup                                  as MaterialGroup,
        d.Product                                       as Poduct1,
        e.ProductDescription                            as ProductDescription,
        @Semantics.amount.currencyCode:'waers'
        g.AmountInTransactionCurrency                   as CGSTAmount,
        @Semantics.amount.currencyCode:'waers'
        H.AmountInTransactionCurrency                   as SGSTAmount,
        @Semantics.amount.currencyCode:'waers'
        I.AmountInTransactionCurrency                   as IGSTAmount,
        k.cgst                                          as Cgst,
        cast(k.sgst as abap.fltp(16,2))                 as Sgst,
        cast(k.igst as abap.fltp(16,2))                 as Igst,
        r.DocumentReferenceID                           as Reference,
        n.GLAccountName                                 as GLDesc1,
        p.ProductGroupName                              as Materialgroupdesc,
        case
        when b.Quantity = 0 then 0
        else cast(b.AmountInFunctionalCurrency as abap.dec( 16,2 )) / cast( b.Quantity as abap.dec( 16,2 ))
        end                                             as IR,

        //        @Semantics.amount.currencyCode:'waers'
        //        case I.TransactionTypeDetermination
        //        when 'JII'
        //        then
        //        cast((b.AmountInFunctionalCurrency + I.AmountInTransactionCurrency) as abap.curr(16,2))
        //        else
        //        cast((b.AmountInFunctionalCurrency + g.AmountInTransactionCurrency + H.AmountInTransactionCurrency) as abap.curr(16,2))
        //        end                                                  as Total,

        @Semantics.amount.currencyCode:'waers'
        case I.TransactionTypeDetermination
        when 'JII'
        then
        cast(coalesce(get_numeric_value(b.AmountInFunctionalCurrency),0)as abap.curr( 16, 2 )) + cast(coalesce(get_numeric_value(I.AmountInTransactionCurrency),0)as abap.curr( 16, 2 ))
        else
        cast(coalesce(get_numeric_value(b.AmountInFunctionalCurrency),0)as abap.curr( 16, 2 )) + cast(coalesce(get_numeric_value(g.AmountInTransactionCurrency),0)as abap.curr( 16, 2 )) + cast(coalesce(get_numeric_value(H.AmountInTransactionCurrency),0)as abap.curr( 16, 2 ))
        end                                             as Total,


        case c.Region
        when 'AN' then 'ANDAMAN AND NICOBAR ISLANDS'
        when 'AP' then 'ANDHRA PRADESH'
        when 'AR' then 'ARUNACHAL PRADESH'
        when 'AS' then 'ASSAM'
        when 'BR' then 'BIHAR'
        when 'CG' then 'CHATTISGARH'
        when 'CH' then 'CHANDIGARH'
        when 'DH' then 'DADRA AND NAGAR HAVELI AND DAMAN AND DIU'
        when 'DL' then 'DELHI'
        when 'GA' then 'GOA'
        when 'GJ' then 'GUJRAT'
        when 'HP' then 'HIMACHAL PRADESH'
        when 'HR' then 'HARYANA'
        when 'JH' then 'JHARKHAND'
        when 'JK' then 'JAMMU AND KASHMIR'
        when 'KA' then 'KARNATAKA'
        when 'KL' then 'KERALA'
        when 'LA' then 'LADAKH'
        when 'LD' then 'LAKSHADWEEP'
        when 'MH' then 'MAHARASHTRA'
        when 'ML' then 'MEGHALAYA'
        when 'MN' then 'MANIPUR'
        when 'MP' then 'MADHYA PRADESH'
        when 'MZ' then 'MIZORAM'
        when 'NL' then 'NAGALAND'
        when 'OD' then 'ODISHA'
        when 'PB' then 'PUNJAB'
        when 'PY' then 'PUDUCHERRY'
        when 'RJ' then 'RAJASTHAN'
        when 'SK' then 'SIKKIM'
        when 'TN' then 'TAMIL NADU'
        when 'TR' then 'TRIPURA'
        when 'TS' then 'TELANGANA'
        when 'UK' then 'UTTARAKHAND'
        when 'UP' then 'UTTAR PRADESH'
        when 'WB' then 'WEST BENGAL'
        else ''
        end                                             as RegionDesc,

        case b.TaxCode
        when 'G0' then 'IN INPUT GST zero 0%'
        when 'G1' then 'IN: CGST 0.45% + SGST 0.45%'
        when 'G2' then 'IN: CGST 0.90% + SGST 0.90%'
        when 'G4' then 'IN: CGST 1.5% + SGST 1.5%'
        when 'G5' then 'IN: CGST 2.5% + SGST 2.5%'
        when 'G7' then 'IN: CGST 6% + SGST 6%'
        when 'G8' then 'IN: CGST 9% + SGST 9%'
        when 'G9' then 'IN: CGST 14% + SGST 14%'
        when 'GA' then 'IN:IGST 5% '
        when 'GB' then 'IN: IGST12%'
        when 'GC' then 'IN: IGST18 %'
        when 'GF' then 'IN: IGST28 %'
        when 'GH' then 'IN:SGST 1.5% & CGST 1.5% NON CREDIT'
        when 'GJ' then 'IN:SGST 2.5% & CGST 2.5% NON CREDIT'
        when 'GK' then 'IN:SGST 6% & CGST 6% NON CREDIT'
        when 'GL' then 'IN:SGST 9% & CGST 9% NON CREDIT'
        when 'GM' then 'IN:SGST 14% & CGST 14% NON CREDIT'
        when 'GN' then 'IN:IGST 5% NON CREDIT'
        when 'GO' then 'IN:IGST 12% NON CREDIT'
        when 'GP' then 'IN:IGST 18% NON CREDIT'
        when 'GQ' then 'IN:IGST 28% NON CREDIT'
        when 'GR' then 'IN:SGST 9% & CGST 9% NON CREDIT'
        when 'R1' then 'IN:RCM SGST 1.5% & CGST 1.5% '
        when 'R2' then 'IN:RCM SGST 2.5% & CGST 2.5% '
        when 'R3' then 'IN:RCM SGST 6% & CGST 6% '
        when 'R4' then 'IN:RCM SGST 9% & CGST 9% '
        when 'R5' then 'IN:RCM SGST 14% & CGST 14% '
        when 'R6' then 'IN:RCM SGST 2.5% & CGST 2.5% NON CREDIT'
        when 'R7' then 'IN:RCM SGST 6% & CGST 6% NON CREDIT'
        when 'R8' then 'IN:RCM SGST 9% & CGST 9% NON CREDIT'
        when 'R9' then 'IN:RCM SGST 14% & CGST 14% NON CREDIT'
        when 'RA' then 'IN:RCM IGST 5% '
        when 'RB' then 'IN:RCM IGST 12% '
        when 'RC' then 'IN:RCM IGST 18% '
        when 'RD' then 'IN:RCM IGST 28% '
        when 'RE' then 'TELANGIN:RCM IGST 5% NON CREDITANA'
        when 'RF' then 'IN:RCM IGST 12% NON CREDIT'
        when 'RG' then 'IN:RCM IGST 18% NON CREDIT'
        when 'RH' then 'IN:RCM IGST 28% NON CREDIT'
        when 'S1' then 'OUTPUT tax 0%'
        when 'S2' then 'OUTPUT(0.1%) CGST 0.05% + SGST 0.05%'
        when 'S3' then 'OUTPUT CGST 2.5% + SGST 2.5%'
        when 'S4' then 'OUTPUT CGST 6% + SGST 6%'
        when 'S5' then 'OUTPUT CGST 9% + SGST 9%'
        when 'S6' then 'OUTPUT CGST 14% + SGST 14%'
        when 'S7' then 'OUTPUT IGST 5% '
        when 'S8' then 'OUTPUT IGST 12% '
        when 'S9' then 'OUTPUT IGST 18% '
        when 'SA' then 'OUTPUT IGST 28% '
        else ''
        end                                             as TaxCodeDesc,

        case b.TaxCode
        when 'G0' then 'NO'
        when 'G1' then 'NO'
        when 'G2' then 'NO'
        when 'G4' then 'NO'
        when 'G5' then 'NO'
        when 'G7' then 'NO'
        when 'G8' then 'NO'
        when 'G9' then 'NO'
        when 'GA' then 'NO'
        when 'GB' then 'NO'
        when 'GC' then 'NO'
        when 'GF' then 'NO'
        when 'GH' then 'NO'
        when 'GJ' then 'NO'
        when 'GK' then 'NO'
        when 'GL' then 'NO'
        when 'GM' then 'NO'
        when 'GN' then 'NO'
        when 'GO' then 'NO'
        when 'GP' then 'NO'
        when 'GQ' then 'NO'
        when 'R1' then 'YES'
        when 'R2' then 'YES'
        when 'R3' then 'YES'
        when 'R4' then 'YES'
        when 'R5' then 'YES'
        when 'R6' then 'YES'
        when 'R7' then 'YES'
        when 'R8' then 'YES'
        when 'R9' then 'YES'
        when 'RA' then 'YES'
        when 'RB' then 'YES'
        when 'RC' then 'YES'
        when 'RD' then 'YES'
        when 'RE' then 'YES'
        when 'RF' then 'YES'
        when 'RG' then 'YES'
        when 'RH' then 'YES'
        when 'S1' then 'NO'
        when 'S2' then 'NO'
        when 'S3' then 'NO'
        when 'S4' then 'NO'
        when 'S5' then 'NO'
        when 'S6' then 'NO'
        when 'S7' then 'NO'
        when 'S8' then 'NO'
        when 'S9' then 'NO'
        when 'SA' then 'NO'
        else ''
        end                                             as RevercedChargeFlag,

        j.IsReversed                                    as ReversedIndicator,
        j.ReversalReferenceDocument                     as ReversalReferenceDocument,

        case a.AccountingDocumentType
        when 'RE' then 'INV'
        when 'KG' then 'CR'
        when 'KR' then 'INV'
        else ' '
        end                                             as DocumentType1,

        case a.AccountingDocumentType
        when 'RE' then 'TAX'
        when 'KG' then 'TAX'
        when 'KR' then 'INV'
        else ' '
        end                                             as SupplyType,
        @Semantics.amount.currencyCode:'waers'
        q.AmountInTransactionCurrency                   as dif,

        j.AssignmentReference                           as AssignmentReference  //Added by Sukhwinder on 06.02.2026
}
where
  (
    (
      (
           a.AccountingDocumentType = 'RE'
        or a.AccountingDocumentType = 'KR'
        or a.AccountingDocumentType = 'RR'
      )
      //      and b.AmountInTransactionCurrency > 1
    )

    or(
      (
           a.AccountingDocumentType = 'KA'
        or a.AccountingDocumentType = 'KG'
      )
      //      and b.AmountInTransactionCurrency < 0
    )
  )
  and      a.AccountingDocumentItem = '001'

