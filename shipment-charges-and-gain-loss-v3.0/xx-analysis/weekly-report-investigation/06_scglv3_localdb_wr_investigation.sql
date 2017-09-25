/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Subsidy Tracker by City Tier Mapping
 
Prepared by		: Ryan Disastra
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
SET @extractstart = '2017-09-01';
SET @extractend = '2017-09-25';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        bu,
            SUM(CASE
                WHEN is_delivered = 1 THEN 1
                ELSE 0
            END) 'delivered_items',
            SUM(CASE
                WHEN is_not_delivered = 1 THEN 1
                ELSE 0
            END) 'not_delivered_items',
            SUM(CASE
                WHEN bu = 'DIRECT BILLING' AND is_delivered = 1 THEN IFNULL(total_delivery_cost_item, 0)
                WHEN bu = 'MASTER ACCOUNT' AND (is_delivered = 1 OR is_not_delivered = 1) THEN IFNULL(delivery_cost_item, 0) + IFNULL(delivery_cost_discount_item, 0) + IFNULL(delivery_cost_vat_item, 0) + IFNULL(insurance_3pl_item, 0) + IFNULL(insurance_vat_3pl_item, 0) + IFNULL(pickup_cost_item, 0) + IFNULL(pickup_cost_discount_item, 0) + IFNULL(pickup_cost_vat_item, 0)
                WHEN bu = 'RETAIL' AND (is_delivered = 1 OR is_not_delivered = 1) THEN IFNULL(total_delivery_cost_item, 0)
            END) 'outbound',
            SUM(CASE
                WHEN bu = 'DIRECT BILLING' AND is_not_delivered = 1 THEN 0
                WHEN bu = 'MASTER ACCOUNT' AND is_not_delivered = 1 THEN IFNULL(delivery_cost_item, 0) + IFNULL(delivery_cost_discount_item, 0) + IFNULL(delivery_cost_vat_item, 0)
                WHEN bu = 'RETAIL' AND is_not_delivered = 1 THEN IFNULL(delivery_cost_item, 0) + IFNULL(delivery_cost_discount_item, 0) + IFNULL(delivery_cost_vat_item, 0)
            END) 'failed_delivery',
            SUM(CASE
                WHEN bu = 'DIRECT BILLING' AND is_delivered = 1 THEN IFNULL(shipping_amount, 0) + IFNULL(shipping_surcharge, 0)
                WHEN bu = 'MASTER ACCOUNT' AND is_delivered = 1 THEN IFNULL(shipping_amount, 0) + IFNULL(shipping_surcharge, 0)
                WHEN bu = 'RETAIL' AND is_delivered = 1 THEN IFNULL(shipping_amount, 0) + IFNULL(shipping_surcharge, 0)
            END) 'customer_charge',
            SUM(CASE
                WHEN bu = 'DIRECT BILLING' AND is_delivered = 1 THEN IFNULL(shipment_fee_mp_seller_item, 0) + IFNULL(insurance_seller_item, 0) + IFNULL(insurance_vat_seller_item, 0)
                WHEN bu = 'MASTER ACCOUNT' AND (is_delivered = 1 OR is_not_delivered = 1) THEN IFNULL(shipment_fee_mp_seller_item, 0) + IFNULL(insurance_seller_item, 0) + IFNULL(insurance_vat_seller_item, 0)
                WHEN bu = 'RETAIL' AND is_delivered = 1 THEN IFNULL(shipment_fee_mp_seller_item, 0) + IFNULL(insurance_seller_item, 0) + IFNULL(insurance_vat_seller_item, 0)
            END) 'seller_charge'
    FROM
        (SELECT 
        *,
            IF(order_date >= @extractstart AND order_date < @extractend, 1, 0) 'is_ordered',
            IF(first_shipped_date >= @extractstart AND first_shipped_date < @extractend, 1, 0) 'is_shipped',
            IF(delivered_date >= @extractstart AND delivered_date < @extractend, 1, 0) 'is_delivered',
            IF(not_delivered_date >= @extractstart AND not_delivered_date < @extractend, 1, 0) 'is_not_delivered',
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN ABS(total_delivery_cost_item / unit_price) > 5 THEN 0
                WHEN (shipping_amount + shipping_surcharge) > 40000000 THEN 0
                ELSE 1
            END 'pass',
            CASE
                WHEN shipment_scheme LIKE '%DIRECT BILLING%' THEN 'DIRECT BILLING'
                WHEN is_marketplace = 0 THEN 'RETAIL'
                ELSE 'MASTER ACCOUNT'
            END 'bu'
    FROM
        scglv3.anondb_calculate
    WHERE
        ((delivered_date >= @extractstart AND delivered_date < @extractend)
            OR (not_delivered_date >= @extractstart AND not_delivered_date < @extractend)
            OR (first_shipped_date >= @extractstart AND first_shipped_date < @extractend)
            OR (order_date >= @extractstart AND order_date < @extractend))
            AND shipment_scheme <> 'DIGITAL'
            AND shipment_scheme <> 'CROSS BORDER'
    HAVING pass = 1) result
    GROUP BY bu) result