/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Invoice Check
 
Prepared by		: RM
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @period for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @seller_type = 'supplier';-- supplier/merchant

SELECT 
    li.lazada_package_number,
    SUM(li.weight) 'weight',
    SUM(li.discounted_delivery_fee) 'discounted_delivery_fee',
    SUM(li.vat_delivery_fee) 'vat_delivery_fee',
    SUM(li.discounted_return_failed_delivery_fee) 'discounted_return_failed_delivery_fee',
    SUM(li.vat_return_failed_delivery_fee) 'vat_return_failed_delivery_fee',
    SUM(li.cod_fee) 'cod_fee',
    SUM(li.vat_cod_fee) 'vat_cod_fee',
    SUM(li.insurance_fee) 'insurance_fee',
    SUM(li.vat_insurance_fee) 'vat_insurance_fee',
    SUM(li.discounted_pickup_fee) 'discounted_pickup_fee',
    SUM(li.vat_pickup_fee) 'vat_pickup_fee',
    SUM(li.total_payment) 'total_payment',
    ac.rounded_weight,
    ac.total_shipment_cost,
    CASE
        WHEN SUM(li.weight) - ac.rounded_weight < 0 THEN 'Invoice weight < system weight'
        WHEN SUM(li.weight) - ac.rounded_weight > 0 THEN 'Invoice weight > system weight'
        WHEN SUM(li.weight) - ac.rounded_weight = 0 THEN 'Invoice weight = system weight'
    END 'weight_remarks',
    CASE
        WHEN SUM(li.discounted_delivery_fee) - ac.total_shipment_cost < 0 THEN 'Invoice delivery cost < calculated delivery cost'
        WHEN SUM(li.discounted_delivery_fee) - ac.total_shipment_cost > 0 THEN 'Invoice delivery cost > calculated delivery cost'
        WHEN SUM(li.discounted_delivery_fee) - ac.total_shipment_cost = 0 THEN 'Invoice delivery cost = calculated delivery cost'
    END 'delivery_cost_remarks'
FROM
    lel_invoice_tracker.lel_invoice li
        LEFT JOIN
    scgl.anondb_calculate ac ON li.lazada_package_number = ac.package_number
        AND ac.seller_type = @seller_type
GROUP BY li.lazada_package_number