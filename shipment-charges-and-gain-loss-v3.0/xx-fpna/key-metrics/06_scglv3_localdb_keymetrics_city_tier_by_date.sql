/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SCGL Key Metrics by Business Unit

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
SET @extractstart = '2017-07-26';
SET @extractend = '2017-07-28';-- This MUST be D + 1

CREATE TEMPORARY TABLE period_tier (
   `period` DATETIME NOT NULL,
   KEY (period)
);

delimiter //
CREATE PROCEDURE load_date_tier()
BEGIN
	SET @start_loop_tier = @extractstart;
	WHILE @start_loop_tier < @extractend DO
		INSERT INTO period_tier VALUES (@start_loop_tier);
        SET @start_loop_tier = DATE_ADD(@start_loop_tier, INTERVAL 1 DAY);
	END WHILE;
END //
delimiter ;

CALL load_date_tier;

SELECT 
    *
FROM
    (SELECT 
        period,
            SUM(IF(tier = 'Tier 1' AND created_at = period, nmv, 0)) 'NMV Tier 1 Created',
            SUM(IF(tier = 'Tier 2' AND created_at = period, nmv, 0)) 'NMV Tier 2 Created',
            SUM(IF(tier = 'Tier 3' AND created_at = period, nmv, 0)) 'NMV Tier 3 Created',
            SUM(IF(tier = 'Others' AND created_at = period, nmv, 0)) 'NMV Others Created',
            
            
            SUM(IF(tier = 'Tier 1' AND shipped_at = period, nmv, 0)) 'NMV Shipped Tier 1',
            SUM(IF(tier = 'Tier 2' AND shipped_at = period, nmv, 0)) 'NMV Shipped Tier 2',
            SUM(IF(tier = 'Tier 3' AND shipped_at = period, nmv, 0)) 'NMV Shipped Tier 3',
            SUM(IF(tier = 'Others' AND shipped_at = period, nmv, 0)) 'NMV Shipped Others',
            
            
            SUM(IF(tier = 'Tier 1' AND delivered_at = period, nmv, 0)) 'NMV Delivered Tier 1',
            SUM(IF(tier = 'Tier 2' AND delivered_at = period, nmv, 0)) 'NMV Delivered Tier 2',
            SUM(IF(tier = 'Tier 3' AND delivered_at = period, nmv, 0)) 'NMV Delivered Tier 3',
            SUM(IF(tier = 'Others' AND delivered_at = period, nmv, 0)) 'NMV Delivered Others',
            
            
            SUM(IF(tier = 'Tier 1' AND failed_at = period, nmv, 0)) 'NMV Failed Tier 1',
            SUM(IF(tier = 'Tier 2' AND failed_at = period, nmv, 0)) 'NMV Failed Tier 2',
            SUM(IF(tier = 'Tier 3' AND failed_at = period, nmv, 0)) 'NMV Failed Tier 3',
            SUM(IF(tier = 'Others' AND failed_at = period, nmv, 0)) 'NMV Failed Others',
            
            
            SUM(IF(tier = 'Tier 1' AND created_at = period, orders, 0)) 'Orders Tier 1 Created',
            SUM(IF(tier = 'Tier 2' AND created_at = period, orders, 0)) 'Orders Tier 2 Created',
            SUM(IF(tier = 'Tier 3' AND created_at = period, orders, 0)) 'Orders Tier 3 Created',
            SUM(IF(tier = 'Others' AND created_at = period, orders, 0)) 'Orders Others Created',
            
            
            SUM(IF(tier = 'Tier 1' AND shipped_at = period, orders, 0)) 'Orders Shipped Tier 1',
            SUM(IF(tier = 'Tier 2' AND shipped_at = period, orders, 0)) 'Orders Shipped Tier 2',
            SUM(IF(tier = 'Tier 3' AND shipped_at = period, orders, 0)) 'Orders Shipped Tier 3',
            SUM(IF(tier = 'Others' AND shipped_at = period, orders, 0)) 'Orders Shipped Others',
            
            
            SUM(IF(tier = 'Tier 1' AND delivered_at = period, orders, 0)) 'Orders Delivered Tier 1',
            SUM(IF(tier = 'Tier 2' AND delivered_at = period, orders, 0)) 'Orders Delivered Tier 2',
            SUM(IF(tier = 'Tier 3' AND delivered_at = period, orders, 0)) 'Orders Delivered Tier 3',
            SUM(IF(tier = 'Others' AND delivered_at = period, orders, 0)) 'Orders Delivered Others',
            
            
            SUM(IF(tier = 'Tier 1' AND failed_at = period, orders, 0)) 'Orders Failed Tier 1',
            SUM(IF(tier = 'Tier 2' AND failed_at = period, orders, 0)) 'Orders Failed Tier 2',
            SUM(IF(tier = 'Tier 3' AND failed_at = period, orders, 0)) 'Orders Failed Tier 3',
            SUM(IF(tier = 'Others' AND failed_at = period, orders, 0)) 'Orders Failed Others',
            
            
            SUM(IF(tier = 'Tier 1' AND created_at = period, item, 0)) 'Items Tier 1 Created',
            SUM(IF(tier = 'Tier 2' AND created_at = period, item, 0)) 'Items Tier 2 Created',
            SUM(IF(tier = 'Tier 3' AND created_at = period, item, 0)) 'Items Tier 3 Created',
            SUM(IF(tier = 'Others' AND created_at = period, item, 0)) 'Items Others Created',
            
            
            SUM(IF(tier = 'Tier 1' AND shipped_at = period, item, 0)) 'Items Shipped Tier 1',
            SUM(IF(tier = 'Tier 2' AND shipped_at = period, item, 0)) 'Items Shipped Tier 2',
            SUM(IF(tier = 'Tier 3' AND shipped_at = period, item, 0)) 'Items Shipped Tier 3',
            SUM(IF(tier = 'Others' AND shipped_at = period, item, 0)) 'Items Shipped Others',
            
            
            SUM(IF(tier = 'Tier 1' AND delivered_at = period, item, 0)) 'Items Delivered Tier 1',
            SUM(IF(tier = 'Tier 2' AND delivered_at = period, item, 0)) 'Items Delivered Tier 2',
            SUM(IF(tier = 'Tier 3' AND delivered_at = period, item, 0)) 'Items Delivered Tier 3',
            SUM(IF(tier = 'Others' AND delivered_at = period, item, 0)) 'Items Delivered Others',
            
            
            SUM(IF(tier = 'Tier 1' AND failed_at = period, item, 0)) 'Items Failed Tier 1',
            SUM(IF(tier = 'Tier 2' AND failed_at = period, item, 0)) 'Items Failed Tier 2',
            SUM(IF(tier = 'Tier 3' AND failed_at = period, item, 0)) 'Items Failed Tier 3',
            SUM(IF(tier = 'Others' AND failed_at = period, item, 0)) 'Items Failed Others',
            
            
            SUM(IF(tier = 'Tier 1' AND created_at = period, parcels, 0)) 'Parcels Tier 1 Created',
            SUM(IF(tier = 'Tier 2' AND created_at = period, parcels, 0)) 'Parcels Tier 2 Created',
            SUM(IF(tier = 'Tier 3' AND created_at = period, parcels, 0)) 'Parcels Tier 3 Created',
            SUM(IF(tier = 'Others' AND created_at = period, parcels, 0)) 'Parcels Others Created',
            
            
            SUM(IF(tier = 'Tier 1' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Tier 1',
            SUM(IF(tier = 'Tier 2' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Tier 2',
            SUM(IF(tier = 'Tier 3' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Tier 3',
            SUM(IF(tier = 'Others' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Others',
            
            
            SUM(IF(tier = 'Tier 1' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Tier 1',
            SUM(IF(tier = 'Tier 2' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Tier 2',
            SUM(IF(tier = 'Tier 3' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Tier 3',
            SUM(IF(tier = 'Others' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Others',
            
            
            SUM(IF(tier = 'Tier 1' AND failed_at = period, parcels, 0)) 'Parcels Failed Tier 1',
            SUM(IF(tier = 'Tier 2' AND failed_at = period, parcels, 0)) 'Parcels Failed Tier 2',
            SUM(IF(tier = 'Tier 3' AND failed_at = period, parcels, 0)) 'Parcels Failed Tier 3',
            SUM(IF(tier = 'Others' AND failed_at = period, parcels, 0)) 'Parcels Failed Others',
            
            
            SUM(IF(tier = 'Tier 1' AND created_at = period, weight, 0)) 'Weight Tier 1 Created',
            SUM(IF(tier = 'Tier 2' AND created_at = period, weight, 0)) 'Weight Tier 2 Created',
            SUM(IF(tier = 'Tier 3' AND created_at = period, weight, 0)) 'Weight Tier 3 Created',
            SUM(IF(tier = 'Others' AND created_at = period, weight, 0)) 'Weight Others Created',
            
            
            SUM(IF(tier = 'Tier 1' AND shipped_at = period, weight, 0)) 'Weight Shipped Tier 1',
            SUM(IF(tier = 'Tier 2' AND shipped_at = period, weight, 0)) 'Weight Shipped Tier 2',
            SUM(IF(tier = 'Tier 3' AND shipped_at = period, weight, 0)) 'Weight Shipped Tier 3',
            SUM(IF(tier = 'Others' AND shipped_at = period, weight, 0)) 'Weight Shipped Others',
            
            
            SUM(IF(tier = 'Tier 1' AND delivered_at = period, weight, 0)) 'Weight Delivered Tier 1',
            SUM(IF(tier = 'Tier 2' AND delivered_at = period, weight, 0)) 'Weight Delivered Tier 2',
            SUM(IF(tier = 'Tier 3' AND delivered_at = period, weight, 0)) 'Weight Delivered Tier 3',
            SUM(IF(tier = 'Others' AND delivered_at = period, weight, 0)) 'Weight Delivered Others',
            
            
            SUM(IF(tier = 'Tier 1' AND failed_at = period, weight, 0)) 'Weight Failed Tier 1',
            SUM(IF(tier = 'Tier 2' AND failed_at = period, weight, 0)) 'Weight Failed Tier 2',
            SUM(IF(tier = 'Tier 3' AND failed_at = period, weight, 0)) 'Weight Failed Tier 3',
            SUM(IF(tier = 'Others' AND failed_at = period, weight, 0)) 'Weight Failed Others',
            
            
            SUM(IF(tier = 'Tier 1' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Tier 1 Created',
            SUM(IF(tier = 'Tier 2' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Tier 2 Created',
            SUM(IF(tier = 'Tier 3' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Tier 3 Created',
            SUM(IF(tier = 'Others' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Others Created',
            
            
            SUM(IF(tier = 'Tier 1' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped Tier 1',
            SUM(IF(tier = 'Tier 2' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped Tier 2',
            SUM(IF(tier = 'Tier 3' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped Tier 3',
            SUM(IF(tier = 'Others' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped Others',
            
            
            SUM(IF(tier = 'Tier 1' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered Tier 1',
            SUM(IF(tier = 'Tier 2' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered Tier 2',
            SUM(IF(tier = 'Tier 3' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered Tier 3',
            SUM(IF(tier = 'Others' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered Others',
            
            
            SUM(IF(tier = 'Tier 1' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed Tier 1',
            SUM(IF(tier = 'Tier 2' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed Tier 2',
            SUM(IF(tier = 'Tier 3' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed Tier 3',
            SUM(IF(tier = 'Others' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed Others',
            
            
            SUM(IF(tier = 'Tier 1' AND created_at = period, seller_charges, 0)) 'Seller Charges Tier 1 Created',
            SUM(IF(tier = 'Tier 2' AND created_at = period, seller_charges, 0)) 'Seller Charges Tier 2 Created',
            SUM(IF(tier = 'Tier 3' AND created_at = period, seller_charges, 0)) 'Seller Charges Tier 3 Created',
            SUM(IF(tier = 'Others' AND created_at = period, seller_charges, 0)) 'Seller Charges Others Created',
            
            
            SUM(IF(tier = 'Tier 1' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Tier 1',
            SUM(IF(tier = 'Tier 2' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Tier 2',
            SUM(IF(tier = 'Tier 3' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Tier 3',
            SUM(IF(tier = 'Others' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Others',
            
            
            SUM(IF(tier = 'Tier 1' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Tier 1',
            SUM(IF(tier = 'Tier 2' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Tier 2',
            SUM(IF(tier = 'Tier 3' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Tier 3',
            SUM(IF(tier = 'Others' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Others',
            
            
            SUM(IF(tier = 'Tier 1' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Tier 1',
            SUM(IF(tier = 'Tier 2' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Tier 2',
            SUM(IF(tier = 'Tier 3' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Tier 3',
            SUM(IF(tier = 'Others' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Others',
            
            
            SUM(IF(tier = 'Tier 1' AND created_at = period, customer_charges, 0)) 'Customer Charges Tier 1 Created',
            SUM(IF(tier = 'Tier 2' AND created_at = period, customer_charges, 0)) 'Customer Charges Tier 2 Created',
            SUM(IF(tier = 'Tier 3' AND created_at = period, customer_charges, 0)) 'Customer Charges Tier 3 Created',
            SUM(IF(tier = 'Others' AND created_at = period, customer_charges, 0)) 'Customer Charges Others Created',
            
            
            SUM(IF(tier = 'Tier 1' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Tier 1',
            SUM(IF(tier = 'Tier 2' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Tier 2',
            SUM(IF(tier = 'Tier 3' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Tier 3',
            SUM(IF(tier = 'Others' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Others',
            
            
            SUM(IF(tier = 'Tier 1' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Tier 1',
            SUM(IF(tier = 'Tier 2' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Tier 2',
            SUM(IF(tier = 'Tier 3' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Tier 3',
            SUM(IF(tier = 'Others' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Others',
            
            
            SUM(IF(tier = 'Tier 1' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Tier 1',
            SUM(IF(tier = 'Tier 2' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Tier 2',
            SUM(IF(tier = 'Tier 3' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Tier 3',
            SUM(IF(tier = 'Others' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Others',
            
            
            SUM(IF(tier = 'Tier 1' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Tier 1 Created',
            SUM(IF(tier = 'Tier 2' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Tier 2 Created',
            SUM(IF(tier = 'Tier 3' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Tier 3 Created',
            SUM(IF(tier = 'Others' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Others Created',
            
            
            SUM(IF(tier = 'Tier 1' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Tier 1',
            SUM(IF(tier = 'Tier 2' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Tier 2',
            SUM(IF(tier = 'Tier 3' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Tier 3',
            SUM(IF(tier = 'Others' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Others',
            
            
            SUM(IF(tier = 'Tier 1' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Tier 1',
            SUM(IF(tier = 'Tier 2' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Tier 2',
            SUM(IF(tier = 'Tier 3' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Tier 3',
            SUM(IF(tier = 'Others' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Others',
            
            
            SUM(IF(tier = 'Tier 1' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Tier 1',
            SUM(IF(tier = 'Tier 2' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Tier 2',
            SUM(IF(tier = 'Tier 3' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Tier 3',
            SUM(IF(tier = 'Others' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Others',
            
            
            SUM(IF(tier = 'Tier 1' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Tier 1 Created',
            SUM(IF(tier = 'Tier 2' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Tier 2 Created',
            SUM(IF(tier = 'Tier 3' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Tier 3 Created',
            SUM(IF(tier = 'Others' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Others Created',
            
            
            SUM(IF(tier = 'Tier 1' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Tier 1',
            SUM(IF(tier = 'Tier 2' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Tier 2',
            SUM(IF(tier = 'Tier 3' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Tier 3',
            SUM(IF(tier = 'Others' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Others',
            
            
            SUM(IF(tier = 'Tier 1' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Tier 1',
            SUM(IF(tier = 'Tier 2' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Tier 2',
            SUM(IF(tier = 'Tier 3' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Tier 3',
            SUM(IF(tier = 'Others' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Others',
            
            
            SUM(IF(tier = 'Tier 1' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Tier 1',
            SUM(IF(tier = 'Tier 2' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Tier 2',
            SUM(IF(tier = 'Tier 3' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Tier 3',
            SUM(IF(tier = 'Others' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Others'
    FROM
        (SELECT 
		tier,
            created_at_temp 'created_at',
            shipped_at,
            delivered_at,
            failed_at,
            SUM(nmv) 'nmv',
            SUM(unit_price) 'unit_price',
            COUNT(bob_id_sales_order_item) 'item',
            COUNT(DISTINCT order_nr) 'orders',
            COUNT(DISTINCT package_number) 'parcels',
            SUM(weight_3pl_item) 'weight',
            SUM(weight_seller_item) 'chargable_weight',
            SUM(total_shipment_fee_mp_seller_item) 'seller_charges',
            SUM(shipping_amount_temp + shipping_surcharge_temp) 'customer_charges',
            SUM(delivery_cost) 'delivery_cost',
            SUM(pickup_cost) 'pickup_cost'
    FROM
        (SELECT 
        ac.*,
			IFNULL(tm.tier,'Others') 'tier',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_surcharge, 0) / 1.1
                ELSE IFNULL(shipping_surcharge, 0)
            END 'shipping_surcharge_temp',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_amount, 0) / 1.1
                ELSE IFNULL(shipping_amount, 0)
            END 'shipping_amount_temp',
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN ABS(total_delivery_cost_item / unit_price) > 5 THEN 0
                WHEN shipping_amount + shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass',
            CASE
                WHEN
                    delivered_date >= @extractstart
                        AND delivered_date < @extractend
                THEN
                    DATE(delivered_date)
                ELSE 0
            END 'delivered_at',
            CASE
                WHEN
                    not_delivered_date >= @extractstart
                        AND not_delivered_date < @extractend
                THEN
                    DATE(not_delivered_date)
                ELSE 0
            END 'failed_at',
            CASE
                WHEN
                    first_shipped_date >= @extractstart
                        AND first_shipped_date < @extractend
                THEN
                    DATE(first_shipped_date)
                ELSE 0
            END 'shipped_at',
            CASE
                WHEN
                    order_date >= @extractstart
                        AND order_date < @extractend
                THEN
                    DATE(order_date)
                ELSE 0
            END 'created_at_temp',
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv',
            delivery_cost_item + delivery_cost_discount_item + delivery_cost_vat_item + insurance_3pl_item + insurance_vat_3pl_item 'delivery_cost',
            pickup_cost_item + pickup_cost_discount_item + pickup_cost_vat_item 'pickup_cost'
    FROM
        anondb_calculate ac
			LEFT JOIN
		tier_mapping tm ON ac.id_district = tm.id_district
    WHERE
        (delivered_date >= @extractstart
            AND delivered_date < @extractend)
            OR (not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend)
            OR (first_shipped_date >= @extractstart
            AND first_shipped_date < @extractend)
            OR (order_date >= @extractstart
            AND order_date < @extractend)
    HAVING pass = 1) result
    GROUP BY tier , created_at , shipped_at , delivered_at , failed_at) result
    LEFT JOIN period_tier pd ON (pd.period = result.created_at
        OR pd.period = result.shipped_at
        OR pd.period = result.delivered_at
        OR pd.period = result.failed_at)
    GROUP BY pd.period) result;

DROP PROCEDURE load_date_tier;

DROP TEMPORARY TABLE period_tier;