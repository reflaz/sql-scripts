/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Deffered Revenue
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
				  - Change @statusend to a specific cutoff date
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

/*
	69,	-- ovip
	67,	-- finfer
	9,	-- canceled
    5,	-- shipped
	27,	-- delv
	55,	-- refund pending
	56,	-- refund completed
	57	-- refund reject
*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-01-01';
SET @extractend = '2017-04-01';-- This MUST be D + 1

SET @statusend = '2017-04-01';-- Cutoff date

SELECT 
    *
FROM
    (SELECT 
        *,
            CASE
                WHEN order_verification_in_progress IS NULL THEN 1
                WHEN
                    payment_method = 'CashOnDelivery'
                        AND 'BU' = 'RETAIL'
                THEN
                    IF(shipped < '2016-06-01'
                        AND closed IS NULL
                        AND delivered IS NULL
                        AND refund_completed IS NULL
                        AND refund_reject IS NULL
                        AND replaced IS NULL, 0, 1)
                WHEN
                    payment_method = 'CashOnDelivery'
                        AND 'BU' <> 'RETAIL'
                THEN
                    IF(shipped < '2015-10-01'
                        AND closed IS NULL
                        AND delivered IS NULL
                        AND refund_completed IS NULL
                        AND refund_reject IS NULL
                        AND replaced IS NULL, 0, 1)
                WHEN
                    closed IS NULL AND delivered IS NULL
                        AND refund_completed IS NULL
                        AND refund_reject IS NULL
                        AND replaced IS NULL
                THEN
                    0
                ELSE 1
            END 'passed'
    FROM
        (SELECT 
        CASE
                WHEN soi.is_marketplace = 0 THEN 'RETAIL'
                WHEN sel.tax_class = 0 THEN 'MP'
                WHEN sel.tax_class = 1 THEN 'CB'
            END 'BU',
            soi.order_nr,
            soi.bob_id_sales_order_item,
            soi.payment_method,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.cart_rule_discount,
            soi.coupon_money_value,
            sois.name 'last_status',
            soi.updated_at 'last_status_change',
            soi.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 69, soish.created_at, NULL)) 'order_verification_in_progress',
            MIN(IF(soish.fk_sales_order_item_status = 67, soish.created_at, NULL)) 'finance_verified',
            MIN(IF(soish.fk_sales_order_item_status = 9, soish.created_at, NULL)) 'cancelled',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped',
            MIN(IF(soish.fk_sales_order_item_status = 6, soish.created_at, NULL)) 'closed',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered',
            MIN(IF(soish.fk_sales_order_item_status = 56, soish.created_at, NULL)) 'refund_completed',
            MIN(IF(soish.fk_sales_order_item_status = 57, soish.created_at, NULL)) 'refund_reject',
            MIN(IF(soish.fk_sales_order_item_status = 78, soish.created_at, NULL)) 'replaced',
            sup.name 'seller_name',
            sel.tax_class
    FROM
        (SELECT 
        so.order_nr,
            soi.id_sales_order_item,
            soi.bob_id_sales_order_item,
            so.payment_method,
            soi.fk_sales_order_item_status,
            soi.is_marketplace,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.cart_rule_discount,
            soi.coupon_money_value,
            soi.bob_id_supplier,
            so.created_at,
            soi.updated_at
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND soi.is_marketplace = 0) soi
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (69 , 67, 9, 5, 6, 27, 56, 57, 78)
        AND soish.created_at < @statusend
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller sel ON sup.id_supplier = sel.src_id
    GROUP BY soi.id_sales_order_item
    HAVING order_verification_in_progress IS NOT NULL) result) result
HAVING passed = 0