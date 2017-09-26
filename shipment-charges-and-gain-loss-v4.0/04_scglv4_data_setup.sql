/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss
Data Setup

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
				  - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv4;

SET @updated_at = NOW();
SET SQL_SAFE_UPDATES = 0;

/*-----------------------------------------------------------------------------------------------------------------------------------
Initialize temporary API data creation date and update date 
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_direct_billing adb 
SET 
    adb.created_at = DATE_FORMAT(SUBSTRING_INDEX(adb.api_date, '-', - 1),
            '%Y-%m-%d %T'),
    adb.updated_at = @updated_at
WHERE
    adb.status = 'TEMPORARY';

UPDATE api_master_account ama 
SET 
    ama.created_at = DATE_FORMAT(SUBSTRING_INDEX(ama.api_date, '-', - 1),
            '%Y-%m-%d %T'),
    ama.updated_at = @updated_at
WHERE
    ama.status = 'TEMPORARY';

/*-----------------------------------------------------------------------------------------------------------------------------------
Check if temporary API data exists in different types of APIs
Temporary data checked to all data regardless of its posting and charge type
Comparing data status is not deleted
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_direct_billing adb
        JOIN
    api_master_account ama ON adb.package_number = ama.package_number
        AND adb.short_code = ama.short_code
        AND ama.status <> 'DELETED' 
SET 
    adb.is_in_master_account = 1
WHERE
    adb.status = 'TEMPORARY';
    
UPDATE api_master_account ama
        JOIN
    api_direct_billing adb ON ama.package_number = adb.package_number
        AND ama.short_code = adb.short_code
        AND adb.status <> 'DELETED' 
SET 
    ama.is_in_direct_billing = 1
WHERE
    ama.status = 'TEMPORARY';
    
/*-----------------------------------------------------------------------------------------------------------------------------------
Check for duplicate API data entries
Comparing data status is not deleted
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_direct_billing adb1
        JOIN
    api_direct_billing adb2 ON adb1.package_number = adb2.package_number
        AND adb1.short_code = adb2.short_code
        AND adb1.posting_type = adb2.posting_type
        AND adb1.charge_type = adb2.charge_type
        AND adb1.id_api_direct_billing <> adb2.id_api_direct_billing
        AND adb2.status <> 'DELETED' 
SET 
    adb1.status = 'DUPLICATE'
WHERE
    adb1.status = 'TEMPORARY';
    
UPDATE api_master_account ama1
        JOIN
    api_master_account ama2 ON ama1.package_number = ama2.package_number
        AND ama1.short_code = ama2.short_code
        AND ama1.posting_type = ama2.posting_type
        AND ama1.charge_type = ama2.charge_type
        AND ama1.id_api_master_account <> ama2.id_api_master_account
        AND ama2.status <> 'DELETED' 
SET 
    ama1.status = 'DUPLICATE'
WHERE
    ama1.status = 'TEMPORARY';
    
/*-----------------------------------------------------------------------------------------------------------------------------------
Check reference for temporary reversal and adjustment API data
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_direct_billing adb1
        LEFT JOIN
    api_direct_billing adb2 ON adb1.package_number = adb2.package_number
        AND adb1.short_code = adb2.short_code
        AND adb1.id_api_direct_billing <> adb2.id_api_direct_billing
        AND adb2.charge_type = 'INCOMING'
        AND adb2.status <> 'DELETED' 
SET 
    adb1.id_api_direct_billing_reference = adb2.id_api_direct_billing,
    adb1.status = CASE
        WHEN adb2.id_api_direct_billing IS NOT NULL THEN adb1.status
        ELSE 'NO_REFERENCE'
    END
WHERE
    adb1.status = 'TEMPORARY'
        AND adb1.posting_type IN ('REVERSAL' , 'ADJUSTMENT');

UPDATE api_master_account ama1
        LEFT JOIN
    api_master_account ama2 ON ama1.package_number = ama2.package_number
        AND ama1.short_code = ama2.short_code
        AND ama1.id_api_master_account <> ama2.id_api_master_account
        AND ama2.charge_type = 'INCOMING'
        AND ama2.status <> 'DELETED' 
SET 
    ama1.id_api_master_account_reference = ama2.id_api_master_account,
    ama1.status = CASE
        WHEN ama2.id_api_master_account IS NOT NULL THEN ama1.status
        ELSE 'NO_REFERENCE'
    END
WHERE
    ama1.status = 'TEMPORARY'
        AND ama1.posting_type IN ('REVERSAL' , 'ADJUSTMENT');

/*-----------------------------------------------------------------------------------------------------------------------------------
Complete missing fields from ANON DB data extract
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_direct_billing adb
        JOIN
    anondb_extract ae ON adb.package_number = ae.package_number
        AND adb.short_code = ae.short_code 
SET 
    adb.id_package_dispatching = ae.id_package_dispatching,
    adb.bob_id_supplier = ae.bob_id_supplier,
    adb.weight_source = 'Direct Billing API',
    adb.delivered_date = ae.delivered_date,
    adb.status = CASE
        WHEN ae.id_package_dispatching IS NULL THEN 'INCOMPLETE'
        WHEN ae.bob_id_supplier IS NULL THEN 'INCOMPLETE'
        WHEN ae.delivered_date IS NULL THEN 'INCOMPLETE'
        ELSE 'COMPLETE'
    END
WHERE
    adb.status IN ('TEMPORARY' , 'NA', 'INCOMPLETE');
    
UPDATE api_master_account ama
        JOIN
    anondb_extract ae ON ama.package_number = ae.package_number
        AND ama.short_code = ae.short_code 
SET 
    ama.id_package_dispatching = ae.id_package_dispatching,
    ama.bob_id_supplier = ae.bob_id_supplier,
    ama.delivered_date = ae.delivered_date,
    ama.status = CASE
        WHEN ae.id_package_dispatching IS NULL THEN 'INCOMPLETE'
        WHEN ae.bob_id_supplier IS NULL THEN 'INCOMPLETE'
        WHEN ae.delivered_date IS NULL THEN 'INCOMPLETE'
        ELSE 'COMPLETE'
    END
WHERE
    ama.status IN ('TEMPORARY' , 'NA', 'INCOMPLETE');

/*-----------------------------------------------------------------------------------------------------------------------------------
Set status to NA for all API data not found in ANON DB extract
-----------------------------------------------------------------------------------------------------------------------------------*/
    
UPDATE api_direct_billing adb 
SET 
    adb.status = 'NA'
WHERE
    adb.status = 'TEMPORARY';

UPDATE api_master_account ama 
SET 
    ama.status = 'NA'
WHERE
    ama.status = 'TEMPORARY';
    
/*-----------------------------------------------------------------------------------------------------------------------------------
Data setup completed
-----------------------------------------------------------------------------------------------------------------------------------*/
    
SET SQL_SAFE_UPDATES = 1;