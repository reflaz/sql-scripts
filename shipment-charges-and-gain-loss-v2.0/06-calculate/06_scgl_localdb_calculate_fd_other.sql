/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss Parameter Setup

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scgl;

SET @extractstart = '2017-03-01';
SET @extractend = '2017-04-01';

SELECT 
    *
FROM
    (SELECT 
        *,
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost - IF(fk_shipment_scheme IN (2 , 3, 4)
                AND first_shipped_date IS NOT NULL
                AND not_delivered_date IS NOT NULL, total_shipment_cost, 0) 'gain_loss',
            CASE
                WHEN seller_type = 'supplier' THEN shipping_fee_to_customer
                WHEN fk_zone_type <> 0 THEN shipping_amount
                ELSE 0
            END 'pc1',
            CASE
                WHEN
                    seller_type = 'supplier'
                THEN
                    (total_delivery_cost + IF(fk_shipment_scheme IN (2 , 3, 4)
                        AND first_shipped_date IS NOT NULL
                        AND not_delivered_date IS NOT NULL, total_shipment_cost, 0)) * - 1
                ELSE 0
            END 'pc2',
            CASE
                WHEN
                    seller_type = 'supplier'
                        OR fk_zone_type = 0
                THEN
                    0
                ELSE total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost - IF(fk_shipment_scheme IN (2 , 3, 4)
                    AND first_shipped_date IS NOT NULL
                    AND not_delivered_date IS NOT NULL, total_shipment_cost, 0)
            END 'pc3'
    FROM
        scgl.anondb_calculate
    WHERE
        not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend
            AND fk_shipment_scheme = 1) direct_billing;
        
SELECT 
    *
FROM
    (SELECT 
        *,
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost - IF(fk_shipment_scheme IN (2 , 3, 4)
                AND first_shipped_date IS NOT NULL
                AND not_delivered_date IS NOT NULL, total_shipment_cost, 0) 'gain_loss',
            CASE
                WHEN seller_type = 'supplier' THEN shipping_fee_to_customer
                WHEN fk_zone_type <> 0 THEN shipping_amount / 1.1
                ELSE 0
            END 'pc1',
            CASE
                WHEN
                    seller_type = 'supplier'
                THEN
                    (total_delivery_cost + IF(fk_shipment_scheme IN (2 , 3, 4)
                        AND first_shipped_date IS NOT NULL
                        AND not_delivered_date IS NOT NULL, total_shipment_cost, 0)) * - 1
                ELSE 0
            END 'pc2',
            CASE
                WHEN
                    seller_type = 'supplier'
                        OR fk_zone_type = 0
                THEN
                    0
                ELSE total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost - IF(fk_shipment_scheme IN (2 , 3, 4)
                    AND first_shipped_date IS NOT NULL
                    AND not_delivered_date IS NOT NULL, total_shipment_cost, 0)
            END 'pc3'
    FROM
        scgl.anondb_calculate
    WHERE
        not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend
            AND seller_type = 'supplier') retail;
        
SELECT 
    *
FROM
    (SELECT 
        *,
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost - IF(fk_shipment_scheme IN (2 , 3, 4)
                AND first_shipped_date IS NOT NULL
                AND not_delivered_date IS NOT NULL, total_shipment_cost, 0) 'gain_loss',
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_shipment_cost - total_insurance_charge 'pc1',
            - total_pickup_cost 'pc2',
            0 'pc3'
    FROM
        scgl.anondb_calculate
    WHERE
        not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend
            AND fk_shipment_scheme = 7) go_jek;