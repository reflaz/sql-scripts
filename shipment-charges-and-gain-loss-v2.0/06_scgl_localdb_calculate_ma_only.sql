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

SELECT 
    *
FROM
    (SELECT 
        *,
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost 'gain_loss',
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_shipment_cost - total_insurance_charge 'pc1',
            - total_pickup_cost 'pc2',
            0 'pc3'
    FROM
        scgl.anondb_calculate
    WHERE
        fk_shipment_scheme IN (2 , 4)
            AND seller_type = 'merchant') master_account LIMIT 1000000;
            
USE scgl;

SELECT 
    *
FROM
    (SELECT 
        *,
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost 'gain_loss',
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_shipment_cost - total_insurance_charge 'pc1',
            - total_pickup_cost 'pc2',
            0 'pc3'
    FROM
        scgl.anondb_calculate
    WHERE
        fk_shipment_scheme IN (2 , 4)
            AND seller_type = 'merchant') master_account LIMIT 1000000,1000000;
            
USE scgl;

SELECT 
    *
FROM
    (SELECT 
        *,
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost 'gain_loss',
            total_shipment_fee_mp_seller + shipping_fee_to_customer - total_shipment_cost - total_insurance_charge 'pc1',
            - total_pickup_cost 'pc2',
            0 'pc3'
    FROM
        scgl.anondb_calculate
    WHERE
        fk_shipment_scheme IN (2 , 4)
            AND seller_type = 'merchant') master_account LIMIT 2000000,1000000;