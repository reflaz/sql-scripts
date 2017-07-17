/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Back Margin (Local Processing)
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-06-01';
SET @extractend = '2017-06-02';-- This MUST be D + 1

SELECT 
    order_nr,
    bob_id_sales_order_item,
    ae.sku,
    unit_price,
    paid_price,
    order_date,
    bob_id_supplier,
    short_code,
    seller_name,
    tax_class,
    order_date 'period',
    order_nr 'count_so',
    bob_id_sales_order_item 'count_soi',
    unit_price 'temp_unit_price',
    paid_price 'temp_paid_price',
    wp.periode_order_date 'periode_wp',
    wp.backmargin_per_item 'backmargin'
FROM
    scgl.anondb_extract ae
        LEFT JOIN
    scgl.wp_backmargin wp ON ae.sku = wp.sku
        AND DATE(ae.order_date) = wp.periode_order_date
WHERE
    ae.order_date >= @extractstart
        AND ae.order_date < @extractend
        AND wp.backmargin_per_item IS NOT NULL