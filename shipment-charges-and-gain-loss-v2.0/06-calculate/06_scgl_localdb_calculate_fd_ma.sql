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
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_shipment_cost - IF(fk_shipment_scheme IN (2 , 3, 4)
                AND first_shipped_date IS NOT NULL
                AND not_delivered_date IS NOT NULL, total_shipment_cost, 0) - total_insurance_charge 'pc1',
            - total_pickup_cost 'pc2',
            0 'pc3'
    FROM
        scgl.anondb_calculate
    WHERE
        not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend
            AND fk_shipment_scheme IN (2 , 4)
            AND seller_type = 'merchant') master_account
LIMIT 1000000;
            
USE scgl;

SELECT 
    *
FROM
    (SELECT 
        *,
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost - IF(fk_shipment_scheme IN (2 , 3, 4)
                AND first_shipped_date IS NOT NULL
                AND not_delivered_date IS NOT NULL, total_shipment_cost, 0) 'gain_loss',
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_shipment_cost - IF(fk_shipment_scheme IN (2 , 3, 4)
                AND first_shipped_date IS NOT NULL
                AND not_delivered_date IS NOT NULL, total_shipment_cost, 0) - total_insurance_charge 'pc1',
            - total_pickup_cost 'pc2',
            0 'pc3'
    FROM
        scgl.anondb_calculate
    WHERE
        not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend
            AND fk_shipment_scheme IN (2 , 4)
            AND seller_type = 'merchant') master_account
LIMIT 1000000 , 1000000;
            
USE scgl;

SELECT 
    *
FROM
    (SELECT 
        *,
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost - IF(fk_shipment_scheme IN (2 , 3, 4)
                AND first_shipped_date IS NOT NULL
                AND not_delivered_date IS NOT NULL, total_shipment_cost, 0) 'gain_loss',
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_shipment_cost - IF(fk_shipment_scheme IN (2 , 3, 4)
                AND first_shipped_date IS NOT NULL
                AND not_delivered_date IS NOT NULL, total_shipment_cost, 0) - total_insurance_charge 'pc1',
            - total_pickup_cost 'pc2',
            0 'pc3'
    FROM
        scgl.anondb_calculate
    WHERE
        not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend
            AND fk_shipment_scheme IN (2 , 4)
            AND seller_type = 'merchant') master_account
LIMIT 2000000 , 1000000;