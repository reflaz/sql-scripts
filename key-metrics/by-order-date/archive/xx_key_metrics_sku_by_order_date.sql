/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Key Metrics Summarization
 
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
SET @extractstart = '2016-12-11';
SET @extractend = '2016-12-12'; -- This MUST be D + 1

-- WARNING! Only change this part whenever there's update!
SET @jakarta = '6606,6605,17231,6653,6652,6651,6650,6649,6648,6647,6646,6644,6643,6642,6641,6640,6639,6638,6637,6635,6634,6633,6632,6631,6630,6629,6628,6627,6626,6624,6623,6622,6621,6620,6619,6618,6617,6616,6615,6613,6612,6611,6610,6609,6608';
SET @bodetabek = '6229,6228,6227,6226,6225,6224,6223,6222,6221,6220,6219,6218,6217,6216,6215,6214,6213,6212,6211,6210,6209,6208,6207,6206,6205,6204,6203,6202,6201,6200,6199,6198,6197,6196,6195,6194,6193,6192,6191,6190,17389,6344,6343,6342,6341,6340,6339,6327,17384,6326,17385,6325,6324,6323,6322,6885,6884,6883,6882,6881,6880,6879,6878,6877,6876,6875,6874,6873,6872,6871,6870,6869,6868,6867,6866,6865,6864,6863,6862,6861,6860,6859,6858,6857,7001,7000,6999,6998,6997,6996,6995,17393,6994,6993,6992,6991,6990,6989,6987,6986,6985,6984,6983,6982,6981,6253,6252,6251,6250,6249,17381,6248,6247,6246,6245,6244,6243,6242,6241,6240,6239,6238,6237,6236,6235,6234,6233,6232,6231,6357,17390,6356,6355,6354,6353,6352,6351,6350,6349,6348,6347,6346';
SET @free = '7125,17315,7124,7123,7122,17316,7121,17317,17318,7120,17319,7130,7129,7128,7127,6979,6978,6977,6976,6975,6974,6973,6972,6971,6970,6969,6968,6967,6966,6965,6964,6963,6962,6961,6960,6959,6958,6957,6956,6955,6954,6953,6952,6950,6949,6948,17392,6947,6946,6945,6944,6943,6942,6941,6940,6939,6938,6937,6936,6935,6934,6933,6932,6931,6930,6929,6928,6927,6926,6925,6924,6923,6922,6921,6920,6919,6918,6917,6916,6914,6913,6912,6911,6910,6909,6908,6907,6906,6905,6904,6903,6902,6901,6900,6899,6898,6897,6896,6895,6894,6893,6892,6891,6890,6889,6888,6887,6885,6884,6883,6882,6881,6880,6879,6878,6877,6876,6875,6874,6873,6872,6871,6870,6869,6868,6867,6866,6865,6864,6863,6862,6861,6860,6859,6858,6857,7017,7016,7015,7014,7013,7012,17394,7011,7010,7008,7007,7006,7005,7004,7003,7001,7000,6999,6998,6997,6996,6995,17393,6994,6993,6992,6991,6990,6989,6987,6986,6985,6984,6983,6982,6981,6671,6670,6669,6668,6667,6666,6665,6664,6663,6662,6661,6660,6659,6658,6657,6656,6655,6736,6735,6734,6733,6732,6731,6730,6729,6728,6727,6726,6725,6724,6723,17212,6606,6605,17231,6653,6652,6651,6650,6649,6648,6647,6646,6644,6643,6642,6641,6640,6639,6638,6637,6635,6634,6633,6632,6631,6630,6629,6628,6627,6626,6624,6623,6622,6621,6620,6619,6618,6617,6616,6615,6613,6612,6611,6610,6609,6608,6301,6300,6299,6298,6297,6296,6295,6294,6293,6292,6291,6290,6289,6288,6287,6286,6285,6284,6283,6282,6281,6280,6279,6278,6277,6276,6275,6274,6273,6272,6271,6269,6268,6267,6266,17382,6265,6264,6263,6262,6261,6260,6259,6258,6257,6256,6255,6253,6252,6251,6250,6249,17381,6248,6247,6246,6245,6244,6243,6242,6241,6240,6239,6238,6237,6236,6235,6234,6233,6232,6231,6229,6228,6227,6226,6225,6224,6223,6222,6221,6220,6219,6218,6217,6216,6215,6214,6213,6212,6211,6210,6209,6208,6207,6206,6205,6204,6203,6202,6201,6200,6199,6198,6197,6196,6195,6194,6193,6192,6191,6190,6393,6392,6391,6390,6389,6388,17391,6387,6386,6385,6384,6383,6382,6381,6380,6379,6378,6377,6376,6375,6374,6373,6372,6371,6370,6369,6368,6367,6366,6365,6364,6357,17390,6356,6355,6354,6353,6352,6351,6350,6349,6348,6347,6346,17389,6344,6343,6342,6341,6340,6339,17388,6337,6336,6335,6327,17384,6326,17385,6325,6324,6323,6322,5441,5440,5439,5438,5437,5436,5435,5434,5433,5432,5431,5430,5429,5428,17496,5427,5426,5425,5424,5423,5422,5421,5420,5419,5418,5417,5416,5274,5273,5272,5271,5270,5269,5268,5267,5266,5265,5264,5263,5262,5261,5260,5259,5258,17493,5257,5256,5732,5731,5730,5729,5728,5727,5726,5725,5724,17506,5723,5722,5721,5720,5719,5718,5717,5715,5714,5713,5712,5711,17505,4954,4953,4952,4951,4950,4949,4948,4947,4946,4945,4944,4943,4942,4941,4940,4939,4938,4937,4881,4880,4879,4878,4877,4876,4875,4874,4873,4872,4871,4870,4869,4868,4867,4866,4865,4864,4863,4862,4861,4860,4859,4858,4857,4856,4854,4853,4852,4851,4850,4849,4848,4847,4846,4845,4844,4843,4842,4841,4840,4839,4838,4837,4836,4835,4834,4833,4832,4831,4830,4829,4828,4662,4661,4660,4659,4658,4657,17238,4656,4655,4654,4653,4652,4651,4650,4561,4560,4559,4558,4557,4556,4555,4554,4553,4552,4551,4550,4549,4548,4547,4546,4545,4544,5122,5121,5120,5119,17248,5118,5105,5104,5103,5102,5101,5100,5099,5098,5097,5096,5095,5094,5093,5092,5091,5090,5089,5088,5087,5086,5085,5084,5083,5082,5081,5080,5079,5078,5077,5076,5075,17211,3742,3741,3740,3739,3738,3737,3736,3735,3734,3733,3732,3731,3730,17443,565,564,563,562,561,560,559,558,557,556,555,554,553,552,551,550,549,548,547,546,545';

