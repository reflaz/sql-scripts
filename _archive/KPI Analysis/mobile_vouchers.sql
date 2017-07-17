SET @extractstart = '2016-01-01';
SET @extractend = '2016-10-01';
SET @vipaug = '1466,1492,4599,1805,2768,4709,3555,3715,13624,4274,812,3530,13702,1706,54831,3621,13286,3181,5366,6800,8852,32304,7500,950,1559,1609,1740,1836,2740,3284,6169,8897,21949,9048,3400,41051,32830,3644,34429,23138,34405,18455,21817,2429,25194,6346,12237,2263,1375,1923,2088,2287,4398,4971,2871,15819,2199,2742,3578,4491,9878,16550,10441,1493,17783,2422,2549,4188,4737,4998,9946,5000,3821,2360,4862,50672,38581,50771,3566,6012,3239,36838,3244,4264,4387,5803,9627,9147,1693,2194,1744,2334,35484,8184,8651,11059,916,50161,1395,3032,3870,2486,33607,10287,1294,1751,3377,5292,815,9646,5349,2857,3330,5334,773,21780,4544,1429,11883,14361,1520,18190,907,945,10207,3449,5056,10347,10944,1287,15468,30675,5066,5108,1893,2132,9768,1635,1651,17846,45808,14280,949,13902,14237,1720,3260,36562,3857,7166,978,5212,14673,1596,2917,35441,38078,43581,1122,1273,2011,2272,3328,4564,3435,50127,10739,3382,1045,14502,2602,2771,2965,3043,32660,3439,3453,3969,6054,9205,969,1049,10540,1099,1128,14090,1691,1747,2333,2342,3432,44685,5300,7665,976,2314,11935,12452,14286,18256,2348,28986,3928';
SET @vipsept = '3201,13287,969,1099,949,3284,38581,6800,4599,1693,3260,5292,1429,14090,1273,2740,14502,17783,1635,7665,2011,976,3578,1596,907,9768,3244,9048,4737,4998,1751,10287,13902,2342,38078,1492,14673,9946,28986,1294,21817,1493,1720,1520,2132,5000,10944,3328,2742,3439,3043,815,18455,1609,6346,2199,35441,3330,13286,945,2088,5558,2486,6169,1744,2917,14237,9878,1287,3969,1740,6012,1893,4387,5803,33607,17846,12237,3928,13702,32660,44685,5108,3432,1466,14286,1836,2549,25194,1375,1559,4564,2272,812,1186,950,10739,8184,1049,1747,10540,773,978,1128,1651,1963,2314,2348,2422,2768,3382,4264,4709,5056,5066,5212,5366,7166,8897,9627,21949,23138,916,1706,1776,1805,1923,2017,2529,2861,3287,3621,3644,4274,4544,4862,4971,5334,5349,10207,13624,34405,3400,1045,1691,2334,2965,3181,3453,4255,4661,5300,6054,7500,9147,9205,10441,12452,14361,30675,31200,35484,1122,1262,2006,2602,2857,3418,3435,3449,3555,3870,3960,4188,4413,9646,15468,16550,23669,28462,30542,2287,32304,22097,4491,3377,10347,3032,3385,4398,18190,8651,2333,3239,8852,2194,2429,2263,21780,11883,2771,3857,15819,43581,15082,41051,11935,18256,36562,3821,50771,50127,50672,50161,50673,50126,50289,52943,11071,52205,3715,3530,54831,32830,34429,2871,2360,3566,36838,11059,1395,45808,14280,6809,1268,10786,1674,1075,41292,43915,1481,5765,48879,3671,29095,2007,55445';
SET @vipoct = '1492,1466,4599,950,11238,46324,3715,13624,50771,50672,4274,11071,20068,54831,13286,6800,32304,1429,1893,2132,1049,3432,1559,1740,2740,6169,1609,3284,8897,1836,21324,46345,6809,3239,2333,18455,21817,25194,6346,12237,52205,4398,2088,2871,15819,2199,2742,4491,9878,3578,10441,1493,17783,2422,2549,4737,16550,4998,9946,5000,2360,4862,10786,9646,6012,3566,1674,2007,7590,14644,50161,2314,916,3870,11059,4264,5803,9627,3244,4387,9147,43581,39487,13702,3857,1693,1744,4971,1375,2287,1923,38581,1268,1395,35484,8184,8651,2334,2194,33607,2486,1287,3400,41051,50289,10287,55445,1751,815,5349,1294,5292,3330,5334,21949,21780,10739,907,945,1520,14361,8267,2521,3449,5056,10207,30675,5108,10347,5066,10944,30542,15468,1651,1635,17846,9048,17930,33481,13902,14237,7166,978,45808,949,1720,3260,36562,5212,52943,1596,2917,35441,38078,50673,50126,42555,1122,2011,3328,4564,1273,2272,2861,50127,3382,15375,36441,812,3644,773,32830,1747,1075,43915,1481,5765,48879,1045,14502,2602,3043,32660,3439,2771,2965,3453,3969,6054,9205,969,9768,10540,14090,44685,976,1099,1128,1691,5300,7665,2342,42413,14286,28986,11935,18256,2348,3928,3671,29095';

