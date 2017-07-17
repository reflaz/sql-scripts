SET @extractstart = '2016-01-01';
SET @extractend = '2016-09-01';

SET @old_free_city = '175,544,774,970,1728,1831,2060,3687,3729,3939,3950,4441,4461,4482,4543,4562,4577,4624,4649,4696,4717,4789,4805,4827,4855,4882,4904,4936,4979,5055,5074,5106,5110,5114,5117,5123,5127,5255,5710,5716,5747,6189,6230,6254,6270,6302,6313,6321,6328,6338,6345,6363,6604,6607,6614,6625,6636,6645,6654,6672,6685,6704,6722,6856,6886,6915,6951,6980,6988,7002,7009,7096,7119,7126,1655';
SET @new_free_city = '5361,5415,5656,5814,5971,6002,6077,6334,7059';
SET @old_mixed_city = '4441,4461,4482,4562,4624,4649,4696,4827,4855,4882,4936,4979,5055,5255,7119,4789';

SELECT 
    *
FROM
    (SELECT 
        province,
            city,
            CASE
                WHEN FIND_IN_SET(id_customer_address_region, @new_free_city) THEN 'New Free City'
                WHEN FIND_IN_SET(id_customer_address_region, @old_mixed_city) THEN 'Old Mixed City'
                WHEN FIND_IN_SET(id_customer_address_region, @old_free_city) THEN 'Old Free City'
                ELSE 'Paid City'
            END 'flag',
            january,
            february,
            march,
            april,
            may,
            june,
            july,
            august
    FROM
        (SELECT 
        city,
            id_customer_address_region,
            province,
            SUM(IF(created_at >= '2016-01-01'
                AND created_at < '2016-02-01', 1, 0)) 'january',
            SUM(IF(created_at >= '2016-02-01'
                AND created_at < '2016-03-01', 1, 0)) 'february',
            SUM(IF(created_at >= '2016-03-01'
                AND created_at < '2016-04-01', 1, 0)) 'march',
            SUM(IF(created_at >= '2016-04-01'
                AND created_at < '2016-05-01', 1, 0)) 'april',
            SUM(IF(created_at >= '2016-05-01'
                AND created_at < '2016-06-01', 1, 0)) 'may',
            SUM(IF(created_at >= '2016-06-01'
                AND created_at < '2016-07-01', 1, 0)) 'june',
            SUM(IF(created_at >= '2016-07-01'
                AND created_at < '2016-08-01', 1, 0)) 'july',
            SUM(IF(created_at >= '2016-08-01'
                AND created_at < '2016-09-01', 1, 0)) 'august'
    FROM
        (SELECT 
        cty.name 'city',
            cty.id_customer_address_region,
            reg.name 'province',
            soish.created_at
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6
    GROUP BY fk_package) psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region cty ON dst.fk_customer_address_region = cty.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region reg ON cty.fk_customer_address_region = reg.id_customer_address_region
    GROUP BY soi.id_sales_order_item
    HAVING reg.name IS NOT NULL) result
    GROUP BY id_customer_address_region) result) result;