/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss Summary

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
SET @extractstart = '2017-03-01';
SET @extractend = '2017-03-13';-- This MUST be D + 1

-- Free districts mapping
SET @jakarta = '6606,6605,17231,6653,6652,6651,6650,6649,6648,6647,6646,6644,6643,6642,6641,6640,6639,6638,6637,6635,6634,6633,6632,6631,6630,6629,6628,6627,6626,6624,6623,6622,6621,6620,6619,6618,6617,6616,6615,6613,6612,6611,6610,6609,6608';
SET @bodetabek = '6229,6228,6227,6226,6225,6224,6223,6222,6221,6220,6219,6218,6217,6216,6215,6214,6213,6212,6211,6210,6209,6208,6207,6206,6205,6204,6203,6202,6201,6200,6199,6198,6197,6196,6195,6194,6193,6192,6191,6190,17389,6344,6343,6342,6341,6340,6339,6327,17384,6326,17385,6325,6324,6323,6322,6885,6884,6883,6882,6881,6880,6879,6878,6877,6876,6875,6874,6873,6872,6871,6870,6869,6868,6867,6866,6865,6864,6863,6862,6861,6860,6859,6858,6857,7001,7000,6999,6998,6997,6996,6995,17393,6994,6993,6992,6991,6990,6989,6987,6986,6985,6984,6983,6982,6981,6253,6252,6251,6250,6249,17381,6248,6247,6246,6245,6244,6243,6242,6241,6240,6239,6238,6237,6236,6235,6234,6233,6232,6231,6357,17390,6356,6355,6354,6353,6352,6351,6350,6349,6348,6347,6346';
SET @free = '7125,17315,7124,7123,7122,17316,7121,17317,17318,7120,17319,7130,7129,7128,7127,6979,6978,6977,6976,6975,6974,6973,6972,6971,6970,6969,6968,6967,6966,6965,6964,6963,6962,6961,6960,6959,6958,6957,6956,6955,6954,6953,6952,6950,6949,6948,17392,6947,6946,6945,6944,6943,6942,6941,6940,6939,6938,6937,6936,6935,6934,6933,6932,6931,6930,6929,6928,6927,6926,6925,6924,6923,6922,6921,6920,6919,6918,6917,6916,6914,6913,6912,6911,6910,6909,6908,6907,6906,6905,6904,6903,6902,6901,6900,6899,6898,6897,6896,6895,6894,6893,6892,6891,6890,6889,6888,6887,6885,6884,6883,6882,6881,6880,6879,6878,6877,6876,6875,6874,6873,6872,6871,6870,6869,6868,6867,6866,6865,6864,6863,6862,6861,6860,6859,6858,6857,7017,7016,7015,7014,7013,7012,17394,7011,7010,7008,7007,7006,7005,7004,7003,7001,7000,6999,6998,6997,6996,6995,17393,6994,6993,6992,6991,6990,6989,6987,6986,6985,6984,6983,6982,6981,6671,6670,6669,6668,6667,6666,6665,6664,6663,6662,6661,6660,6659,6658,6657,6656,6655,6736,6735,6734,6733,6732,6731,6730,6729,6728,6727,6726,6725,6724,6723,17212,6606,6605,17231,6653,6652,6651,6650,6649,6648,6647,6646,6644,6643,6642,6641,6640,6639,6638,6637,6635,6634,6633,6632,6631,6630,6629,6628,6627,6626,6624,6623,6622,6621,6620,6619,6618,6617,6616,6615,6613,6612,6611,6610,6609,6608,6301,6300,6299,6298,6297,6296,6295,6294,6293,6292,6291,6290,6289,6288,6287,6286,6285,6284,6283,6282,6281,6280,6279,6278,6277,6276,6275,6274,6273,6272,6271,6269,6268,6267,6266,17382,6265,6264,6263,6262,6261,6260,6259,6258,6257,6256,6255,6253,6252,6251,6250,6249,17381,6248,6247,6246,6245,6244,6243,6242,6241,6240,6239,6238,6237,6236,6235,6234,6233,6232,6231,6229,6228,6227,6226,6225,6224,6223,6222,6221,6220,6219,6218,6217,6216,6215,6214,6213,6212,6211,6210,6209,6208,6207,6206,6205,6204,6203,6202,6201,6200,6199,6198,6197,6196,6195,6194,6193,6192,6191,6190,6393,6392,6391,6390,6389,6388,17391,6387,6386,6385,6384,6383,6382,6381,6380,6379,6378,6377,6376,6375,6374,6373,6372,6371,6370,6369,6368,6367,6366,6365,6364,6357,17390,6356,6355,6354,6353,6352,6351,6350,6349,6348,6347,6346,17389,6344,6343,6342,6341,6340,6339,17388,6337,6336,6335,6327,17384,6326,17385,6325,6324,6323,6322,5441,5440,5439,5438,5437,5436,5435,5434,5433,5432,5431,5430,5429,5428,17496,5427,5426,5425,5424,5423,5422,5421,5420,5419,5418,5417,5416,5274,5273,5272,5271,5270,5269,5268,5267,5266,5265,5264,5263,5262,5261,5260,5259,5258,17493,5257,5256,5732,5731,5730,5729,5728,5727,5726,5725,5724,17506,5723,5722,5721,5720,5719,5718,5717,5715,5714,5713,5712,5711,17505,4954,4953,4952,4951,4950,4949,4948,4947,4946,4945,4944,4943,4942,4941,4940,4939,4938,4937,4881,4880,4879,4878,4877,4876,4875,4874,4873,4872,4871,4870,4869,4868,4867,4866,4865,4864,4863,4862,4861,4860,4859,4858,4857,4856,4854,4853,4852,4851,4850,4849,4848,4847,4846,4845,4844,4843,4842,4841,4840,4839,4838,4837,4836,4835,4834,4833,4832,4831,4830,4829,4828,4662,4661,4660,4659,4658,4657,17238,4656,4655,4654,4653,4652,4651,4650,4561,4560,4559,4558,4557,4556,4555,4554,4553,4552,4551,4550,4549,4548,4547,4546,4545,4544,5122,5121,5120,5119,17248,5118,5105,5104,5103,5102,5101,5100,5099,5098,5097,5096,5095,5094,5093,5092,5091,5090,5089,5088,5087,5086,5085,5084,5083,5082,5081,5080,5079,5078,5077,5076,5075,17211,3742,3741,3740,3739,3738,3737,3736,3735,3734,3733,3732,3731,3730,17443,565,564,563,562,561,560,559,558,557,556,555,554,553,552,551,550,549,548,547,546,545';

