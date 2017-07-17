/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Master Account Shipping Charge Calculation
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Run the script and wait for the result
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE masc;

SELECT 
    *
FROM
    (SELECT 
        order_nr 'Order Number',
            bob_id_sales_order_item 'Sales Order Item',
            sc_sales_order_item 'SC Sales Order Item',
            sku 'SKU',
            qty 'Qty',
            seller_id 'Seller ID',
            sc_seller_id 'SC Seller ID',
            seller_name 'Seller Name',
            seller_type 'Seller Type',
            tax_class 'Tax Class',
            total_unit_price 'Total Unit Price',
            total_paid_price 'Total Paid Price',
            total_shipping_surcharge 'Total Shipping Surcharge',
            last_status 'Last Status',
            order_date 'Order Date',
            first_shipped_date 'First Shipped Date',
            last_shipped_date 'Last Shipped Date',
            delivered_date 'Delivered Date',
            first_tracking_number 'First Tracking Number',
            first_shipment_provider 'First Shipment Provider',
            last_tracking_number 'Last Tracking Number',
            last_shipment_provider 'Last Shipment Provider',
            total_weight 'Total Weight',
            total_volumetric_weight 'Total Volumetric Weight',
            formula_weight 'Formula Weight',
            rounded_weight 'Rounded Weight',
            vip_calculation 'VIP Calculation',
            insurance_waived 'Insurance Waived',
            IF(vip_calculation = 1, 1000, rate) 'Charge Rate',
            net_charge_to_seller 'Charge to Seller',
            sc_shipping_fee 'SC Shipping Fee',
            IF(insurance_waived = 1, 0, IF(last_shipment_provider LIKE '%LEX%'
                OR last_shipment_provider LIKE '%REPEX%', insurance * 1.1, insurance)) 'Insurance',
            (net_charge_to_seller + IF(insurance_waived = 1, 0, IF(last_shipment_provider LIKE '%LEX%'
                OR last_shipment_provider LIKE '%REPEX%', insurance * 1.1, insurance))) 'Total Charge to Seller'
    FROM
        (SELECT 
        oms.*,
            IF(vs.seller_id IS NOT NULL
                AND oms.first_shipped_date >= vs.start_date
                AND oms.first_shipped_date <= IFNULL(IF(vs.end_date < vs.start_date, NULL, vs.end_date), NOW()), 1, 0) 'vip_calculation',
            IF(iw.seller_id IS NOT NULL
                AND oms.first_shipment_provider LIKE '%LEX%'
                AND oms.first_shipped_date >= iw.start_date
                AND oms.first_shipped_date <= IFNULL(IF(iw.end_date < iw.start_date, NULL, iw.end_date), NOW())
                AND total_unit_price < 1000000, 1, 0) 'insurance_waived',
            IF(vs.seller_id IS NOT NULL
                AND oms.first_shipped_date >= vs.start_date, (1000 * rounded_weight), charge_to_seller) 'net_charge_to_seller',
            CASE
                WHEN
                    last_shipment_provider LIKE '%LEX%'
                        AND total_unit_price < 1000000
                THEN
                    2500
                WHEN
                    last_shipment_provider NOT LIKE '%LEX%'
                        AND total_paid_price + IFNULL(total_shipping_surcharge, 0) < 1000000
                THEN
                    2500
                WHEN
                    last_shipment_provider LIKE '%LEX%'
                        AND total_unit_price >= 1000000
                THEN
                    total_unit_price * 0.0025
                ELSE (total_paid_price + IFNULL(total_shipping_surcharge, 0)) * 0.0025
            END 'insurance'
    FROM
        oms
    LEFT JOIN insurance_waive iw ON oms.sc_seller_id = iw.seller_id
    LEFT JOIN vip_seller vs ON oms.sc_seller_id = vs.seller_id
    WHERE
        delivered_date IS NOT NULL) result) result