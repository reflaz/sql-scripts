/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SCGL Key Metrics by City Type

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

CREATE TEMPORARY TABLE period_zt (
   `period` DATETIME NOT NULL,
   KEY (period)
);

delimiter //
CREATE PROCEDURE load_date_zt()
BEGIN
	SET @start_loop_zt = @extractstart;
	WHILE @start_loop_zt < @extractend DO
		INSERT INTO period_zt VALUES (@start_loop_zt);
        SET @start_loop_zt = DATE_ADD(@start_loop_zt, INTERVAL 1 DAY);
	END WHILE;
END //
delimiter ;

CALL load_date_zt;

SELECT 
    *
FROM
    (SELECT 
        period,
			sum(if (zone_type = 'Jabodetabek' AND created_at = period, nmv, 0)) 'NMV Created Jabodetabek',
			sum(if (zone_type = 'Free district' AND created_at = period, nmv, 0)) 'NMV Created Free',
			sum(if (zone_type = 'Old paid district' AND created_at = period, nmv, 0)) 'NMV Created Old Paid',
			sum(if (zone_type = 'New paid - half price' AND created_at = period, nmv, 0)) 'NMV Created New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND created_at = period, nmv, 0)) 'NMV Created New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND shipped_at = period, nmv, 0)) 'NMV Shipped Jabodetabek',
			sum(if (zone_type = 'Free district' AND shipped_at = period, nmv, 0)) 'NMV Shipped Free',
			sum(if (zone_type = 'Old paid district' AND shipped_at = period, nmv, 0)) 'NMV Shipped Old Paid',
			sum(if (zone_type = 'New paid - half price' AND shipped_at = period, nmv, 0)) 'NMV Shipped New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND shipped_at = period, nmv, 0)) 'NMV Shipped New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND delivered_at = period, nmv, 0)) 'NMV Delivered Jabodetabek',
			sum(if (zone_type = 'Free district' AND delivered_at = period, nmv, 0)) 'NMV Delivered Free',
			sum(if (zone_type = 'Old paid district' AND delivered_at = period, nmv, 0)) 'NMV Delivered Old Paid',
			sum(if (zone_type = 'New paid - half price' AND delivered_at = period, nmv, 0)) 'NMV Delivered New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND delivered_at = period, nmv, 0)) 'NMV Delivered New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND failed_at = period, nmv, 0)) 'NMV Failed Jabodetabek',
			sum(if (zone_type = 'Free district' AND failed_at = period, nmv, 0)) 'NMV Failed Free',
			sum(if (zone_type = 'Old paid district' AND failed_at = period, nmv, 0)) 'NMV Failed Old Paid',
			sum(if (zone_type = 'New paid - half price' AND failed_at = period, nmv, 0)) 'NMV Failed New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND failed_at = period, nmv, 0)) 'NMV Failed New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND created_at = period, orders, 0)) 'Orders Created Jabodetabek',
			sum(if (zone_type = 'Free district' AND created_at = period, orders, 0)) 'Orders Created Free',
			sum(if (zone_type = 'Old paid district' AND created_at = period, orders, 0)) 'Orders Created Old Paid',
			sum(if (zone_type = 'New paid - half price' AND created_at = period, orders, 0)) 'Orders Created New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND created_at = period, orders, 0)) 'Orders Created New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND shipped_at = period, orders, 0)) 'Orders Shipped Jabodetabek',
			sum(if (zone_type = 'Free district' AND shipped_at = period, orders, 0)) 'Orders Shipped Free',
			sum(if (zone_type = 'Old paid district' AND shipped_at = period, orders, 0)) 'Orders Shipped Old Paid',
			sum(if (zone_type = 'New paid - half price' AND shipped_at = period, orders, 0)) 'Orders Shipped New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND shipped_at = period, orders, 0)) 'Orders Shipped New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND delivered_at = period, orders, 0)) 'Orders Delivered Jabodetabek',
			sum(if (zone_type = 'Free district' AND delivered_at = period, orders, 0)) 'Orders Delivered Free',
			sum(if (zone_type = 'Old paid district' AND delivered_at = period, orders, 0)) 'Orders Delivered Old Paid',
			sum(if (zone_type = 'New paid - half price' AND delivered_at = period, orders, 0)) 'Orders Delivered New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND delivered_at = period, orders, 0)) 'Orders Delivered New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND failed_at = period, orders, 0)) 'Orders Failed Jabodetabek',
			sum(if (zone_type = 'Free district' AND failed_at = period, orders, 0)) 'Orders Failed Free',
			sum(if (zone_type = 'Old paid district' AND failed_at = period, orders, 0)) 'Orders Failed Old Paid',
			sum(if (zone_type = 'New paid - half price' AND failed_at = period, orders, 0)) 'Orders Failed New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND failed_at = period, orders, 0)) 'Orders Failed New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND created_at = period, item, 0)) 'Items Created Jabodetabek',
			sum(if (zone_type = 'Free district' AND created_at = period, item, 0)) 'Items Created Free',
			sum(if (zone_type = 'Old paid district' AND created_at = period, item, 0)) 'Items Created Old Paid',
			sum(if (zone_type = 'New paid - half price' AND created_at = period, item, 0)) 'Items Created New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND created_at = period, item, 0)) 'Items Created New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND shipped_at = period, item, 0)) 'Items Shipped Jabodetabek',
			sum(if (zone_type = 'Free district' AND shipped_at = period, item, 0)) 'Items Shipped Free',
			sum(if (zone_type = 'Old paid district' AND shipped_at = period, item, 0)) 'Items Shipped Old Paid',
			sum(if (zone_type = 'New paid - half price' AND shipped_at = period, item, 0)) 'Items Shipped New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND shipped_at = period, item, 0)) 'Items Shipped New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND delivered_at = period, item, 0)) 'Items Delivered Jabodetabek',
			sum(if (zone_type = 'Free district' AND delivered_at = period, item, 0)) 'Items Delivered Free',
			sum(if (zone_type = 'Old paid district' AND delivered_at = period, item, 0)) 'Items Delivered Old Paid',
			sum(if (zone_type = 'New paid - half price' AND delivered_at = period, item, 0)) 'Items Delivered New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND delivered_at = period, item, 0)) 'Items Delivered New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND failed_at = period, item, 0)) 'Items Failed Jabodetabek',
			sum(if (zone_type = 'Free district' AND failed_at = period, item, 0)) 'Items Failed Free',
			sum(if (zone_type = 'Old paid district' AND failed_at = period, item, 0)) 'Items Failed Old Paid',
			sum(if (zone_type = 'New paid - half price' AND failed_at = period, item, 0)) 'Items Failed New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND failed_at = period, item, 0)) 'Items Failed New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND created_at = period, parcels, 0)) 'Parcels Created Jabodetabek',
			sum(if (zone_type = 'Free district' AND created_at = period, parcels, 0)) 'Parcels Created Free',
			sum(if (zone_type = 'Old paid district' AND created_at = period, parcels, 0)) 'Parcels Created Old Paid',
			sum(if (zone_type = 'New paid - half price' AND created_at = period, parcels, 0)) 'Parcels Created New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND created_at = period, parcels, 0)) 'Parcels Created New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Jabodetabek',
			sum(if (zone_type = 'Free district' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Free',
			sum(if (zone_type = 'Old paid district' AND shipped_at = period, parcels, 0)) 'Parcels Shipped Old Paid',
			sum(if (zone_type = 'New paid - half price' AND shipped_at = period, parcels, 0)) 'Parcels Shipped New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND shipped_at = period, parcels, 0)) 'Parcels Shipped New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Jabodetabek',
			sum(if (zone_type = 'Free district' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Free',
			sum(if (zone_type = 'Old paid district' AND delivered_at = period, parcels, 0)) 'Parcels Delivered Old Paid',
			sum(if (zone_type = 'New paid - half price' AND delivered_at = period, parcels, 0)) 'Parcels Delivered New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND delivered_at = period, parcels, 0)) 'Parcels Delivered New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND failed_at = period, parcels, 0)) 'Parcels Failed Jabodetabek',
			sum(if (zone_type = 'Free district' AND failed_at = period, parcels, 0)) 'Parcels Failed Free',
			sum(if (zone_type = 'Old paid district' AND failed_at = period, parcels, 0)) 'Parcels Failed Old Paid',
			sum(if (zone_type = 'New paid - half price' AND failed_at = period, parcels, 0)) 'Parcels Failed New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND failed_at = period, parcels, 0)) 'Parcels Failed New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND created_at = period, weight, 0)) 'Weight Created Jabodetabek',
			sum(if (zone_type = 'Free district' AND created_at = period, weight, 0)) 'Weight Created Free',
			sum(if (zone_type = 'Old paid district' AND created_at = period, weight, 0)) 'Weight Created Old Paid',
			sum(if (zone_type = 'New paid - half price' AND created_at = period, weight, 0)) 'Weight Created New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND created_at = period, weight, 0)) 'Weight Created New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND shipped_at = period, weight, 0)) 'Weight Shipped Jabodetabek',
			sum(if (zone_type = 'Free district' AND shipped_at = period, weight, 0)) 'Weight Shipped Free',
			sum(if (zone_type = 'Old paid district' AND shipped_at = period, weight, 0)) 'Weight Shipped Old Paid',
			sum(if (zone_type = 'New paid - half price' AND shipped_at = period, weight, 0)) 'Weight Shipped New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND shipped_at = period, weight, 0)) 'Weight Shipped New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND delivered_at = period, weight, 0)) 'Weight Delivered Jabodetabek',
			sum(if (zone_type = 'Free district' AND delivered_at = period, weight, 0)) 'Weight Delivered Free',
			sum(if (zone_type = 'Old paid district' AND delivered_at = period, weight, 0)) 'Weight Delivered Old Paid',
			sum(if (zone_type = 'New paid - half price' AND delivered_at = period, weight, 0)) 'Weight Delivered New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND delivered_at = period, weight, 0)) 'Weight Delivered New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND failed_at = period, weight, 0)) 'Weight Failed Jabodetabek',
			sum(if (zone_type = 'Free district' AND failed_at = period, weight, 0)) 'Weight Failed Free',
			sum(if (zone_type = 'Old paid district' AND failed_at = period, weight, 0)) 'Weight Failed Old Paid',
			sum(if (zone_type = 'New paid - half price' AND failed_at = period, weight, 0)) 'Weight Failed New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND failed_at = period, weight, 0)) 'Weight Failed New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Created Jabodetabek',
			sum(if (zone_type = 'Free district' AND created_at = period, chargable_weight, 0)) 'Chargable Weight  Created Free',
			sum(if (zone_type = 'Old paid district' AND created_at = period, chargable_weight, 0)) 'Chargable Weight  Created Old Paid',
			sum(if (zone_type = 'New paid - half price' AND created_at = period, chargable_weight, 0)) 'Chargable Weight  Created New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND created_at = period, chargable_weight, 0)) 'Chargable Weight  Created New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight  Shipped Jabodetabek',
			sum(if (zone_type = 'Free district' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight  Shipped Free',
			sum(if (zone_type = 'Old paid district' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight  Shipped Old Paid',
			sum(if (zone_type = 'New paid - half price' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight  Shipped New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight  Shipped New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight  Delivered Jabodetabek',
			sum(if (zone_type = 'Free district' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight  Delivered Free',
			sum(if (zone_type = 'Old paid district' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight  Delivered Old Paid',
			sum(if (zone_type = 'New paid - half price' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight  Delivered New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight  Delivered New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight  Failed Jabodetabek',
			sum(if (zone_type = 'Free district' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight  Failed Free',
			sum(if (zone_type = 'Old paid district' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight  Failed Old Paid',
			sum(if (zone_type = 'New paid - half price' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight  Failed New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight  Failed New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND created_at = period, seller_charges, 0)) 'Seller Charges Created Jabodetabek',
			sum(if (zone_type = 'Free district' AND created_at = period, seller_charges, 0)) 'Seller Charges Created Free',
			sum(if (zone_type = 'Old paid district' AND created_at = period, seller_charges, 0)) 'Seller Charges Created Old Paid',
			sum(if (zone_type = 'New paid - half price' AND created_at = period, seller_charges, 0)) 'Seller Charges Created New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND created_at = period, seller_charges, 0)) 'Seller Charges Created New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Jabodetabek',
			sum(if (zone_type = 'Free district' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Free',
			sum(if (zone_type = 'Old paid district' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped Old Paid',
			sum(if (zone_type = 'New paid - half price' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Jabodetabek',
			sum(if (zone_type = 'Free district' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Free',
			sum(if (zone_type = 'Old paid district' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered Old Paid',
			sum(if (zone_type = 'New paid - half price' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Jabodetabek',
			sum(if (zone_type = 'Free district' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Free',
			sum(if (zone_type = 'Old paid district' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed Old Paid',
			sum(if (zone_type = 'New paid - half price' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND created_at = period, customer_charges, 0)) 'Customer Charges Created Jabodetabek',
			sum(if (zone_type = 'Free district' AND created_at = period, customer_charges, 0)) 'Customer Charges Created Free',
			sum(if (zone_type = 'Old paid district' AND created_at = period, customer_charges, 0)) 'Customer Charges Created Old Paid',
			sum(if (zone_type = 'New paid - half price' AND created_at = period, customer_charges, 0)) 'Customer Charges Created New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND created_at = period, customer_charges, 0)) 'Customer Charges Created New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Jabodetabek',
			sum(if (zone_type = 'Free district' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Free',
			sum(if (zone_type = 'Old paid district' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped Old Paid',
			sum(if (zone_type = 'New paid - half price' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Jabodetabek',
			sum(if (zone_type = 'Free district' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Free',
			sum(if (zone_type = 'Old paid district' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered Old Paid',
			sum(if (zone_type = 'New paid - half price' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Jabodetabek',
			sum(if (zone_type = 'Free district' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Free',
			sum(if (zone_type = 'Old paid district' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed Old Paid',
			sum(if (zone_type = 'New paid - half price' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Created Jabodetabek',
			sum(if (zone_type = 'Free district' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Created Free',
			sum(if (zone_type = 'Old paid district' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Created Old Paid',
			sum(if (zone_type = 'New paid - half price' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Created New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Created New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Jabodetabek',
			sum(if (zone_type = 'Free district' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Free',
			sum(if (zone_type = 'Old paid district' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped Old Paid',
			sum(if (zone_type = 'New paid - half price' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Jabodetabek',
			sum(if (zone_type = 'Free district' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Free',
			sum(if (zone_type = 'Old paid district' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered Old Paid',
			sum(if (zone_type = 'New paid - half price' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Jabodetabek',
			sum(if (zone_type = 'Free district' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Free',
			sum(if (zone_type = 'Old paid district' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed Old Paid',
			sum(if (zone_type = 'New paid - half price' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Created Jabodetabek',
			sum(if (zone_type = 'Free district' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Created Free',
			sum(if (zone_type = 'Old paid district' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Created Old Paid',
			sum(if (zone_type = 'New paid - half price' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Created New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Created New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Jabodetabek',
			sum(if (zone_type = 'Free district' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Free',
			sum(if (zone_type = 'Old paid district' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped Old Paid',
			sum(if (zone_type = 'New paid - half price' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Jabodetabek',
			sum(if (zone_type = 'Free district' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Free',
			sum(if (zone_type = 'Old paid district' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered Old Paid',
			sum(if (zone_type = 'New paid - half price' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered New Paid - Full',
			
			sum(if (zone_type = 'Jabodetabek' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Jabodetabek',
			sum(if (zone_type = 'Free district' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Free',
			sum(if (zone_type = 'Old paid district' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed Old Paid',
			sum(if (zone_type = 'New paid - half price' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed New Paid - Half',
			sum(if (zone_type = 'New paid - full price' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed New Paid - Full'
    FROM
        (SELECT 
        zone_type_temp 'zone_type',
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
            IFNULL((SELECT 
                    zone_type
                FROM
                    zone_mapping
                WHERE
                    id_district = ac.id_district
                        AND end_date >= NOW()), 'Old Paid District') 'zone_type_temp',
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
        anondb_calculate ac
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
    GROUP BY zone_type_temp , created_at , shipped_at , delivered_at , failed_at) result
    LEFT JOIN period_zt pd ON (pd.period = result.created_at
        OR pd.period = result.shipped_at
        OR pd.period = result.delivered_at
        OR pd.period = result.failed_at)
    GROUP BY pd.period) result;

DROP PROCEDURE load_date_zt;

DROP TEMPORARY TABLE period_zt;