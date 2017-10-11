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
SELECT @updated_at;

/*-----------------------------------------------------------------------------------------------------------------------------------
Initialize ANON DB extract temporary data
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_item_level 
SET 
    payment_flat_cost_rate = NULL,
    payment_cost_mdr_rate = NULL,
    payment_cost_ipp_rate = NULL,
    customer_charge_pct = NULL,
    payment_flat_cost = NULL,
    payment_cost_mdr = NULL,
    payment_cost_ipp = NULL,
    api_type = 0,
    shipment_scheme = NULL,
    campaign = NULL,
    weight = IFNULL(config_weight, 0),
    volumetric_weight = IFNULL(config_length * config_width * config_height / 6000,
            0),
    item_weight_seller = GREATEST(IFNULL(config_weight, 0),
            IFNULL(config_length * config_width * config_height / 6000,
                    0)),
    item_weight_seller_flag = 0,
    rounding_seller = NULL,
    formula_weight_seller = NULL,
    chargeable_weight_seller = NULL,
    seller_flat_charge_rate = NULL,
    seller_charge_rate = NULL,
    insurance_rate_seller = NULL,
    insurance_vat_rate_seller = NULL,
    weight_seller_pct = NULL,
    seller_flat_charge = NULL,
    seller_charge = NULL,
    insurance_seller = NULL,
    insurance_vat_seller = NULL,
    rate_card_scheme = NULL,
    rounding_3pl = NULL,
    formula_weight_3pl = NULL,
    chargeable_weight_3pl = NULL,
    pickup_cost_rate = NULL,
    pickup_cost_discount_rate = NULL,
    pickup_cost_vat_rate = NULL,
    delivery_flat_cost_rate = NULL,
    delivery_cost_rate = NULL,
    delivery_cost_discount_rate = NULL,
    delivery_cost_vat_rate = NULL,
    insurance_rate_3pl = NULL,
    insurance_vat_rate_3pl = NULL,
    weight_3pl_pct = NULL,
    pickup_cost = NULL,
    pickup_cost_discount = NULL,
    pickup_cost_vat = NULL,
    delivery_flat_cost = NULL,
    delivery_cost = NULL,
    delivery_cost_discount = NULL,
    delivery_cost_vat = NULL,
    insurance_3pl = NULL,
    insurance_vat_3pl = NULL,
    total_customer_charge = NULL,
    total_seller_charge = NULL,
    total_pickup_cost = NULL,
    total_delivery_cost = NULL,
    total_failed_delivery_cost = NULL,
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

UPDATE api_data_direct_billing 
SET 
    amount = ABS(amount) * - 1,
    tax_amount = ABS(tax_amount) * - 1,
    total_amount = ABS(total_amount) * - 1,
    status = CASE
        WHEN IFNULL(formula_weight, 0) = 0 THEN 'INCOMPLETE'
        WHEN IFNULL(total_amount, 0) = 0 THEN 'INCOMPLETE'
        ELSE status
    END,
    created_at = DATE_FORMAT(SUBSTRING_INDEX(api_date, '-', - 1),
            '%Y-%m-%d %T'),
    updated_at = @updated_at
WHERE
    status IN ('TEMPORARY' , 'NA', 'INCOMPLETE', 'COMPLETE');

UPDATE api_data_master_account 
SET 
    amount = ABS(amount) * - 1,
    tax_amount = ABS(tax_amount) * - 1,
    total_amount = ABS(total_amount) * - 1,
    status = CASE
        WHEN IFNULL(formula_weight, 0) = 0 THEN 'INCOMPLETE'
        WHEN IFNULL(total_amount, 0) = 0 THEN 'INCOMPLETE'
        ELSE status
    END,
    created_at = DATE_FORMAT(SUBSTRING_INDEX(api_date, '-', - 1),
            '%Y-%m-%d %T'),
    updated_at = @updated_at
WHERE
    status IN ('TEMPORARY' , 'NA', 'INCOMPLETE', 'COMPLETE');

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

UPDATE tmp_item_level til
        JOIN
    api_data_direct_billing addb ON til.package_number = addb.package_number
        AND til.short_code = addb.short_code 
SET 
    til.api_type = CASE
        WHEN
            til.id_package_dispatching IS NOT NULL
                AND til.bob_id_supplier IS NOT NULL
                AND (til.delivered_date IS NOT NULL
                OR til.failed_delivery_date IS NOT NULL)
                AND IFNULL(addb.formula_weight, 0) <> 0
				AND IFNULL(addb.total_amount, 0) <> 0
        THEN
            1
        ELSE 0
    END,
    addb.id_package_dispatching = til.id_package_dispatching,
    addb.bob_id_supplier = til.bob_id_supplier,
    addb.weight_source = 'Direct Billing API',
    addb.dfd_date = IFNULL(til.delivered_date,
            til.failed_delivery_date),
    addb.status = CASE
        WHEN til.id_package_dispatching IS NULL THEN 'INCOMPLETE'
        WHEN til.bob_id_supplier IS NULL THEN 'INCOMPLETE'
        WHEN
            til.delivered_date IS NULL
                AND til.failed_delivery_date IS NULL
        THEN
            'INCOMPLETE'
        WHEN IFNULL(addb.formula_weight, 0) = 0 THEN 'INCOMPLETE'
        WHEN IFNULL(addb.total_amount, 0) = 0 THEN 'INCOMPLETE'
        ELSE 'COMPLETE'
    END
WHERE
    addb.status IN ('TEMPORARY' , 'NA', 'INCOMPLETE', 'COMPLETE', 'ACTIVE');
    
UPDATE tmp_item_level til
        JOIN
    api_data_master_account adma ON til.package_number = adma.package_number
        AND til.short_code = adma.short_code 
SET 
    til.api_type = CASE
        WHEN
            til.id_package_dispatching IS NOT NULL
                AND til.bob_id_supplier IS NOT NULL
                AND (til.delivered_date IS NOT NULL
                OR til.failed_delivery_date IS NOT NULL)
                AND IFNULL(adma.formula_weight, 0) <> 0
				AND IFNULL(adma.total_amount, 0) <> 0
        THEN
            2
        ELSE 0
    END,
    adma.id_package_dispatching = til.id_package_dispatching,
    adma.bob_id_supplier = til.bob_id_supplier,
    adma.dfd_date = IFNULL(til.delivered_date,
            til.failed_delivery_date),
    adma.status = CASE
        WHEN til.id_package_dispatching IS NULL THEN 'INCOMPLETE'
        WHEN til.bob_id_supplier IS NULL THEN 'INCOMPLETE'
        WHEN
            til.delivered_date IS NULL
                AND til.failed_delivery_date IS NULL
        THEN
            'INCOMPLETE'
        WHEN IFNULL(adma.formula_weight, 0) = 0 THEN 'INCOMPLETE'
        WHEN IFNULL(adma.total_amount, 0) = 0 THEN 'INCOMPLETE'
        ELSE 'COMPLETE'
    END
WHERE
    adma.status IN ('TEMPORARY' , 'NA', 'INCOMPLETE', 'COMPLETE', 'ACTIVE');

/*-----------------------------------------------------------------------------------------------------------------------------------
Set status to NA for all API data not found in ANON DB extract
-----------------------------------------------------------------------------------------------------------------------------------*/
    
UPDATE api_data_direct_billing 
SET 
    status = 'NA'
WHERE
    status = 'TEMPORARY';

UPDATE api_data_master_account 
SET 
    status = 'NA'
WHERE
    status = 'TEMPORARY';
    
/*-----------------------------------------------------------------------------------------------------------------------------------
Data setup completed
-----------------------------------------------------------------------------------------------------------------------------------*/

SET SQL_SAFE_UPDATES = 1;