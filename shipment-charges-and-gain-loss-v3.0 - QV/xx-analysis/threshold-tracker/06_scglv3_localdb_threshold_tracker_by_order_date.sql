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

USE scglv3_qv;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-07-04';
SET @extractend = '2017-07-10';-- This MUST be D + 1

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
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN shipping_amount + shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass',
            CASE
                WHEN ac.tax_class = 'international' THEN 'CB'
                ELSE sfrc.value_threshold
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
        anondb_calculate ac
    LEFT JOIN shipping_fee_rate_card sfrc ON ac.id_district = sfrc.destination_zone
        AND sfrc.leadtime = 'Standard'
        AND ac.origin = sfrc.origin
        AND sfrc.charging_level = 'Source'
        AND sfrc.threshold_level = 'Source'
        AND is_live = 1
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.shipment_scheme IN ('CROSS BORDER' , 'RETAIL', 'FBL', 'DIRECT BILLING', 'MASTER ACCOUNT')
    HAVING pass = 1) ac
GROUP BY threshold_order