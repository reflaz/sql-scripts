/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SCGL Key Metrics by Customer Type

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
SET @extractstart = '2017-08-01';
SET @extractend = '2017-08-15';-- This MUST be D + 1

CREATE TEMPORARY TABLE period_cust (
   `period` DATETIME NOT NULL,
   KEY (period)
);

delimiter //
CREATE PROCEDURE load_date_cust()
BEGIN
	SET @start_loop_cust = @extractstart;
	WHILE @start_loop_cust < @extractend DO
		INSERT INTO period_cust VALUES (@start_loop_cust);
        SET @start_loop_cust = DATE_ADD(@start_loop_cust, INTERVAL 1 DAY);
	END WHILE;
END //
delimiter ;

CALL load_date_cust;

SELECT 
    *
FROM
    (SELECT 
        period,
            sum(if (customer_type = 'Free' AND created_at = period, nmv, 0)) 'NMV Created Free',
			sum(if (customer_type = 'Flat Fee' AND created_at = period, nmv, 0)) 'NMV Created Flat Fee',
			sum(if (customer_type = 'Paid' AND created_at = period, nmv, 0)) 'NMV Created Paid',

			sum(if (customer_type = 'Free' AND shipped_at = period, nmv, 0)) 'NMV Shipped Free',
			sum(if (customer_type = 'Flat Fee' AND shipped_at = period, nmv, 0)) 'NMV Shipped Flat Fee',
			sum(if (customer_type = 'Paid' AND shipped_at = period, nmv, 0)) 'NMV Shipped Paid',

			sum(if (customer_type = 'Free' AND delivered_at = period, nmv, 0)) 'NMV Delivered Free',
			sum(if (customer_type = 'Flat Fee' AND delivered_at = period, nmv, 0)) 'NMV Delivered Flat Fee',
			sum(if (customer_type = 'Paid' AND delivered_at = period, nmv, 0)) 'NMV Delivered Paid',

			sum(if (customer_type = 'Free' AND failed_at = period, nmv, 0)) 'NMV Failed Free',
			sum(if (customer_type = 'Flat Fee' AND failed_at = period, nmv, 0)) 'NMV Failed Flat Fee',
			sum(if (customer_type = 'Paid' AND failed_at = period, nmv, 0)) 'NMV Failed Paid',

			sum(if (customer_type = 'Free' AND created_at = period, orders, 0)) 'Orders Created Free',
			sum(if (customer_type = 'Flat Fee' AND created_at = period, orders, 0)) 'Orders Created Flat Fee',
			sum(if (customer_type = 'Paid' AND created_at = period, orders, 0)) 'Orders Created Paid',

			sum(if (customer_type = 'Free' AND shipped_at = period, orders, 0)) 'Orders Shipped Free',
			sum(if (customer_type = 'Flat Fee' AND shipped_at = period, orders, 0)) 'Orders Shipped Flat Fee',
			sum(if (customer_type = 'Paid' AND shipped_at = period, orders, 0)) 'Orders Shipped Paid',

			sum(if (customer_type = 'Free' AND delivered_at = period, orders, 0)) 'Orders Delivered Free',
			sum(if (customer_type = 'Flat Fee' AND delivered_at = period, orders, 0)) 'Orders Delivered Flat Fee',
			sum(if (customer_type = 'Paid' AND delivered_at = period, orders, 0)) 'Orders Delivered Paid',

			sum(if (customer_type = 'Free' AND failed_at = period, orders, 0)) 'Orders Failed Free',
			sum(if (customer_type = 'Flat Fee' AND failed_at = period, orders, 0)) 'Orders Failed Flat Fee',
			sum(if (customer_type = 'Paid' AND failed_at = period, orders, 0)) 'Orders Failed Paid',

			sum(if (customer_type = 'Free' AND created_at = period, item, 0)) 'Items Created Free',
			sum(if (customer_type = 'Flat Fee' AND created_at = period, item, 0)) 'Items Created Flat Fee',
			sum(if (customer_type = 'Paid' AND created_at = period, item, 0)) 'Items Created Paid',

			sum(if (customer_type = 'Free' AND shipped_at = period, item, 0)) 'Items Shipped Free',
			sum(if (customer_type = 'Flat Fee' AND shipped_at = period, item, 0)) 'Items Shipped Flat Fee',
			sum(if (customer_type = 'Paid' AND shipped_at = period, item, 0)) 'Items Shipped Paid',

			sum(if (customer_type = 'Free' AND delivered_at = period, item, 0)) 'Items Delivered Free',
			sum(if (customer_type = 'Flat Fee' AND delivered_at = period, item, 0)) 'Items Delivered Flat Fee',
			sum(if (customer_type = 'Paid' AND delivered_at = period, item, 0)) 'Items Delivered Paid',

			sum(if (customer_type = 'Free' AND failed_at = period, item, 0)) 'Items Failed Free',
			sum(if (customer_type = 'Flat Fee' AND failed_at = period, item, 0)) 'Items Failed Flat Fee',
			sum(if (customer_type = 'Paid' AND failed_at = period, item, 0)) 'Items Failed Paid',

			sum(if (customer_type = 'Free' AND created_at = period, parcels, 0)) 'Parcels Created Free',
			sum(if (customer_type = 'Flat Fee' AND created_at = period, parcels, 0)) 'Parcels Created Flat Fee',
			sum(if (customer_type = 'Paid' AND created_at = period, parcels, 0)) 'Parcels Created Paid',

			sum(if (customer_type = 'Free' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Free',
			sum(if (customer_type = 'Flat Fee' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Flat Fee',
			sum(if (customer_type = 'Paid' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Paid',

			sum(if (customer_type = 'Free' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Free',
			sum(if (customer_type = 'Flat Fee' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Flat Fee',
			sum(if (customer_type = 'Paid' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Paid',

			sum(if (customer_type = 'Free' AND failed_at = period, parcels, 0)) 'Parcels Failed Free',
			sum(if (customer_type = 'Flat Fee' AND failed_at = period, parcels, 0)) 'Parcels Failed Flat Fee',
			sum(if (customer_type = 'Paid' AND failed_at = period, parcels, 0)) 'Parcels Failed Paid',

			sum(if (customer_type = 'Free' AND created_at = period, weight, 0)) 'Weight Created Free',
			sum(if (customer_type = 'Flat Fee' AND created_at = period, weight, 0)) 'Weight Created Flat Fee',
			sum(if (customer_type = 'Paid' AND created_at = period, weight, 0)) 'Weight Created Paid',

			sum(if (customer_type = 'Free' AND shipped_at = period, weight, 0)) 'Weight Shipped Free',
			sum(if (customer_type = 'Flat Fee' AND shipped_at = period, weight, 0)) 'Weight Shipped Flat Fee',
			sum(if (customer_type = 'Paid' AND shipped_at = period, weight, 0)) 'Weight Shipped Paid',

			sum(if (customer_type = 'Free' AND delivered_at = period, weight, 0)) 'Weight Delivered Free',
			sum(if (customer_type = 'Flat Fee' AND delivered_at = period, weight, 0)) 'Weight Delivered Flat Fee',
			sum(if (customer_type = 'Paid' AND delivered_at = period, weight, 0)) 'Weight Delivered Paid',

			sum(if (customer_type = 'Free' AND failed_at = period, weight, 0)) 'Weight Failed Free',
			sum(if (customer_type = 'Flat Fee' AND failed_at = period, weight, 0)) 'Weight Failed Flat Fee',
			sum(if (customer_type = 'Paid' AND failed_at = period, weight, 0)) 'Weight Failed Paid',

			sum(if (customer_type = 'Free' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Created Free',
			sum(if (customer_type = 'Flat Fee' AND created_at = period, chargable_weight, 0)) 'Chargable Weight  Created Flat Fee',
			sum(if (customer_type = 'Paid' AND created_at = period, chargable_weight, 0)) 'Chargable Weight  Created Paid',

			sum(if (customer_type = 'Free' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight  Shipped Free',
			sum(if (customer_type = 'Flat Fee' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight  Shipped Flat Fee',
			sum(if (customer_type = 'Paid' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight  Shipped Paid',

			sum(if (customer_type = 'Free' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight  Delivered Free',
			sum(if (customer_type = 'Flat Fee' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight  Delivered Flat Fee',
			sum(if (customer_type = 'Paid' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight  Delivered Paid',

			sum(if (customer_type = 'Free' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight  Failed Free',
			sum(if (customer_type = 'Flat Fee' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight  Failed Flat Fee',
			sum(if (customer_type = 'Paid' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight  Failed Paid',

			sum(if (customer_type = 'Free' AND created_at = period, seller_charges, 0)) 'Seller Charges Created Free',
			sum(if (customer_type = 'Flat Fee' AND created_at = period, seller_charges, 0)) 'Seller Charges Created Flat Fee',
			sum(if (customer_type = 'Paid' AND created_at = period, seller_charges, 0)) 'Seller Charges Created Paid',

			sum(if (customer_type = 'Free' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Free',
			sum(if (customer_type = 'Flat Fee' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Flat Fee',
			sum(if (customer_type = 'Paid' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Paid',

			sum(if (customer_type = 'Free' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Free',
			sum(if (customer_type = 'Flat Fee' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Flat Fee',
			sum(if (customer_type = 'Paid' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Paid',

			sum(if (customer_type = 'Free' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Free',
			sum(if (customer_type = 'Flat Fee' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Flat Fee',
			sum(if (customer_type = 'Paid' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Paid',

			sum(if (customer_type = 'Free' AND created_at = period, customer_charges, 0)) 'Customer Charges Created Free',
			sum(if (customer_type = 'Flat Fee' AND created_at = period, customer_charges, 0)) 'Customer Charges Created Flat Fee',
			sum(if (customer_type = 'Paid' AND created_at = period, customer_charges, 0)) 'Customer Charges Created Paid',

			sum(if (customer_type = 'Free' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Free',
			sum(if (customer_type = 'Flat Fee' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Flat Fee',
			sum(if (customer_type = 'Paid' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Paid',

			sum(if (customer_type = 'Free' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Free',
			sum(if (customer_type = 'Flat Fee' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Flat Fee',
			sum(if (customer_type = 'Paid' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Paid',

			sum(if (customer_type = 'Free' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Free',
			sum(if (customer_type = 'Flat Fee' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Flat Fee',
			sum(if (customer_type = 'Paid' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Paid',

			sum(if (customer_type = 'Free' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Created Free',
			sum(if (customer_type = 'Flat Fee' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Created Flat Fee',
			sum(if (customer_type = 'Paid' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Created Paid',

			sum(if (customer_type = 'Free' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Free',
			sum(if (customer_type = 'Flat Fee' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Flat Fee',
			sum(if (customer_type = 'Paid' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Paid',

			sum(if (customer_type = 'Free' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Free',
			sum(if (customer_type = 'Flat Fee' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Flat Fee',
			sum(if (customer_type = 'Paid' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Paid',

			sum(if (customer_type = 'Free' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Free',
			sum(if (customer_type = 'Flat Fee' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Flat Fee',
			sum(if (customer_type = 'Paid' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Paid',

			sum(if (customer_type = 'Free' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Created Free',
			sum(if (customer_type = 'Flat Fee' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Created Flat Fee',
			sum(if (customer_type = 'Paid' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Created Paid',

			sum(if (customer_type = 'Free' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Free',
			sum(if (customer_type = 'Flat Fee' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Flat Fee',
			sum(if (customer_type = 'Paid' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Paid',

			sum(if (customer_type = 'Free' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Free',
			sum(if (customer_type = 'Flat Fee' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Flat Fee',
			sum(if (customer_type = 'Paid' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Paid',

			sum(if (customer_type = 'Free' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Free',
			sum(if (customer_type = 'Flat Fee' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Flat Fee',
			sum(if (customer_type = 'Paid' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Paid'
    FROM
        (SELECT 
        customer_type,
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
                WHEN
                    IFNULL(shipping_surcharge, 0) = 0
                        AND IFNULL(shipping_amount, 0) = 0
                THEN
                    'Free'
                WHEN IFNULL(shipping_amount, 0) = 0 THEN 'Flat Fee'
                ELSE 'Paid'
            END 'customer_type',
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
    HAVING pass = 1 AND (bu = 'MA' OR bu = 'DB')) result
    GROUP BY customer_type , created_at , shipped_at , delivered_at , failed_at) result
    LEFT JOIN period_cust pd ON (pd.period = result.created_at
        OR pd.period = result.shipped_at
        OR pd.period = result.delivered_at
        OR pd.period = result.failed_at)
    GROUP BY pd.period) result;

DROP PROCEDURE load_date_cust;

DROP TEMPORARY TABLE period_cust;