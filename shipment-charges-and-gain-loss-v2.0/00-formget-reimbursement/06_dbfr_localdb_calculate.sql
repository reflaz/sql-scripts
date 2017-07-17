/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Direct Billing vs Formget Reimbursement Calculation
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Run the script and wait for the result
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    *
FROM
    (SELECT 
        IFNULL(inv.short_code, '') 'Seller ID',
            IFNULL(inv.seller_name, ac.seller_name) 'Seller Name',
            IFNULL(inv.order_nr, '') 'Order Number',
            IFNULL(inv.free_text, '') 'Uploaded Shipment Receipt',
            IFNULL(inv.origin, '') 'Seller\'s Location',
            IFNULL(inv.weight, '') 'Weight',
            IFNULL(inv.delivery_charge, '') 'Formget Delivery Charge',
            IFNULL(ac.order_date, '') 'System Created Date',
            IFNULL(MIN(ac.delivered_date), '') 'Delivered Date',
            IFNULL(MIN(ac.sc_sales_order_item), '') 'SC Sales Order Item',
            IFNULL(ac.sku, '') 'SKU',
            IFNULL(MIN(ac.last_tracking_number), '') 'Tracking Number',
            IFNULL(MIN(ac.last_shipment_provider), '') 'Shipment Provider',
            IFNULL(ac.city, '') 'Destination',
            IFNULL(ac.qty, '') 'Qty',
            IFNULL(ac.rounded_chargeable_weight, '') 'System Weight',
            IFNULL(ac.shipping_amount, '') 'Shipping Amount',
            IFNULL(ac.shipping_surcharge, '') 'Shipping Surcharge',
            IFNULL(ac.total_shipment_fee_mp_seller, 0) 'Seller Shipping Fee',
            IFNULL(ac.sc_fee_3, 0) 'Weekly Reimbursement',
            (IFNULL(inv.weight, 0) - IFNULL(ac.rounded_chargeable_weight, 0)) 'Weight Difference',
            IFNULL(inv.delivery_charge, 0) - IFNULL(ac.total_shipment_fee_mp_seller, 0) - IFNULL(ac.shipping_amount, 0) - IFNULL(ac.shipping_surcharge, 0) - IFNULL(ac.sc_fee_3, 0) 'Amount to be Paid',
            CASE
                WHEN (ac.qty > 1) THEN 'Qty > 1'
                WHEN (IFNULL(inv.weight, 0) > IFNULL(ac.chargeable_weight, 0)) THEN 'Formget Weight > SC Weight'
                WHEN (IFNULL(inv.weight, 0) < IFNULL(ac.chargeable_weight, 0)) THEN 'Formget Weight < SC Weight'
                WHEN (IFNULL(inv.weight, 0) = IFNULL(ac.chargeable_weight, 0)) THEN 'Formget Weight = SC Weight'
            END 'Weight Remarks',
            CASE
                WHEN COUNT(tracking_number) > 1 THEN 'Multiple AWB per Order'
                WHEN (IFNULL(inv.weight, 0) <> IFNULL(ac.chargeable_weight, 0)) THEN 'Different Weight'
                WHEN (IFNULL(inv.delivery_charge, 0) - IFNULL(ac.total_shipment_fee_mp_seller, 0) - IFNULL(ac.shipping_amount, 0) - IFNULL(ac.shipping_surcharge, 0) - IFNULL(ac.sc_fee_3, 0) = 0) THEN 'Reimbursed to Seller'
                WHEN (IFNULL(inv.delivery_charge, 0) - IFNULL(ac.total_shipment_fee_mp_seller, 0) - IFNULL(ac.shipping_amount, 0) - IFNULL(ac.shipping_surcharge, 0) - IFNULL(ac.sc_fee_3, 0) <> 0) THEN 'Different Rate'
                ELSE ''
            END 'Rate Remarks'
    FROM
        scgl.invoice inv
    LEFT JOIN scgl.anondb_calculate ac ON inv.order_nr = ac.order_nr
        AND inv.short_code = ac.short_code
    GROUP BY inv.order_nr , inv.short_code) result;