SET @vip = '773,812,815,907,916,945,949,950,959,969,976,1049,1099,1128,1186,1268,1273,1287,1289,1294,1375,1395,1481,1492,1493,1520,1559,1596,1609,1651,1674,1691,1693,1720,1740,1744,1747,1751,1836,1893,1923,2007,2088,2132,2199,2272,2287,2333,2334,2342,2348,2360,2422,2486,2521,2549,2602,2740,2742,2771,2871,2917,2965,3043,3161,3244,3260,3284,3328,3330,3400,3432,3439,3449,3453,3566,3578,3644,3671,3715,3857,3928,3969,4264,4274,4328,4387,4398,4491,4564,4599,4737,4862,4971,4998,5000,5056,5066,5108,5125,5212,5292,5300,5334,5631,5803,6012,6169,6346,6800,6809,7166,7590,7665,7879,8184,8651,8897,9048,9147,9205,9627,9646,9768,9878,9946,10011,10207,10287,10441,10540,10786,10944,11059,11071,11935,12237,12851,13071,13286,13702,13902,14237,14286,14502,14600,14644,15375,15468,15819,16550,16637,17783,17846,17930,18256,18455,20068,21324,21780,21817,21949,25111,25194,28986,29095,30675,32304,32660,32830,33481,33607,35441,36441,36562,36883,38581,39487,41051,42413,42414,42555,43581,43733,43915,44685,45808,45882,46324,46345,46349,48879,49883,50126,50127,50289,50672,50673,50771,52205,52943,53596,54687,54831,55445,55626,55769,56050,57452,2753,11372,13017,15070,18751,24481,46724,49153,50302,51412,58577,59085,64120,66948,15082,63851,63876,63871,63868,63831,63870,63859,63829,63862,63874,63845,63836,63850,63873,63834,63864,63869,63835,63872,63858,63841,63861,63866,63847,63842,63833,63854,63855,63849,63853,63860,63830,63843,69608,69603,63838';

