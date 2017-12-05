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

USE refrain_live;

SET SQL_SAFE_UPDATES = 0;

/*-----------------------------------------------------------------------------------------------------------------------------------
Set data update timestamp
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @updated_at = NOW();
SELECT @updated_at;

/*-----------------------------------------------------------------------------------------------------------------------------------
Starting Transaction
-----------------------------------------------------------------------------------------------------------------------------------*/

START TRANSACTION;

/*-----------------------------------------------------------------------------------------------------------------------------------
Initialize ANON DB extract temporary data
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_item_level til
		LEFT JOIN
	map_payment_cost mpc ON til.payment_method = IFNULL(mpc.payment_method, til.payment_method)
		AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mpc.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mpc.end_date
SET
	til.payment_flat_cost_rate = mpc.flat_rate,
    til.payment_mdr_cost_rate = mpc.mdr_rate,
    til.payment_ipp_cost_rate = mpc.ipp_rate,
    til.payment_flat_cost = IFNULL(mpc.flat_rate, 0) * (IFNULL(til.paid_price, 0) + IFNULL(til.shipping_amount, 0) + IFNULL(til.shipping_surcharge, 0)) / til.payment_value,
    til.payment_mdr_cost = IFNULL(mpc.mdr_rate, 0) * (IFNULL(til.paid_price, 0) + IFNULL(til.shipping_amount, 0) + IFNULL(til.shipping_surcharge, 0)),
    til.payment_ipp_cost = IFNULL(mpc.ipp_rate, 0) * (IFNULL(til.paid_price, 0) + IFNULL(til.shipping_amount, 0) + IFNULL(til.shipping_surcharge, 0)),
    til.weight = IFNULL(til.config_weight, 0),
    til.volumetric_weight = IFNULL(til.config_length * til.config_width * til.config_height / 6000,
            0),
    til.item_weight_seller = GREATEST(IFNULL(til.config_weight, 0),
            IFNULL(til.config_length * til.config_width * til.config_height / 6000,
                    0)),
    til.total_customer_charge = (IFNULL(til.shipping_amount, 0) + IFNULL(til.shipping_surcharge, 0)) / IF(til.is_marketplace = 1, 1, 1.1),
    til.created_at = IFNULL(til.created_at, @updated_at),
    til.updated_at = @updated_at
WHERE
    til.created_at IS NULL;

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
    amount = ABS(IFNULL(amount, 0)) * - 1,
    discount = ABS(IFNULL(discount, 0)),
    tax_amount = ABS(IFNULL(tax_amount, 0)) * - 1,
    total_amount = ABS(IFNULL(total_amount, 0)) * - 1,
    created_at = DATE_FORMAT(SUBSTRING_INDEX(api_date, '-', - 1),
            '%Y-%m-%d %T'),
    updated_at = @updated_at
WHERE
    status NOT IN ('ACTIVE', 'DELETED');

UPDATE api_data_master_account 
SET 
    amount = ABS(IFNULL(amount, 0)) * - 1,
    discount = ABS(IFNULL(discount, 0)),
    tax_amount = ABS(IFNULL(tax_amount, 0)) * - 1,
    total_amount = ABS(IFNULL(total_amount, 0)) * - 1,
    created_at = DATE_FORMAT(SUBSTRING_INDEX(api_date, '-', - 1),
            '%Y-%m-%d %T'),
    updated_at = @updated_at
WHERE
    status NOT IN ('ACTIVE', 'DELETED');

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

UPDATE api_data_direct_billing addb
        JOIN
    api_data_master_account adma ON addb.package_number = adma.package_number
        AND addb.short_code = adma.short_code
        AND adma.status <> 'DELETED' 
SET 
    adma.status = 'API_TYPE_CONFLICT'
WHERE
    addb.status IN ('TEMPORARY');
    
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
Check delivery referrence
Comparing data status is not 'DELETED'
-----------------------------------------------------------------------------------------------------------------------------------*/
UPDATE api_data_direct_billing addb1
        LEFT JOIN
    api_data_direct_billing addb2 ON addb1.package_number = addb2.package_number
        AND addb1.short_code = addb2.short_code
        AND addb1.id_api_direct_billing <> addb2.id_api_direct_billing
        AND addb2.posting_type = 'INCOMING'
        AND addb2.charge_type IN ('DELIVERY' , 'FAILED DELIVERY')
        AND addb2.status <> 'DELETED' 
