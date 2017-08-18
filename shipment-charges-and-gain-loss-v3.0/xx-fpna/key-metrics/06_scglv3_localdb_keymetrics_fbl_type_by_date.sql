/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SCGL Key Metrics by FBL Type

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
            sum(if (shipment = 'FBL' AND created_at = period, nmv, 0)) 'NMV Created FBL',
			sum(if (shipment = 'NON FBL' AND created_at = period, nmv, 0)) 'NMV Created NON FBL',
			
			sum(if (shipment = 'FBL' AND shipped_at = period, nmv, 0)) 'NMV Shipped FBL',
			sum(if (shipment = 'NON FBL' AND shipped_at = period, nmv, 0)) 'NMV Shipped NON FBL',
			
			sum(if (shipment = 'FBL' AND delivered_at = period, nmv, 0)) 'NMV Delivered FBL',
			sum(if (shipment = 'NON FBL' AND delivered_at = period, nmv, 0)) 'NMV Delivered NON FBL',
			
			sum(if (shipment = 'FBL' AND failed_at = period, nmv, 0)) 'NMV Failed FBL',
			sum(if (shipment = 'NON FBL' AND failed_at = period, nmv, 0)) 'NMV Failed NON FBL',
			
			sum(if (shipment = 'FBL' AND created_at = period, orders, 0)) 'Orders Created FBL',
			sum(if (shipment = 'NON FBL' AND created_at = period, orders, 0)) 'Orders Created NON FBL',
			
			sum(if (shipment = 'FBL' AND shipped_at = period, orders, 0)) 'Orders Shipped FBL',
			sum(if (shipment = 'NON FBL' AND shipped_at = period, orders, 0)) 'Orders Shipped NON FBL',
			
			sum(if (shipment = 'FBL' AND delivered_at = period, orders, 0)) 'Orders Delivered FBL',
			sum(if (shipment = 'NON FBL' AND delivered_at = period, orders, 0)) 'Orders Delivered NON FBL',
			
			sum(if (shipment = 'FBL' AND failed_at = period, orders, 0)) 'Orders Failed FBL',
			sum(if (shipment = 'NON FBL' AND failed_at = period, orders, 0)) 'Orders Failed NON FBL',
			
			sum(if (shipment = 'FBL' AND created_at = period, item, 0)) 'Items Created FBL',
			sum(if (shipment = 'NON FBL' AND created_at = period, item, 0)) 'Items Created NON FBL',
			
			sum(if (shipment = 'FBL' AND shipped_at = period, item, 0)) 'Items Shipped FBL',
			sum(if (shipment = 'NON FBL' AND shipped_at = period, item, 0)) 'Items Shipped NON FBL',
			
			sum(if (shipment = 'FBL' AND delivered_at = period, item, 0)) 'Items Delivered FBL',
			sum(if (shipment = 'NON FBL' AND delivered_at = period, item, 0)) 'Items Delivered NON FBL',
			
			sum(if (shipment = 'FBL' AND failed_at = period, item, 0)) 'Items Failed FBL',
			sum(if (shipment = 'NON FBL' AND failed_at = period, item, 0)) 'Items Failed NON FBL',
			
			sum(if (shipment = 'FBL' AND created_at = period, parcels, 0)) 'Parcels Created FBL',
			sum(if (shipment = 'NON FBL' AND created_at = period, parcels, 0)) 'Parcels Created NON FBL',
			
			sum(if (shipment = 'FBL' AND shipped_at = period, parcels, 0)) 'Parcels Shipped FBL',
			sum(if (shipment = 'NON FBL' AND shipped_at = period, parcels, 0)) 'Parcels Shipped NON FBL',
			
			sum(if (shipment = 'FBL' AND delivered_at = period, parcels, 0)) 'Parcels Delivered FBL',
			sum(if (shipment = 'NON FBL' AND delivered_at = period, parcels, 0)) 'Parcels Delivered NON FBL',
			
			sum(if (shipment = 'FBL' AND failed_at = period, parcels, 0)) 'Parcels Failed FBL',
			sum(if (shipment = 'NON FBL' AND failed_at = period, parcels, 0)) 'Parcels Failed NON FBL',
			
			sum(if (shipment = 'FBL' AND created_at = period, weight, 0)) 'Weight Created FBL',
			sum(if (shipment = 'NON FBL' AND created_at = period, weight, 0)) 'Weight Created NON FBL',
			
			sum(if (shipment = 'FBL' AND shipped_at = period, weight, 0)) 'Weight Shipped FBL',
			sum(if (shipment = 'NON FBL' AND shipped_at = period, weight, 0)) 'Weight Shipped NON FBL',
			
			sum(if (shipment = 'FBL' AND delivered_at = period, weight, 0)) 'Weight Delivered FBL',
			sum(if (shipment = 'NON FBL' AND delivered_at = period, weight, 0)) 'Weight Delivered NON FBL',
			
			sum(if (shipment = 'FBL' AND failed_at = period, weight, 0)) 'Weight Failed FBL',
			sum(if (shipment = 'NON FBL' AND failed_at = period, weight, 0)) 'Weight Failed NON FBL',
			
			sum(if (shipment = 'FBL' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Created FBL',
			sum(if (shipment = 'NON FBL' AND created_at = period, chargable_weight, 0)) 'Chargable Weight Created NON FBL',
			
			sum(if (shipment = 'FBL' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped FBL',
			sum(if (shipment = 'NON FBL' AND shipped_at = period, chargable_weight, 0)) 'Chargable Weight Shipped NON FBL',
			
			sum(if (shipment = 'FBL' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered FBL',
			sum(if (shipment = 'NON FBL' AND delivered_at = period, chargable_weight, 0)) 'Chargable Weight Delivered NON FBL',
			
			sum(if (shipment = 'FBL' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed FBL',
			sum(if (shipment = 'NON FBL' AND failed_at = period, chargable_weight, 0)) 'Chargable Weight Failed NON FBL',
			
			sum(if (shipment = 'FBL' AND created_at = period, seller_charges, 0)) 'Seller Charges Created FBL',
			sum(if (shipment = 'NON FBL' AND created_at = period, seller_charges, 0)) 'Seller Charges Created NON FBL',
			
			sum(if (shipment = 'FBL' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped FBL',
			sum(if (shipment = 'NON FBL' AND shipped_at = period, seller_charges, 0)) 'Seller Charges Shipped NON FBL',
			
			sum(if (shipment = 'FBL' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered FBL',
			sum(if (shipment = 'NON FBL' AND delivered_at = period, seller_charges, 0)) 'Seller Charges Delivered NON FBL',
			
			sum(if (shipment = 'FBL' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed FBL',
			sum(if (shipment = 'NON FBL' AND failed_at = period, seller_charges, 0)) 'Seller Charges Failed NON FBL',
			
			sum(if (shipment = 'FBL' AND created_at = period, customer_charges, 0)) 'Customer Charges Created FBL',
			sum(if (shipment = 'NON FBL' AND created_at = period, customer_charges, 0)) 'Customer Charges Created NON FBL',
			
			sum(if (shipment = 'FBL' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped FBL',
			sum(if (shipment = 'NON FBL' AND shipped_at = period, customer_charges, 0)) 'Customer Charges Shipped NON FBL',
			
			sum(if (shipment = 'FBL' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered FBL',
			sum(if (shipment = 'NON FBL' AND delivered_at = period, customer_charges, 0)) 'Customer Charges Delivered NON FBL',
			
			sum(if (shipment = 'FBL' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed FBL',
			sum(if (shipment = 'NON FBL' AND failed_at = period, customer_charges, 0)) 'Customer Charges Failed NON FBL',
			
			sum(if (shipment = 'FBL' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Created FBL',
			sum(if (shipment = 'NON FBL' AND created_at = period, delivery_cost, 0)) 'Delivery Cost Created NON FBL',
			
			sum(if (shipment = 'FBL' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped FBL',
			sum(if (shipment = 'NON FBL' AND shipped_at = period, delivery_cost, 0)) 'Delivery Cost Shipped NON FBL',
			
			sum(if (shipment = 'FBL' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered FBL',
			sum(if (shipment = 'NON FBL' AND delivered_at = period, delivery_cost, 0)) 'Delivery Cost Delivered NON FBL',
			
			sum(if (shipment = 'FBL' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed FBL',
			sum(if (shipment = 'NON FBL' AND failed_at = period, delivery_cost, 0)) 'Delivery Cost Failed NON FBL',
			
			sum(if (shipment = 'FBL' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Created FBL',
			sum(if (shipment = 'NON FBL' AND created_at = period, pickup_cost, 0)) 'Pickup Cost Created NON FBL',
			
			sum(if (shipment = 'FBL' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped FBL',
			sum(if (shipment = 'NON FBL' AND shipped_at = period, pickup_cost, 0)) 'Pickup Cost Shipped NON FBL',
			
			sum(if (shipment = 'FBL' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered FBL',
			sum(if (shipment = 'NON FBL' AND delivered_at = period, pickup_cost, 0)) 'Pickup Cost Delivered NON FBL',
			
			sum(if (shipment = 'FBL' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed FBL',
			sum(if (shipment = 'NON FBL' AND failed_at = period, pickup_cost, 0)) 'Pickup Cost Failed NON FBL'
    FROM
        (SELECT 
        temp_shipment 'shipment',
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
                WHEN shipment_scheme LIKE '%FBL%' THEN 'FBL'
                ELSE 'NON FBL'
            END 'temp_shipment',
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
    GROUP BY temp_shipment , created_at , shipped_at , delivered_at , failed_at) result
    LEFT JOIN period_bu pd ON (pd.period = result.created_at
        OR pd.period = result.shipped_at
        OR pd.period = result.delivered_at
        OR pd.period = result.failed_at)
    GROUP BY pd.period) result;

DROP PROCEDURE load_date_bu;

DROP TEMPORARY TABLE period_bu;