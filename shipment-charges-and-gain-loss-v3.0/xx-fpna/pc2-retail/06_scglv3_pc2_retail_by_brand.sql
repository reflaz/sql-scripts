/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Retail PC2 by Brands

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
SET @extractstart = '2018-01-01';
SET @extractend = '2018-01-02';-- This MUST be D + 1

SET @wh_handling_retail = 7316;#Item Retail

SELECT 
    res.brand,
    SUM(IF(ordered_flag = 1, orders, 0)) 'order_ordered',
    SUM(IF(delivered_flag = 1, orders, 0)) 'order_delivered',
    SUM(IF(ordered_flag = 1, parcels, 0)) 'parcels_ordered',
    SUM(IF(delivered_flag = 1, parcels, 0)) 'parcels_delivered',
    SUM(IF(ordered_flag = 1, item, 0)) 'item_ordered',
    SUM(IF(delivered_flag = 1, item, 0)) 'item_delivered',
    SUM(IF(ordered_flag = 1, nmv, 0)) 'nmv_ordered',
    SUM(IF(delivered_flag = 1, nmv, 0)) 'nmv_delivered',
    - @wh_handling_retail * SUM(IF(res.shipped_flag = 1, res.item, 0)) 'wh_handling',
    - SUM(IF(res.delivered_flag = 1
            OR res.failed_flag = 1,
        res.delivery_cost,
        0)) 'delivery_cost',
    SUM(IF(ordered_flag = 1,
        res.payment_cost,
        0)) 'payment_cost',
    SUM(IF(delivered_flag = 1,
        res.backmargin,
        0)) 'backmargin',
    - SUM(IF(delivered_flag = 1, discount, 0)) 'voucher'
FROM
    (SELECT 
        cb.name 'brand',
            ac.ordered_flag,
            ac.shipped_flag,
            ac.delivered_flag,
            ac.failed_flag,
            SUM(IFNULL(ac.nmv, 0)) 'nmv',
            COUNT(DISTINCT ac.order_nr) 'orders',
            COUNT(DISTINCT ac.package_number) 'parcels',
            COUNT(ac.bob_id_sales_order_item) 'item',
            SUM(IFNULL(ac.order_flat_item, 0) + IFNULL(ac.mdr_item, 0) + IFNULL(ac.ipp_item, 0)) 'payment_cost',
            SUM(IFNULL(ac.total_delivery_cost_item, 0)) 'delivery_cost',
            SUM(IFNULL(ac.discount, 0)) 'discount',
            SUM(IF(ac.refund_completed_date IS NULL, bm.backmargin, 0)) 'backmargin'
    FROM
        (SELECT 
        ac.*,
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN ABS(total_delivery_cost_item / unit_price) > 5 THEN 0
                WHEN (shipping_amount + shipping_surcharge) > 40000000 THEN 0
                ELSE 1
            END 'pass',
            CASE
                WHEN
                    delivered_date >= @extractstart
                        AND delivered_date < @extractend
                THEN
                    1
                ELSE 0
            END 'delivered_flag',
            CASE
                WHEN
                    not_delivered_date >= @extractstart
                        AND not_delivered_date < @extractend
                THEN
                    1
                ELSE 0
            END 'failed_flag',
            CASE
                WHEN
                    first_shipped_date >= @extractstart
                        AND first_shipped_date < @extractend
                THEN
                    1
                ELSE 0
            END 'shipped_flag',
            CASE
                WHEN
                    order_date >= @extractstart
                        AND order_date < @extractend
                THEN
                    1
                ELSE 0
            END 'ordered_flag',
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv',
            IF(coupon_type = 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) + cart_rule_discount 'discount',
            SUBSTRING_INDEX(ac.sku, '-', 1) AS sku_key
    FROM
        scglv3.anondb_calculate ac
    WHERE
        ((delivered_date >= @extractstart
            AND delivered_date < @extractend)
            OR (not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend)
            OR (first_shipped_date >= @extractstart
            AND first_shipped_date < @extractend)
            OR (order_date >= @extractstart
            AND order_date < @extractend))
            AND shipment_scheme = 'RETAIL'
    HAVING pass = 1) ac
    LEFT JOIN seller_mapping.catalog_config cc ON cc.sku = ac.sku_key
    LEFT JOIN seller_mapping.catalog_brand cb ON cb.id_catalog_brand = cc.fk_catalog_brand
    LEFT JOIN scglv3.backmargin bm ON ac.sku = bm.sku
        AND DATE(ac.order_date) = bm.bm_date
    GROUP BY cb.name , ac.ordered_flag , ac.shipped_flag , ac.delivered_flag , ac.failed_flag) res
GROUP BY res.brand