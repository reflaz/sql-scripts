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
SET @extractstart = '2017-08-01';
SET @extractend = '2017-08-15';-- This MUST be D + 1

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
			sum(if (bu = 'MA' AND payment_method = 'cod' AND created_at = period, nmv, 0)) 'NMV MA COD Created',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND created_at = period, nmv, 0)) 'NMV DB COD Created',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND created_at = period, nmv, 0)) 'NMV CB COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND created_at = period, nmv, 0)) 'NMV Retail COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND created_at = period, nmv, 0)) 'NMV Digital COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND created_at = period, nmv, 0)) 'NMV MA NON COD Created',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND created_at = period, nmv, 0)) 'NMV DB NON COD Created',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND created_at = period, nmv, 0)) 'NMV CB NON COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND created_at = period, nmv, 0)) 'NMV Retail NON COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND created_at = period, nmv, 0)) 'NMV Digital NON COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND shipped_at = period, nmv, 0)) 'NMV MA COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND shipped_at = period, nmv, 0)) 'NMV DB COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND shipped_at = period, nmv, 0)) 'NMV CB COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND shipped_at = period, nmv, 0)) 'NMV Retail COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND shipped_at = period, nmv, 0)) 'NMV Digital COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND shipped_at = period, nmv, 0)) 'NMV MA NON COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND shipped_at = period, nmv, 0)) 'NMV DB NON COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND shipped_at = period, nmv, 0)) 'NMV CB NON COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND shipped_at = period, nmv, 0)) 'NMV Retail NON COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND shipped_at = period, nmv, 0)) 'NMV Digital NON COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND delivered_at = period, nmv, 0)) 'NMV MA COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND delivered_at = period, nmv, 0)) 'NMV DB COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND delivered_at = period, nmv, 0)) 'NMV CB COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND delivered_at = period, nmv, 0)) 'NMV Retail COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND delivered_at = period, nmv, 0)) 'NMV Digital COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND delivered_at = period, nmv, 0)) 'NMV MA NON COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND delivered_at = period, nmv, 0)) 'NMV DB NON COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND delivered_at = period, nmv, 0)) 'NMV CB NON COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND delivered_at = period, nmv, 0)) 'NMV Retail NON COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND delivered_at = period, nmv, 0)) 'NMV Digital NON COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND failed_at = period, nmv, 0)) 'NMV MA COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND failed_at = period, nmv, 0)) 'NMV DB COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND failed_at = period, nmv, 0)) 'NMV CB COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND failed_at = period, nmv, 0)) 'NMV Retail COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND failed_at = period, nmv, 0)) 'NMV Digital COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND failed_at = period, nmv, 0)) 'NMV MA NON COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND failed_at = period, nmv, 0)) 'NMV DB NON COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND failed_at = period, nmv, 0)) 'NMV CB NON COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND failed_at = period, nmv, 0)) 'NMV Retail NON COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND failed_at = period, nmv, 0)) 'NMV Digital NON COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND created_at = period, orders, 0)) 'Orders MA COD Created',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND created_at = period, orders, 0)) 'Orders DB COD Created',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND created_at = period, orders, 0)) 'Orders CB COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND created_at = period, orders, 0)) 'Orders Retail COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND created_at = period, orders, 0)) 'Orders Digital COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND created_at = period, orders, 0)) 'Orders MA NON COD Created',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND created_at = period, orders, 0)) 'Orders DB NON COD Created',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND created_at = period, orders, 0)) 'Orders CB NON COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND created_at = period, orders, 0)) 'Orders Retail NON COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND created_at = period, orders, 0)) 'Orders Digital NON COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND shipped_at = period, orders, 0)) 'Orders MA COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND shipped_at = period, orders, 0)) 'Orders DB COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND shipped_at = period, orders, 0)) 'Orders CB COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND shipped_at = period, orders, 0)) 'Orders Retail COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND shipped_at = period, orders, 0)) 'Orders Digital COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND shipped_at = period, orders, 0)) 'Orders MA NON COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND shipped_at = period, orders, 0)) 'Orders DB NON COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND shipped_at = period, orders, 0)) 'Orders CB NON COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND shipped_at = period, orders, 0)) 'Orders Retail NON COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND shipped_at = period, orders, 0)) 'Orders Digital NON COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND delivered_at = period, orders, 0)) 'Orders MA COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND delivered_at = period, orders, 0)) 'Orders DB COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND delivered_at = period, orders, 0)) 'Orders CB COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND delivered_at = period, orders, 0)) 'Orders Retail COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND delivered_at = period, orders, 0)) 'Orders Digital COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND delivered_at = period, orders, 0)) 'Orders MA NON COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND delivered_at = period, orders, 0)) 'Orders DB NON COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND delivered_at = period, orders, 0)) 'Orders CB NON COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND delivered_at = period, orders, 0)) 'Orders Retail NON COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND delivered_at = period, orders, 0)) 'Orders Digital NON COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND failed_at = period, orders, 0)) 'Orders MA COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND failed_at = period, orders, 0)) 'Orders DB COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND failed_at = period, orders, 0)) 'Orders CB COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND failed_at = period, orders, 0)) 'Orders Retail COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND failed_at = period, orders, 0)) 'Orders Digital COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND failed_at = period, orders, 0)) 'Orders MA NON COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND failed_at = period, orders, 0)) 'Orders DB NON COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND failed_at = period, orders, 0)) 'Orders CB NON COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND failed_at = period, orders, 0)) 'Orders Retail NON COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND failed_at = period, orders, 0)) 'Orders Digital NON COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND created_at = period, item, 0)) 'Items MA COD Created',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND created_at = period, item, 0)) 'Items DB COD Created',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND created_at = period, item, 0)) 'Items CB COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND created_at = period, item, 0)) 'Items Retail COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND created_at = period, item, 0)) 'Items Digital COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND created_at = period, item, 0)) 'Items MA NON COD Created',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND created_at = period, item, 0)) 'Items DB NON COD Created',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND created_at = period, item, 0)) 'Items CB NON COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND created_at = period, item, 0)) 'Items Retail NON COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND created_at = period, item, 0)) 'Items Digital NON COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND shipped_at = period, item, 0)) 'Items MA COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND shipped_at = period, item, 0)) 'Items DB COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND shipped_at = period, item, 0)) 'Items CB COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND shipped_at = period, item, 0)) 'Items Retail COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND shipped_at = period, item, 0)) 'Items Digital COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND shipped_at = period, item, 0)) 'Items MA NON COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND shipped_at = period, item, 0)) 'Items DB NON COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND shipped_at = period, item, 0)) 'Items CB NON COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND shipped_at = period, item, 0)) 'Items Retail NON COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND shipped_at = period, item, 0)) 'Items Digital NON COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND delivered_at = period, item, 0)) 'Items MA COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND delivered_at = period, item, 0)) 'Items DB COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND delivered_at = period, item, 0)) 'Items CB COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND delivered_at = period, item, 0)) 'Items Retail COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND delivered_at = period, item, 0)) 'Items Digital COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND delivered_at = period, item, 0)) 'Items MA NON COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND delivered_at = period, item, 0)) 'Items DB NON COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND delivered_at = period, item, 0)) 'Items CB NON COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND delivered_at = period, item, 0)) 'Items Retail NON COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND delivered_at = period, item, 0)) 'Items Digital NON COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND failed_at = period, item, 0)) 'Items MA COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND failed_at = period, item, 0)) 'Items DB COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND failed_at = period, item, 0)) 'Items CB COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND failed_at = period, item, 0)) 'Items Retail COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND failed_at = period, item, 0)) 'Items Digital COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND failed_at = period, item, 0)) 'Items MA NON COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND failed_at = period, item, 0)) 'Items DB NON COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND failed_at = period, item, 0)) 'Items CB NON COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND failed_at = period, item, 0)) 'Items Retail NON COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND failed_at = period, item, 0)) 'Items Digital NON COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND created_at = period, parcels, 0)) 'Parcels MA COD Created',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND created_at = period, parcels, 0)) 'Parcels DB COD Created',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND created_at = period, parcels, 0)) 'Parcels CB COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND created_at = period, parcels, 0)) 'Parcels Retail COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND created_at = period, parcels, 0)) 'Parcels Digital COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND created_at = period, parcels, 0)) 'Parcels MA NON COD Created',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND created_at = period, parcels, 0)) 'Parcels DB NON COD Created',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND created_at = period, parcels, 0)) 'Parcels CB NON COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND created_at = period, parcels, 0)) 'Parcels Retail NON COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND created_at = period, parcels, 0)) 'Parcels Digital NON COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND shipped_at = period, parcels, 0)) 'Parcels MA COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND shipped_at = period, parcels, 0)) 'Parcels DB COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND shipped_at = period, parcels, 0)) 'Parcels CB COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND shipped_at = period, parcels, 0)) 'Parcels Retail COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND shipped_at = period, parcels, 0)) 'Parcels Digital COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND shipped_at = period, parcels, 0)) 'Parcels MA NON COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND shipped_at = period, parcels, 0)) 'Parcels DB NON COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND shipped_at = period, parcels, 0)) 'Parcels CB NON COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND shipped_at = period, parcels, 0)) 'Parcels Retail NON COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND shipped_at = period, parcels, 0)) 'Parcels Digital NON COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND delivered_at = period, parcels, 0)) 'Parcels MA COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND delivered_at = period, parcels, 0)) 'Parcels DB COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND delivered_at = period, parcels, 0)) 'Parcels CB COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND delivered_at = period, parcels, 0)) 'Parcels Retail COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND delivered_at = period, parcels, 0)) 'Parcels Digital COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND delivered_at = period, parcels, 0)) 'Parcels MA NON COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND delivered_at = period, parcels, 0)) 'Parcels DB NON COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND delivered_at = period, parcels, 0)) 'Parcels CB NON COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND delivered_at = period, parcels, 0)) 'Parcels Retail NON COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND delivered_at = period, parcels, 0)) 'Parcels Digital NON COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND failed_at = period, parcels, 0)) 'Parcels MA COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND failed_at = period, parcels, 0)) 'Parcels DB COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND failed_at = period, parcels, 0)) 'Parcels CB COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND failed_at = period, parcels, 0)) 'Parcels Retail COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND failed_at = period, parcels, 0)) 'Parcels Digital COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND failed_at = period, parcels, 0)) 'Parcels MA NON COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND failed_at = period, parcels, 0)) 'Parcels DB NON COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND failed_at = period, parcels, 0)) 'Parcels CB NON COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND failed_at = period, parcels, 0)) 'Parcels Retail NON COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND failed_at = period, parcels, 0)) 'Parcels Digital NON COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND created_at = period, weight, 0)) 'Weight MA COD Created',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND created_at = period, weight, 0)) 'Weight DB COD Created',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND created_at = period, weight, 0)) 'Weight CB COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND created_at = period, weight, 0)) 'Weight Retail COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND created_at = period, weight, 0)) 'Weight Digital COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND created_at = period, weight, 0)) 'Weight MA NON COD Created',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND created_at = period, weight, 0)) 'Weight DB NON COD Created',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND created_at = period, weight, 0)) 'Weight CB NON COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND created_at = period, weight, 0)) 'Weight Retail NON COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND created_at = period, weight, 0)) 'Weight Digital NON COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND shipped_at = period, weight, 0)) 'Weight MA COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND shipped_at = period, weight, 0)) 'Weight DB COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND shipped_at = period, weight, 0)) 'Weight CB COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND shipped_at = period, weight, 0)) 'Weight Retail COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND shipped_at = period, weight, 0)) 'Weight Digital COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND shipped_at = period, weight, 0)) 'Weight MA NON COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND shipped_at = period, weight, 0)) 'Weight DB NON COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND shipped_at = period, weight, 0)) 'Weight CB NON COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND shipped_at = period, weight, 0)) 'Weight Retail NON COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND shipped_at = period, weight, 0)) 'Weight Digital NON COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND delivered_at = period, weight, 0)) 'Weight MA COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND delivered_at = period, weight, 0)) 'Weight DB COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND delivered_at = period, weight, 0)) 'Weight CB COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND delivered_at = period, weight, 0)) 'Weight Retail COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND delivered_at = period, weight, 0)) 'Weight Digital COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND delivered_at = period, weight, 0)) 'Weight MA NON COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND delivered_at = period, weight, 0)) 'Weight DB NON COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND delivered_at = period, weight, 0)) 'Weight CB NON COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND delivered_at = period, weight, 0)) 'Weight Retail NON COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND delivered_at = period, weight, 0)) 'Weight Digital NON COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND failed_at = period, weight, 0)) 'Weight MA COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND failed_at = period, weight, 0)) 'Weight DB COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND failed_at = period, weight, 0)) 'Weight CB COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND failed_at = period, weight, 0)) 'Weight Retail COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND failed_at = period, weight, 0)) 'Weight Digital COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND failed_at = period, weight, 0)) 'Weight MA NON COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND failed_at = period, weight, 0)) 'Weight DB NON COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND failed_at = period, weight, 0)) 'Weight CB NON COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND failed_at = period, weight, 0)) 'Weight Retail NON COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND failed_at = period, weight, 0)) 'Weight Digital NON COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND created_at = period, chargable_weight, 0)) 'Chargable Weight MA COD Created',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND created_at = period, chargable_weight, 0)) 'Chargable Weight DB COD Created',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND created_at = period, chargable_weight, 0)) 'Chargable Weight CB COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Retail COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Digital COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND created_at = period, chargable_weight, 0)) 'Chargable Weight MA NON COD Created',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND created_at = period, chargable_weight, 0)) 'Chargable Weight DB NON COD Created',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND created_at = period, chargable_weight, 0)) 'Chargable Weight CB NON COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Retail NON COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Digital NON COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight MA COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight DB COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight CB COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Retail COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Digital COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight MA NON COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight DB NON COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight CB NON COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Retail NON COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Digital NON COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight MA COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight DB COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight CB COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Retail COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Digital COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight MA NON COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight DB NON COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight CB NON COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Retail NON COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Digital NON COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight MA COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight DB COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight CB COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Retail COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Digital COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight MA NON COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight DB NON COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight CB NON COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Retail NON COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Digital NON COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND created_at = period, seller_charges, 0)) 'Seller Charges MA COD Created',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND created_at = period, seller_charges, 0)) 'Seller Charges DB COD Created',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND created_at = period, seller_charges, 0)) 'Seller Charges CB COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND created_at = period, seller_charges, 0)) 'Seller Charges Retail COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND created_at = period, seller_charges, 0)) 'Seller Charges Digital COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND created_at = period, seller_charges, 0)) 'Seller Charges MA NON COD Created',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND created_at = period, seller_charges, 0)) 'Seller Charges DB NON COD Created',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND created_at = period, seller_charges, 0)) 'Seller Charges CB NON COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND created_at = period, seller_charges, 0)) 'Seller Charges Retail NON COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND created_at = period, seller_charges, 0)) 'Seller Charges Digital NON COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND shipped_at = period, seller_charges, 0)) 'Seller Charges MA COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND shipped_at = period, seller_charges, 0)) 'Seller Charges DB COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND shipped_at = period, seller_charges, 0)) 'Seller Charges CB COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Retail COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Digital COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND shipped_at = period, seller_charges, 0)) 'Seller Charges MA NON COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND shipped_at = period, seller_charges, 0)) 'Seller Charges DB NON COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND shipped_at = period, seller_charges, 0)) 'Seller Charges CB NON COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Retail NON COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Digital NON COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND delivered_at = period, seller_charges, 0)) 'Seller Charges MA COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND delivered_at = period, seller_charges, 0)) 'Seller Charges DB COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND delivered_at = period, seller_charges, 0)) 'Seller Charges CB COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Retail COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Digital COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND delivered_at = period, seller_charges, 0)) 'Seller Charges MA NON COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND delivered_at = period, seller_charges, 0)) 'Seller Charges DB NON COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND delivered_at = period, seller_charges, 0)) 'Seller Charges CB NON COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Retail NON COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Digital NON COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND failed_at = period, seller_charges, 0)) 'Seller Charges MA COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND failed_at = period, seller_charges, 0)) 'Seller Charges DB COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND failed_at = period, seller_charges, 0)) 'Seller Charges CB COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND failed_at = period, seller_charges, 0)) 'Seller Charges Retail COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND failed_at = period, seller_charges, 0)) 'Seller Charges Digital COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND failed_at = period, seller_charges, 0)) 'Seller Charges MA NON COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND failed_at = period, seller_charges, 0)) 'Seller Charges DB NON COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND failed_at = period, seller_charges, 0)) 'Seller Charges CB NON COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND failed_at = period, seller_charges, 0)) 'Seller Charges Retail NON COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND failed_at = period, seller_charges, 0)) 'Seller Charges Digital NON COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND created_at = period, customer_charges, 0)) 'Customer Charges MA COD Created',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND created_at = period, customer_charges, 0)) 'Customer Charges DB COD Created',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND created_at = period, customer_charges, 0)) 'Customer Charges CB COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND created_at = period, customer_charges, 0)) 'Customer Charges Retail COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND created_at = period, customer_charges, 0)) 'Customer Charges Digital COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND created_at = period, customer_charges, 0)) 'Customer Charges MA NON COD Created',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND created_at = period, customer_charges, 0)) 'Customer Charges DB NON COD Created',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND created_at = period, customer_charges, 0)) 'Customer Charges CB NON COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND created_at = period, customer_charges, 0)) 'Customer Charges Retail NON COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND created_at = period, customer_charges, 0)) 'Customer Charges Digital NON COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND shipped_at = period, customer_charges, 0)) 'Customer Charges MA COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND shipped_at = period, customer_charges, 0)) 'Customer Charges DB COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND shipped_at = period, customer_charges, 0)) 'Customer Charges CB COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Retail COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Digital COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND shipped_at = period, customer_charges, 0)) 'Customer Charges MA NON COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND shipped_at = period, customer_charges, 0)) 'Customer Charges DB NON COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND shipped_at = period, customer_charges, 0)) 'Customer Charges CB NON COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Retail NON COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Digital NON COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND delivered_at = period, customer_charges, 0)) 'Customer Charges MA COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND delivered_at = period, customer_charges, 0)) 'Customer Charges DB COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND delivered_at = period, customer_charges, 0)) 'Customer Charges CB COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Retail COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Digital COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND delivered_at = period, customer_charges, 0)) 'Customer Charges MA NON COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND delivered_at = period, customer_charges, 0)) 'Customer Charges DB NON COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND delivered_at = period, customer_charges, 0)) 'Customer Charges CB NON COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Retail NON COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Digital NON COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND failed_at = period, customer_charges, 0)) 'Customer Charges MA COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND failed_at = period, customer_charges, 0)) 'Customer Charges DB COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND failed_at = period, customer_charges, 0)) 'Customer Charges CB COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND failed_at = period, customer_charges, 0)) 'Customer Charges Retail COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND failed_at = period, customer_charges, 0)) 'Customer Charges Digital COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND failed_at = period, customer_charges, 0)) 'Customer Charges MA NON COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND failed_at = period, customer_charges, 0)) 'Customer Charges DB NON COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND failed_at = period, customer_charges, 0)) 'Customer Charges CB NON COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND failed_at = period, customer_charges, 0)) 'Customer Charges Retail NON COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND failed_at = period, customer_charges, 0)) 'Customer Charges Digital NON COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND created_at = period, delivery_cost, 0)) 'Delivery Cost MA COD Created',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND created_at = period, delivery_cost, 0)) 'Delivery Cost DB COD Created',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND created_at = period, delivery_cost, 0)) 'Delivery Cost CB COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Retail COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Digital COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND created_at = period, delivery_cost, 0)) 'Delivery Cost MA NON COD Created',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND created_at = period, delivery_cost, 0)) 'Delivery Cost DB NON COD Created',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND created_at = period, delivery_cost, 0)) 'Delivery Cost CB NON COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Retail NON COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Digital NON COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost MA COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost DB COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost CB COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Retail COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Digital COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost MA NON COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost DB NON COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost CB NON COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Retail NON COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Digital NON COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost MA COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost DB COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost CB COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Retail COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Digital COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost MA NON COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost DB NON COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost CB NON COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Retail NON COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Digital NON COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost MA COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost DB COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost CB COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Retail COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Digital COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost MA NON COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost DB NON COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost CB NON COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Retail NON COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Digital NON COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND created_at = period, pickup_cost, 0)) 'Pickup Cost MA COD Created',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND created_at = period, pickup_cost, 0)) 'Pickup Cost DB COD Created',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND created_at = period, pickup_cost, 0)) 'Pickup Cost CB COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Retail COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Digital COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND created_at = period, pickup_cost, 0)) 'Pickup Cost MA NON COD Created',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND created_at = period, pickup_cost, 0)) 'Pickup Cost DB NON COD Created',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND created_at = period, pickup_cost, 0)) 'Pickup Cost CB NON COD Created',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Retail NON COD Created',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Digital NON COD Created',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost MA COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost DB COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost CB COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Retail COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Digital COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost MA NON COD Shipped',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost DB NON COD Shipped',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost CB NON COD Shipped',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Retail NON COD Shipped',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Digital NON COD Shipped',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost MA COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost DB COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost CB COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Retail COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Digital COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost MA NON COD Delivered',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost DB NON COD Delivered',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost CB NON COD Delivered',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Retail NON COD Delivered',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Digital NON COD Delivered',
			
			sum(if (bu = 'MA' AND payment_method = 'cod' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost MA COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'cod' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost DB COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'cod' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost CB COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'cod' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Retail COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'cod' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Digital COD Failed',
			
			sum(if (bu = 'MA' AND payment_method = 'non_cod' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost MA NON COD Failed',
			sum(if (bu = 'DB' AND payment_method = 'non_cod' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost DB NON COD Failed',
			sum(if (bu = 'CB' AND payment_method = 'non_cod' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost CB NON COD Failed',
			sum(if (bu = 'Retail' AND payment_method = 'non_cod' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Retail NON COD Failed',
			sum(if (bu = 'Digital' AND payment_method = 'non_cod' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Digital NON COD Failed'
    FROM
        (SELECT 
        bu,
            payment_method_temp 'payment_method',
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
                WHEN payment_method = 'CashOnDelivery' THEN 'cod'
                ELSE 'non_cod'
            END 'payment_method_temp',
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
    GROUP BY payment_method_temp , bu , created_at , shipped_at , delivered_at , failed_at) result
    LEFT JOIN period_bu pd ON (pd.period = result.created_at
        OR pd.period = result.shipped_at
        OR pd.period = result.delivered_at
        OR pd.period = result.failed_at)
    GROUP BY pd.period) result;

DROP PROCEDURE load_date_bu;

DROP TEMPORARY TABLE period_bu;