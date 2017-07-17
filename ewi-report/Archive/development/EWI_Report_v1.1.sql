/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
EWI Report
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2015-08-31';
SET @extractend = '2015-09-07'; -- this must be the day after

SELECT 
    sc_soi.src_id 'sap_item_id',
    oms_soi.bob_id_sales_order_item 'sales_order_item',
    sc_soi.id_sales_order_item 'sc_sales_order_item',
    sc_soi.created_at 'order_date',
    (SELECT 
            name
        FROM
            oms_live.ims_sales_order_item_status
        WHERE
            id_sales_order_item_status = oms_ver.fk_sales_order_item_status) 'payment_verification_status',
    oms_ver.created_at 'payment_verification_date',
    (SELECT 
            name
        FROM
            oms_live.ims_sales_order_item_status
        WHERE
            id_sales_order_item_status = oms_soi.fk_sales_order_item_status) 'item_status',
    oms_shi.updated_at 'shipped_date',
    oms_dlv.real_action_date 'delivered_date',
    oms_dlv.updated_at 'delivered_date_input',
    oms_ret.updated_at 'returned_date',
    sc_soi.unit_price 'unit_price', 
    sc_soi.paid_price 'paid_price',
    oms_soi.shipping_surcharge 'shipping_surcharge',
    IFNULL(SUM(str1.value), 0) 'item_price_credit',
    IFNULL(SUM(str2.value), 0) 'shipping_fee_credit',
    IFNULL(SUM(str4.value), 0) 'commission',
    IFNULL(SUM(str5.value), 0) 'payment_fee',
    IFNULL(SUM(str6.value), 0) 'item_price',
    IFNULL(SUM(str7.value), 0) 'comission_credit',
    IFNULL(SUM(str8.value), 0) 'return_to_seller_fee',
    IFNULL(SUM(str9.value), 0) 'shipping_fee',
    IFNULL(SUM(str10.value), 0) 'other_fee',
    (IFNULL(SUM(str1.value), 0) + IFNULL(SUM(str2.value), 0) + IFNULL(SUM(str4.value), 0) + IFNULL(SUM(str5.value), 0) 
		+ IFNULL(SUM(str6.value), 0) + IFNULL(SUM(str7.value), 0) + IFNULL(SUM(str8.value), 0) + IFNULL(SUM(str9.value), 0) 
        + IFNULL(SUM(str10.value), 0)) 'amount_paid_seller',
    oms_soi.coupon_money_value 'coupon_money_value',
    oms_soi.cart_rule_discount 'cart_rule_discount',
    (IFNULL(SUM(str4.value), 0) + IFNULL(SUM(str5.value), 0)) / 1.1 'gross_commission_income',
    ((IFNULL(SUM(str4.value), 0) + IFNULL(SUM(str5.value), 0)) / 1.1) * 0.1 'vat_out',
    -- zone from oms ?
    sc_tr.created_at 'transaction_date',
    sc_sel.tax_class 'tax_class',
    /*varchar type fields moved to the end of the script to increase performance*/
    sc_so.order_nr 'order_number',
    sc_soi.sku 'sku',
    sc_soi.tracking_code 'awb',
    sc_sp.name 'shipment_provider',
    sc_sel.name 'seller_name',
    sc_so.payment_method 'payment_method',
    CONCAT(sc_ts.start_date, ' - ', sc_ts.end_date) 'time_frame',
    sc_tr.number 'transaction_id',
    sc_lv2.name 'description'
