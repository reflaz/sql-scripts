/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SCGL Key Metrics by Seller Chargeable Weight

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

CREATE TEMPORARY TABLE period_cw (
   `period` DATETIME NOT NULL,
   KEY (period)
);

delimiter //
CREATE PROCEDURE load_date_cw()
BEGIN
	SET @start_loop_cw = @extractstart;
	WHILE @start_loop_cw < @extractend DO
		INSERT INTO period_cw VALUES (@start_loop_cw);
        SET @start_loop_cw = DATE_ADD(@start_loop_cw, INTERVAL 1 DAY);
	END WHILE;
END //
delimiter ;

CALL load_date_cw;

SELECT 
    *
FROM
    (SELECT 
        period,
            sum(if (cw = 0 AND  created_at = period, nmv, 0)) 'NMV Created 0Kg',
			sum(if (cw = 1 AND  created_at = period, nmv, 0)) 'NMV Created 1Kg',
			sum(if (cw = 2 AND  created_at = period, nmv, 0)) 'NMV Created 2Kg',
			sum(if (cw = 3 AND  created_at = period, nmv, 0)) 'NMV Created 3Kg',
			sum(if (cw = 5 AND  created_at = period, nmv, 0)) 'NMV Created 5Kg',
			sum(if (cw = 10 AND  created_at = period, nmv, 0)) 'NMV Created 10Kg',
			
			sum(if (cw = 0 AND  shipped_at = period, nmv, 0)) 'NMV Shipped 0Kg',
			sum(if (cw = 1 AND  shipped_at = period, nmv, 0)) 'NMV Shipped 1Kg',
			sum(if (cw = 2 AND  shipped_at = period, nmv, 0)) 'NMV Shipped 2Kg',
			sum(if (cw = 3 AND  shipped_at = period, nmv, 0)) 'NMV Shipped 3Kg',
			sum(if (cw = 5 AND  shipped_at = period, nmv, 0)) 'NMV Shipped 5Kg',
			sum(if (cw = 10 AND  shipped_at = period, nmv, 0)) 'NMV Shipped 10Kg',
			
			sum(if (cw = 0 AND  delivered_at = period, nmv, 0)) 'NMV Delivered 0Kg',
			sum(if (cw = 1 AND  delivered_at = period, nmv, 0)) 'NMV Delivered 1Kg',
			sum(if (cw = 2 AND  delivered_at = period, nmv, 0)) 'NMV Delivered 2Kg',
			sum(if (cw = 3 AND  delivered_at = period, nmv, 0)) 'NMV Delivered 3Kg',
			sum(if (cw = 5 AND  delivered_at = period, nmv, 0)) 'NMV Delivered 5Kg',
			sum(if (cw = 10 AND  delivered_at = period, nmv, 0)) 'NMV Delivered 10Kg',
			
			sum(if (cw = 0 AND  failed_at = period, nmv, 0)) 'NMV Failed 0Kg',
			sum(if (cw = 1 AND  failed_at = period, nmv, 0)) 'NMV Failed 1Kg',
			sum(if (cw = 2 AND  failed_at = period, nmv, 0)) 'NMV Failed 2Kg',
			sum(if (cw = 3 AND  failed_at = period, nmv, 0)) 'NMV Failed 3Kg',
			sum(if (cw = 5 AND  failed_at = period, nmv, 0)) 'NMV Failed 5Kg',
			sum(if (cw = 10 AND  failed_at = period, nmv, 0)) 'NMV Failed 10Kg',
			
			sum(if (cw = 0 AND  created_at = period, orders, 0)) 'Orders Created 0Kg',
			sum(if (cw = 1 AND  created_at = period, orders, 0)) 'Orders Created 1Kg',
			sum(if (cw = 2 AND  created_at = period, orders, 0)) 'Orders Created 2Kg',
			sum(if (cw = 3 AND  created_at = period, orders, 0)) 'Orders Created 3Kg',
			sum(if (cw = 5 AND  created_at = period, orders, 0)) 'Orders Created 5Kg',
			sum(if (cw = 10 AND  created_at = period, orders, 0)) 'Orders Created 10Kg',
			
			sum(if (cw = 0 AND  shipped_at = period, orders, 0)) 'Orders Shipped 0Kg',
			sum(if (cw = 1 AND  shipped_at = period, orders, 0)) 'Orders Shipped 1Kg',
			sum(if (cw = 2 AND  shipped_at = period, orders, 0)) 'Orders Shipped 2Kg',
			sum(if (cw = 3 AND  shipped_at = period, orders, 0)) 'Orders Shipped 3Kg',
			sum(if (cw = 5 AND  shipped_at = period, orders, 0)) 'Orders Shipped 5Kg',
			sum(if (cw = 10 AND  shipped_at = period, orders, 0)) 'Orders Shipped 10Kg',
			
			sum(if (cw = 0 AND  delivered_at = period, orders, 0)) 'Orders Delivered 0Kg',
			sum(if (cw = 1 AND  delivered_at = period, orders, 0)) 'Orders Delivered 1Kg',
			sum(if (cw = 2 AND  delivered_at = period, orders, 0)) 'Orders Delivered 2Kg',
			sum(if (cw = 3 AND  delivered_at = period, orders, 0)) 'Orders Delivered 3Kg',
			sum(if (cw = 5 AND  delivered_at = period, orders, 0)) 'Orders Delivered 5Kg',
			sum(if (cw = 10 AND  delivered_at = period, orders, 0)) 'Orders Delivered 10Kg',
			
			sum(if (cw = 0 AND  failed_at = period, orders, 0)) 'Orders Failed 0Kg',
			sum(if (cw = 1 AND  failed_at = period, orders, 0)) 'Orders Failed 1Kg',
			sum(if (cw = 2 AND  failed_at = period, orders, 0)) 'Orders Failed 2Kg',
			sum(if (cw = 3 AND  failed_at = period, orders, 0)) 'Orders Failed 3Kg',
			sum(if (cw = 5 AND  failed_at = period, orders, 0)) 'Orders Failed 5Kg',
			sum(if (cw = 10 AND  failed_at = period, orders, 0)) 'Orders Failed 10Kg',
			
			sum(if (cw = 0 AND  created_at = period, item, 0)) 'Items Created 0Kg',
			sum(if (cw = 1 AND  created_at = period, item, 0)) 'Items Created 1Kg',
			sum(if (cw = 2 AND  created_at = period, item, 0)) 'Items Created 2Kg',
			sum(if (cw = 3 AND  created_at = period, item, 0)) 'Items Created 3Kg',
			sum(if (cw = 5 AND  created_at = period, item, 0)) 'Items Created 5Kg',
			sum(if (cw = 10 AND  created_at = period, item, 0)) 'Items Created 10Kg',
			
			sum(if (cw = 0 AND  shipped_at = period, item, 0)) 'Items Shipped 0Kg',
			sum(if (cw = 1 AND  shipped_at = period, item, 0)) 'Items Shipped 1Kg',
			sum(if (cw = 2 AND  shipped_at = period, item, 0)) 'Items Shipped 2Kg',
			sum(if (cw = 3 AND  shipped_at = period, item, 0)) 'Items Shipped 3Kg',
			sum(if (cw = 5 AND  shipped_at = period, item, 0)) 'Items Shipped 5Kg',
			sum(if (cw = 10 AND  shipped_at = period, item, 0)) 'Items Shipped 10Kg',
			
			sum(if (cw = 0 AND  delivered_at = period, item, 0)) 'Items Delivered 0Kg',
			sum(if (cw = 1 AND  delivered_at = period, item, 0)) 'Items Delivered 1Kg',
			sum(if (cw = 2 AND  delivered_at = period, item, 0)) 'Items Delivered 2Kg',
			sum(if (cw = 3 AND  delivered_at = period, item, 0)) 'Items Delivered 3Kg',
			sum(if (cw = 5 AND  delivered_at = period, item, 0)) 'Items Delivered 5Kg',
			sum(if (cw = 10 AND  delivered_at = period, item, 0)) 'Items Delivered 10Kg',
			
			sum(if (cw = 0 AND  failed_at = period, item, 0)) 'Items Failed 0Kg',
			sum(if (cw = 1 AND  failed_at = period, item, 0)) 'Items Failed 1Kg',
			sum(if (cw = 2 AND  failed_at = period, item, 0)) 'Items Failed 2Kg',
			sum(if (cw = 3 AND  failed_at = period, item, 0)) 'Items Failed 3Kg',
			sum(if (cw = 5 AND  failed_at = period, item, 0)) 'Items Failed 5Kg',
			sum(if (cw = 10 AND  failed_at = period, item, 0)) 'Items Failed 10Kg',
			
			sum(if (cw = 0 AND  created_at = period, parcels, 0)) 'Parcels Created 0Kg',
			sum(if (cw = 1 AND  created_at = period, parcels, 0)) 'Parcels Created 1Kg',
			sum(if (cw = 2 AND  created_at = period, parcels, 0)) 'Parcels Created 2Kg',
			sum(if (cw = 3 AND  created_at = period, parcels, 0)) 'Parcels Created 3Kg',
			sum(if (cw = 5 AND  created_at = period, parcels, 0)) 'Parcels Created 5Kg',
			sum(if (cw = 10 AND  created_at = period, parcels, 0)) 'Parcels Created 10Kg',
			
			sum(if (cw = 0 AND  shipped_at = period, parcels, 0)) 'Parcels Shipped 0Kg',
			sum(if (cw = 1 AND  shipped_at = period, parcels, 0)) 'Parcels Shipped 1Kg',
			sum(if (cw = 2 AND  shipped_at = period, parcels, 0)) 'Parcels Shipped 2Kg',
			sum(if (cw = 3 AND  shipped_at = period, parcels, 0)) 'Parcels Shipped 3Kg',
			sum(if (cw = 5 AND  shipped_at = period, parcels, 0)) 'Parcels Shipped 5Kg',
			sum(if (cw = 10 AND  shipped_at = period, parcels, 0)) 'Parcels Shipped 10Kg',
			
			sum(if (cw = 0 AND  delivered_at = period, parcels, 0)) 'Parcels Delivered 0Kg',
			sum(if (cw = 1 AND  delivered_at = period, parcels, 0)) 'Parcels Delivered 1Kg',
			sum(if (cw = 2 AND  delivered_at = period, parcels, 0)) 'Parcels Delivered 2Kg',
			sum(if (cw = 3 AND  delivered_at = period, parcels, 0)) 'Parcels Delivered 3Kg',
			sum(if (cw = 5 AND  delivered_at = period, parcels, 0)) 'Parcels Delivered 5Kg',
			sum(if (cw = 10 AND  delivered_at = period, parcels, 0)) 'Parcels Delivered 10Kg',
			
			sum(if (cw = 0 AND  failed_at = period, parcels, 0)) 'Parcels Failed 0Kg',
			sum(if (cw = 1 AND  failed_at = period, parcels, 0)) 'Parcels Failed 1Kg',
			sum(if (cw = 2 AND  failed_at = period, parcels, 0)) 'Parcels Failed 2Kg',
			sum(if (cw = 3 AND  failed_at = period, parcels, 0)) 'Parcels Failed 3Kg',
			sum(if (cw = 5 AND  failed_at = period, parcels, 0)) 'Parcels Failed 5Kg',
			sum(if (cw = 10 AND  failed_at = period, parcels, 0)) 'Parcels Failed 10Kg',
			
			sum(if (cw = 0 AND  created_at = period, weight, 0)) 'Weight Created 0Kg',
			sum(if (cw = 1 AND  created_at = period, weight, 0)) 'Weight Created 1Kg',
			sum(if (cw = 2 AND  created_at = period, weight, 0)) 'Weight Created 2Kg',
			sum(if (cw = 3 AND  created_at = period, weight, 0)) 'Weight Created 3Kg',
			sum(if (cw = 5 AND  created_at = period, weight, 0)) 'Weight Created 5Kg',
			sum(if (cw = 10 AND  created_at = period, weight, 0)) 'Weight Created 10Kg',
			
			sum(if (cw = 0 AND  shipped_at = period, weight, 0)) 'Weight Shipped 0Kg',
			sum(if (cw = 1 AND  shipped_at = period, weight, 0)) 'Weight Shipped 1Kg',
			sum(if (cw = 2 AND  shipped_at = period, weight, 0)) 'Weight Shipped 2Kg',
			sum(if (cw = 3 AND  shipped_at = period, weight, 0)) 'Weight Shipped 3Kg',
			sum(if (cw = 5 AND  shipped_at = period, weight, 0)) 'Weight Shipped 5Kg',
			sum(if (cw = 10 AND  shipped_at = period, weight, 0)) 'Weight Shipped 10Kg',
			
			sum(if (cw = 0 AND  delivered_at = period, weight, 0)) 'Weight Delivered 0Kg',
			sum(if (cw = 1 AND  delivered_at = period, weight, 0)) 'Weight Delivered 1Kg',
			sum(if (cw = 2 AND  delivered_at = period, weight, 0)) 'Weight Delivered 2Kg',
			sum(if (cw = 3 AND  delivered_at = period, weight, 0)) 'Weight Delivered 3Kg',
			sum(if (cw = 5 AND  delivered_at = period, weight, 0)) 'Weight Delivered 5Kg',
			sum(if (cw = 10 AND  delivered_at = period, weight, 0)) 'Weight Delivered 10Kg',
			
			sum(if (cw = 0 AND  failed_at = period, weight, 0)) 'Weight Failed 0Kg',
			sum(if (cw = 1 AND  failed_at = period, weight, 0)) 'Weight Failed 1Kg',
			sum(if (cw = 2 AND  failed_at = period, weight, 0)) 'Weight Failed 2Kg',
			sum(if (cw = 3 AND  failed_at = period, weight, 0)) 'Weight Failed 3Kg',
			sum(if (cw = 5 AND  failed_at = period, weight, 0)) 'Weight Failed 5Kg',
			sum(if (cw = 10 AND  failed_at = period, weight, 0)) 'Weight Failed 10Kg',

			sum(if (cw = 0 AND  created_at = period, chargable_weight, 0)) 'Chargable Weight Created 0Kg',
			sum(if (cw = 1 AND  created_at = period, chargable_weight, 0)) 'Chargable Weight Created 1Kg',
			sum(if (cw = 2 AND  created_at = period, chargable_weight, 0)) 'Chargable Weight Created 2Kg',
			sum(if (cw = 3 AND  created_at = period, chargable_weight, 0)) 'Chargable Weight Created 3Kg',
			sum(if (cw = 5 AND  created_at = period, chargable_weight, 0)) 'Chargable Weight Created 5Kg',
			sum(if (cw = 10 AND  created_at = period, chargable_weight, 0)) 'Chargable Weight Created 10Kg',
			
			sum(if (cw = 0 AND  shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped 0Kg',
			sum(if (cw = 1 AND  shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped 1Kg',
			sum(if (cw = 2 AND  shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped 2Kg',
			sum(if (cw = 3 AND  shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped 3Kg',
			sum(if (cw = 5 AND  shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped 5Kg',
			sum(if (cw = 10 AND  shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped 10Kg',
			
			sum(if (cw = 0 AND  delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered 0Kg',
			sum(if (cw = 1 AND  delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered 1Kg',
			sum(if (cw = 2 AND  delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered 2Kg',
			sum(if (cw = 3 AND  delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered 3Kg',
			sum(if (cw = 5 AND  delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered 5Kg',
			sum(if (cw = 10 AND  delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered 10Kg',
			
			sum(if (cw = 0 AND  failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed 0Kg',
			sum(if (cw = 1 AND  failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed 1Kg',
			sum(if (cw = 2 AND  failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed 2Kg',
			sum(if (cw = 3 AND  failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed 3Kg',
			sum(if (cw = 5 AND  failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed 5Kg',
			sum(if (cw = 10 AND  failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed 10Kg',

			sum(if (cw = 0 AND  created_at = period, seller_charges, 0)) 'Seller Charges Created 0Kg',
			sum(if (cw = 1 AND  created_at = period, seller_charges, 0)) 'Seller Charges Created 1Kg',
			sum(if (cw = 2 AND  created_at = period, seller_charges, 0)) 'Seller Charges Created 2Kg',
			sum(if (cw = 3 AND  created_at = period, seller_charges, 0)) 'Seller Charges Created 3Kg',
			sum(if (cw = 5 AND  created_at = period, seller_charges, 0)) 'Seller Charges Created 5Kg',
			sum(if (cw = 10 AND  created_at = period, seller_charges, 0)) 'Seller Charges Created 10Kg',
			
			sum(if (cw = 0 AND  shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped 0Kg',
			sum(if (cw = 1 AND  shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped 1Kg',
			sum(if (cw = 2 AND  shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped 2Kg',
			sum(if (cw = 3 AND  shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped 3Kg',
			sum(if (cw = 5 AND  shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped 5Kg',
			sum(if (cw = 10 AND  shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped 10Kg',
			
			sum(if (cw = 0 AND  delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered 0Kg',
			sum(if (cw = 1 AND  delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered 1Kg',
			sum(if (cw = 2 AND  delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered 2Kg',
			sum(if (cw = 3 AND  delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered 3Kg',
			sum(if (cw = 5 AND  delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered 5Kg',
			sum(if (cw = 10 AND  delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered 10Kg',
			
			sum(if (cw = 0 AND  failed_at = period, seller_charges, 0)) 'Seller Charges Failed 0Kg',
			sum(if (cw = 1 AND  failed_at = period, seller_charges, 0)) 'Seller Charges Failed 1Kg',
			sum(if (cw = 2 AND  failed_at = period, seller_charges, 0)) 'Seller Charges Failed 2Kg',
			sum(if (cw = 3 AND  failed_at = period, seller_charges, 0)) 'Seller Charges Failed 3Kg',
			sum(if (cw = 5 AND  failed_at = period, seller_charges, 0)) 'Seller Charges Failed 5Kg',
			sum(if (cw = 10 AND  failed_at = period, seller_charges, 0)) 'Seller Charges Failed 10Kg',
			
			sum(if (cw = 0 AND  created_at = period, customer_charges, 0)) 'Customer Charges Created 0Kg',
			sum(if (cw = 1 AND  created_at = period, customer_charges, 0)) 'Customer Charges Created 1Kg',
			sum(if (cw = 2 AND  created_at = period, customer_charges, 0)) 'Customer Charges Created 2Kg',
			sum(if (cw = 3 AND  created_at = period, customer_charges, 0)) 'Customer Charges Created 3Kg',
			sum(if (cw = 5 AND  created_at = period, customer_charges, 0)) 'Customer Charges Created 5Kg',
			sum(if (cw = 10 AND  created_at = period, customer_charges, 0)) 'Customer Charges Created 10Kg',
			
			sum(if (cw = 0 AND  shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped 0Kg',
			sum(if (cw = 1 AND  shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped 1Kg',
			sum(if (cw = 2 AND  shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped 2Kg',
			sum(if (cw = 3 AND  shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped 3Kg',
			sum(if (cw = 5 AND  shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped 5Kg',
			sum(if (cw = 10 AND  shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped 10Kg',
			
			sum(if (cw = 0 AND  delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered 0Kg',
			sum(if (cw = 1 AND  delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered 1Kg',
			sum(if (cw = 2 AND  delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered 2Kg',
			sum(if (cw = 3 AND  delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered 3Kg',
			sum(if (cw = 5 AND  delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered 5Kg',
			sum(if (cw = 10 AND  delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered 10Kg',
			
			sum(if (cw = 0 AND  failed_at = period, customer_charges, 0)) 'Customer Charges Failed 0Kg',
			sum(if (cw = 1 AND  failed_at = period, customer_charges, 0)) 'Customer Charges Failed 1Kg',
			sum(if (cw = 2 AND  failed_at = period, customer_charges, 0)) 'Customer Charges Failed 2Kg',
			sum(if (cw = 3 AND  failed_at = period, customer_charges, 0)) 'Customer Charges Failed 3Kg',
			sum(if (cw = 5 AND  failed_at = period, customer_charges, 0)) 'Customer Charges Failed 5Kg',
			sum(if (cw = 10 AND  failed_at = period, customer_charges, 0)) 'Customer Charges Failed 10Kg',

			sum(if (cw = 0 AND  created_at = period, delivery_cost, 0)) 'Delivery Cost Created 0Kg',
			sum(if (cw = 1 AND  created_at = period, delivery_cost, 0)) 'Delivery Cost Created 1Kg',
			sum(if (cw = 2 AND  created_at = period, delivery_cost, 0)) 'Delivery Cost Created 2Kg',
			sum(if (cw = 3 AND  created_at = period, delivery_cost, 0)) 'Delivery Cost Created 3Kg',
			sum(if (cw = 5 AND  created_at = period, delivery_cost, 0)) 'Delivery Cost Created 5Kg',
			sum(if (cw = 10 AND  created_at = period, delivery_cost, 0)) 'Delivery Cost Created 10Kg',
			
			sum(if (cw = 0 AND  shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped 0Kg',
			sum(if (cw = 1 AND  shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped 1Kg',
			sum(if (cw = 2 AND  shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped 2Kg',
			sum(if (cw = 3 AND  shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped 3Kg',
			sum(if (cw = 5 AND  shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped 5Kg',
			sum(if (cw = 10 AND  shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped 10Kg',
			
			sum(if (cw = 0 AND  delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered 0Kg',
			sum(if (cw = 1 AND  delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered 1Kg',
			sum(if (cw = 2 AND  delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered 2Kg',
			sum(if (cw = 3 AND  delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered 3Kg',
			sum(if (cw = 5 AND  delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered 5Kg',
			sum(if (cw = 10 AND  delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered 10Kg',
			
			sum(if (cw = 0 AND  failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed 0Kg',
			sum(if (cw = 1 AND  failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed 1Kg',
			sum(if (cw = 2 AND  failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed 2Kg',
			sum(if (cw = 3 AND  failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed 3Kg',
			sum(if (cw = 5 AND  failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed 5Kg',
			sum(if (cw = 10 AND  failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed 10Kg',

			sum(if (cw = 0 AND  created_at = period, pickup_cost, 0)) 'Pickup Cost Created 0Kg',
			sum(if (cw = 1 AND  created_at = period, pickup_cost, 0)) 'Pickup Cost Created 1Kg',
			sum(if (cw = 2 AND  created_at = period, pickup_cost, 0)) 'Pickup Cost Created 2Kg',
			sum(if (cw = 3 AND  created_at = period, pickup_cost, 0)) 'Pickup Cost Created 3Kg',
			sum(if (cw = 5 AND  created_at = period, pickup_cost, 0)) 'Pickup Cost Created 5Kg',
			sum(if (cw = 10 AND  created_at = period, pickup_cost, 0)) 'Pickup Cost Created 10Kg',
			
			sum(if (cw = 0 AND  shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped 0Kg',
			sum(if (cw = 1 AND  shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped 1Kg',
			sum(if (cw = 2 AND  shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped 2Kg',
			sum(if (cw = 3 AND  shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped 3Kg',
			sum(if (cw = 5 AND  shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped 5Kg',
			sum(if (cw = 10 AND  shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped 10Kg',
			
			sum(if (cw = 0 AND  delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered 0Kg',
			sum(if (cw = 1 AND  delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered 1Kg',
			sum(if (cw = 2 AND  delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered 2Kg',
			sum(if (cw = 3 AND  delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered 3Kg',
			sum(if (cw = 5 AND  delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered 5Kg',
			sum(if (cw = 10 AND  delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered 10Kg',
			
			sum(if (cw = 0 AND  failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed 0Kg',
			sum(if (cw = 1 AND  failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed 1Kg',
			sum(if (cw = 2 AND  failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed 2Kg',
			sum(if (cw = 3 AND  failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed 3Kg',
			sum(if (cw = 5 AND  failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed 5Kg',
			sum(if (cw = 10 AND  failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed 10Kg'
    FROM
        (SELECT 
        chargeable_weight_bucket 'cw',
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
                WHEN chargeable_weight_seller_ps <= 5 THEN chargeable_weight_seller_ps
                ELSE 10
            END 'chargeable_weight_bucket',
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
    HAVING pass = 1 AND (bu ='MA' OR bu = 'DB')) result
    GROUP BY chargeable_weight_bucket , created_at , shipped_at , delivered_at , failed_at) result
    LEFT JOIN period_cw pd ON (pd.period = result.created_at
        OR pd.period = result.shipped_at
        OR pd.period = result.delivered_at
        OR pd.period = result.failed_at)
    GROUP BY pd.period) result;

DROP PROCEDURE load_date_cw;

DROP TEMPORARY TABLE period_cw;