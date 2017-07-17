SET @extractstart = '2016-06-23';
SET @extractend = '2016-06-24';

SELECT 
    leadtime.*
FROM
    (SELECT 
        fk_mwh_warehouse 'origin',
            id_city,
            SUM(unit_price) 'total_unit_price',
            SUM(paid_price) 'total_paid_price',
            COUNT(DISTINCT order_nr) 'total_so',
            COUNT(id_sales_order_item) 'total_soi',
            AVG(shipped_date) 'average_shipped_date',
            AVG(delivered_date) 'average_delivered_date',
            ROUND(AVG(lead_time)) 'avg_lead_time',
            ROUND(STDDEV(lead_time)) 'stdev_lead_time'
    FROM
        (SELECT 
        CASE
                WHEN
                    lsc_sel.tax_class = 'international'
                        OR asc_sel.tax_class = '1'
                THEN
                    0
                ELSE soi.fk_mwh_warehouse
            END 'fk_mwh_warehouse',
            dst.fk_customer_address_region 'id_city',
            ship.created_at 'shipped_date',
            delv.created_at 'delivered_date',
            DATEDIFF(delv.created_at, ship.created_at) 'lead_time',
            so.order_nr,
            soi.id_sales_order_item,
            IFNULL(soi.unit_price, 0) 'unit_price',
            IFNULL(soi.paid_price, 0) 'paid_price'
    FROM
        oms_live.oms_package_status_history delv
    LEFT JOIN oms_live.oms_package_status_history ship ON delv.fk_package = ship.fk_package
        AND ship.id_package_status_history = (SELECT 
            MAX(id_package_status_history)
        FROM
            oms_live.oms_package_status_history
        WHERE
            fk_package = delv.fk_package
                AND fk_package_status = 4)
    LEFT JOIN oms_live.oms_package pck ON delv.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN screport.seller lsc_sel ON soi.bob_id_supplier = lsc_sel.src_id
    LEFT JOIN asc_live.seller asc_sel ON soi.bob_id_supplier = asc_sel.src_id
    WHERE
        delv.created_at >= @extractstart
            AND delv.created_at < @extractend
            AND delv.fk_package_status = 6
            AND soi.is_marketplace = 1) leadtime
    GROUP BY fk_mwh_warehouse , id_city) leadtime