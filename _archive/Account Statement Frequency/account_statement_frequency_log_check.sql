/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Account Statement Frequency Log
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Go to your excel file
				  - Format the parameter in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted Seller ID in >> WHERE sel.short_code IN () << part of the script
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    IF(al.global_setting = 1,
        'Global Setting',
        CONCAT('ID', sel.src_id)) 'seller_id',
    IF(al.global_setting = 1,
        'Global Setting',
        sel.short_code) 'short_code',
    IF(al.global_setting = 1,
        'Global Setting',
        sel.name) 'seller_name',
    IF(al.global_setting = 0,
        sel.tax_class,
        '') 'tax_class',
    sel.account_status,
    CASE
        WHEN REPLACE(sc.value, '"', '') = '1' THEN 'Weekly'
        WHEN REPLACE(sc.value, '"', '') = '2' THEN 'Monthly'
        WHEN REPLACE(sc.value, '"', '') = '3' THEN 'Bi-Weekly'
        WHEN REPLACE(sc.value, '"', '') IS NULL THEN 'Global Default'
    END 'current_statement_freq',
    CASE
        WHEN al.statement_freq = '1' THEN 'Weekly'
        WHEN al.statement_freq = '2' THEN 'Monthly'
        WHEN al.statement_freq = '3' THEN 'Bi-Weekly'
        WHEN al.statement_freq IS NULL THEN 'Global Default'
    END 'statement_freq_log',
    al.created_at,
    al.user_email 'changed_by'
FROM
    (SELECT 
        fk_user,
            user_email,
            SUBSTRING_INDEX(SUBSTRING_INDEX(event_description, 'Statement freq.: \'', - 1), '\'', 1) 'statement_freq',
            SUBSTRING_INDEX(SUBSTRING_INDEX(event_description, '(ID: \'', - 1), '\')', 1) 'fk_seller',
            SUBSTRING_INDEX(SUBSTRING_INDEX(event_description, 'seller \'', - 1), '\'', 1) 'name',
            IF(event_description LIKE '%Global Setting%', 1, 0) 'global_setting',
            created_at
    FROM
        screport.audit_log
    WHERE
        created_at >= '2016-04-01'
            AND fk_audit_log_event = 5) al
        LEFT JOIN
    screport.seller sel ON al.fk_seller = sel.id_seller
        LEFT JOIN
    screport.seller_config sc ON sel.id_seller = sc.fk_seller
        AND sc.field = 'account_statement_frequency'
WHERE
    sel.short_code IN ();