-- WARNING! DO NOT CHANGE THIS PART, EVER!!
SET @lvl = 0;

SELECT 
    sku,
    name 'product_name',
    is_marketplace 'is_marketplace',
    SUM(nmv) 'nmv',
    COUNT(DISTINCT id_sales_order) 'count_so',
    COUNT(bob_id_sales_order_item) 'count_soi',
    SUM(unit_price) 'unit_price',
    SUM(paid_price) 'paid_price',
    SUM(shipping_fee) 'shipping_fee',
    SUM(shipping_amount) 'shipping_amount',
    SUM(commission_fee) 'commission_fee',
    SUM(payment_fee) 'payment_fee',
    SUM(retail_cogs) 'retail_cogs',
    (SUM(paid_price) - SUM(retail_cogs)) 'gm2',
    (SUM(paid_price) - SUM(retail_cogs)) / (SUM(paid_price)) 'gm2_ratio'
FROM
    (SELECT 
        so.id_sales_order,
            soi.bob_id_sales_order_item,
            soi.sku,
            prd.name,
            soi.is_marketplace,
            IF(soi.is_marketplace = 0, IFNULL(soi.unit_price, 0) / 1.1, IFNULL(soi.unit_price, 0)) 'unit_price',
            IF(soi.is_marketplace = 0, IFNULL(soi.paid_price, 0) / 1.1, IFNULL(soi.paid_price, 0)) 'paid_price',
            IF(soi.is_marketplace = 0, IFNULL(soi.shipping_surcharge, 0) / 1.1, IFNULL(soi.shipping_surcharge, 0)) 'shipping_fee',
            IF(soi.is_marketplace = 0, IFNULL(soi.shipping_amount, 0) / 1.1, IFNULL(soi.shipping_amount, 0)) 'shipping_amount',
            IF(soi.is_marketplace = 0, IFNULL(soi.cart_rule_discount, 0) / 1.1, IFNULL(soi.cart_rule_discount, 0)) 'cart_rule_discount',
            IF(soi.is_marketplace = 0, IFNULL(soi.coupon_money_value, 0) / 1.1, IFNULL(soi.coupon_money_value, 0)) 'coupon_money_value',
            IF(soi.is_marketplace = 0, (IFNULL(soi.paid_price, 0) + IFNULL(soi.shipping_surcharge, 0) + IFNULL(soi.shipping_amount, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value, 0), 0)) / 1.1, IFNULL(soi.paid_price, 0) + IFNULL(soi.shipping_surcharge, 0) + IFNULL(soi.shipping_amount, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value, 0), 0)) 'nmv',
            CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN
                        lsc_sel.tax_class = 'local'
                            OR asc_sel.tax_class = 0
                    THEN
                        (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END / 1.1 'payment_fee',
            IFNULL(soi.marketplace_commission_fee, 0) / 1.1 'commission_fee',
            IFNULL(IF(soi.fk_marketplace_merchant IS NULL, poi.cost, 0), 0) / 1.1 'retail_cogs',
            CASE
                WHEN
                    FIND_IN_SET(soa.fk_customer_address_region, @jakarta)
                        OR FIND_IN_SET(soa.fk_customer_address_region, @bodetabek)
                THEN
                    'jabodetabek'
                WHEN FIND_IN_SET(soa.fk_customer_address_region, @free) THEN 'other_free'
                ELSE 'paid'
            END 'zone_type'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 67)
    LEFT JOIN oms_live.ims_product prd ON soi.fk_product = prd.id_product
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.wms_inventory inv ON pi.fk_inventory = inv.id_inventory
    LEFT JOIN oms_live.ims_purchase_order_item poi ON inv.fk_purchase_order_item = poi.id_purchase_order_item
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN screport.seller lsc_sel ON sup.id_supplier = lsc_sel.src_id
    LEFT JOIN asc_live.seller asc_sel ON sup.id_supplier = asc_sel.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND soish.id_sales_order_item_status_history IS NOT NULL
    GROUP BY id_sales_order_item) result
GROUP BY sku