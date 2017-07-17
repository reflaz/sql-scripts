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
    package_number,
    first_tracking_number,
    last_tracking_number,
    first_shipment_provider,
    last_shipment_provider,
    order_nr AS order_number,
    seller_name,
    seller_type,
    tax_class,
    last_shipped_date,
    delivered_date,
    last_status,
    shipping_amount,
    shipping_surcharge,
    shipment_fee_mp_seller,
    sel_ins_fee 'insurance_fee',
    sel_ins_fee_vat 'insurance_fee_vat',
    total_shipment_fee_mp_seller,
    city 'destination_city',
    id_district,
    payment_method,
    qty
FROM
    scgl.anondb_calculate
WHERE
    fk_shipment_scheme IN (2 , 4)
        AND seller_type = 'merchant'
LIMIT 1000000;

USE scgl;

SELECT 
    package_number,
    first_tracking_number,
    last_tracking_number,
    first_shipment_provider,
    last_shipment_provider,
    order_nr AS order_number,
    seller_name,
    seller_type,
    tax_class,
    last_shipped_date,
    delivered_date,
    last_status,
    shipping_amount,
    shipping_surcharge,
    shipment_fee_mp_seller,
    sel_ins_fee,
    sel_ins_fee_vat,
    total_shipment_fee_mp_seller,
    destination_city,
    id_district,
    payment_method,
    qty
FROM
    scgl.anondb_calculate
WHERE
    fk_shipment_scheme IN (2 , 4)
        AND seller_type = 'merchant'
LIMIT 1000000,1000000;
            
USE scgl;

SELECT 
    package_number,
    first_tracking_number,
    last_tracking_number,
    first_shipment_provider,
    last_shipment_provider,
    order_nr AS order_number,
    seller_name,
    seller_type,
    tax_class,
    last_shipped_date,
    delivered_date,
    last_status,
    shipping_amount,
    shipping_surcharge,
    shipment_fee_mp_seller,
    sel_ins_fee,
    sel_ins_fee_vat,
    total_shipment_fee_mp_seller,
    destination_city,
    id_district,
    payment_method,
    qty
FROM
    scgl.anondb_calculate
WHERE
    fk_shipment_scheme IN (2 , 4)
        AND seller_type = 'merchant'
LIMIT 2000000,1000000;