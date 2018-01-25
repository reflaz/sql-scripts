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
    til.payment_flat_cost = - IFNULL(mpc.flat_rate, 0) * (IFNULL(til.paid_price, 0) + IFNULL(til.shipping_amount, 0) + IFNULL(til.shipping_surcharge, 0)) / til.payment_value,
    til.payment_mdr_cost = - IFNULL(mpc.mdr_rate, 0) * (IFNULL(til.paid_price, 0) + IFNULL(til.shipping_amount, 0) + IFNULL(til.shipping_surcharge, 0)),
    til.payment_ipp_cost = - IFNULL(mpc.ipp_rate, 0) * (IFNULL(til.paid_price, 0) + IFNULL(til.shipping_amount, 0) + IFNULL(til.shipping_surcharge, 0)),
    til.weight = IFNULL(til.config_weight, 0),
    til.volumetric_weight = IFNULL(til.config_length * til.config_width * til.config_height / 6000, 0),
    til.item_weight_seller = GREATEST(IFNULL(til.config_weight, 0), IFNULL(til.config_length * til.config_width * til.config_height / 6000, 0)),
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
        WHEN end_date < start_date OR end_date IS NULL THEN '9999-12-31 23:59:59'
        ELSE DATE_FORMAT(end_date, '%Y-%m-%d 23:59:59')
    END;

