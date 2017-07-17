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
            IFNULL(vip_calculation, '') 'VIP Calculation',
            IFNULL(first_shipment_provider, '') 'First Shipment Provider',
            IFNULL(shipping_surcharge, 0) 'Shipping Surcharge',
            IFNULL(unit_price, 0) 'Unit Price',
            IFNULL(total_unit_price, 0) 'Total Unit Price',
            IFNULL(insurance_rate, 0) 'Insurance Rate',
            IFNULL(insurance_waived, 0) 'Insurance Waived',
            IFNULL(origin, '') 'Origin',
            IFNULL(destination, '') 'Destination',
            IFNULL(system_qty, 0) 'System Qty',
            IFNULL(length, 0) 'System Length',
            IFNULL(width, 0) 'System Width',
            IFNULL(height, 0) 'System Height',
            IFNULL(volumetric_weight, 0) 'Volumetric Weight',
            IFNULL(package_weight, 0) 'Package Weight',
            IFNULL(system_weight, 0) 'System Weight',
            IFNULL(total_system_weight, 0) 'Total System Weight',
            IFNULL(charge_rate, 0) 'Charge Rate',
            IFNULL(formula_weight, 0) 'Formula Weight',
            (IFNULL(weight, 0) - IFNULL(formula_weight, 0)) 'Weight Difference',
            IFNULL(charged_to_seller, 0) 'Charged to Seller',
            IFNULL(calculated_charge, 0) 'Calculated Invoice Charge',
            IFNULL((calculated_charge * charge_rate) + (insurance * insurance_rate * IF(first_shipment_provider LIKE '%LEX%', 1.1, 1)), 0) 'Distributed Invoice Charge',
            (IFNULL(charged_to_seller, 0) * - 1) - (IFNULL((calculated_charge * charge_rate) + (insurance * insurance_rate), 0)) 'Amount to be Charged',
            CASE
                WHEN (system_qty > 1) THEN 'Qty > 1'
                WHEN weight_remarks IS NOT NULL THEN weight_remarks
                WHEN (IFNULL(weight, 0) > IFNULL(formula_weight, 0)) THEN 'Invoice Weight > SC Weight'
                WHEN (IFNULL(weight, 0) < IFNULL(formula_weight, 0)) THEN 'Invoice Weight < SC Weight'
                WHEN (IFNULL(weight, 0) = IFNULL(formula_weight, 0)) THEN 'Invoice Weight = SC Weight'
            END 'Weight Remarks',
            CASE
                WHEN IFNULL((calculated_charge * charge_rate) + (insurance * insurance_rate * IF(first_shipment_provider LIKE '%LEX%', 1.1, 1)), 0) + IFNULL(charged_to_seller, 0) = 0 THEN 'Charged to Seller'
                WHEN IFNULL((calculated_charge * charge_rate) + (insurance * insurance_rate * IF(first_shipment_provider LIKE '%LEX%', 1.1, 1)), 0) + IFNULL(charged_to_seller, 0) < 0 THEN 'Over Charged'
                WHEN IFNULL((calculated_charge * charge_rate) + (insurance * insurance_rate * IF(first_shipment_provider LIKE '%LEX%', 1.1, 1)), 0) + IFNULL(charged_to_seller, 0) > 0 THEN 'Under Charged'
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
            IF(vs.seller_id IS NOT NULL
                AND oms.shipped_date >= vs.start_date
                AND oms.shipped_date <= IFNULL(IF(vs.end_date < vs.start_date, NULL, vs.end_date), NOW()), 1, 0) 'vip_calculation',
            oms.first_shipment_provider,
            oms.shipping_surcharge,
            oms.unit_price,
            ins.total_unit_price 'total_unit_price',
            IF((iw.start_date IS NULL
                OR oms.order_date < iw.start_date
                OR oms.order_date > IFNULL(IF(iw.end_date < iw.start_date, NULL, iw.end_date), NOW())), oms.unit_price / ins.total_unit_price, 0) 'insurance_rate',
            IF(oms.order_date >= iw.start_date, 1, 0) 'insurance_waived',
            oms.origin,
            oms.city 'Destination',
            oms.qty 'system_qty',
            oms.length,
            oms.width,
            oms.height,
            oms.volumetric_weight,
            oms.weight 'package_weight',
            oms.system_weight,
            pw.total_system_weight 'total_system_weight',
            (oms.system_weight / pw.total_system_weight) 'charge_rate',
            SUM(IFNULL(oms.charged_to_seller, 0)) 'charged_to_Seller',
            CASE
                WHEN oms.first_shipment_provider LIKE '%LEX%' THEN CEIL(oms.system_weight)
                ELSE IF(oms.system_weight < 1, 1, IF(MOD(oms.system_weight, 1) <= 0.3, FLOOR(oms.system_weight), CEIL(oms.system_weight)))
            END 'formula_weight',
            CASE
                WHEN
                    vs.seller_id IS NOT NULL
                        AND oms.shipped_date >= vs.start_date
                        AND oms.shipped_date <= IFNULL(IF(vs.end_date < vs.start_date, NULL, vs.end_date), NOW())
                THEN
                    (CEIL(inv.weight) * 1000)
                WHEN oms.first_shipment_provider LIKE '%LEX%' THEN (CEIL(inv.weight) * 6464)
                ELSE (IF(inv.weight < 1, 1, IF(MOD(inv.weight, 1) <= 0.3, FLOOR(inv.weight), CEIL(inv.weight))) * 7000)
            END 'calculated_charge',
            weight_remarks
    FROM
        invoice inv
    LEFT JOIN oms ON inv.tracking_number = oms.tracking_number
    LEFT JOIN vip_seller vs ON oms.sc_seller_id = vs.seller_id
    LEFT JOIN (SELECT 
        tracking_number, SUM(system_weight) total_system_weight
    FROM
        oms
    GROUP BY tracking_number) pw ON oms.tracking_number = pw.tracking_number
    LEFT JOIN (SELECT 
        inv.tracking_number, SUM(oms.unit_price) total_unit_price
    FROM
        invoice inv
    LEFT JOIN oms ON inv.tracking_number = oms.tracking_number
    LEFT JOIN insurance_waive iw ON oms.sc_seller_id = iw.seller_id
    WHERE
        iw.start_date IS NULL
            OR oms.order_date < iw.start_date
            OR oms.order_date > IFNULL(IF(iw.end_date < iw.start_date, NULL, iw.end_date), NOW())
    GROUP BY tracking_number) ins ON oms.tracking_number = ins.tracking_number
    LEFT JOIN insurance_waive iw ON oms.sc_seller_id = iw.seller_id
    GROUP BY inv.tracking_number , oms.sc_seller_id) result) result;