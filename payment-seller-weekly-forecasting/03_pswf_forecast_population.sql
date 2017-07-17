SET @extractstart = '2016-10-19';
SET @extractend = '2016-12-10';

-- 5/27/2016	6/6/2016

SELECT 
    leadtime.*
FROM
    (SELECT 
        fk_mwh_warehouse 'origin',
        id_city,
		SUM(CASE
			WHEN fk_mwh_warehouse = 'NULL' AND id_city = 'NULL' AND shipped_date >= '2016-12-02' AND shipped_date < '2016-12-06' THEN unit_price
			ELSE 0 -- do not delete this!
		END) 'total_unit_price',
		SUM(CASE
			WHEN fk_mwh_warehouse = 'NULL' AND id_city = 'NULL' AND shipped_date >= '2016-12-02' AND shipped_date < '2016-12-06' THEN paid_price
			ELSE 0 -- do not delete this!
		END) 'total_paid_price',
		COUNT(DISTINCT -- do not delete this!
			CASE
			WHEN fk_mwh_warehouse = 'NULL' AND id_city = 'NULL' AND shipped_date >= '2016-12-02' AND shipped_date < '2016-12-06' THEN order_nr
			ELSE NULL -- do not delete this!
		END) 'total_so',
		SUM(CASE
			WHEN fk_mwh_warehouse = 'NULL' AND id_city = 'NULL' AND shipped_date >= '2016-12-02' AND shipped_date < '2016-12-06' THEN 1
			ELSE 0 -- do not delete this!
		END) 'total_soi'
    FROM
        (SELECT 
        IF(sel.tax_class = 1, 0, fk_mwh_warehouse) 'fk_mwh_warehouse',
            dst.fk_customer_address_region 'id_city',
            ship.shipped_date,
            so.order_nr,
            soi.id_sales_order_item,
            IFNULL(soi.unit_price, 0) 'unit_price',
            IFNULL(soi.paid_price, 0) 'paid_price',
            delv.created_at 'delivered_date'
    FROM
        (SELECT 
        fk_package, MAX(created_at) 'shipped_date'
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 4
    GROUP BY fk_package) ship
    LEFT JOIN oms_live.oms_package_status_history delv ON ship.fk_package = delv.fk_package
        AND delv.id_package_status_history = (SELECT 
            MAX(id_package_status_history)
        FROM
            oms_live.oms_package_status_history
        WHERE
            fk_package = ship.fk_package
                AND fk_package_status = 6
                AND created_at < @extractstart)
    LEFT JOIN oms_live.oms_package_item pi ON ship.fk_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN asc_live.seller sel ON soi.bob_id_supplier = sel.src_id
    WHERE
		delv.id_package_status_history IS NULL
			AND soi.is_marketplace = 1) leadtime
    GROUP BY fk_mwh_warehouse , id_city) leadtime