SELECT 
    ac.order_nr,
    ac.bob_id_sales_order_item,
    ac.bob_id_supplier,
    ac.short_code,
    ac.seller_name,
    ac.seller_type,
    ac.tax_class,
    ac.origin,
    ac.id_region,
    ac.region,
    ac.id_city,
    ac.city,
    ac.id_district,
    ac.district,
    ac.fk_zone_type,
    ac.zone_type,
    ac.delivery_type,
    ac.bu,
    GROUP_CONCAT(DISTINCT ac.shipment_scheme
        SEPARATOR ', ') 'shipment_scheme',
    SUM(rounded_chargeable_weight) 'rounded_chargeable_weight',
    SUM(rounded_weight) 'rounded_weight',
    SUM(ac.customer_weight) 'customer_weight',
    rcc.shipment_cost_rate 'customer_rate_card',
    SUM(ac.unit_price) 'total_unit_price',
    SUM(ac.paid_price) 'total_paid_price',
    SUM(ac.shipping_amount) 'total_shipping_amount',
    SUM(ac.shipping_surcharge) 'total_shipping_surcharge',
    SUM(ac.shipping_fee_to_customer) 'total_shipping_fee_to_customer',
    SUM(ac.order_value) 'total_order_value',
    SUM(ac.nmv) 'total_nmv',
    SUM(ac.total_shipment_fee_mp_seller) 'total_shipment_fee_mp_seller',
    SUM(ac.shipment_fee_mp_seller) 'shipment_fee_mp_seller',
    SUM(ac.insurance_fee_mp_seller) 'insurance_fee_mp_seller',
    SUM(ac.total_delivery_cost) 'total_delivery_cost',
    SUM(ac.qty) 'qty'