FROM
    (SELECT 
        id_transaction_statement,
            fk_seller,
            start_date,
            end_date,
            created_at,
            number
    FROM
        screport.transaction_statement
    WHERE
		start_date >= STR_TO_DATE(@extractstart, '%Y-%m-%d')
            AND end_date < STR_TO_DATE(@extractend, '%Y-%m-%d')) sc_ts
        INNER JOIN
    (SELECT 
        id_transaction,
			fk_seller,
			fk_transaction_statement,
			created_at,
			ref,
			number
    FROM
        screport.transaction
    WHERE
        created_at >= STR_TO_DATE(@extractstart, '%Y-%m-%d')
            AND created_at < STR_TO_DATE(@extractend, '%Y-%m-%d')
	GROUP BY ref) sc_tr ON sc_ts.id_transaction_statement = sc_tr.fk_transaction_statement
        LEFT JOIN
    screport.transaction str1 ON sc_tr.ref = str1.ref
        AND str1.fk_transaction_type = 13 -- Item Price Credit
        LEFT JOIN
    screport.transaction str2 ON sc_tr.ref = str2.ref
        AND str2.fk_transaction_type = 8 -- Shipping Fee Credit
        LEFT JOIN
    screport.transaction str4 ON sc_tr.ref = str4.ref
        AND str4.fk_transaction_type = 16 -- Commission
        LEFT JOIN
    screport.transaction str5 ON sc_tr.ref = str5.ref
        AND str5.fk_transaction_type = 3 -- Payment Fee
        LEFT JOIN
    screport.transaction str6 ON sc_tr.ref = str6.ref
        AND str6.fk_transaction_type = 14 -- Item Price
        LEFT JOIN
    screport.transaction str7 ON sc_tr.ref = str7.ref
        AND str7.fk_transaction_type = 15 -- Commission Credit
        LEFT JOIN
    screport.transaction str8 ON sc_tr.ref = str8.ref
        AND str8.fk_transaction_type = 26 -- Return to Seller Fee
        LEFT JOIN
    screport.transaction str9 ON sc_tr.ref = str9.ref
        AND str9.fk_transaction_type = 7 -- Shipping Fee
        LEFT JOIN
    screport.transaction str10 ON sc_tr.ref = str10.ref
        AND str10.fk_transaction_type = 20 -- Other Fee
        LEFT JOIN
    screport.sales_order_item sc_soi ON sc_tr.ref = sc_soi.id_sales_order_item
        LEFT JOIN
    screport.sales_order sc_so ON sc_soi.fk_sales_order = sc_so.id_sales_order
        LEFT JOIN
    screport.catalog_product sc_cp ON sc_soi.sku = sc_cp.sku
        AND sc_soi.fk_seller = sc_cp.fk_seller
        LEFT JOIN
    (SELECT 
        id_catalog_category, LEFT(global_identifier, 4) gi
    FROM
        screport.catalog_category) sc_cc ON sc_cp.primary_category = sc_cc.id_catalog_category
        LEFT JOIN
    (SELECT 
        LEFT(global_identifier, 4) gi,
            REPLACE(global_identifier, '0', '') gi1,
            name
    FROM
        screport.catalog_category
    GROUP BY gi
    HAVING MIN(LENGTH(gi1))) sc_lv2 ON sc_cc.gi = sc_lv2.gi
        LEFT JOIN
    screport.shipment_provider sc_sp ON sc_soi.fk_shipment_provider = sc_sp.id_shipment_provider
        LEFT JOIN
    screport.seller sc_sel ON sc_tr.fk_seller = sc_sel.id_seller
        INNER JOIN
    oms_live.ims_sales_order_item oms_soi ON sc_soi.src_id = oms_soi.id_sales_order_item
        AND oms_soi.is_marketplace = 1 -- from marketplace
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history oms_ver ON oms_soi.id_sales_order_item = oms_ver.fk_sales_order_item
		AND oms_ver.id_sales_order_item_status_history = (SELECT 
			MIN(id_sales_order_item_status_history) 
		FROM 
			oms_live.ims_sales_order_item_status_history soish 
        WHERE 
			soish.fk_sales_order_item = oms_soi.id_sales_order_item 
				AND soish.fk_sales_order_item_status = 67) -- Verified
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history oms_shi ON oms_soi.id_sales_order_item = oms_shi.fk_sales_order_item
		AND oms_shi.id_sales_order_item_status_history = (SELECT 
			MIN(id_sales_order_item_status_history) 
		FROM 
			oms_live.ims_sales_order_item_status_history soish 
		WHERE 
			soish.fk_sales_order_item = oms_soi.id_sales_order_item 
				AND soish.fk_sales_order_item_status = 5) -- shipped
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history oms_dlv ON oms_soi.id_sales_order_item = oms_dlv.fk_sales_order_item
		AND oms_dlv.id_sales_order_item_status_history = (SELECT 
			MIN(id_sales_order_item_status_history) 
		FROM 
			oms_live.ims_sales_order_item_status_history soish 
        WHERE 
			soish.fk_sales_order_item = oms_soi.id_sales_order_item 
				AND soish.fk_sales_order_item_status = 27) -- delivered
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history oms_ret ON oms_soi.id_sales_order_item = oms_ret.fk_sales_order_item
		AND oms_ret.id_sales_order_item_status_history = (SELECT 
			MIN(id_sales_order_item_status_history) 
		FROM 
			oms_live.ims_sales_order_item_status_history soish 
		WHERE 
			soish.fk_sales_order_item = oms_soi.id_sales_order_item 
				AND soish.fk_sales_order_item_status = 68) -- returned
WHERE
	oms_dlv.updated_at >= @extractstart
		AND oms_dlv.updated_at < @extractend
GROUP BY sc_soi.id_sales_order_item;