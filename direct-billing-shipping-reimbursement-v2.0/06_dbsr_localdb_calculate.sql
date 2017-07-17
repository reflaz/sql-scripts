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
        order_nr 'Order Number',
            bob_id_sales_order_item 'Sales Order Item',
            sc_sales_order_item 'SC Sales Order Item',
            sku 'SKU',
            short_code 'SC Seller ID',
            seller_name 'Seller Name',
            shipping_amount 'Total Shipping Amount',
            shipping_surcharge 'Total Shipping Surcharge',
            shipping_fee_to_customer 'Total Shipping Surcharge Non Bulky',
            order_date 'Order Date',
            last_shipped_date 'Shipped Date',
            delivered_date 'Delivered Date',
            package_number 'Package Number',
            last_tracking_number 'Tracking Number',
            last_shipment_provider 'Shipment Provider',
            origin 'Origin',
            city 'City',
            id_district 'District ID',
            qty 'Qty',
            formula_weight 'Formula Weight',
            rounded_weight 'Rounded Weight',
            rounded_chargeable_weight 'Rounded Weight Non Bulky',
            total_shipment_fee_mp_seller 'Total Charge to Seller',
            shipment_cost_rate '3PL Rate',
            CASE
                WHEN
                    first_shipped_date >= '2017-01-01'
                        OR order_date >= '2017-01-01'
                THEN
                    (rounded_weight * shipment_cost_rate)
                ELSE (rounded_chargeable_weight * shipment_cost_rate)
            END 'Total 3PL Charge',
            CASE
                WHEN
                    first_shipped_date >= '2017-01-01'
                        OR order_date >= '2017-01-01'
                THEN
                    (rounded_weight * shipment_cost_rate) - total_shipment_fee_mp_seller - shipping_fee_to_customer
                ELSE (rounded_chargeable_weight * shipment_cost_rate) - total_shipment_fee_mp_seller - shipping_fee_to_customer
            END 'Shipping Reimbursement/Charge'
    FROM
        scgl.anondb_calculate
    WHERE
        fk_shipment_scheme = 1) direct_billing;