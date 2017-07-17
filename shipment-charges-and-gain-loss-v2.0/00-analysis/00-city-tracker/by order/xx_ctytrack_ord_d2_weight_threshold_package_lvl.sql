/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
City Tracker
 
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
SET @kg1 = '1343,439,7023,4310,7119,7114,1807,1799,1771,7104,1760,7096,1728,7090,1716,7081,7076,3868,1655,3816,3811,1595,1586,7065,1576,3519,3950,3313,4218,7126,1831,1140,544,1816,4434,3939,3270,3239,3183,3166,2873,2576,1480,4171,4043,2848,3105,4410,6828,3778,6589,1115,1102,2540,3508,1298,1291,2827,3075,3416,3378,3367,2496,2483,2193,4011,3997,4377,2475,3760,3494,3329,1056,2462,1206,2784,3988,2774,3754,1694,3464,1891,1875,2749,2167,2430,2409,2396,1036,1011,1438,1173,2383,3743,327,297,287,277,2363,853,3042,3033,6533,1398,3968,3323,2143,1931,2715,4274,6737,3442,208,2132,3807,1557,4112,6407,2087,2591,1361,3540,1164,1354,2584,2211,518,1134,3502,3486,2534,2523,2516,2452,2443,2437,2374,2352,2343,2334,2317,2282,2275,2223,2217,2160,2112,1198,3280,3246,3222,3211,3198,3141,3113,932,486,4209,1500,7050,7044,7036,7029,5055,4189,751,4053,4036,6509,478,7018,2051,6835,6815,3920,2556,2991,3087,5007,5623,4979,17671,1121,1109,1320,4955,6571,3909,6491,1468,17666,6151,462,920,2982,1452,743,1747,2201,2808,6553,6547,6685,4024,3385,3349,4159,4147,4136,428,2030,2015,4882,1994,4383,5490,3768,410,6799,5463,6790,909,1988,1087,1076,6478,4356,1270,1256,1229,4230,4082,4066,1975,4346,5938,3887,3849,400,394,385,725,4332,361,6784,986,2971,2958,2937,2931,4805,1682,1670,4789,4770,5911,1907,3836,3471,3453,1863,337,2764,2756,4320,6453,17630,3602,1018,1000,702,6444,6768,3977,690,668,3066,2741,2731,4696,4676,318,309,3827,651,632,620,600,579,4663,891,268,1642,1417,878,866,1962,5326,3594,1629,1846,4602,3585,4577,5307,6752,5275,1948,2722,4290,258,4562,2323,6433,4266,1617,3448,240,3962,1916,1605,1382,844,2693,3024,4251,4525,829,821,2123,3956,2686,2677,2671,2649,2906,2897,4497,4123,806,4102,6419,196,175,159,4089,6394,2079,2616,144,1372,1534,4482,4461,3549,4441,1519,3525,5155,6358,4224,5135,3017,573,1155,5131,3946,982,2073,566,1150,3307,3302,797,5123,967,537,791,4060,1821,963,957,5738,530,767,5106,3299,952,17637,525,4428,949,3293,6518,3789,3934,512,3435,3426,3514';
SET @kg2 = '7059,3010,6002,5656,4904,4717,4624,5585,6034,5202,6597,5705,6254,5684,6704,5030,5640,5603,6118,5560,6077,5545,5525,5508,5971,4855,5442,5415,5405,6672,4827,3705,3687,3658,3633,3609,6951,5383,4736,4649,6915,5361,5341,5893,5290,5255,6886,4543,6654,5234,5862,5814,5221,5787,3564,5747,5181,5139,3729,3794,6847,7009,6328,6524,5127,2891,5743,5117,3723,5114,970,774,1514,5110,2060,5733,5716,7002,6313,5710,6302,6722,6645,6636,6625,6614,6607,6345,6988,6230,5074,6189,6980,6856,6321,6363,6338,6270,4936,6334,6604';

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-05-12';
SET @extractend = '2017-05-15';-- This MUST be D + 1

SELECT 
    items_bracket,
    weight_bracket,
    COUNT(DISTINCT order_package) 'total_package'
FROM
    (SELECT 
        *,
            CASE
                WHEN qty > 1 THEN '> 1 items'
                ELSE '1 items'
            END 'items_bracket',
            CASE
                WHEN formula_weight <= subs_kg THEN 'under subsidized kg'
                ELSE 'above subsidized kg'
            END 'weight_bracket'
    FROM
        (SELECT 
        *,
            COUNT(bob_id_sales_order_item) 'qty',
            GREATEST(weight, volumetric_weight) 'formula_weight'
    FROM
        (SELECT 
        ae.*,
            CASE
                WHEN FIND_IN_SET(fz.id_city, @kg1) THEN '1'
                WHEN FIND_IN_SET(fz.id_city, @kg2) THEN '2'
            END 'subs_kg',
            CONCAT(ae.order_nr, IFNULL(ae.id_package_dispatching, 1)) 'order_package',
            IFNULL(CASE
                WHEN
                    ae.simple_weight > 0
                        OR (ae.simple_length * ae.simple_width * ae.simple_height) > 0
                THEN
                    ae.simple_weight
                ELSE ae.config_weight
            END, 0) 'weight',
            IFNULL(CASE
                WHEN
                    ae.simple_weight > 0
                        OR (ae.simple_length * ae.simple_width * ae.simple_height) > 0
                THEN
                    (ae.simple_length * ae.simple_width * ae.simple_height) / 6000
                ELSE ae.config_length * ae.config_width * ae.config_height / 6000
            END, 0) 'volumetric_weight'
    FROM
        scgl.anondb_calculate ac
    JOIN scgl.anondb_extract ae ON ac.order_nr = ae.order_nr
        AND ac.bob_id_supplier = ae.bob_id_supplier
        AND IFNULL(ac.id_package_dispatching, 1) = IFNULL(ae.id_package_dispatching, 1)
    LEFT JOIN scgl.free_zone fz ON ac.id_district = fz.id_district
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND (rounded_weight / qty) <= 400
            AND fk_shipment_scheme IN (1 , 2, 3, 4, 7)
    GROUP BY ae.bob_id_sales_order_item) ae
    GROUP BY order_package) ae) ae
GROUP BY items_bracket , weight_bracket