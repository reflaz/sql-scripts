/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Data Setup

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE refrain;

SET SQL_SAFE_UPDATES = 0;

/*-----------------------------------------------------------------------------------------------------------------------------------
Set data update timestamp
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @updated_at = NOW();

/*-----------------------------------------------------------------------------------------------------------------------------------
Initialize ANON DB extract temporary data
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_item_level 
SET 
    api_type = 0,
    shipment_scheme = NULL,
    rate_card_scheme = NULL,
    campaign = NULL,
    rounding_seller = NULL,
    rounding_3pl = NULL,
    item_weight_flag = 0,
    package_weight_source = NULL,
    weight = NULL,
    volumetric_weight = NULL,
    package_weight = NULL,
    formula_weight_seller = NULL,
    chargeable_weight_seller = NULL,
    formula_weight_3pl = NULL,
    chargeable_weight_3pl = NULL,
    order_flat_rate = NULL,
    mdr_rate = NULL,
    ipp_rate = NULL,
    seller_flat_charge_rate = NULL,
    seller_charge_rate = NULL,
    insurance_rate_sel = NULL,
    insurance_vat_rate_sel = NULL,
    pickup_cost_rate = NULL,
    pickup_cost_discount_rate = NULL,
    pickup_cost_vat_rate = NULL,
    delivery_flat_cost_rate = NULL,
    delivery_cost_rate = NULL,
    delivery_cost_discount_rate = NULL,
    delivery_cost_vat_rate = NULL,
    insurance_rate_3pl = NULL,
    insurance_vat_rate_3pl = NULL,
    unit_price_pct = NULL,
    customer_charge_pct = NULL,
    weight_seller_pct = NULL,
    weight_3pl_pct = NULL,
    order_flat = NULL,
    mdr = NULL,
    ipp = NULL,
    seller_flat_charge = NULL,
    seller_charge = NULL,
    insurance_seller = NULL,
    insurance_vat_seller = NULL,
    pickup_cost = NULL,
    pickup_cost_discount = NULL,
    pickup_cost_vat = NULL,
    delivery_flat_cost = NULL,
    delivery_cost = NULL,
    delivery_cost_discount = NULL,
    delivery_cost_vat = NULL,
    insurance_3pl = NULL,
    insurance_vat_3pl = NULL,
    created_at = IFNULL(created_at, @updated_at),
    updated_at = @updated_at;

/*-----------------------------------------------------------------------------------------------------------------------------------
Update campaign tracker end date
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE map_campaign_tracker 
SET 
    end_date = CASE
        WHEN
            end_date < start_date
                OR end_date IS NULL
        THEN
            '9999-12-31 23:59:59'
        ELSE DATE_FORMAT(end_date, '%Y-%m-%d 23:59:59')
    END;

/*-----------------------------------------------------------------------------------------------------------------------------------
Initialize temporary API data creation date and update date 
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data_direct_billing addb 
SET 
    addb.created_at = DATE_FORMAT(SUBSTRING_INDEX(addb.api_date, '-', - 1),
            '%Y-%m-%d %T'),
    addb.updated_at = @updated_at
WHERE
    addb.status IN ('TEMPORARY' , 'NA', 'INCOMPLETE');

UPDATE api_data_master_account adma 
SET 
    adma.created_at = DATE_FORMAT(SUBSTRING_INDEX(adma.api_date, '-', - 1),
            '%Y-%m-%d %T'),
    adma.updated_at = @updated_at
WHERE
    adma.status IN ('TEMPORARY' , 'NA', 'INCOMPLETE');

/*-----------------------------------------------------------------------------------------------------------------------------------
Check if temporary API data exists in different types of APIs
Temporary data checked to all data regardless of its posting and charge type
Comparing data status is not 'DELETED'
Only check Master Account data, as Direct Billing data are more reliable
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data_master_account adma
        JOIN
    api_data_direct_billing addb ON adma.package_number = addb.package_number
        AND adma.short_code = addb.short_code
        AND addb.status <> 'DELETED' 
SET 
    adma.status = 'API_TYPE_CONFLICT'
WHERE
    adma.status IN ('TEMPORARY' , 'API_TYPE_CONFLICT');
    
/*-----------------------------------------------------------------------------------------------------------------------------------
Check for duplicate API data entries
Comparing data status is not 'DELETED'
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data_direct_billing addb1
        JOIN
    api_data_direct_billing addb2 ON addb1.package_number = addb2.package_number
        AND addb1.short_code = addb2.short_code
        AND addb1.posting_type = addb2.posting_type
        AND addb1.charge_type = addb2.charge_type
        AND addb1.id_api_direct_billing <> addb2.id_api_direct_billing
        AND addb2.status <> 'DELETED' 
SET 
    addb1.status = 'DUPLICATE'
WHERE
    addb1.status IN ('TEMPORARY' , 'DUPLICATE');
    
UPDATE api_data_master_account adma1
        JOIN
    api_data_master_account adma2 ON adma1.package_number = adma2.package_number
        AND adma1.short_code = adma2.short_code
        AND adma1.posting_type = adma2.posting_type
        AND adma1.charge_type = adma2.charge_type
        AND adma1.id_api_master_account <> adma2.id_api_master_account
        AND adma2.status <> 'DELETED' 
SET 
    adma1.status = 'DUPLICATE'
WHERE
    adma1.status IN ('TEMPORARY' , 'DUPLICATE');
    
/*-----------------------------------------------------------------------------------------------------------------------------------
Check reference for temporary reversal and adjustment API data
Comparing data status is not 'DELETED'
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data_direct_billing addb1
        LEFT JOIN
    api_data_direct_billing addb2 ON addb1.package_number = addb2.package_number
        AND addb1.short_code = addb2.short_code
        AND addb1.id_api_direct_billing <> addb2.id_api_direct_billing
        AND addb2.charge_type = 'INCOMING'
        AND addb2.status <> 'DELETED' 
SET 
    addb1.id_api_direct_billing_reference = addb2.id_api_direct_billing,
    addb1.status = CASE
        WHEN addb2.id_api_direct_billing IS NOT NULL THEN addb1.status
        ELSE 'NO_REFERENCE'
    END
WHERE
    addb1.status IN ('TEMPORARY' , 'NO_REFERENCE')
        AND addb1.posting_type IN ('REVERSAL' , 'ADJUSTMENT');

UPDATE api_data_master_account adma1
        LEFT JOIN
    api_data_master_account adma2 ON adma1.package_number = adma2.package_number
        AND adma1.short_code = adma2.short_code
        AND adma1.id_api_master_account <> adma2.id_api_master_account
        AND adma2.charge_type = 'INCOMING'
        AND adma2.status <> 'DELETED' 
SET 
    adma1.id_api_master_account_reference = adma2.id_api_master_account,
    adma1.status = CASE
        WHEN adma2.id_api_master_account IS NOT NULL THEN adma1.status
        ELSE 'NO_REFERENCE'
    END
WHERE
    adma1.status IN ('TEMPORARY' , 'NO_REFERENCE')
        AND adma1.posting_type IN ('REVERSAL' , 'ADJUSTMENT');

/*-----------------------------------------------------------------------------------------------------------------------------------
Complete missing API fields from ANON DB data extract
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data_direct_billing addb
        JOIN
    tmp_item_level til ON addb.package_number = til.package_number
        AND addb.short_code = til.short_code 
SET 
    til.api_type = 1,
    til.package_weight_source = 'API_DIRECT_BILLING',
    addb.id_package_dispatching = til.id_package_dispatching,
    addb.bob_id_supplier = til.bob_id_supplier,
    addb.weight_source = 'Direct Billing API',
    addb.delivered_date = til.delivered_date,
    addb.status = CASE
        WHEN til.id_package_dispatching IS NULL THEN 'INCOMPLETE'
        WHEN til.bob_id_supplier IS NULL THEN 'INCOMPLETE'
        WHEN til.delivered_date IS NULL THEN 'INCOMPLETE'
        ELSE 'COMPLETE'
    END
WHERE
    addb.status IN ('TEMPORARY' , 'NA', 'INCOMPLETE', 'COMPLETE');
    
UPDATE api_data_master_account adma
        JOIN
    tmp_item_level til ON adma.package_number = til.package_number
        AND adma.short_code = til.short_code 
SET 
    til.api_type = 2,
    til.package_weight_source = 'API_MASTER_ACCOUNT',
    adma.id_package_dispatching = til.id_package_dispatching,
    adma.bob_id_supplier = til.bob_id_supplier,
    adma.delivered_date = til.delivered_date,
    adma.status = CASE
        WHEN til.id_package_dispatching IS NULL THEN 'INCOMPLETE'
        WHEN til.bob_id_supplier IS NULL THEN 'INCOMPLETE'
        WHEN til.delivered_date IS NULL THEN 'INCOMPLETE'
        ELSE 'COMPLETE'
    END
WHERE
    adma.status IN ('TEMPORARY' , 'NA', 'INCOMPLETE', 'COMPLETE');

/*-----------------------------------------------------------------------------------------------------------------------------------
Set status to NA for all API data not found in ANON DB extract
-----------------------------------------------------------------------------------------------------------------------------------*/
    
UPDATE api_data_direct_billing addb 
SET 
    addb.status = 'NA'
WHERE
    addb.status = 'TEMPORARY';

UPDATE api_data_master_account adma 
SET 
    adma.status = 'NA'
WHERE
    adma.status = 'TEMPORARY';
    
/*-----------------------------------------------------------------------------------------------------------------------------------
Data setup completed
-----------------------------------------------------------------------------------------------------------------------------------*/

SET SQL_SAFE_UPDATES = 1;