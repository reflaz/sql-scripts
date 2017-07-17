SELECT 
    *
FROM
    (SELECT 
        origin,
            COUNT(IF(destination = 'Jabodetabekdung', bob_id_sales_order_item, NULL)) 'count_soi_jabodetabekdung',
            COUNT(IF(destination = 'East Java', bob_id_sales_order_item, NULL)) 'count_soi_east_java',
            COUNT(IF(destination = 'North Sumatera', bob_id_sales_order_item, NULL)) 'count_soi_north_sumatera',
            COUNT(IF(destination = 'Other', bob_id_sales_order_item, NULL)) 'count_soi_other',
            COUNT(bob_id_sales_order_item) 'count_soi',
            SUM(IF(destination = 'Jabodetabekdung', paid_price, 0)) 'nmv_jabodetabekdung',
            SUM(IF(destination = 'East Java', paid_price, 0)) 'nmv_east_java',
            SUM(IF(destination = 'North Sumatera', paid_price, 0)) 'nmv_north_sumatera',
            SUM(IF(destination = 'Other', paid_price, 0)) 'nmv_other',
            SUM(paid_price) 'nmv_soi'
    FROM
        (SELECT 
        bob_id_sales_order_item,
            paid_price,
            CASE
                WHEN origin = '' THEN 'DKI Jakarta'
                ELSE origin
            END 'origin',
            CASE
                WHEN city LIKE '%Kab. Tangerang%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Tangerang%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Tangerang Selatan%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kab. Kepulauan Seribu%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Jakarta Barat%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Jakarta Pusat%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Jakarta Selatan%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Jakarta Timur%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Jakarta Utara%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kab. Bekasi%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kab. Bogor%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Bekasi%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Bogor%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Depok%' THEN 'Jabodetabekdung'
                WHEN city LIKE '%Kab. Bandung%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kab. Bandung Barat%' THEN 'Jabodetabekdung'
				WHEN city LIKE '%Kota Bandung%' THEN 'Jabodetabekdung'
                WHEN city LIKE '%Sumatera Utara%' THEN 'North Sumatera'
                WHEN city LIKE '%Jawa Timur%' THEN 'East Java'
                ELSE 'Other'
            END 'destination',
            CASE
                WHEN tax_class = 'international' THEN 0
                WHEN delivery_type = 'digital' THEN 0
                WHEN
                    first_shipment_provider = 'Digital Delivery'
                        OR last_shipment_provider = 'Digital Delivery'
                THEN
                    0
                ELSE 1
            END 'pass'
    FROM
        scgl.anondb_extract ae
    HAVING pass = 1) ae
    GROUP BY origin) ae