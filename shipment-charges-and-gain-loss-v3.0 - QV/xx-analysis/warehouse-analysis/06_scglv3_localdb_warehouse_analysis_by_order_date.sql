/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Warehouse Analysis

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3_qv;

SET @extractstart = '2016-01-01';
SET @extractend = '2016-07-01';

SELECT 
    city,
    period,
    SUM(unit_price) 'unit_price',
    COUNT(DISTINCT order_nr) 'count_so',
    COUNT(bob_id_sales_order_item) 'qty',
    SUM(nmv) 'nmv',
    SUM(shipping_amount + shipping_surcharge + total_shipment_fee_mp_seller_item + total_delivery_cost_item) 'shipping_subsidy'
FROM
    (SELECT 
        zm.id_city,
            zm.city,
            ac.order_nr,
            ac.bob_id_sales_order_item,
            ac.unit_price,
            IFNULL(ac.paid_price / 1.1, 0) + IFNULL(ac.shipping_surcharge / 1.1, 0) + IFNULL(ac.shipping_amount / 1.1, 0) + IF(ac.coupon_type <> 'coupon', IFNULL(ac.coupon_money_value / 1.1, 0), 0) 'nmv',
            ac.shipping_amount / IF(is_marketplace = 0, 1.1, 1) 'shipping_amount',
            ac.shipping_surcharge / IF(is_marketplace = 0, 1.1, 1) 'shipping_surcharge',
            ac.total_shipment_fee_mp_seller_item,
            ac.total_delivery_cost_item,
            DATE_FORMAT(ac.order_date, '%Y-%m-01') 'period',
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN shipping_amount + shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass'
    FROM
        anondb_calculate ac
    LEFT JOIN zone_mapping zm ON ac.id_district = zm.id_district
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) >= zm.start_date
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) <= zm.end_date
    WHERE
        order_date >= @extractstart
            AND order_date < @extractend
            AND shipment_scheme IN ('DIRECT BILLING' , 'FBL', 'MASTER ACCOUNT', 'RETAIL')
    HAVING pass = 1) ac
GROUP BY id_city , period