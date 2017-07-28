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
    ac.bob_id_supplier,
    ac.short_code,
    ac.seller_name,
    ac.tax_class,
    ac.sku,
    ct.level1,
    COUNT(DISTINCT ac.order_nr) 'count_so',
    COUNT(ac.bob_id_sales_order_item) 'count_soi',
    SUM(ac.unit_price) 'temp_unit_price',
    SUM(ac.paid_price) 'temp_paid_price',
    bm.bm_date,
    SUM(bm.backmargin) 'backmargin'
FROM
    scglv3.anondb_calculate ac
        JOIN
    scglv3.backmargin bm ON ac.sku = bm.sku
        AND DATE(ac.order_date) = bm.bm_date
        LEFT JOIN
    scglv3.category_tree ct ON ac.primary_category = ct.id_primary_category
WHERE
    ac.order_date >= @extractstart
        AND ac.order_date < @extractend
GROUP BY bob_id_supplier , sku , bm_date , level1_id