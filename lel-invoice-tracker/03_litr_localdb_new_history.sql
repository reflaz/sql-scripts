/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Data For Population in History Invoice
 
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
    inv.*, @period AS period
FROM
    (SELECT 
        inv.bob_id_sales_order_item,
            MAX(inv.total_payment) 'total_payment'
    FROM
        lel_invoice_tracker.lel_invoice inv
    LEFT JOIN lel_invoice_tracker.lel_invoice_history hist ON inv.bob_id_sales_order_item = hist.bob_id_sales_order_item
    WHERE
        hist.lazada_package_number IS NULL
    GROUP BY inv.bob_id_sales_order_item) result
        LEFT JOIN
    lel_invoice_tracker.lel_invoice inv ON result.bob_id_sales_order_item = inv.bob_id_sales_order_item
        AND result.total_payment = inv.total_payment
GROUP BY inv.bob_id_sales_order_item