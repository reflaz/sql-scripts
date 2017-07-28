/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Direct Billing Shipping Reimbursement

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

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
            IFNULL(ac.count_soi, '') 'Qty',
            IFNULL(ac.chargeable_weight_seller_ps, '') 'System Weight',
            IFNULL(ac.shipping_amount_temp, '') 'Shipping Amount',
            IFNULL(ac.shipping_surcharge_temp, '') 'Shipping Surcharge',
            IFNULL(ac.total_shipment_fee_mp_seller, 0) 'Seller Shipping Fee',
            IFNULL(ac.weekly_reimbursement, 0) 'Weekly Reimbursement',
            (IFNULL(inv.weight, 0) - IFNULL(ac.chargeable_weight_seller_ps, 0)) 'Weight Difference',
            IFNULL(inv.delivery_charge, 0) - IFNULL(ac.total_shipment_fee_mp_seller, 0) - IFNULL(ac.shipping_amount_temp, 0) - IFNULL(ac.shipping_surcharge_temp, 0) - IFNULL(ac.weekly_reimbursement, 0) 'Amount to be Paid',
            CASE
                WHEN (ac.count_soi > 1) THEN 'Qty > 1'
                WHEN (IFNULL(inv.weight, 0) > IFNULL(ac.chargeable_weight_seller_ps, 0)) THEN 'Formget Weight > SC Weight'
                WHEN (IFNULL(inv.weight, 0) < IFNULL(ac.chargeable_weight_seller_ps, 0)) THEN 'Formget Weight < SC Weight'
                WHEN (IFNULL(inv.weight, 0) = IFNULL(ac.chargeable_weight_seller_ps, 0)) THEN 'Formget Weight = SC Weight'
            END 'Weight Remarks',
            CASE
                WHEN COUNT(tracking_number) > 1 THEN 'Multiple AWB per Order'
                WHEN (IFNULL(inv.weight, 0) <> IFNULL(ac.chargeable_weight_seller_ps, 0)) THEN 'Different Weight'
                WHEN (IFNULL(inv.delivery_charge, 0) - IFNULL(ac.total_shipment_fee_mp_seller, 0) - IFNULL(ac.shipping_amount_temp, 0) - IFNULL(ac.shipping_surcharge_temp, 0) - IFNULL(ac.weekly_reimbursement, 0) = 0) THEN 'Reimbursed to Seller'
                WHEN (IFNULL(inv.delivery_charge, 0) - IFNULL(ac.total_shipment_fee_mp_seller, 0) - IFNULL(ac.shipping_amount_temp, 0) - IFNULL(ac.shipping_surcharge_temp, 0) - IFNULL(ac.weekly_reimbursement, 0) <> 0) THEN 'Different Rate'
                ELSE ''
            END 'Rate Remarks'
    FROM
        (SELECT 
        *,
            SUM(IFNULL(unit_price, 0)) 'unit_price_temp',
            SUM(IFNULL(paid_price, 0)) 'paid_price_temp',
            SUM(IFNULL(shipping_amount, 0)) 'shipping_amount_temp',
            SUM(IFNULL(shipping_surcharge, 0)) 'shipping_surcharge_temp',
            COUNT(bob_id_sales_order_item) 'count_soi',
            SUM(IFNULL(total_failed_delivery_cost_item, 0)) 'total_shipment_fee_mp_seller',
            SUM(IFNULL(seller_cr_db_item, 0)) 'weekly_reimbursement'
    FROM
        scglv3.anondb_calculate
    WHERE
        shipment_scheme LIKE '%DIRECT BILLING%'
    GROUP BY order_nr , bob_id_supplier) ac
    RIGHT JOIN scgl.invoice inv ON ac.order_nr = inv.order_nr
        AND ac.short_code = inv.short_code) result;