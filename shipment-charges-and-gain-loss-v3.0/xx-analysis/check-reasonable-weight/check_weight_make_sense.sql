SELECT 
    weight_bucket,
    SUM(total_delivery_cost_item) 'total_delivery_cost_item',
    SUM(unit_price) 'unit_price',
    SUM(order_value) 'order_value',
    COUNT(DISTINCT order_nr) 'count_so',
    COUNT(DISTINCT id_package_dispatching) 'count_pck',
    COUNT(bob_id_sales_order_item) 'count_soi',
    AVG(delcost_unit_price_pct) 'average_delcost_unit_price_pct',
    MIN(delcost_unit_price_pct) 'min_delcost_unit_price_pct',
    MAX(delcost_unit_price_pct) 'max_delcost_unit_price_pct',
    STDDEV(delcost_unit_price_pct) 'stdev_delcost_unit_price_pct',
    AVG(delcost_order_value_pct) 'average_delcost_order_value_pct',
    MIN(delcost_order_value_pct) 'min_delcost_order_value_pct',
    MAX(delcost_order_value_pct) 'max_delcost_order_value_pct',
    STDDEV(delcost_order_value_pct) 'stdev_delcost_order_value_pct',
    SUM(total_delivery_cost_item) / SUM(unit_price) 'weighted_average_delcost_unit_price_pct',
    SUM(total_delivery_cost_item) / SUM(order_value) 'weighted_average_delcost_order_value_pct'
FROM
    (SELECT 
        order_nr,
            bob_id_sales_order_item,
            id_package_dispatching,
            bob_id_supplier,
            shipment_scheme,
            unit_price,
            paid_price,
            shipping_amount,
            shipping_surcharge,
            order_value,
            total_delivery_cost_item,
            weight_3pl_item,
            formula_weight_3pl_ps,
            ABS(total_delivery_cost_item / unit_price) 'delcost_unit_price_pct',
            ABS(total_delivery_cost_item / order_value) 'delcost_order_value_pct',
            CASE
                WHEN weight_3pl_item <= 1 THEN '001'
                WHEN weight_3pl_item <= 2 THEN '002'
                WHEN weight_3pl_item <= 3 THEN '003'
                WHEN weight_3pl_item <= 4 THEN '004'
                WHEN weight_3pl_item <= 5 THEN '005'
                WHEN weight_3pl_item <= 6 THEN '006'
                WHEN weight_3pl_item <= 7 THEN '007'
                WHEN weight_3pl_item <= 8 THEN '008'
                WHEN weight_3pl_item <= 9 THEN '009'
                WHEN weight_3pl_item <= 10 THEN '010'
                WHEN weight_3pl_item <= 20 THEN '020'
                WHEN weight_3pl_item <= 30 THEN '030'
                WHEN weight_3pl_item <= 40 THEN '040'
                WHEN weight_3pl_item <= 50 THEN '050'
                WHEN weight_3pl_item <= 60 THEN '060'
                WHEN weight_3pl_item <= 70 THEN '070'
                WHEN weight_3pl_item <= 80 THEN '080'
                WHEN weight_3pl_item <= 90 THEN '090'
                WHEN weight_3pl_item <= 100 THEN '100'
                WHEN weight_3pl_item <= 200 THEN '200'
                WHEN weight_3pl_item <= 300 THEN '300'
                WHEN weight_3pl_item <= 400 THEN '400'
                ELSE 'above 400'
            END 'weight_bucket'
    FROM
        scglv3.anondb_calculate
    WHERE
        order_date >= '2017-07-01'
            AND order_date < '2017-08-01'
    HAVING delcost_unit_price_pct <= 5) result
GROUP BY weight_bucket