SET 
    addb1.status = CASE
        WHEN addb2.id_api_direct_billing IS NOT NULL THEN addb1.status
        ELSE 'NO_DELIVERY_DETAILS'
    END
WHERE
    addb1.status IN ('TEMPORARY' , 'INCOMPLETE')
        AND addb1.charge_type IN ('PICKUP' , 'COD', 'INSURANCE');

UPDATE api_data_master_account adma1
        LEFT JOIN
    api_data_master_account adma2 ON adma1.package_number = adma2.package_number
        AND adma1.short_code = adma2.short_code
        AND adma1.id_api_master_account <> adma2.id_api_master_account
        AND adma2.posting_type = 'INCOMING'
        AND adma2.charge_type IN ('DELIVERY' , 'FAILED DELIVERY')
        AND adma2.status <> 'DELETED' 
SET 
    adma1.status = CASE
        WHEN adma2.id_api_master_account IS NOT NULL THEN adma1.status
        ELSE 'NO_DELIVERY_DETAILS'
    END
WHERE
    adma1.status IN ('TEMPORARY' , 'INCOMPLETE')
        AND adma1.charge_type IN ('PICKUP' , 'COD', 'INSURANCE');

/*-----------------------------------------------------------------------------------------------------------------------------------
Check reference for temporary reversal and adjustment API data
Comparing data status is not 'DELETED'
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data_direct_billing addb1
        LEFT JOIN
    api_data_direct_billing addb2 ON addb1.package_number = addb2.package_number
        AND addb1.short_code = addb2.short_code
        AND addb1.charge_type = addb2.charge_type
        AND addb1.id_api_direct_billing <> addb2.id_api_direct_billing
        AND addb2.posting_type = 'INCOMING'
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
        AND adma1.charge_type = adma2.charge_type
        AND adma1.id_api_master_account <> adma2.id_api_master_account
        AND adma2.posting_type = 'INCOMING'
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
        WHEN til.id_package_dispatching IS NULL THEN 'PACKAGE_NOT_FOUND'
        WHEN til.bob_id_supplier IS NULL THEN 'SELLER_NOT_FOUND'
        WHEN
            til.delivered_date IS NULL
                AND til.failed_delivery_date IS NULL
        THEN
            'NO_DFD_DATE'
        WHEN IFNULL(addb.total_amount, 0) = 0 THEN 'INCOMPLETE'
        ELSE 'COMPLETE'
    END
WHERE
    addb.status IN ('TEMPORARY' , 'NA',
        'INCOMPLETE',
        'COMPLETE',
        'ACTIVE',
        'PACKAGE_NOT_FOUND',
        'SELLER_NOT_FOUND',
        'NO_DFD_DATE');
    
UPDATE tmp_item_level til
        JOIN
    api_data_master_account adma ON til.package_number = adma.package_number
        AND til.short_code = adma.short_code 
SET 
    til.api_type = CASE
        WHEN
            til.id_package_dispatching IS NOT NULL
                AND til.bob_id_supplier IS NOT NULL
        THEN
            2
        ELSE 0
    END,
    adma.id_package_dispatching = til.id_package_dispatching,
    adma.bob_id_supplier = til.bob_id_supplier,
    adma.dfd_date = IFNULL(til.delivered_date,
            til.failed_delivery_date),
    adma.status = CASE
        WHEN til.id_package_dispatching IS NULL THEN 'PACKAGE_NOT_FOUND'
        WHEN til.bob_id_supplier IS NULL THEN 'SELLER_NOT_FOUND'
        WHEN
            til.delivered_date IS NULL
                AND til.failed_delivery_date IS NULL
        THEN
            'NO_DFD_DATE'
        WHEN IFNULL(adma.total_amount, 0) = 0 THEN 'INCOMPLETE'
        ELSE 'COMPLETE'
    END
WHERE
    adma.status IN ('TEMPORARY' , 'NA',
        'INCOMPLETE',
        'COMPLETE',
        'ACTIVE',
        'PACKAGE_NOT_FOUND',
        'SELLER_NOT_FOUND',
        'NO_DFD_DATE');

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
Commit Transaction
-----------------------------------------------------------------------------------------------------------------------------------*/

COMMIT;

/*-----------------------------------------------------------------------------------------------------------------------------------
Data setup completed
-----------------------------------------------------------------------------------------------------------------------------------*/

SET SQL_SAFE_UPDATES = 1;