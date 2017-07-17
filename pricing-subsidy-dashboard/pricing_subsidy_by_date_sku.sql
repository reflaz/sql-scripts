/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Pricing Item Subsidy Dashboard by Date by SKU
 
Prepared by		: RM
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractstart for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-10-21';
SET @extractend = '2017-01-01';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        bob_id_supplier,
            short_code,
            seller_name,
            tax_class,
            sku,
            name,
            period,
            COUNT(DISTINCT count_so) count_so,
            COUNT(count_soi) count_soi,
            SUM(temp_unit_price) sum_unit_price,
            SUM(temp_paid_price) sum_paid_price
    FROM
        (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            soi.sku,
            soi.name,
            soi.unit_price,
            soi.paid_price,
            so.order_date,
            soi.bob_id_supplier,
            sel.short_code,
            sup.name 'seller_name',
            CASE
				WHEN sel.tax_class = 0 THEN 'local'
                WHEN sel.tax_class = 1 THEN 'international'
			END 'tax_class',
            CASE
                WHEN order_date >= '2016-10-21' and order_date < '2016-12-01' and sku = 'AC016ELAA57M8DANID-10481220' THEN '2016-10-21 - 2016-12-01'
            END AS period,
            CASE
                WHEN order_date >= '2016-10-21' and order_date < '2016-12-01' and sku = 'AC016ELAA57M8DANID-10481220' THEN order_nr
            END AS count_so,
            CASE
                WHEN order_date >= '2016-10-21' and order_date < '2016-12-01' and sku = 'AC016ELAA57M8DANID-10481220' THEN bob_id_sales_order_item
            END AS count_soi,
            CASE
                WHEN order_date >= '2016-10-21' and order_date < '2016-12-01' and sku = 'AC016ELAA57M8DANID-10481220' THEN unit_price
            END AS temp_unit_price,
            CASE
                WHEN order_date >= '2016-10-21' and order_date < '2016-12-01' and sku = 'AC016ELAA57M8DANID-10481220' THEN paid_price
            END AS temp_paid_price
    FROM
        (SELECT 
        id_sales_order, order_nr, created_at 'order_date'
    FROM
        oms_live.ims_sales_order
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend) so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        soi.sku IN ()
    GROUP BY soi.bob_id_sales_order_item
    HAVING period IS NOT NULL) result
    GROUP BY sku , period) result