/*-----------------------------------------------------------------------------------------------------------------------------------
Initialize temporary API data creation date and update date 
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data
SET 
    amount = ABS(IFNULL(amount, 0)) * - 1,
    discount = ABS(IFNULL(discount, 0)),
    tax_amount = ABS(IFNULL(tax_amount, 0)) * - 1,
    total_amount = ABS(IFNULL(total_amount, 0)) * - 1,
    created_at = DATE_FORMAT(SUBSTRING_INDEX(api_date, '-', - 1), '%Y-%m-%d %T'),
    updated_at = @updated_at
WHERE
    (status IS NULL
		OR status NOT IN ('ACTIVE', 'DELETED', 'API_TYPE_CONFLICT', 'REVERSED'))
		AND charge_type NOT IN ('SELLER FEE');

UPDATE api_data
SET 
    amount = ABS(IFNULL(amount, 0)),
    discount = ABS(IFNULL(discount, 0)) * - 1,
    tax_amount = ABS(IFNULL(tax_amount, 0)),
    total_amount = ABS(IFNULL(total_amount, 0)),
    created_at = DATE_FORMAT(SUBSTRING_INDEX(api_date, '-', - 1), '%Y-%m-%d %T'),
    updated_at = @updated_at
WHERE
    (status IS NULL
		OR status NOT IN ('ACTIVE', 'DELETED', 'API_TYPE_CONFLICT', 'REVERSED'))
		AND charge_type IN ('SELLER FEE');

/*-----------------------------------------------------------------------------------------------------------------------------------
Check if temporary API data exists in different types of APIs
Temporary data checked to all data regardless of its posting and charge type
Comparing data status is not 'DELETED'
If data exists in Other API, then set status to API_TYPE_CONFLICT
This one is for MA only
Exclude Retail APIs in checking, assuming MA API is more reliable
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data adma
        JOIN
    api_data addb ON adma.package_number = addb.package_number
        AND IFNULL(adma.short_code, 'short_code') = COALESCE(addb.short_code, adma.short_code, 'short_code')
        AND adma.is_actual = addb.is_actual
        AND addb.fk_api_type NOT IN (10002, 20001)
        AND addb.status NOT IN ('DELETED', 'NO_REFERENCE', 'API_TYPE_CONFLICT', 'NO_DELIVERY_DETAILS', 'REVERSED')
SET 
    adma.status = 'API_TYPE_CONFLICT'
WHERE
    adma.status IN ('TEMPORARY' , 'API_TYPE_CONFLICT')
		AND adma.fk_api_type = 10002;

UPDATE api_data addb
        JOIN
    api_data adma ON addb.package_number = adma.package_number
        AND IFNULL(addb.short_code, 'short_code') = COALESCE(adma.short_code, adma.short_code, 'short_code')
        AND addb.is_actual = adma.is_actual
        AND adma.fk_api_type = 10002
        AND adma.status NOT IN ('DELETED', 'NO_REFERENCE', 'API_TYPE_CONFLICT', 'NO_DELIVERY_DETAILS', 'REVERSED')
SET 
    adma.status = 'API_TYPE_CONFLICT'
WHERE
    addb.status IN ('TEMPORARY')
		AND addb.fk_api_type NOT IN (10002, 20001);

/*-----------------------------------------------------------------------------------------------------------------------------------
Check if temporary API data exists in different types of APIs
Temporary data checked to all data regardless of its posting and charge type
Comparing data status is not 'DELETED'
If data exists in Other API, then set status to API_TYPE_CONFLICT
This one is for Retail only
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data adma
        JOIN
    api_data addb ON adma.package_number = addb.package_number
        AND IFNULL(adma.short_code, 'short_code') = COALESCE(addb.short_code, adma.short_code, 'short_code')
        AND adma.is_actual = addb.is_actual
        AND addb.fk_api_type NOT IN (20001)
        AND addb.status NOT IN ('DELETED', 'NO_REFERENCE', 'API_TYPE_CONFLICT', 'NO_DELIVERY_DETAILS', 'REVERSED')
SET 
    adma.status = 'API_TYPE_CONFLICT'
WHERE
    adma.status IN ('TEMPORARY' , 'API_TYPE_CONFLICT')
		AND adma.fk_api_type = 20001;

UPDATE api_data addb
        JOIN
    api_data adma ON addb.package_number = adma.package_number
        AND IFNULL(addb.short_code, 'short_code') = COALESCE(adma.short_code, adma.short_code, 'short_code')
        AND addb.is_actual = adma.is_actual
        AND adma.fk_api_type = 20001
        AND adma.status NOT IN ('DELETED', 'NO_REFERENCE', 'API_TYPE_CONFLICT', 'NO_DELIVERY_DETAILS', 'REVERSED')
SET 
    adma.status = 'API_TYPE_CONFLICT'
WHERE
    addb.status IN ('TEMPORARY')
		AND addb.fk_api_type NOT IN (20001);

/*-----------------------------------------------------------------------------------------------------------------------------------
Check for duplicate API data entries
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data ad1
        JOIN
    api_data ad2 ON ad1.package_number = ad2.package_number
        AND IFNULL(ad1.short_code, 'short_code') = COALESCE(ad2.short_code, ad1.short_code, 'short_code')
        AND ad1.fk_api_type = ad2.fk_api_type
        AND ad1.posting_type = ad2.posting_type
        AND ad1.charge_type = ad2.charge_type
        AND ad1.is_actual = ad2.is_actual
        AND ad1.id_api_data <> ad2.id_api_data
        AND ad2.status NOT IN ('DELETED', 'NO_REFERENCE', 'API_TYPE_CONFLICT', 'NO_DELIVERY_DETAILS', 'REVERSED')
SET
    ad1.status = 'DUPLICATE'
WHERE
    ad1.status IN ('TEMPORARY' , 'DUPLICATE');

/*-----------------------------------------------------------------------------------------------------------------------------------
Check delivery referrence
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data ad1
        LEFT JOIN
    api_data ad2 ON ad1.package_number = ad2.package_number
        AND IFNULL(ad1.short_code, 'short_code') = COALESCE(ad2.short_code, ad1.short_code, 'short_code')
        AND ad1.fk_api_type = ad2.fk_api_type
        AND ad1.id_api_data <> ad2.id_api_data
        AND ad2.posting_type = 'INCOMING'
        AND ad2.charge_type IN ('DELIVERY' , 'FAILED DELIVERY')
        AND ad2.status NOT IN ('DELETED', 'NO_REFERENCE', 'API_TYPE_CONFLICT', 'NO_DELIVERY_DETAILS', 'REVERSED')
SET 
    ad1.status = CASE
        WHEN ad2.id_api_data IS NOT NULL THEN ad1.status
        ELSE 'NO_DELIVERY_DETAILS'
    END
WHERE
    ad1.status IN ('TEMPORARY', 'NO_DELIVERY_DETAILS')
        AND ad1.charge_type IN ('PICKUP' , 'COD', 'INSURANCE');

/*-----------------------------------------------------------------------------------------------------------------------------------
Check reference for reversal and adjustment API data
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data ad1
        LEFT JOIN
    api_data ad2 ON ad1.package_number = ad2.package_number
        AND IFNULL(ad1.short_code, 'short_code') = COALESCE(ad2.short_code, ad1.short_code, 'short_code')
        AND ad1.fk_api_type = ad2.fk_api_type
        AND ad1.charge_type = ad2.charge_type
        AND ad1.id_api_data <> ad2.id_api_data
        AND ad2.posting_type = 'INCOMING'
        AND ad2.status NOT IN ('DELETED', 'NO_REFERENCE', 'API_TYPE_CONFLICT', 'NO_DELIVERY_DETAILS', 'REVERSED')
SET 
    ad1.id_api_data_reference = ad2.id_api_data,
    ad1.status = CASE
        WHEN ad2.id_api_data IS NOT NULL THEN ad1.status
        ELSE 'NO_REFERENCE'
    END
WHERE
    ad1.status IN ('TEMPORARY' , 'NO_REFERENCE')
        AND ad1.posting_type IN ('REVERSAL' , 'ADJUSTMENT');

/*-----------------------------------------------------------------------------------------------------------------------------------
Complete missing API fields from ANON DB data extract
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_item_level til
        JOIN
    api_data ad ON til.package_number = ad.package_number
        AND IFNULL(til.short_code, 'short_code') = COALESCE(ad.short_code, til.short_code, 'short_code')
        AND til.is_marketplace = ad.is_marketplace
SET 
    til.fk_api_type = CASE
        WHEN til.id_package_dispatching IS NOT NULL AND til.bob_id_supplier IS NOT NULL THEN ad.fk_api_type
        ELSE 0
    END,
    ad.id_package_dispatching = til.id_package_dispatching,
    ad.bob_id_supplier = til.bob_id_supplier,
    ad.dfd_date = IFNULL(til.delivered_date, til.failed_delivery_date),
    ad.status = CASE
        WHEN til.id_package_dispatching IS NULL THEN 'PACKAGE_NOT_FOUND'
        WHEN til.bob_id_supplier IS NULL THEN 'SELLER_NOT_FOUND'
        WHEN til.delivered_date IS NULL AND til.failed_delivery_date IS NULL THEN 'NO_DFD_DATE'
        WHEN IFNULL(ad.total_amount, 0) = 0 THEN 'INCOMPLETE'
        ELSE 'COMPLETE'
    END
WHERE
    ad.status NOT IN ('DELETED', 'NO_REFERENCE', 'API_TYPE_CONFLICT', 'NO_DELIVERY_DETAILS', 'REVERSED');

/*-----------------------------------------------------------------------------------------------------------------------------------
Set status to NA for all API data not found in ANON DB extract
-----------------------------------------------------------------------------------------------------------------------------------*/
    
UPDATE api_data
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