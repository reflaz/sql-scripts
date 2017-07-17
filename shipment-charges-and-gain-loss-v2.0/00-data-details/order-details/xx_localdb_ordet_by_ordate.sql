/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Order Details by Order Date

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
SET @extractend = '2017-04-01';-- This MUST be D + 1

SET @jakarta = '6606,6605,17231,6653,6652,6651,6650,6649,6648,6647,6646,6644,6643,6642,6641,6640,6639,6638,6637,6635,6634,6633,6632,6631,6630,6629,6628,6627,6626,6624,6623,6622,6621,6620,6619,6618,6617,6616,6615,6613,6612,6611,6610,6609,6608';
SET @bodetabek = '6229,6228,6227,6226,6225,6224,6223,6222,6221,6220,6219,6218,6217,6216,6215,6214,6213,6212,6211,6210,6209,6208,6207,6206,6205,6204,6203,6202,6201,6200,6199,6198,6197,6196,6195,6194,6193,6192,6191,6190,17389,6344,6343,6342,6341,6340,6339,6327,17384,6326,17385,6325,6324,6323,6322,6885,6884,6883,6882,6881,6880,6879,6878,6877,6876,6875,6874,6873,6872,6871,6870,6869,6868,6867,6866,6865,6864,6863,6862,6861,6860,6859,6858,6857,7001,7000,6999,6998,6997,6996,6995,17393,6994,6993,6992,6991,6990,6989,6987,6986,6985,6984,6983,6982,6981,6253,6252,6251,6250,6249,17381,6248,6247,6246,6245,6244,6243,6242,6241,6240,6239,6238,6237,6236,6235,6234,6233,6232,6231,6357,17390,6356,6355,6354,6353,6352,6351,6350,6349,6348,6347,6346';

SET @cbrate = -2161.67824846249000;

SELECT 
    *
FROM
    (SELECT 
        *,
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv',
            CASE
                WHEN FIND_IN_SET(id_district, @jakarta) THEN 'Jabodetabek'
                WHEN FIND_IN_SET(id_district, @bodetabek) THEN 'Jabodetabek'
                ELSE zone_type
            END zone_type_temp,
            CASE
                WHEN fk_shipment_scheme = 5 THEN total_shipment_fee_mp_seller + shipping_fee_to_customer - @cbrate * qty
                ELSE total_delivery_cost
            END 'delivery_cost',
            CASE
                WHEN fk_shipment_scheme = 5 THEN @cbrate * qty
                ELSE total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost
            END 'total_subsidy'
    FROM
        scgl.anondb_calculate
    WHERE
        fk_shipment_scheme IN (1 , 2, 3, 4, 5, 7)) ac
        LEFT JOIN
    scgl.rate_card_customer rcc ON ac.id_district = rcc.id_district
        AND ac.origin = rcc.origin