/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Master Account vs Invoice Charge Calculate
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Run the script and wait for the result
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE maic;

SELECT 
    *
FROM
    (SELECT 
        tracking_number 'Tracking Number',
            dest 'Dest',
            qty 'Qty',
            weight 'Weight',
            goods_value 'Goods Value',
            insurance 'Insurance',
            delivery_charges 'Delivery Charge',
            IFNULL(order_date, '') 'System Created Date',
            IFNULL(shipped_date, '') 'System Shipped Date',
            IFNULL(order_nr, '') 'Order Number',
            IFNULL(sc_sales_order_item, '') 'SC Sales Order Item',
            IFNULL(sc_seller_id, '') 'Seller ID',
            IFNULL(seller_name, '') 'Seller Name',
            IFNULL(tax_class, '') 'Tax Class',
            IFNULL(first_shipment_provider, '') 'First Shipment Provider',
            IFNULL(origin, '') 'Origin',
            IFNULL(destination, '') 'Destination',
            IFNULL(system_qty, 0) 'System Qty',
            IFNULL(length, 0) 'System Width',
            IFNULL(width, 0) 'System Length',
            IFNULL(height, 0) 'System Height',
            IFNULL(system_weight, 0) 'System Weight',
            IFNULL(formula_weight, 0) 'Formula Weight',
            IFNULL(shipping_surcharge, 0) 'Shipping Surcharge',
            IFNULL(charged_to_seller, 0) 'Charged to Seller',
            IFNULL(calculated_charge, 0) 'Calculated Invoice Charge',
            (IFNULL(weight, 0) - IFNULL(formula_weight, 0)) 'Weight Difference',
            (IFNULL(charged_to_seller, 0) * - 1) - IFNULL(calculated_charge, 0) 'Amount to be Charged',
            CASE
                WHEN (system_qty > 1) THEN 'Qty > 1'
                WHEN weight_remarks IS NOT NULL THEN weight_remarks
                WHEN (IFNULL(weight, 0) > IFNULL(formula_weight, 0)) THEN 'Invoice Weight > SC Weight'
                WHEN (IFNULL(weight, 0) < IFNULL(formula_weight, 0)) THEN 'Invoice Weight < SC Weight'
                WHEN (IFNULL(weight, 0) = IFNULL(formula_weight, 0)) THEN 'Invoice Weight = SC Weight'
            END 'Weight Remarks',
            CASE
                WHEN IFNULL(calculated_charge, 0) + IFNULL(charged_to_seller, 0) = 0 THEN 'Charged to Seller'
                WHEN IFNULL(calculated_charge, 0) + IFNULL(charged_to_seller, 0) < 0 THEN 'Over Charged'
                WHEN IFNULL(calculated_charge, 0) + IFNULL(charged_to_seller, 0) > 0 THEN 'Under Charged'
            END 'Rate Remarks'
    FROM
        (SELECT 
        inv.tracking_number,
            inv.dest,
            inv.qty,
            inv.weight,
            inv.goods_value,
            inv.insurance,
            inv.delivery_charges,
            oms.order_date,
            oms.shipped_date,
            oms.order_nr,
            oms.sc_sales_order_item,
            oms.sc_seller_id,
            oms.seller_name,
            oms.tax_class,
            oms.first_shipment_provider,
            oms.origin,
            oms.city 'Destination',
            oms.qty 'system_qty',
            oms.length,
            oms.width,
            oms.height,
            oms.weight 'system_weight',
            oms.formula_weight,
            oms.shipping_surcharge,
            SUM(IFNULL(oms.charged_to_seller, 0)) 'charged_to_Seller',
            CASE
                WHEN oms.first_shipment_provider LIKE '%LEX%' THEN (CEIL(inv.weight) * 6464) + (inv.insurance * 1.1)
                ELSE (IF(inv.weight < 1, 1, IF(MOD(inv.weight, 1) <= 0.3, FLOOR(inv.weight), CEIL(inv.weight))) * 7000) + inv.insurance
            END 'calculated_charge',
            weight_remarks
    FROM
        invoice inv
    LEFT JOIN oms ON inv.tracking_number = oms.tracking_number
    GROUP BY inv.tracking_number) result) result;