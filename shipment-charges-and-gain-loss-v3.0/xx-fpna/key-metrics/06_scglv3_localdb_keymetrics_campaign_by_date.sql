/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SCGL Key Metrics by Campaign

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
SET @extractstart = '2017-07-01';
SET @extractend = '2017-07-28';-- This MUST be D + 1

CREATE TEMPORARY TABLE period_cam (
   `period` DATETIME NOT NULL,
   KEY (period)
);

delimiter //
CREATE PROCEDURE load_date_cam()
BEGIN
	SET @start_loop_cam = @extractstart;
	WHILE @start_loop_cam < @extractend DO
		INSERT INTO period_cam VALUES (@start_loop_cam);
        SET @start_loop_cam = DATE_ADD(@start_loop_cam, INTERVAL 1 DAY);
	END WHILE;
END //
delimiter ;

CALL load_date_cam;

SELECT 
    *
FROM
    (SELECT 
        period,
            SUM(IF(campaign = 'VIP' AND created_at = period, nmv, 0)) 'NMV VIP Created',
            SUM(IF(campaign = 'Prioritas' AND created_at = period, nmv, 0)) 'NMV Prioritas Created',
            SUM(IF(campaign = 'NON VIP'AND created_at = period, nmv, 0)) 'NMV Non Campaign Created',
            
            SUM(IF(campaign = 'VIP' AND shipped_at = period, nmv, 0)) 'NMV VIP Shipped',
            SUM(IF(campaign = 'Prioritas' AND shipped_at = period, nmv, 0)) 'NMV Prioritas Shipped',
            SUM(IF(campaign = 'NON VIP'AND shipped_at = period, nmv, 0)) 'NMV Non Campaign Shipped',
            
            SUM(IF(campaign = 'VIP' AND delivered_at = period, nmv, 0)) 'NMV VIP Delivered',
            SUM(IF(campaign = 'Prioritas' AND delivered_at = period, nmv, 0)) 'NMV Prioritas Delivered',
            SUM(IF(campaign = 'NON VIP' AND delivered_at = period, nmv, 0)) 'NMV Non Campaign Delivered',
            
            SUM(IF(campaign = 'VIP' AND failed_at = period, nmv, 0)) 'NMV VIP Failed',
            SUM(IF(campaign = 'Prioritas' AND failed_at = period, nmv, 0)) 'NMV Prioritas Failed',
            SUM(IF(campaign = 'NON VIP' AND failed_at = period, nmv, 0)) 'NMV Non Campaign Failed',
            
            SUM(IF(campaign = 'VIP' AND created_at = period, orders, 0)) 'Orders VIP Created',
            SUM(IF(campaign = 'Prioritas' AND created_at = period, orders, 0)) 'Orders Prioritas Created',
            SUM(IF(campaign = 'NON VIP' AND created_at = period, orders, 0)) 'Orders Non Campaign Created',
            
            SUM(IF(campaign = 'VIP' AND shipped_at = period, orders, 0)) 'Orders VIP Shipped',
            SUM(IF(campaign = 'Prioritas' AND shipped_at = period, orders, 0)) 'Orders Prioritas Shipped',
            SUM(IF(campaign = 'NON VIP' AND shipped_at = period, orders, 0)) 'Orders Non Campaign Shipped',
            
            SUM(IF(campaign = 'VIP' AND delivered_at = period, orders, 0)) 'Orders VIP Delivered',
            SUM(IF(campaign = 'Prioritas' AND delivered_at = period, orders, 0)) 'Orders Prioritas Delivered',
            SUM(IF(campaign = 'NON VIP' AND delivered_at = period, orders, 0)) 'Orders Non Campaign Delivered',
            
            SUM(IF(campaign = 'VIP' AND failed_at = period, orders, 0)) 'Orders VIP Failed',
            SUM(IF(campaign = 'Prioritas' AND failed_at = period, orders, 0)) 'Orders Prioritas Failed',
            SUM(IF(campaign = 'NON VIP' AND failed_at = period, orders, 0)) 'Orders Non Campaign Failed',
            
            SUM(IF(campaign = 'VIP' AND created_at = period, item, 0)) 'Items VIP Created',
            SUM(IF(campaign = 'Prioritas' AND created_at = period, item, 0)) 'Items Prioritas Created',
            SUM(IF(campaign = 'NON VIP' AND created_at = period, item, 0)) 'Items Non Campaign Created',
            
            SUM(IF(campaign = 'VIP' AND shipped_at = period, item, 0)) 'Items VIP Shipped',
            SUM(IF(campaign = 'Prioritas' AND shipped_at = period, item, 0)) 'Items Prioritas Shipped',
            SUM(IF(campaign = 'NON VIP' AND shipped_at = period, item, 0)) 'Items Non Campaign Shipped',
            
            SUM(IF(campaign = 'VIP' AND delivered_at = period, item, 0)) 'Items VIP Delivered',
            SUM(IF(campaign = 'Prioritas' AND delivered_at = period, item, 0)) 'Items Prioritas Delivered',
            SUM(IF(campaign = 'NON VIP' AND delivered_at = period, item, 0)) 'Items Non Campaign Delivered',
            
            SUM(IF(campaign = 'VIP' AND failed_at = period, item, 0)) 'Items VIP Failed',
            SUM(IF(campaign = 'Prioritas' AND failed_at = period, item, 0)) 'Items Prioritas Failed',
            SUM(IF(campaign = 'NON VIP' AND failed_at = period, item, 0)) 'Items Non Campaign Failed',
            
            SUM(IF(campaign = 'VIP' AND created_at = period, parcels, 0)) 'Parcels VIP Created',
            SUM(IF(campaign = 'Prioritas' AND created_at = period, parcels, 0)) 'Parcels Prioritas Created',
            SUM(IF(campaign = 'NON VIP' AND created_at = period, parcels, 0)) 'Parcels Non Campaign Created',
            
            SUM(IF(campaign = 'VIP' AND shipped_at = period, parcels, 0)) 'Parcels VIP Shipped',
            SUM(IF(campaign = 'Prioritas' AND shipped_at = period, parcels, 0)) 'Parcels Prioritas Shipped',
            SUM(IF(campaign = 'NON VIP' AND shipped_at = period, parcels, 0)) 'Parcels Non Campaign Shipped',
            
            SUM(IF(campaign = 'VIP' AND delivered_at = period, parcels, 0)) 'Parcels VIP Delivered',
            SUM(IF(campaign = 'Prioritas' AND delivered_at = period, parcels, 0)) 'Parcels Prioritas Delivered',
            SUM(IF(campaign = 'NON VIP' AND delivered_at = period, parcels, 0)) 'Parcels Non Campaign Delivered',
            
            SUM(IF(campaign = 'VIP' AND failed_at = period, parcels, 0)) 'Parcels VIP Failed',
            SUM(IF(campaign = 'Prioritas' AND failed_at = period, parcels, 0)) 'Parcels Prioritas Failed',
            SUM(IF(campaign = 'NON VIP' AND failed_at = period, parcels, 0)) 'Parcels Non Campaign Failed',
            
            SUM(IF(campaign = 'VIP' AND created_at = period, weight, 0)) 'Weight VIP Created',
            SUM(IF(campaign = 'Prioritas' AND created_at = period, weight, 0)) 'Weight Prioritas Created',
            SUM(IF(campaign = 'NON VIP' AND created_at = period, weight, 0)) 'Weight Non Campaign Created',
            
            SUM(IF(campaign = 'VIP' AND shipped_at = period, weight, 0)) 'Weight VIP Shipped',
            SUM(IF(campaign = 'Prioritas' AND shipped_at = period, weight, 0)) 'Weight Prioritas Shipped',
            SUM(IF(campaign = 'NON VIP' AND shipped_at = period, weight, 0)) 'Weight Non Campaign Shipped',
            
            SUM(IF(campaign = 'VIP' AND delivered_at = period, weight, 0)) 'Weight VIP Delivered',
            SUM(IF(campaign = 'Prioritas' AND delivered_at = period, weight, 0)) 'Weight Prioritas Delivered',
            SUM(IF(campaign = 'NON VIP' AND delivered_at = period, weight, 0)) 'Weight Non Campaign Delivered',
            
            SUM(IF(campaign = 'VIP' AND failed_at = period, weight, 0)) 'Weight VIP Failed',
            SUM(IF(campaign = 'Prioritas' AND failed_at = period, weight, 0)) 'Weight Prioritas Failed',
            SUM(IF(campaign = 'NON VIP' AND failed_at = period, weight, 0)) 'Weight Non Campaign Failed',
            
            SUM(IF(campaign = 'VIP' AND created_at = period, chargable_weight, 0)) 'Chargable Weight VIP Created',
            SUM(IF(campaign = 'Prioritas' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Prioritas Created',
            SUM(IF(campaign = 'NON VIP' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Non Campaign Created',
            
            SUM(IF(campaign = 'VIP' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight VIP Shipped',
            SUM(IF(campaign = 'Prioritas' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Prioritas Shipped',
            SUM(IF(campaign = 'NON VIP' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Non Campaign Shipped',
            
            SUM(IF(campaign = 'VIP' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight VIP Delivered',
            SUM(IF(campaign = 'Prioritas' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Prioritas Delivered',
            SUM(IF(campaign = 'NON VIP' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Non Campaign Delivered',
            
            SUM(IF(campaign = 'VIP' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight VIP Failed',
            SUM(IF(campaign = 'Prioritas' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Prioritas Failed',
            SUM(IF(campaign = 'NON VIP' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Non Campaign Failed',
            
            SUM(IF(campaign = 'VIP' AND created_at = period, seller_charges, 0)) 'Seller Charges VIP Created',
            SUM(IF(campaign = 'Prioritas' AND created_at = period, seller_charges, 0)) 'Seller Charges Prioritas Created',
            SUM(IF(campaign = 'NON VIP' AND created_at = period, seller_charges, 0)) 'Seller Charges Non Campaign Created',
            
            SUM(IF(campaign = 'VIP' AND shipped_at = period, seller_charges, 0)) 'Seller Charges VIP Shipped',
            SUM(IF(campaign = 'Prioritas' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Prioritas Shipped',
            SUM(IF(campaign = 'NON VIP' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Non Campaign Shipped',
            
            SUM(IF(campaign = 'VIP' AND delivered_at = period, seller_charges, 0)) 'Seller Charges VIP Delivered',
            SUM(IF(campaign = 'Prioritas' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Prioritas Delivered',
            SUM(IF(campaign = 'NON VIP' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Non Campaign Delivered',
            
            SUM(IF(campaign = 'VIP' AND failed_at = period, seller_charges, 0)) 'Seller Charges VIP Failed',
            SUM(IF(campaign = 'Prioritas' AND failed_at = period, seller_charges, 0)) 'Seller Charges Prioritas Failed',
            SUM(IF(campaign = 'NON VIP' AND failed_at = period, seller_charges, 0)) 'Seller Charges Non Campaign Failed',
            
            SUM(IF(campaign = 'VIP' AND created_at = period, customer_charges, 0)) 'Customer Charges VIP Created',
            SUM(IF(campaign = 'Prioritas' AND created_at = period, customer_charges, 0)) 'Customer Charges Prioritas Created',
            SUM(IF(campaign = 'NON VIP' AND created_at = period, customer_charges, 0)) 'Customer Charges Non Campaign Created',
            
            SUM(IF(campaign = 'VIP' AND shipped_at = period, customer_charges, 0)) 'Customer Charges VIP Shipped',
            SUM(IF(campaign = 'Prioritas' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Prioritas Shipped',
            SUM(IF(campaign = 'NON VIP' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Non Campaign Shipped',
            
            SUM(IF(campaign = 'VIP' AND delivered_at = period, customer_charges, 0)) 'Customer Charges VIP Delivered',
            SUM(IF(campaign = 'Prioritas' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Prioritas Delivered',
            SUM(IF(campaign = 'NON VIP' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Non Campaign Delivered',
            
            SUM(IF(campaign = 'VIP' AND failed_at = period, customer_charges, 0)) 'Customer Charges VIP Failed',
            SUM(IF(campaign = 'Prioritas' AND failed_at = period, customer_charges, 0)) 'Customer Charges Prioritas Failed',
            SUM(IF(campaign = 'NON VIP' AND failed_at = period, customer_charges, 0)) 'Customer Charges Non Campaign Failed',
            
            SUM(IF(campaign = 'VIP' AND created_at = period, delivery_cost, 0)) 'Delivery Cost VIP Created',
            SUM(IF(campaign = 'Prioritas' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Prioritas Created',
            SUM(IF(campaign = 'NON VIP' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Non Campaign Created',
            
            SUM(IF(campaign = 'VIP' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost VIP Shipped',
            SUM(IF(campaign = 'Prioritas' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Prioritas Shipped',
            SUM(IF(campaign = 'NON VIP' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Non Campaign Shipped',
            
            SUM(IF(campaign = 'VIP' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost VIP Delivered',
            SUM(IF(campaign = 'Prioritas' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Prioritas Delivered',
            SUM(IF(campaign = 'NON VIP' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Non Campaign Delivered',
            
            SUM(IF(campaign = 'VIP' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost VIP Failed',
            SUM(IF(campaign = 'Prioritas' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Prioritas Failed',
            SUM(IF(campaign = 'NON VIP' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Non Campaign Failed',
            
            SUM(IF(campaign = 'VIP' AND created_at = period, pickup_cost, 0)) 'Pickup Cost VIP Created',
            SUM(IF(campaign = 'Prioritas' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Prioritas Created',
            SUM(IF(campaign = 'NON VIP' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Non Campaign Created',
            
            SUM(IF(campaign = 'VIP' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost VIP Shipped',
            SUM(IF(campaign = 'Prioritas' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Prioritas Shipped',
            SUM(IF(campaign = 'NON VIP' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Non Campaign Shipped',
            
            SUM(IF(campaign = 'VIP' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost VIP Delivered',
            SUM(IF(campaign = 'Prioritas' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Prioritas Delivered',
            SUM(IF(campaign = 'NON VIP' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Non Campaign Delivered',
            
            SUM(IF(campaign = 'VIP' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost VIP Failed',
            SUM(IF(campaign = 'Prioritas' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Prioritas Failed',
            SUM(IF(campaign = 'NON VIP' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Non Campaign Failed'
    FROM
        (SELECT 
        bu,
            temp_campaign 'campaign',
            created_at,
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
        *,
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
                WHEN shipment_scheme LIKE '%DIGITAL%' THEN 'Digital'
                WHEN shipment_scheme LIKE '%DIRECT BILLING%' THEN 'DB'
                WHEN shipment_scheme LIKE '%MASTER ACCOUNT%' THEN 'MA'
                WHEN shipment_scheme LIKE '%RETAIL%' THEN 'Retail'
                WHEN shipment_scheme LIKE '%CROSS BORDER%' THEN 'CB'
                WHEN
                    shipment_scheme LIKE '%GO-JEK%'
                        OR shipment_scheme LIKE '%EXPRESS%'
                        OR shipment_scheme LIKE '%FBL%'
                THEN
                    CASE
                        WHEN tax_class = 'international' THEN 'CB'
                        WHEN is_marketplace = 0 THEN 'Retail'
                        ELSE 'MA'
                    END
            END 'bu',
            CASE
				WHEN campaign LIKE '%Prioritas%' THEN 'Prioritas'
                WHEN campaign LIKE '%VIP%' THEN 'VIP'
                ELSE 'NON VIP'
            END 'temp_campaign',
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
            END 'created_at',
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv',
            delivery_cost_item + delivery_cost_discount_item + delivery_cost_vat_item + insurance_3pl_item + insurance_vat_3pl_item 'delivery_cost',
            pickup_cost_item + pickup_cost_discount_item + pickup_cost_vat_item 'pickup_cost'
    FROM
        anondb_calculate
    WHERE
        (delivered_date >= @extractstart
            AND delivered_date < @extractend)
            OR (not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend)
            OR (first_shipped_date >= @extractstart
            AND first_shipped_date < @extractend)
            OR (order_date >= @extractstart
            AND order_date < @extractend)
    HAVING pass = 1 and bu = 'MA') result
    GROUP BY bu , campaign, created_at , shipped_at , delivered_at , failed_at) result
    LEFT JOIN period_cam pd ON (pd.period = result.created_at
        OR pd.period = result.shipped_at
        OR pd.period = result.delivered_at
        OR pd.period = result.failed_at)
    GROUP BY pd.period) result;

DROP PROCEDURE load_date_cam;

DROP TEMPORARY TABLE period_cam;