SELECT
	id_supplier,
	short_code,
	name,
	type,
	tax_class,
    SUM(IF(created_at >= '2016-01-01' AND created_at < '2016-02-01', paid_price, 0)) 'paid_price_January',
	SUM(IF(created_at >= '2016-02-01' AND created_at < '2016-03-01', paid_price, 0)) 'paid_price_February',
	SUM(IF(created_at >= '2016-03-01' AND created_at < '2016-04-01', paid_price, 0)) 'paid_price_March',
	SUM(IF(created_at >= '2016-04-01' AND created_at < '2016-05-01', paid_price, 0)) 'paid_price_April',
	SUM(IF(created_at >= '2016-05-01' AND created_at < '2016-06-01', paid_price, 0)) 'paid_price_May',
	SUM(IF(created_at >= '2016-06-01' AND created_at < '2016-07-01', paid_price, 0)) 'paid_price_June',
	SUM(IF(created_at >= '2016-07-01' AND created_at < '2016-08-01', paid_price, 0)) 'paid_price_July',
	SUM(IF(created_at >= '2016-08-01' AND created_at < '2016-09-01', paid_price, 0)) 'paid_price_August',
	SUM(IF(created_at >= '2016-09-01' AND created_at < '2016-10-01', paid_price, 0)) 'paid_price_September',
    SUM(IF(created_at >= '2016-01-01' AND created_at < '2016-02-01', 1, 0)) 'soi_count_January',
	SUM(IF(created_at >= '2016-02-01' AND created_at < '2016-03-01', 1, 0)) 'soi_count_February',
	SUM(IF(created_at >= '2016-03-01' AND created_at < '2016-04-01', 1, 0)) 'soi_count_March',
	SUM(IF(created_at >= '2016-04-01' AND created_at < '2016-05-01', 1, 0)) 'soi_count_April',
	SUM(IF(created_at >= '2016-05-01' AND created_at < '2016-06-01', 1, 0)) 'soi_count_May',
	SUM(IF(created_at >= '2016-06-01' AND created_at < '2016-07-01', 1, 0)) 'soi_count_June',
	SUM(IF(created_at >= '2016-07-01' AND created_at < '2016-08-01', 1, 0)) 'soi_count_July',
	SUM(IF(created_at >= '2016-08-01' AND created_at < '2016-09-01', 1, 0)) 'soi_count_August',
	SUM(IF(created_at >= '2016-09-01' AND created_at < '2016-10-01', 1, 0)) 'soi_count_September',
    COUNT(DISTINCT IF(created_at >= '2016-01-01' AND created_at < '2016-02-01', id_sales_order, NULL)) 'so_count_January',
	COUNT(DISTINCT IF(created_at >= '2016-02-01' AND created_at < '2016-03-01', id_sales_order, NULL)) 'so_count_February',
	COUNT(DISTINCT IF(created_at >= '2016-03-01' AND created_at < '2016-04-01', id_sales_order, NULL)) 'so_count_March',
	COUNT(DISTINCT IF(created_at >= '2016-04-01' AND created_at < '2016-05-01', id_sales_order, NULL)) 'so_count_April',
	COUNT(DISTINCT IF(created_at >= '2016-05-01' AND created_at < '2016-06-01', id_sales_order, NULL)) 'so_count_May',
	COUNT(DISTINCT IF(created_at >= '2016-06-01' AND created_at < '2016-07-01', id_sales_order, NULL)) 'so_count_June',
	COUNT(DISTINCT IF(created_at >= '2016-07-01' AND created_at < '2016-08-01', id_sales_order, NULL)) 'so_count_July',
	COUNT(DISTINCT IF(created_at >= '2016-08-01' AND created_at < '2016-09-01', id_sales_order, NULL)) 'so_count_August',
	COUNT(DISTINCT IF(created_at >= '2016-09-01' AND created_at < '2016-10-01', id_sales_order, NULL)) 'so_count_September'
