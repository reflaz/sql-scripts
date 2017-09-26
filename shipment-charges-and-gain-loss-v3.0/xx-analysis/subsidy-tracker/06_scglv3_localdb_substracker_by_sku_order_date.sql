/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Subsidy Tracker by SKU
 
Prepared by		: Ryan Disastra
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
				  - Fill the SKU
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-08-01';
SET @extractend = '2017-09-01';-- This MUST be D + 1

SELECT 
    sku,
    SUM(fin.unit_price) 'total_unit_price',
    SUM(fin.paid_price) 'total_paid_price',
    SUM(fin.nmv) 'nmv',
    COUNT(DISTINCT fin.order_nr) 'total_so',
    COUNT(DISTINCT fin.id_package_dispatching) 'total_pck',
    COUNT(fin.qty) 'total_soi',
    SUM(fin.unit_price) / COUNT(DISTINCT fin.order_nr) 'aov',
    SUM(fin.shipping_surcharge_temp) 'total_shipping_surcharge',
    SUM(fin.shipping_amount_temp) 'total_shipping_amount',
    SUM(fin.total_delivery_cost_item) 'total_delivery_cost',
    SUM(fin.total_shipment_fee_mp_seller_item) 'total_shipment_fee_mp_seller',
    SUM(fin.shipping_surcharge_temp) + SUM(fin.shipping_amount_temp) + SUM(fin.total_shipment_fee_mp_seller_item) + SUM(fin.total_delivery_cost_item) 'net_subsidy'
FROM
    (SELECT 
        ac.order_nr,
            ac.id_package_dispatching,
            ac.sku 'sku',
            ac.bob_id_sales_order_item 'qty',
            ac.order_value,
            ac.unit_price,
            ac.paid_price,
            ac.total_shipment_fee_mp_seller_item,
            ac.total_delivery_cost_item,
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN ABS(total_delivery_cost_item / unit_price) > 5 THEN 0
                WHEN shipping_amount + shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_surcharge, 0) / 1.1
                ELSE IFNULL(shipping_surcharge, 0)
            END 'shipping_surcharge_temp',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_amount, 0) / 1.1
                ELSE IFNULL(shipping_amount, 0)
            END 'shipping_amount_temp',
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv'
    FROM
        anondb_calculate ac
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.shipment_scheme IN ('RETAIL' , 'FBL', 'DIRECT BILLING', 'MASTER ACCOUNT')
            AND ac.sku IN ('')
    HAVING pass = 1) fin
GROUP BY sku