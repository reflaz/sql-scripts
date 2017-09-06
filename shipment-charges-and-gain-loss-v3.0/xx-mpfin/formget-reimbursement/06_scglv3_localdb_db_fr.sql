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
    IFNULL(inv_short_code, '') 'Seller ID',
    IFNULL(seller_name, '') 'Seller Name',
    IFNULL(inv_order_nr, '') 'Order Number',
    IFNULL(inv_free_text, '') 'Uploaded Shipment Receipt',
    IFNULL(inv_origin, '') 'Seller\'s Location',
    IFNULL(inv_weight, '') 'Weight',
    IFNULL(inv_delivery_charge, '') 'Formget Delivery Charge',
    IFNULL(order_date, '') 'System Created Date',
    IFNULL(delivered_date, '') 'Delivered Date',
    IFNULL(sc_sales_order_item, '') 'SC Sales Order Item',
    IFNULL(sku, '') 'SKU',
    IFNULL(last_tracking_number, '') 'Tracking Number',
    IFNULL(last_shipment_provider, '') 'Shipment Provider',
    IFNULL(city, '') 'Destination',
    IFNULL(count_soi, '') 'Qty',
    IFNULL(chargeable_weight_seller_ps, '') 'System Weight',
    IFNULL(shipping_amount_temp, '') 'Shipping Amount',
    IFNULL(shipping_surcharge_temp, '') 'Shipping Surcharge',
    IFNULL(total_shipment_fee_mp_seller, 0) 'Seller Shipping Fee',
    IFNULL(weekly_reimbursement, 0) 'Weekly Reimbursement',
    (IFNULL(inv_weight, 0) - IFNULL(chargeable_weight_seller_ps, 0)) 'Weight Difference',
    IFNULL(inv_delivery_charge, 0) - IFNULL(total_shipment_fee_mp_seller, 0) - IFNULL(shipping_amount_temp, 0) - IFNULL(shipping_surcharge_temp, 0) - IFNULL(weekly_reimbursement, 0) 'Amount to be Paid',
    CASE
        WHEN (count_soi > 1) THEN 'Qty > 1'
        WHEN (IFNULL(inv_weight, 0) > IFNULL(chargeable_weight_seller_ps, 0)) THEN 'Formget Weight > SC Weight'
        WHEN (IFNULL(inv_weight, 0) < IFNULL(chargeable_weight_seller_ps, 0)) THEN 'Formget Weight < SC Weight'
        WHEN (IFNULL(inv_weight, 0) = IFNULL(chargeable_weight_seller_ps, 0)) THEN 'Formget Weight = SC Weight'
    END 'Weight Remarks',
    CASE
        WHEN (IFNULL(inv_weight, 0) <> IFNULL(chargeable_weight_seller_ps, 0)) THEN 'Different Weight'
        WHEN (IFNULL(inv_delivery_charge, 0) - IFNULL(total_shipment_fee_mp_seller, 0) - IFNULL(shipping_amount_temp, 0) - IFNULL(shipping_surcharge_temp, 0) - IFNULL(weekly_reimbursement, 0) = 0) THEN 'Reimbursed to Seller'
        WHEN (IFNULL(inv_delivery_charge, 0) - IFNULL(total_shipment_fee_mp_seller, 0) - IFNULL(shipping_amount_temp, 0) - IFNULL(shipping_surcharge_temp, 0) - IFNULL(weekly_reimbursement, 0) <> 0) THEN 'Different Rate'
        ELSE ''
    END 'Rate Remarks'
FROM
    (SELECT 
        ac.*,
            inv.short_code 'inv_short_code',
            inv.order_nr 'inv_order_nr',
            inv.free_text 'inv_free_text',
            inv.origin 'inv_origin',
            inv.weight 'inv_weight',
            inv.delivery_charge 'inv_delivery_charge',
            SUM(IFNULL(ac.unit_price, 0)) 'unit_price_temp',
            SUM(IFNULL(ac.paid_price, 0)) 'paid_price_temp',
            SUM(IFNULL(ac.shipping_amount, 0)) 'shipping_amount_temp',
            SUM(IFNULL(ac.shipping_surcharge, 0)) 'shipping_surcharge_temp',
            COUNT(ac.bob_id_sales_order_item) 'count_soi',
            SUM(IFNULL(ac.total_shipment_fee_mp_seller_item, 0)) 'total_shipment_fee_mp_seller',
            SUM(IFNULL(ac.seller_cr_db_item, 0)) 'weekly_reimbursement'
    FROM
        invoice inv
    LEFT JOIN anondb_calculate ac ON inv.order_nr = ac.order_nr
        AND inv.short_code = ac.short_code
    GROUP BY ac.order_nr , ac.id_package_dispatching , ac.short_code) result