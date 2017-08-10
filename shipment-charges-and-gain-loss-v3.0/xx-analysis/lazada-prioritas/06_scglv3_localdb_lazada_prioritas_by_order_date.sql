/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Lazada Prioritas by Order Date
 
Prepared by		: RM
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
SET @extractstart = '2017-07-01';
SET @extractend = '2017-08-01';-- This MUST be D + 1

SELECT 
    short_code 'SC ID',
    seller_name 'Seller',
    CASE
        WHEN MAX(bu_flag) = 1 THEN 'MA'
        WHEN MAX(bu_flag) = 0 THEN 'DB'
    END 'BU flag',
    CASE
        WHEN MAX(vip_flag) = 1 THEN 'VIP'
        ELSE 'Non-VIP'
    END 'VIP Flag',
    CASE
        WHEN MAX(fbl_flag) = 1 THEN 'FBL'
        ELSE 'Non-FBL'
    END 'FBL flag',
    SUM(nmv) 'NMV',
    COUNT(DISTINCT order_nr) 'Orders',
    COUNT(bob_id_sales_order_item) 'Items',
    SUM(unit_price) 'Unit Price',
    SUM(unit_price) / COUNT(DISTINCT order_nr) 'AOV',
    SUM(shipping_amount_temp) 'Shipping fee',
    SUM(shipping_surcharge_temp) 'Shipping surcharge',
    SUM(total_shipment_fee_mp_seller_item) 'Seller charges',
    SUM(total_delivery_cost_item) '3PL cost',
    SUM(shipping_amount_temp + shipping_surcharge_temp + total_shipment_fee_mp_seller_item + total_delivery_cost_item) 'Shipping subsidies'
FROM
    (SELECT 
        bob_id_supplier,
            short_code,
            seller_name,
            CASE
                WHEN shipment_scheme LIKE '%DIRECT BILLING%' THEN 0
                ELSE 1
            END 'bu_flag',
            CASE
                WHEN campaign LIKE '%EXCEPTION%' THEN 0
                WHEN campaign LIKE '%VIP%' THEN 1
                ELSE 0
            END 'vip_flag',
            CASE
                WHEN shipment_scheme LIKE '%FBL%' THEN 1
                ELSE 0
            END 'fbl_flag',
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv',
            order_nr,
            bob_id_sales_order_item,
            IFNULL(unit_price, 0) 'unit_price',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_amount, 0) / 1.1
                ELSE IFNULL(shipping_amount, 0)
            END 'shipping_amount_temp',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_surcharge, 0) / 1.1
                ELSE IFNULL(shipping_surcharge, 0)
            END 'shipping_surcharge_temp',
            IFNULL(total_shipment_fee_mp_seller_item, 0) 'total_shipment_fee_mp_seller_item',
            IFNULL(total_delivery_cost_item, 0) 'total_delivery_cost_item',
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN shipping_amount + shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass'
    FROM
        anondb_calculate ac
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.shipment_scheme IN ('DIRECT BILLING' , 'EXPRESS DIRECT-BILLING', 'GO-JEK DIRECT BILLING', 'GO-JEK', 'GO-JEK FBL', 'EXPRESS', 'EXPRESS FBL', 'FBL', 'MASTER ACCOUNT')
            AND is_marketplace = 1
            AND tax_class = 'local'
    HAVING pass = 1) result
GROUP BY bob_id_supplier