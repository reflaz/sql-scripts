SET @extractstart = '2016-09-01';
SET @extractend = '2016-10-01';
SET @vip = '3201,13287,969,1099,949,3284,38581,6800,4599,1693,3260,5292,1429,14090,1273,2740,14502,17783,1635,7665,2011,976,3578,1596,907,9768,3244,9048,4737,4998,1751,10287,13902,2342,38078,1492,14673,9946,28986,1294,21817,1493,1720,1520,2132,5000,10944,3328,2742,3439,3043,815,18455,1609,6346,2199,35441,3330,13286,945,2088,5558,2486,6169,1744,2917,14237,9878,1287,3969,1740,6012,1893,4387,5803,33607,17846,12237,3928,13702,32660,44685,5108,3432,1466,14286,1836,2549,25194,1375,1559,4564,2272,812,1186,950,10739,8184,1049,1747,10540,773,978,1128,1651,1963,2314,2348,2422,2768,3382,4264,4709,5056,5066,5212,5366,7166,8897,9627,21949,23138,916,1706,1776,1805,1923,2017,2529,2861,3287,3621,3644,4274,4544,4862,4971,5334,5349,10207,13624,34405,3400,1045,1691,2334,2965,3181,3453,4255,4661,5300,6054,7500,9147,9205,10441,12452,14361,30675,31200,35484,1122,1262,2006,2602,2857,3418,3435,3449,3555,3870,3960,4188,4413,9646,15468,16550,23669,28462,30542,2287,32304,22097,4491,3377,10347,3032,3385,4398,18190,8651,2333,3239,8852,2194,2429,2263,21780,11883,2771,3857,15819,43581,15082,41051,11935,18256,36562,3821,50771,50127,50672,50161,50673,50126,50289,52943,11071,52205,3715,3530,54831,32830,34429,2871,2360,3566,36838,11059,1395,45808,14280,6809,1268,10786,1674,1075,41292,43915,1481,5765,48879,3671,29095,2007,55445';
SET @rsp = '50630,49153,50302,49195,50123,50124,51428,51540,50014,49562,52236,49468,50279,50982,44729,50151,51412,50152,52035,51409,50122,50671,51341,39788,49207,49254,51648,50629,51943,51913,50295,51936,50332,50355,49636,49739,50274,52200,51362,50120,51443,51846,52231,51556,51777,52273,52058,51920,50294,50015,52747,51676,52210,51671,52251,52254,51538,52215,50631,51562,51109,51537,37204,52173,51718,50838,52893,51872,52264,51944,51328,50628,51660,52625,52536,52405,51018,51885,51656,53359,51867,51282,50695,49216,51111,53145,51252,51168,53265,50962,51966,51410,51329,51557,52169,51705,51887,51926,51960,51655,51541,52385,52309,52642,53114,50357,53062,52901,52783,53148,3166,50147,51028,51662,51792,22104,52233,51963,51964,52305,52961,53160,52311,53198,53199,53485,53529,52266,52279,52758,53490,52740,52913,54879,54960,54865,55098,55072,55008,54862,55043,55626,55627,55769,55618,55512,45114,55087,55568,55501,55510,55567,54678,55637,56050,55296,56811,55588,56563,56721,53441,56604,56946,56693,56825,56624,56740,56843,56129,57828,57480,58577,58718,59043,4413,9646,15468,16550,23669,28462,30542,2287,32304,22097,4491,3377,10347,3032,3385,4398,18190,8651,2333,3239,8852,2194,2429,2263,21780,11883,2771,3857,15819,43581,15082,41051,11935,18256,36562,3821,50771,50127,50672,50161,50673,50126,50289,52943,11071,52205,3715,3530,54831,32830,34429,2871,2360,3566,36838,11059,1395,45808,14280,6809,1268,10786,1674,1075,41292,43915,1481,5765,48879,3671,29095,2007,55445';

SELECT 
    type,
    tax_class,
    campaign,
    COUNT(bob_id_sales_order_item) 'count_soi'
FROM
    (SELECT 
        soi.*,
            sup.type,
            sel.tax_class,
            CASE
                WHEN sup.type = 'supplier' THEN NULL
                WHEN sel.tax_class = 'international' THEN NULL
                WHEN FIND_IN_SET(sup.id_supplier, @vip) THEN 'vip'
                WHEN FIND_IN_SET(sup.id_supplier, @rsp) THEN 'rsp'
            END 'campaign'
    FROM
        (SELECT 
        soi.id_sales_order_item,
            soi.bob_id_sales_order_item,
            soi.sku,
            soi.bob_id_supplier,
            soi.fk_sales_order,
            soish.created_at,
            soish.fk_sales_order_item_status
    FROM
        oms_live.ims_sales_order_item_status_history soish
    LEFT JOIN oms_live.ims_sales_order_item soi ON soish.fk_sales_order_item = soi.id_sales_order_item
    WHERE
        soish.created_at >= @extractstart
            AND soish.created_at < @extractend
            AND soish.fk_sales_order_item_status = 56
    GROUP BY soi.id_sales_order_item) soi
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN screport.seller sel ON sup.id_supplier = sel.src_id) result
GROUP BY result.type , tax_class , result.campaign