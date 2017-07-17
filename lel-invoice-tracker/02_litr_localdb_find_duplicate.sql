/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Check Data for Duplicate Invoice from LEL Invoice and from History Invoice
 
Prepared by		: Michael Julius
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @period for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @period = '';

SELECT 
    @period AS period, fin.*
FROM
    (SELECT 
        'Duplicate Billing' AS billing_status,
            b.*,
            IF(a.discounted_delivery_fee = b.discounted_delivery_fee, 'RECON', 'NOT RECON') AS discounted_delivery_fee_remark,
            IF(a.vat_delivery_fee = b.vat_delivery_fee, 'RECON', 'NOT RECON') AS vat_delivery_fee_remark,
            IF(a.discounted_return_failed_delivery_fee = b.discounted_return_failed_delivery_fee, 'RECON', 'NOT RECON') AS discounted_return_failed_delivery_fee_remark,
            IF(a.vat_return_failed_delivery_fee = b.vat_return_failed_delivery_fee, 'RECON', 'NOT RECON') AS vat_return_failed_delivery_fee_remark,
            IF(a.cod_fee = b.cod_fee, 'RECON', 'NOT RECON') AS cod_fee_remark,
            IF(a.vat_cod_fee = b.vat_cod_fee, 'RECON', 'NOT RECON') AS vat_cod_fee_remark,
            IF(a.insurance_fee = b.insurance_fee, 'RECON', 'NOT RECON') AS insurance_fee_remark,
            IF(a.vat_insurance_fee = b.vat_insurance_fee, 'RECON', 'NOT RECON') AS vat_insurance_fee_remark,
            IF(a.discounted_pickup_fee = b.discounted_pickup_fee, 'RECON', 'NOT RECON') AS discounted_pickup_fee_remark,
            IF(a.vat_pickup_fee = b.vat_pickup_fee, 'RECON', 'NOT RECON') AS vat_pickup_fee_remark,
            IF(a.total_payment = b.total_payment, 'RECON', 'NOT RECON') AS total_payment_remark
    FROM
        (SELECT 
        *, COUNT(*) count_id
    FROM
        lel_invoice_tracker.lel_invoice
    GROUP BY bob_id_sales_order_item
    HAVING count_id > 1) a
    LEFT JOIN lel_invoice_tracker.lel_invoice b ON a.bob_id_sales_order_item = b.bob_id_sales_order_item) fin 
UNION ALL SELECT 
    @period AS period, fin.*
FROM
    (SELECT 
        'Billing already in history' AS billing_status,
            a.*,
            IF(a.discounted_delivery_fee = b.discounted_delivery_fee, 'RECON', 'NOT RECON') AS discounted_delivery_fee_remark,
            IF(a.vat_delivery_fee = b.vat_delivery_fee, 'RECON', 'NOT RECON') AS vat_delivery_fee_remark,
            IF(a.discounted_return_failed_delivery_fee = b.discounted_return_failed_delivery_fee, 'RECON', 'NOT RECON') AS discounted_return_failed_delivery_fee_remark,
            IF(a.vat_return_failed_delivery_fee = b.vat_return_failed_delivery_fee, 'RECON', 'NOT RECON') AS vat_return_failed_delivery_fee_remark,
            IF(a.cod_fee = b.cod_fee, 'RECON', 'NOT RECON') AS cod_fee_remark,
            IF(a.vat_cod_fee = b.vat_cod_fee, 'RECON', 'NOT RECON') AS vat_cod_fee_remark,
            IF(a.insurance_fee = b.insurance_fee, 'RECON', 'NOT RECON') AS insurance_fee_remark,
            IF(a.vat_insurance_fee = b.vat_insurance_fee, 'RECON', 'NOT RECON') AS vat_insurance_fee_remark,
            IF(a.discounted_pickup_fee = b.discounted_pickup_fee, 'RECON', 'NOT RECON') AS discounted_pickup_fee_remark,
            IF(a.vat_pickup_fee = b.vat_pickup_fee, 'RECON', 'NOT RECON') AS vat_pickup_fee_remark,
            IF(a.total_payment = b.total_payment, 'RECON', 'NOT RECON') AS total_payment_remark
    FROM
        (SELECT 
        *
    FROM
        lel_invoice_tracker.lel_invoice
    GROUP BY bob_id_sales_order_item) a
    INNER JOIN lel_invoice_tracker.lel_invoice_history b ON a.bob_id_sales_order_item = b.bob_id_sales_order_item) fin