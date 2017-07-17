/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Account Statement Frequency
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    sup.id_supplier 'id_seller',
    sel.short_code,
    sel.name 'seller_name',
    sup.type,
    sup.status,
    IF(sel.verified = 1,
        'verified',
        'not verified') 'verified',
    IF(sel.completed_registration = 1,
        'completed',
        'not_completed') 'completed_registration',
    sel.tax_class,
    CASE
        WHEN sc.value = '"1"' THEN 'Weekly'
        WHEN sc.value = '"2"' THEN 'Monthly'
        WHEN sc.value = '"3"' THEN 'Bi Weekly'
        WHEN sc.value IS NULL THEN 'Global Setting/Bi Weekly'
    END 'account_statement_frequency',
    sc.created_at 'asfreq_created_date',
    sc.updated_at 'asfreq_updated_date'
FROM
    screport.seller sel
        LEFT JOIN
    screport.seller_config sc ON sc.fk_seller = sel.id_seller
        AND sc.field = 'account_statement_frequency'
        LEFT JOIN
    bob_live.supplier sup ON sel.name = sup.name