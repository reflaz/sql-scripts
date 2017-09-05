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
SET @extractstart = '2017-07-01';
SET @extractend = '2017-07-28';-- This MUST be D + 1

CREATE TEMPORARY TABLE period_bu (
   `period` DATETIME NOT NULL,
   KEY (period)
);

delimiter //
CREATE PROCEDURE load_date_bu()
BEGIN
	SET @start_loop_bu = @extractstart;
	WHILE @start_loop_bu < @extractend DO
		INSERT INTO period_bu VALUES (@start_loop_bu);
        SET @start_loop_bu = DATE_ADD(@start_loop_bu, INTERVAL 1 DAY);
	END WHILE;
END //
delimiter ;

CALL load_date_bu;

SELECT 
    *
FROM
    (SELECT 
        period,
            SUM(IF(bu = 'MA' AND created_at = period, nmv, 0)) 'NMV MA Created',
            SUM(IF(bu = 'DB' AND created_at = period, nmv, 0)) 'NMV DB Created',
            SUM(IF(bu = 'CB' AND created_at = period, nmv, 0)) 'NMV CB Created',
            SUM(IF(bu = 'Retail' AND created_at = period, nmv, 0)) 'NMV Retail Created',
            SUM(IF(bu = 'Digital' AND created_at = period, nmv, 0)) 'NMV Digital Created',
            
            
            SUM(IF(bu = 'MA' AND shipped_at = period, nmv, 0)) 'NMV Shipped MA',
            SUM(IF(bu = 'DB' AND shipped_at = period, nmv, 0)) 'NMV Shipped DB',
            SUM(IF(bu = 'CB' AND shipped_at = period, nmv, 0)) 'NMV Shipped CB',
            SUM(IF(bu = 'Retail' AND shipped_at = period, nmv, 0)) 'NMV Shipped Retail',
            SUM(IF(bu = 'Digital' AND shipped_at = period, nmv, 0)) 'NMV Shipped Digital',
            
            
            SUM(IF(bu = 'MA' AND delivered_at = period, nmv, 0)) 'NMV Delivered MA',
            SUM(IF(bu = 'DB' AND delivered_at = period, nmv, 0)) 'NMV Delivered DB',
            SUM(IF(bu = 'CB' AND delivered_at = period, nmv, 0)) 'NMV Delivered CB',
            SUM(IF(bu = 'Retail' AND delivered_at = period, nmv, 0)) 'NMV Delivered Retail',
            SUM(IF(bu = 'Digital' AND delivered_at = period, nmv, 0)) 'NMV Delivered Digital',
            
            
            SUM(IF(bu = 'MA' AND failed_at = period, nmv, 0)) 'NMV Failed MA',
            SUM(IF(bu = 'DB' AND failed_at = period, nmv, 0)) 'NMV Failed DB',
            SUM(IF(bu = 'CB' AND failed_at = period, nmv, 0)) 'NMV Failed CB',
            SUM(IF(bu = 'Retail' AND failed_at = period, nmv, 0)) 'NMV Failed Retail',
            SUM(IF(bu = 'Digital' AND failed_at = period, nmv, 0)) 'NMV Failed Digital',
            
            
            SUM(IF(bu = 'MA' AND created_at = period, orders, 0)) 'Orders MA Created',
            SUM(IF(bu = 'DB' AND created_at = period, orders, 0)) 'Orders DB Created',
            SUM(IF(bu = 'CB' AND created_at = period, orders, 0)) 'Orders CB Created',
            SUM(IF(bu = 'Retail' AND created_at = period, orders, 0)) 'Orders Retail Created',
            SUM(IF(bu = 'Digital' AND created_at = period, orders, 0)) 'Orders Digital Created',
            
            
            SUM(IF(bu = 'MA' AND shipped_at = period, orders, 0)) 'Orders Shipped MA',
            SUM(IF(bu = 'DB' AND shipped_at = period, orders, 0)) 'Orders Shipped DB',
            SUM(IF(bu = 'CB' AND shipped_at = period, orders, 0)) 'Orders Shipped CB',
            SUM(IF(bu = 'Retail' AND shipped_at = period, orders, 0)) 'Orders Shipped Retail',
            SUM(IF(bu = 'Digital' AND shipped_at = period, orders, 0)) 'Orders Shipped Digital',
            
            
            SUM(IF(bu = 'MA' AND delivered_at = period, orders, 0)) 'Orders Delivered MA',
            SUM(IF(bu = 'DB' AND delivered_at = period, orders, 0)) 'Orders Delivered DB',
            SUM(IF(bu = 'CB' AND delivered_at = period, orders, 0)) 'Orders Delivered CB',
            SUM(IF(bu = 'Retail' AND delivered_at = period, orders, 0)) 'Orders Delivered Retail',
            SUM(IF(bu = 'Digital' AND delivered_at = period, orders, 0)) 'Orders Delivered Digital',
            
            
            SUM(IF(bu = 'MA' AND failed_at = period, orders, 0)) 'Orders Failed MA',
            SUM(IF(bu = 'DB' AND failed_at = period, orders, 0)) 'Orders Failed DB',
            SUM(IF(bu = 'CB' AND failed_at = period, orders, 0)) 'Orders Failed CB',
            SUM(IF(bu = 'Retail' AND failed_at = period, orders, 0)) 'Orders Failed Retail',
            SUM(IF(bu = 'Digital' AND failed_at = period, orders, 0)) 'Orders Failed Digital',
            
            
            SUM(IF(bu = 'MA' AND created_at = period, item, 0)) 'Items MA Created',
            SUM(IF(bu = 'DB' AND created_at = period, item, 0)) 'Items DB Created',
            SUM(IF(bu = 'CB' AND created_at = period, item, 0)) 'Items CB Created',
            SUM(IF(bu = 'Retail' AND created_at = period, item, 0)) 'Items Retail Created',
            SUM(IF(bu = 'Digital' AND created_at = period, item, 0)) 'Items Digital Created',
            
            
            SUM(IF(bu = 'MA' AND shipped_at = period, item, 0)) 'Items Shipped MA',
            SUM(IF(bu = 'DB' AND shipped_at = period, item, 0)) 'Items Shipped DB',
            SUM(IF(bu = 'CB' AND shipped_at = period, item, 0)) 'Items Shipped CB',
            SUM(IF(bu = 'Retail' AND shipped_at = period, item, 0)) 'Items Shipped Retail',
            SUM(IF(bu = 'Digital' AND shipped_at = period, item, 0)) 'Items Shipped Digital',
            
            
            SUM(IF(bu = 'MA' AND delivered_at = period, item, 0)) 'Items Delivered MA',
            SUM(IF(bu = 'DB' AND delivered_at = period, item, 0)) 'Items Delivered DB',
            SUM(IF(bu = 'CB' AND delivered_at = period, item, 0)) 'Items Delivered CB',
            SUM(IF(bu = 'Retail' AND delivered_at = period, item, 0)) 'Items Delivered Retail',
            SUM(IF(bu = 'Digital' AND delivered_at = period, item, 0)) 'Items Delivered Digital',
            
            
            SUM(IF(bu = 'MA' AND failed_at = period, item, 0)) 'Items Failed MA',
            SUM(IF(bu = 'DB' AND failed_at = period, item, 0)) 'Items Failed DB',
            SUM(IF(bu = 'CB' AND failed_at = period, item, 0)) 'Items Failed CB',
            SUM(IF(bu = 'Retail' AND failed_at = period, item, 0)) 'Items Failed Retail',
            SUM(IF(bu = 'Digital' AND failed_at = period, item, 0)) 'Items Failed Digital',
            
            
            SUM(IF(bu = 'MA' AND created_at = period, parcels, 0)) 'Parcels MA Created',
            SUM(IF(bu = 'DB' AND created_at = period, parcels, 0)) 'Parcels DB Created',
            SUM(IF(bu = 'CB' AND created_at = period, parcels, 0)) 'Parcels CB Created',
            SUM(IF(bu = 'Retail' AND created_at = period, parcels, 0)) 'Parcels Retail Created',
            SUM(IF(bu = 'Digital' AND created_at = period, parcels, 0)) 'Parcels Digital Created',
            
            
            SUM(IF(bu = 'MA' AND shipped_at = period, parcels, 0)) 'Parcels Shipped MA',
            SUM(IF(bu = 'DB' AND shipped_at = period, parcels, 0)) 'Parcels Shipped DB',
            SUM(IF(bu = 'CB' AND shipped_at = period, parcels, 0)) 'Parcels Shipped CB',
            SUM(IF(bu = 'Retail' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Retail',
            SUM(IF(bu = 'Digital' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Digital',
            
            
            SUM(IF(bu = 'MA' AND delivered_at = period, parcels, 0)) 'Parcels Delivered MA',
            SUM(IF(bu = 'DB' AND delivered_at = period, parcels, 0)) 'Parcels Delivered DB',
            SUM(IF(bu = 'CB' AND delivered_at = period, parcels, 0)) 'Parcels Delivered CB',
            SUM(IF(bu = 'Retail' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Retail',
            SUM(IF(bu = 'Digital' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Digital',
            
            
            SUM(IF(bu = 'MA' AND failed_at = period, parcels, 0)) 'Parcels Failed MA',
            SUM(IF(bu = 'DB' AND failed_at = period, parcels, 0)) 'Parcels Failed DB',
            SUM(IF(bu = 'CB' AND failed_at = period, parcels, 0)) 'Parcels Failed CB',
            SUM(IF(bu = 'Retail' AND failed_at = period, parcels, 0)) 'Parcels Failed Retail',
            SUM(IF(bu = 'Digital' AND failed_at = period, parcels, 0)) 'Parcels Failed Digital',
            
            
            SUM(IF(bu = 'MA' AND created_at = period, weight, 0)) 'Weight MA Created',
            SUM(IF(bu = 'DB' AND created_at = period, weight, 0)) 'Weight DB Created',
            SUM(IF(bu = 'CB' AND created_at = period, weight, 0)) 'Weight CB Created',
            SUM(IF(bu = 'Retail' AND created_at = period, weight, 0)) 'Weight Retail Created',
            SUM(IF(bu = 'Digital' AND created_at = period, weight, 0)) 'Weight Digital Created',
            
            
            SUM(IF(bu = 'MA' AND shipped_at = period, weight, 0)) 'Weight Shipped MA',
            SUM(IF(bu = 'DB' AND shipped_at = period, weight, 0)) 'Weight Shipped DB',
            SUM(IF(bu = 'CB' AND shipped_at = period, weight, 0)) 'Weight Shipped CB',
            SUM(IF(bu = 'Retail' AND shipped_at = period, weight, 0)) 'Weight Shipped Retail',
            SUM(IF(bu = 'Digital' AND shipped_at = period, weight, 0)) 'Weight Shipped Digital',
            
            
            SUM(IF(bu = 'MA' AND delivered_at = period, weight, 0)) 'Weight Delivered MA',
            SUM(IF(bu = 'DB' AND delivered_at = period, weight, 0)) 'Weight Delivered DB',
            SUM(IF(bu = 'CB' AND delivered_at = period, weight, 0)) 'Weight Delivered CB',
            SUM(IF(bu = 'Retail' AND delivered_at = period, weight, 0)) 'Weight Delivered Retail',
            SUM(IF(bu = 'Digital' AND delivered_at = period, weight, 0)) 'Weight Delivered Digital',
            
            
            SUM(IF(bu = 'MA' AND failed_at = period, weight, 0)) 'Weight Failed MA',
            SUM(IF(bu = 'DB' AND failed_at = period, weight, 0)) 'Weight Failed DB',
            SUM(IF(bu = 'CB' AND failed_at = period, weight, 0)) 'Weight Failed CB',
            SUM(IF(bu = 'Retail' AND failed_at = period, weight, 0)) 'Weight Failed Retail',
            SUM(IF(bu = 'Digital' AND failed_at = period, weight, 0)) 'Weight Failed Digital',
            
            
            SUM(IF(bu = 'MA' AND created_at = period, chargable_weight, 0)) 'Chargable Weight MA Created',
            SUM(IF(bu = 'DB' AND created_at = period, chargable_weight, 0)) 'Chargable Weight DB Created',
            SUM(IF(bu = 'CB' AND created_at = period, chargable_weight, 0)) 'Chargable Weight CB Created',
            SUM(IF(bu = 'Retail' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Retail Created',
            SUM(IF(bu = 'Digital' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Digital Created',
            
            
            SUM(IF(bu = 'MA' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped MA',
            SUM(IF(bu = 'DB' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped DB',
            SUM(IF(bu = 'CB' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped CB',
            SUM(IF(bu = 'Retail' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped Retail',
            SUM(IF(bu = 'Digital' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped Digital',
            
            
            SUM(IF(bu = 'MA' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered MA',
            SUM(IF(bu = 'DB' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered DB',
            SUM(IF(bu = 'CB' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered CB',
            SUM(IF(bu = 'Retail' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered Retail',
            SUM(IF(bu = 'Digital' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered Digital',
            
            
            SUM(IF(bu = 'MA' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed MA',
            SUM(IF(bu = 'DB' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed DB',
            SUM(IF(bu = 'CB' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed CB',
            SUM(IF(bu = 'Retail' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed Retail',
            SUM(IF(bu = 'Digital' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed Digital',
            
            
            SUM(IF(bu = 'MA' AND created_at = period, seller_charges, 0)) 'Seller Charges MA Created',
            SUM(IF(bu = 'DB' AND created_at = period, seller_charges, 0)) 'Seller Charges DB Created',
            SUM(IF(bu = 'CB' AND created_at = period, seller_charges, 0)) 'Seller Charges CB Created',
            SUM(IF(bu = 'Retail' AND created_at = period, seller_charges, 0)) 'Seller Charges Retail Created',
            SUM(IF(bu = 'Digital' AND created_at = period, seller_charges, 0)) 'Seller Charges Digital Created',
            
            
            SUM(IF(bu = 'MA' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped MA',
            SUM(IF(bu = 'DB' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped DB',
            SUM(IF(bu = 'CB' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped CB',
            SUM(IF(bu = 'Retail' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Retail',
            SUM(IF(bu = 'Digital' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Digital',
            
            
            SUM(IF(bu = 'MA' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered MA',
            SUM(IF(bu = 'DB' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered DB',
            SUM(IF(bu = 'CB' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered CB',
            SUM(IF(bu = 'Retail' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Retail',
            SUM(IF(bu = 'Digital' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Digital',
            
            
            SUM(IF(bu = 'MA' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed MA',
            SUM(IF(bu = 'DB' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed DB',
            SUM(IF(bu = 'CB' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed CB',
            SUM(IF(bu = 'Retail' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Retail',
            SUM(IF(bu = 'Digital' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Digital',
            
            
            SUM(IF(bu = 'MA' AND created_at = period, customer_charges, 0)) 'Customer Charges MA Created',
            SUM(IF(bu = 'DB' AND created_at = period, customer_charges, 0)) 'Customer Charges DB Created',
            SUM(IF(bu = 'CB' AND created_at = period, customer_charges, 0)) 'Customer Charges CB Created',
            SUM(IF(bu = 'Retail' AND created_at = period, customer_charges, 0)) 'Customer Charges Retail Created',
            SUM(IF(bu = 'Digital' AND created_at = period, customer_charges, 0)) 'Customer Charges Digital Created',
            
            
            SUM(IF(bu = 'MA' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped MA',
            SUM(IF(bu = 'DB' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped DB',
            SUM(IF(bu = 'CB' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped CB',
            SUM(IF(bu = 'Retail' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Retail',
            SUM(IF(bu = 'Digital' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Digital',
            
            
            SUM(IF(bu = 'MA' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered MA',
            SUM(IF(bu = 'DB' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered DB',
            SUM(IF(bu = 'CB' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered CB',
            SUM(IF(bu = 'Retail' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Retail',
            SUM(IF(bu = 'Digital' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Digital',
            
            
            SUM(IF(bu = 'MA' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed MA',
            SUM(IF(bu = 'DB' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed DB',
            SUM(IF(bu = 'CB' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed CB',
            SUM(IF(bu = 'Retail' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Retail',
            SUM(IF(bu = 'Digital' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Digital',
            
            
            SUM(IF(bu = 'MA' AND created_at = period, delivery_cost, 0)) 'Delivery Cost MA Created',
            SUM(IF(bu = 'DB' AND created_at = period, delivery_cost, 0)) 'Delivery Cost DB Created',
            SUM(IF(bu = 'CB' AND created_at = period, delivery_cost, 0)) 'Delivery Cost CB Created',
            SUM(IF(bu = 'Retail' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Retail Created',
            SUM(IF(bu = 'Digital' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Digital Created',
            
            
            SUM(IF(bu = 'MA' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped MA',
            SUM(IF(bu = 'DB' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped DB',
            SUM(IF(bu = 'CB' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped CB',
            SUM(IF(bu = 'Retail' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Retail',
            SUM(IF(bu = 'Digital' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Digital',
            
            
            SUM(IF(bu = 'MA' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered MA',
            SUM(IF(bu = 'DB' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered DB',
            SUM(IF(bu = 'CB' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered CB',
            SUM(IF(bu = 'Retail' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Retail',
            SUM(IF(bu = 'Digital' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Digital',
            
            
            SUM(IF(bu = 'MA' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed MA',
            SUM(IF(bu = 'DB' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed DB',
            SUM(IF(bu = 'CB' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed CB',
            SUM(IF(bu = 'Retail' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Retail',
            SUM(IF(bu = 'Digital' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Digital',
            
            
            SUM(IF(bu = 'MA' AND created_at = period, pickup_cost, 0)) 'Pickup Cost MA Created',
            SUM(IF(bu = 'DB' AND created_at = period, pickup_cost, 0)) 'Pickup Cost DB Created',
            SUM(IF(bu = 'CB' AND created_at = period, pickup_cost, 0)) 'Pickup Cost CB Created',
            SUM(IF(bu = 'Retail' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Retail Created',
            SUM(IF(bu = 'Digital' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Digital Created',
            
            
            SUM(IF(bu = 'MA' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped MA',
            SUM(IF(bu = 'DB' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped DB',
            SUM(IF(bu = 'CB' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped CB',
            SUM(IF(bu = 'Retail' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Retail',
            SUM(IF(bu = 'Digital' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Digital',
            
            
            SUM(IF(bu = 'MA' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered MA',
            SUM(IF(bu = 'DB' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered DB',
            SUM(IF(bu = 'CB' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered CB',
            SUM(IF(bu = 'Retail' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Retail',
            SUM(IF(bu = 'Digital' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Digital',
            
            
            SUM(IF(bu = 'MA' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed MA',
            SUM(IF(bu = 'DB' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed DB',
            SUM(IF(bu = 'CB' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed CB',
            SUM(IF(bu = 'Retail' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Retail',
            SUM(IF(bu = 'Digital' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Digital'
    FROM
        (SELECT 
        bu,
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
    HAVING pass = 1) result
    GROUP BY bu , created_at , shipped_at , delivered_at , failed_at) result
    LEFT JOIN period_bu pd ON (pd.period = result.created_at
        OR pd.period = result.shipped_at
        OR pd.period = result.delivered_at
        OR pd.period = result.failed_at)
    GROUP BY pd.period) result;

DROP PROCEDURE load_date_bu;

DROP TEMPORARY TABLE period_bu;