FROM
    (SELECT 
        so.id_sales_order,
            soi.id_sales_order_item,
            soi.bob_id_sales_order_item,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.paid_price + soi.shipping_amount + soi.shipping_surcharge 'nmv',
            sup.id_supplier,
            sel.short_code,
            sup.name,
            sup.type,
            sel.tax_class,
            so.created_at
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    LEFT JOIN (SELECT 
        IFNULL(lvl0_id, '') 'lvl0_id',
            IFNULL(lvl0, '') 'lvl0',
            IFNULL(lvl1_id, '') 'lvl1_id',
            IFNULL(lvl1, '') 'lvl1',
            IFNULL(lvl2_id, '') 'lvl2_id',
            IFNULL(lvl2, '') 'lvl2',
            IFNULL(lvl3_id, '') 'lvl3_id',
            IFNULL(lvl3, '') 'lvl3',
            IFNULL(lvl4_id, '') 'lvl4_id',
            IFNULL(lvl4, '') 'lvl4',
            IFNULL(lvl5_id, '') 'lvl5_id',
            IFNULL(lvl5, '') 'lvl5',
            IFNULL(lvl6_id, '') 'lvl6_id',
            IFNULL(lvl6, '') 'lvl6',
            cc0_id,
            cc0_name
    FROM
        (SELECT 
        MIN(IF(catree.lvl = 0, catree.cc1_name, NULL)) 'lvl0',
            MIN(IF(catree.lvl = 0, catree.cc1_id, NULL)) 'lvl0_id',
            MIN(IF(catree.lvl = 1, catree.cc1_name, NULL)) 'lvl1',
            MIN(IF(catree.lvl = 1, catree.cc1_id, NULL)) 'lvl1_id',
            MIN(IF(catree.lvl = 2, catree.cc1_name, NULL)) 'lvl2',
            MIN(IF(catree.lvl = 2, catree.cc1_id, NULL)) 'lvl2_id',
            MIN(IF(catree.lvl = 3, catree.cc1_name, NULL)) 'lvl3',
            MIN(IF(catree.lvl = 3, catree.cc1_id, NULL)) 'lvl3_id',
            MIN(IF(catree.lvl = 4, catree.cc1_name, NULL)) 'lvl4',
            MIN(IF(catree.lvl = 4, catree.cc1_id, NULL)) 'lvl4_id',
            MIN(IF(catree.lvl = 5, catree.cc1_name, NULL)) 'lvl5',
            MIN(IF(catree.lvl = 5, catree.cc1_id, NULL)) 'lvl5_id',
            MIN(IF(catree.lvl = 6, catree.cc1_name, NULL)) 'lvl6',
            MIN(IF(catree.lvl = 6, catree.cc1_id, NULL)) 'lvl6_id',
            cc0_id,
            cc0_name
    FROM
        (SELECT 
        *, IF(cc1_id = 1, @lvl:=0, @lvl:=@lvl + 1) 'lvl'
    FROM
        (SELECT 
        cc0.id_catalog_category 'cc0_id',
            cc0.name_en 'cc0_name',
            cc1.id_catalog_category 'cc1_id',
            cc1.name_en 'cc1_name',
            cc1.lft,
            cc1.rgt
    FROM
        bob_live.catalog_category cc0
    LEFT JOIN bob_live.catalog_category cc1 ON cc0.lft >= cc1.lft
        AND cc0.rgt <= cc1.rgt
    WHERE
        cc0.status = 'active'
    ORDER BY cc0.id_catalog_category , cc1.lft , cc1.rgt
    LIMIT 1000000000) catree) catree
    GROUP BY catree.cc0_id) result) catree ON cc.primary_category = catree.cc0_id
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN screport.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND catree.lvl2_id = 10711
            AND soish.id_sales_order_item_status_history IS NOT NULL
    GROUP BY soi.id_sales_order_item) result
GROUP BY id_supplier