FROM
    (SELECT 
        ac.order_nr,
            ac.bob_id_sales_order_item,
            bob_id_supplier,
            short_code,
            seller_name,
            seller_type,
            tax_class,
            IFNULL(ac.unit_price, 0) 'unit_price',
            IFNULL(ac.paid_price, 0) 'paid_price',
            IFNULL(ac.shipping_amount, 0) 'shipping_amount',
            IFNULL(ac.shipping_surcharge, 0) 'shipping_surcharge',
            IFNULL(ac.shipping_fee_to_customer, 0) 'shipping_fee_to_customer',
            IFNULL(ac.paid_price, 0) + IFNULL(ac.shipping_fee_to_customer, 0) 'order_value',
            IFNULL(ac.paid_price / 1.1, 0) + IFNULL(ac.shipping_surcharge / 1.1, 0) + IFNULL(ac.shipping_amount / 1.1, 0) + IF(ac.coupon_type <> 'coupon', IFNULL(ac.coupon_money_value / 1.1, 0), 0) 'nmv',
            IFNULL(ac.total_shipment_fee_mp_seller, 0) 'total_shipment_fee_mp_seller',
            IFNULL(ac.shipment_fee_mp_seller, 0) 'shipment_fee_mp_seller',
            IFNULL(ac.total_insurance_fee, 0) 'insurance_fee_mp_seller',
            IFNULL(ac.total_delivery_cost, 0) 'total_delivery_cost',
            ac.origin,
            fz.id_region,
            fz.region,
            fz.id_city,
            fz.city,
            ac.id_district,
            fz.district,
            CASE
                WHEN ac.fk_shipment_scheme NOT IN (1 , 2, 3, 4) THEN CEIL(ac.formula_weight)
                ELSE CASE
                    WHEN ac.formula_weight <= 0.17 THEN 0
                    ELSE CASE
                        WHEN
                            ac.active = 0
                                AND ac.fk_shipment_scheme = 1
                                AND ac.formula_weight > 7.3
                        THEN
                            0
                        WHEN
                            ac.zone_type LIKE '%free%'
                        THEN
                            CASE
                                WHEN
                                    ac.active = 1
                                THEN
                                    CASE
                                        WHEN CEIL(ac.formula_weight) <= 2 THEN 0
                                        ELSE CEIL(ac.formula_weight) - 2
                                    END
                                ELSE CASE
                                    WHEN CEIL(ac.formula_weight) <= 7 THEN 0
                                    ELSE CEIL(ac.formula_weight)
                                END
                            END
                        ELSE CEIL(ac.formula_weight)
                    END
                END
            END 'customer_weight',
            ac.rounded_chargeable_weight,
            ac.rounded_weight,
            ac.shipment_scheme,
            ac.qty,
            ac.active,
            ac.delivery_type,
            IFNULL(ac.total_shipment_fee_mp_seller, 0) + IFNULL(ac.shipping_fee_to_customer, 0) - IFNULL(ac.total_delivery_cost, 0) 'gain_loss',
            CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @jakarta)
                        OR FIND_IN_SET(ac.id_district, @bodetabek)
                THEN
                    4
                ELSE ac.fk_zone_type
            END 'fk_zone_type',
            CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @jakarta)
                        OR FIND_IN_SET(ac.id_district, @bodetabek)
                THEN
                    'Jabodetabek'
                ELSE ac.zone_type
            END 'zone_type',
            CASE
                WHEN ac.seller_type = 'supplier' THEN 'Retail'
                WHEN ac.tax_class = 'international' THEN 'CB'
                WHEN ac.fk_shipment_scheme = 1 THEN 'DB'
                WHEN
                    ac.tax_class = 'local'
                        AND ac.fk_campaign IN (2 , 4)
                THEN
                    'MP Local - VIP'
                WHEN ac.tax_class = 'local' THEN 'MP Local - Non VIP'
            END 'bu',
            CASE
                WHEN ac.formula_weight <= 0.17 THEN '<= 0.17'
                WHEN ac.rounded_weight < 3 THEN '1-2 Kg'
                WHEN ac.rounded_weight < 4 THEN '3 Kg'
                WHEN ac.rounded_weight < 5 THEN '4 Kg'
                WHEN ac.rounded_weight < 6 THEN '5 Kg'
                WHEN ac.rounded_weight < 7 THEN '6 Kg'
                WHEN ac.rounded_weight < 8 THEN '7 Kg'
                ELSE '8 Kg and above'
            END 'weight_bucket',
            CASE
                WHEN
                    (order_date < '2017-01-01'
                        OR first_shipped_date < '2017-01-01')
                        AND (rounded_weight / qty) > 7
                        AND shipping_fee_to_customer = 0
                THEN
                    0
                WHEN
                    (order_date >= '2017-01-01'
                        OR first_shipped_date >= '2017-01-01')
                        AND (rounded_weight / qty) > 2
                        AND shipping_fee_to_customer = 0
                THEN
                    0
                WHEN
                    fk_shipment_scheme <> 5
                        AND rounded_weight > 0
                        AND total_shipment_cost = 0
                THEN
                    0
                WHEN rounded_weight / qty > 400 THEN 0
                ELSE 1
            END 'pass'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN scgl.free_zone fz ON ac.id_district = fz.id_district
        AND ac.active = fz.active
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.fk_shipment_scheme IN (1 , 2, 3, 4)
    HAVING pass = 1) ac
        LEFT JOIN
    scgl.rate_card_customer rcc ON ac.id_district = rcc.id_district
        AND ac.origin = rcc.origin
        AND ac.active = rcc.active
GROUP BY bob_id_supplier , bu