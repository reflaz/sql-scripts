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
SET @extractstart = '2017-07-01';
SET @extractend = '2017-07-17';-- This MUST be D + 1

SELECT 
    bob_id_supplier,
    short_code,
    seller_name,
    tax_class,
    ae.sku,
    ct.level1,
    DATE(order_date) 'period',
    COUNT(DISTINCT order_nr) 'count_so',
    COUNT(bob_id_sales_order_item) 'count_soi',
    SUM(unit_price) 'temp_unit_price',
    SUM(paid_price) 'temp_paid_price',
    wp.periode_order_date 'periode_wp',
    SUM(wp.backmargin_per_item) 'backmargin'
FROM
    scgl.anondb_extract ae
        LEFT JOIN
    scgl.wp_backmargin wp ON ae.sku = wp.sku
        AND DATE(ae.order_date) = wp.periode_order_date
        LEFT JOIN
    scgl.category_tree ct ON ae.primary_category = ct.lookup_cat_id
WHERE
    ae.order_date >= @extractstart
        AND ae.order_date < @extractend
        AND wp.backmargin_per_item IS NOT NULL
GROUP BY bob_id_supplier , short_code , seller_name , tax_class , ae.sku , DATE(order_date) , wp.periode_order_date , ct.level1