/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Threshold Tracker
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-06-05';
SET @extractend = '2017-06-12';-- This MUST be D + 1

SELECT 
    threshold_order,
    SUM(unit_price) 'total_unit_price',
    SUM(paid_price) 'total_paid_price',
    SUM(nmv) 'nmv',
    COUNT(DISTINCT order_nr) 'total_so',
    COUNT(DISTINCT id_package_dispatching) 'total_pck',
    COUNT(bob_id_sales_order_item) 'total_soi',
    SUM(unit_price) / COUNT(DISTINCT order_nr) 'aov',
    SUM(shipping_surcharge_temp) 'total_shipping_surcharge',
    SUM(shipping_amount_temp) 'total_shipping_amount',
    - SUM(total_delivery_cost_item) 'total_delivery_cost',
    SUM(total_shipment_fee_mp_seller_item) 'total_shipment_fee_mp_seller',
    SUM(shipping_surcharge_temp) + SUM(shipping_amount_temp) + SUM(total_shipment_fee_mp_seller_item) - SUM(total_delivery_cost_item) 'net_subsidy'
FROM
    (SELECT 
        ac.*,
            CASE
                WHEN ac.tax_class = 'international' THEN 'CB'
                WHEN order_value < 30000 THEN '30000'
                WHEN order_value < 50000 THEN '50000'
                WHEN order_value < 75000 THEN '75000'
                WHEN order_value < 100000 THEN '100000'
                WHEN order_value < 150000 THEN '150000'
                WHEN order_value < 200000 THEN '200000'
                WHEN order_value < 250000 THEN '250000'
                WHEN order_value < 300000 THEN '300000'
                WHEN order_value < 350000 THEN '350000'
                WHEN order_value < 400000 THEN '400000'
                WHEN order_value < 500000 THEN '500000'
                ELSE '>= 500000'
            END 'threshold_order',
            CASE
                WHEN ac.is_marketplace = 0 THEN IFNULL(ac.shipping_surcharge, 0) / 1.1
                ELSE IFNULL(ac.shipping_surcharge, 0)
            END 'shipping_surcharge_temp',
            CASE
                WHEN ac.is_marketplace = 0 THEN IFNULL(ac.shipping_amount, 0) / 1.1
                ELSE IFNULL(ac.shipping_amount, 0)
            END 'shipping_amount_temp',
            IFNULL(ac.paid_price / 1.1, 0) + IFNULL(ac.shipping_surcharge / 1.1, 0) + IFNULL(ac.shipping_amount / 1.1, 0) + IF(ac.coupon_type <> 'coupon', IFNULL(ac.coupon_money_value / 1.1, 0), 0) 'nmv',
            CASE
                WHEN ac.tax_class = 'international' THEN 'CB'
                ELSE 'OTHER'
            END 'bu'
    FROM
        scglv3.anondb_calculate ac
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.chargeable_weight_3pl / qty <= 400
            AND ac.shipment_scheme IN ('CROSS BORDER' , 'RETAIL', 'FBL', 'DIRECT BILLING', 'MASTER ACCOUNT')) ac