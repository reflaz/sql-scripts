/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Item per Order on Weight Threshold Summary

Prepared by		: R Maliangkay
Modified by		: RM
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
SET @extractstart = '2017-05-01';
SET @extractend = '2017-05-03';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        order_date_bucket,
            SUM(IF(rounding = 1, qty, 0)) 'item_1kg',
            COUNT(DISTINCT IF(rounding = 1, order_nr, NULL)) 'order_1kg',
            SUM(IF(rounding = 1, qty, 0)) / COUNT(DISTINCT IF(rounding = 1, order_nr, NULL)) 'item_order_1kg',
            SUM(IF(rounding = 2, qty, 0)) 'item_2kg',
            COUNT(DISTINCT IF(rounding = 2, order_nr, NULL)) 'order_2kg',
            SUM(IF(rounding = 2, qty, 0)) / COUNT(DISTINCT IF(rounding = 2, order_nr, NULL)) 'item_order_2kg',
            SUM(IF(rounding IS NOT NULL, qty, 0)) 'item',
            COUNT(DISTINCT IF(rounding IS NOT NULL, order_nr, NULL)) 'order_nr',
            SUM(IF(rounding IS NOT NULL, qty, 0)) / COUNT(DISTINCT IF(rounding IS NOT NULL, order_nr, NULL)) 'item_order'
    FROM
        (SELECT 
        *,
            COUNT(DISTINCT IFNULL(id_package_dispatching, 1)) 'source',
            SUM(qty_temp) 'qty'
    FROM
        (SELECT 
        *,
            GREATEST(SUM(weight), SUM(volumetric_weight)) 'formula_weight',
            COUNT(bob_id_sales_order_item) 'qty_temp'
    FROM
        (SELECT 
        ae.*,
            zt.id_zone_type,
            zt.zone_type,
            rcc.rounding,
            rcc.flat_rate,
            DATE_FORMAT(order_date, '%Y-%m-%d') order_date_bucket,
            IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    simple_weight
                ELSE config_weight
            END, 0) 'weight',
            IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END, 0) 'volumetric_weight'
    FROM
        scgl.anondb_extract ae
    JOIN scgl.rate_card_customer rcc ON ae.id_district = rcc.id_district
        AND ae.origin = rcc.origin
    LEFT JOIN scgl.free_zone fz ON ae.id_district = fz.id_district
    LEFT JOIN scgl.zone_type zt ON fz.fk_zone_type = zt.id_zone_type
    WHERE
        order_date >= @extractstart
            AND order_date < @extractend) ae
    GROUP BY order_nr , id_package_dispatching) ae
    GROUP BY order_nr) ae
    GROUP BY order_date_bucket) ae;