/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Key Metrics Summarization - Payment Cost Summary
 
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
SET @extractstart = '2016-11-01';
SET @extractend = '2016-11-02'; -- This MUST be D + 1

-- WARNING! Only change this part whenever there's update!
SET @jakarta = '6606,6605,17231,6653,6652,6651,6650,6649,6648,6647,6646,6644,6643,6642,6641,6640,6639,6638,6637,6635,6634,6633,6632,6631,6630,6629,6628,6627,6626,6624,6623,6622,6621,6620,6619,6618,6617,6616,6615,6613,6612,6611,6610,6609,6608';
SET @bodetabek = '6229,6228,6227,6226,6225,6224,6223,6222,6221,6220,6219,6218,6217,6216,6215,6214,6213,6212,6211,6210,6209,6208,6207,6206,6205,6204,6203,6202,6201,6200,6199,6198,6197,6196,6195,6194,6193,6192,6191,6190,17389,6344,6343,6342,6341,6340,6339,6327,17384,6326,17385,6325,6324,6323,6322,6885,6884,6883,6882,6881,6880,6879,6878,6877,6876,6875,6874,6873,6872,6871,6870,6869,6868,6867,6866,6865,6864,6863,6862,6861,6860,6859,6858,6857,7001,7000,6999,6998,6997,6996,6995,17393,6994,6993,6992,6991,6990,6989,6987,6986,6985,6984,6983,6982,6981,6253,6252,6251,6250,6249,17381,6248,6247,6246,6245,6244,6243,6242,6241,6240,6239,6238,6237,6236,6235,6234,6233,6232,6231,6357,17390,6356,6355,6354,6353,6352,6351,6350,6349,6348,6347,6346';
SET @free = '7125,17315,7124,7123,7122,17316,7121,17317,17318,7120,17319,7130,7129,7128,7127,6979,6978,6977,6976,6975,6974,6973,6972,6971,6970,6969,6968,6967,6966,6965,6964,6963,6962,6961,6960,6959,6958,6957,6956,6955,6954,6953,6952,6950,6949,6948,17392,6947,6946,6945,6944,6943,6942,6941,6940,6939,6938,6937,6936,6935,6934,6933,6932,6931,6930,6929,6928,6927,6926,6925,6924,6923,6922,6921,6920,6919,6918,6917,6916,6914,6913,6912,6911,6910,6909,6908,6907,6906,6905,6904,6903,6902,6901,6900,6899,6898,6897,6896,6895,6894,6893,6892,6891,6890,6889,6888,6887,6885,6884,6883,6882,6881,6880,6879,6878,6877,6876,6875,6874,6873,6872,6871,6870,6869,6868,6867,6866,6865,6864,6863,6862,6861,6860,6859,6858,6857,7017,7016,7015,7014,7013,7012,17394,7011,7010,7008,7007,7006,7005,7004,7003,7001,7000,6999,6998,6997,6996,6995,17393,6994,6993,6992,6991,6990,6989,6987,6986,6985,6984,6983,6982,6981,6671,6670,6669,6668,6667,6666,6665,6664,6663,6662,6661,6660,6659,6658,6657,6656,6655,6736,6735,6734,6733,6732,6731,6730,6729,6728,6727,6726,6725,6724,6723,17212,6606,6605,17231,6653,6652,6651,6650,6649,6648,6647,6646,6644,6643,6642,6641,6640,6639,6638,6637,6635,6634,6633,6632,6631,6630,6629,6628,6627,6626,6624,6623,6622,6621,6620,6619,6618,6617,6616,6615,6613,6612,6611,6610,6609,6608,6301,6300,6299,6298,6297,6296,6295,6294,6293,6292,6291,6290,6289,6288,6287,6286,6285,6284,6283,6282,6281,6280,6279,6278,6277,6276,6275,6274,6273,6272,6271,6269,6268,6267,6266,17382,6265,6264,6263,6262,6261,6260,6259,6258,6257,6256,6255,6253,6252,6251,6250,6249,17381,6248,6247,6246,6245,6244,6243,6242,6241,6240,6239,6238,6237,6236,6235,6234,6233,6232,6231,6229,6228,6227,6226,6225,6224,6223,6222,6221,6220,6219,6218,6217,6216,6215,6214,6213,6212,6211,6210,6209,6208,6207,6206,6205,6204,6203,6202,6201,6200,6199,6198,6197,6196,6195,6194,6193,6192,6191,6190,6393,6392,6391,6390,6389,6388,17391,6387,6386,6385,6384,6383,6382,6381,6380,6379,6378,6377,6376,6375,6374,6373,6372,6371,6370,6369,6368,6367,6366,6365,6364,6357,17390,6356,6355,6354,6353,6352,6351,6350,6349,6348,6347,6346,17389,6344,6343,6342,6341,6340,6339,17388,6337,6336,6335,6327,17384,6326,17385,6325,6324,6323,6322,5441,5440,5439,5438,5437,5436,5435,5434,5433,5432,5431,5430,5429,5428,17496,5427,5426,5425,5424,5423,5422,5421,5420,5419,5418,5417,5416,5274,5273,5272,5271,5270,5269,5268,5267,5266,5265,5264,5263,5262,5261,5260,5259,5258,17493,5257,5256,5732,5731,5730,5729,5728,5727,5726,5725,5724,17506,5723,5722,5721,5720,5719,5718,5717,5715,5714,5713,5712,5711,17505,4954,4953,4952,4951,4950,4949,4948,4947,4946,4945,4944,4943,4942,4941,4940,4939,4938,4937,4881,4880,4879,4878,4877,4876,4875,4874,4873,4872,4871,4870,4869,4868,4867,4866,4865,4864,4863,4862,4861,4860,4859,4858,4857,4856,4854,4853,4852,4851,4850,4849,4848,4847,4846,4845,4844,4843,4842,4841,4840,4839,4838,4837,4836,4835,4834,4833,4832,4831,4830,4829,4828,4662,4661,4660,4659,4658,4657,17238,4656,4655,4654,4653,4652,4651,4650,4561,4560,4559,4558,4557,4556,4555,4554,4553,4552,4551,4550,4549,4548,4547,4546,4545,4544,5122,5121,5120,5119,17248,5118,5105,5104,5103,5102,5101,5100,5099,5098,5097,5096,5095,5094,5093,5092,5091,5090,5089,5088,5087,5086,5085,5084,5083,5082,5081,5080,5079,5078,5077,5076,5075,17211,3742,3741,3740,3739,3738,3737,3736,3735,3734,3733,3732,3731,3730,17443,565,564,563,562,561,560,559,558,557,556,555,554,553,552,551,550,549,548,547,546,545';

SET @vip = ;

-- WARNING! DO NOT CHANGE THIS PART, EVER!!
SET @lvl = 0;

SELECT 
    *
FROM
    (SELECT 
        payment_method,
            CASE
                WHEN payment_cost_logic = 1 THEN 'Cybersource 1.85% from customer'
                WHEN payment_cost_logic = 2 THEN 'Mandiri_Virtual_Payment IDR 3000 per order'
                WHEN payment_cost_logic = 3 THEN 'BCA_Virtual_Account IDR 1000 per order'
                WHEN payment_cost_logic = 4 THEN 'Hellopay 2.25% from customer'
                WHEN payment_cost_logic = 5 THEN 'MandiriClickpay IDR 3000 per order'
                WHEN payment_cost_logic = 6 THEN 'BCA_KlikPay Debit IDR 3500 per order'
                WHEN payment_cost_logic = 7 THEN 'BCA_KlikPay Installment IDR 1500 per order + 1.5% from customer'
                WHEN payment_cost_logic = 8 THEN 'CashOnDelivery LEX 1.5% from customer'
                WHEN payment_cost_logic = 9 THEN 'CashOnDelivery 3PL 1.5% from customer'
                WHEN payment_cost_logic = 10 THEN 'DOKUInstallment Mandiri 3 Month IDR 1500 per order + 2.5% from customer'
                WHEN payment_cost_logic = 11 THEN 'DOKUInstallment Mandiri 6 Month IDR 1500 per order + 4% from customer'
                WHEN payment_cost_logic = 12 THEN 'DOKUInstallment Mandiri 12 Month IDR 1500 per order + 6% from customer'
                WHEN payment_cost_logic = 13 THEN 'DOKUInstallment BNI 3 Month IDR 1500 per order + 3% from customer'
                WHEN payment_cost_logic = 14 THEN 'DOKUInstallment BNI 6 Month IDR 1500 per order + 4% from customer'
                WHEN payment_cost_logic = 15 THEN 'DOKUInstallment BNI 12 IDR 1500 per order + 6% from customer'
                WHEN payment_cost_logic = 16 THEN 'DOKUInstallment Other 1.9% from customer'
                WHEN payment_cost_logic = 17 THEN 'BCA_Bank_Transfer IDR 3050 per order'
                WHEN payment_cost_logic = 18 THEN 'KlikBCA_Payment IDR 3500 per order'
                WHEN payment_cost_logic = 19 THEN 'BNI_Virtual_Account IDR 2200 per order'
            END 'payment_cost_logic',
            COUNT(IF(seller_type = 'RETAIL', bob_id_sales_order_item, NULL)) 'total_qty_retail',
            COUNT(DISTINCT IF(seller_type = 'RETAIL', id_sales_order, NULL)) 'total_so_retail',
            SUM(IF(seller_type = 'RETAIL', from_customer, 0)) 'from_customer_retail',
            SUM(IF(seller_type = 'RETAIL', nmv, 0)) 'nmv_retail',
            SUM(IF(seller_type = 'RETAIL', payment_cost, 0)) 'payment_cost_retail',
            COUNT(IF(seller_type = 'CB', bob_id_sales_order_item, NULL)) 'total_qty_cb',
            COUNT(DISTINCT IF(seller_type = 'CB', id_sales_order, NULL)) 'total_so_cb',
            SUM(IF(seller_type = 'CB', from_customer, 0)) 'from_customer_cb',
            SUM(IF(seller_type = 'CB', nmv, 0)) 'nmv_cb',
            SUM(IF(seller_type = 'CB', payment_cost, 0)) 'payment_cost_cb',
            COUNT(IF(seller_type = 'VIP', bob_id_sales_order_item, NULL)) 'total_qty_vip',
            COUNT(DISTINCT IF(seller_type = 'VIP', id_sales_order, NULL)) 'total_so_vip',
            SUM(IF(seller_type = 'VIP', from_customer, 0)) 'from_customer_vip',
            SUM(IF(seller_type = 'VIP', nmv, 0)) 'nmv_vip',
            SUM(IF(seller_type = 'VIP', payment_cost, 0)) 'payment_cost_vip',
            COUNT(IF(seller_type = 'NON-VIP', bob_id_sales_order_item, NULL)) 'total_qty_non_vip',
            COUNT(DISTINCT IF(seller_type = 'NON-VIP', id_sales_order, NULL)) 'total_so_non_vip',
            SUM(IF(seller_type = 'NON-VIP', from_customer, 0)) 'from_customer_non_vip',
            SUM(IF(seller_type = 'NON-VIP', nmv, 0)) 'nmv_non_vip',
            SUM(IF(seller_type = 'NON-VIP', payment_cost, 0)) 'payment_cost_non_vip',
            COUNT(bob_id_sales_order_item) 'total_qty',
            COUNT(DISTINCT id_sales_order) 'total_so',
            SUM(from_customer) 'total_from_customer',
            SUM(nmv) 'total_nmv',
            SUM(payment_cost) 'total_payment_cost'
    FROM
        (SELECT 
        result.*,
            IFNULL(CASE
                WHEN payment_cost_logic = 1 THEN 0.0185 * from_customer
                WHEN payment_cost_logic = 2 THEN 3000 / total_order_soi
                WHEN payment_cost_logic = 3 THEN 1000 / total_order_soi
                WHEN payment_cost_logic = 4 THEN 0.0225 * from_customer
                WHEN payment_cost_logic = 5 THEN 3000 / total_order_soi
                WHEN payment_cost_logic = 6 THEN 3500 / total_order_soi
                WHEN payment_cost_logic = 7 THEN (1500 / total_order_soi) + (0.015 * from_customer)
                WHEN payment_cost_logic = 8 THEN 0.015 * from_customer
                WHEN payment_cost_logic = 9 THEN 0.015 * from_customer
                WHEN payment_cost_logic = 10 THEN (1500 / total_order_soi) + (0.025 * from_customer)
                WHEN payment_cost_logic = 11 THEN (1500 / total_order_soi) + (0.04 * from_customer)
                WHEN payment_cost_logic = 12 THEN (1500 / total_order_soi) + (0.06 * from_customer)
                WHEN payment_cost_logic = 13 THEN (1500 / total_order_soi) + (0.03 * from_customer)
                WHEN payment_cost_logic = 14 THEN (1500 / total_order_soi) + (0.04 * from_customer)
                WHEN payment_cost_logic = 15 THEN (1500 / total_order_soi) + (0.06 * from_customer)
                WHEN payment_cost_logic = 16 THEN 0.019 * from_customer
                WHEN payment_cost_logic = 17 THEN 3050 / total_order_soi
                WHEN payment_cost_logic = 18 THEN 3500 / total_order_soi
                WHEN payment_cost_logic = 19 THEN 2200 / total_order_soi
            END, 0) / 1.1 'payment_cost'
    FROM
        (SELECT 
        so.id_sales_order,
            soi.bob_id_sales_order_item,
            IFNULL(soi.unit_price / 1.1, 0) 'unit_price',
            IFNULL(soi.paid_price / 1.1, 0) 'paid_price',
            IFNULL(soi.shipping_surcharge / 1.1, 0) 'shipping_fee',
            IFNULL(soi.shipping_amount / 1.1, 0) 'shipping_amount',
            IFNULL(soi.cart_rule_discount / 1.1, 0) 'cart_rule_discount',
            IFNULL(soi.coupon_money_value / 1.1, 0) 'coupon_money_value',
            IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value / 1.1, 0), 0) 'nmv',
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
            IFNULL(soi.marketplace_commission_fee / 1.1, 0) 'commission_fee',
            CASE
                WHEN is_marketplace = 1 THEN 0
                ELSE IFNULL(IFNULL(poi.cost, soi.cost), 0)
            END 'retail_cogs',
            so.payment_method,
            (SELECT 
                    COUNT(id_sales_order_item)
                FROM
                    oms_live.ims_sales_order_item soi
                WHERE
                    fk_sales_order = so.id_sales_order
                GROUP BY fk_sales_order) 'total_order_soi',
            (IFNULL(soi.paid_price, 0) + IFNULL(soi.shipping_surcharge, 0) + IFNULL(soi.shipping_amount, 0)) 'from_customer',
            CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 'RETAIL'
                WHEN
                    lsc_sel.tax_class = 'international'
                        OR asc_sel.tax_class = 1
                THEN
                    'CB'
                WHEN FIND_IN_SET(sup.id_supplier, @vip) THEN 'VIP'
                ELSE 'NON-VIP'
            END 'seller_type',
            CASE
                WHEN so.payment_method = 'Cybersource' THEN 1
                WHEN so.payment_method = 'Mandiri_Virtual_Payment' THEN 2
                WHEN so.payment_method = 'BCA_Virtual_Account' THEN 3
                WHEN so.payment_method = 'Hellopay' THEN 4
                WHEN so.payment_method = 'MandiriClickpay' THEN 5
                WHEN
                    so.payment_method = 'BCA_KlikPay'
                        AND (SELECT 
                            payType
                        FROM
                            bob_live.payment_bca_response
                        WHERE
                            transactionNo = so.order_nr
                        GROUP BY transactionNo) = '01'
                THEN
                    6
                WHEN
                    so.payment_method = 'BCA_KlikPay'
                        AND (SELECT 
                            payType
                        FROM
                            bob_live.payment_bca_response
                        WHERE
                            transactionNo = so.order_nr
                        GROUP BY transactionNo) = '02'
                THEN
                    7
                WHEN
                    so.payment_method = 'CashOnDelivery'
                        AND (ppt.name = 'LEX'
                        OR sp0.shipment_provider_name LIKE '%LEX%')
                THEN
                    8
                WHEN so.payment_method = 'CashOnDelivery' THEN 9
                WHEN
                    so.payment_method = 'DOKUInstallment'
                        AND (SELECT 
                            SUBSTRING_INDEX(SUBSTRING_INDEX(raw_response, '</BANK>', 1), '<BANK>', - 1)
                        FROM
                            bob_live.payment_dokuinstallment_response
                        WHERE
                            fk_sales_order = bsoi.fk_sales_order
                        GROUP BY fk_sales_order) LIKE '%Mandiri%'
                        AND (SELECT 
                            tenor
                        FROM
                            bob_live.sales_order_instalment
                        WHERE
                            order_nr = so.order_nr
                        GROUP BY order_nr) = 3
                THEN
                    10
                WHEN
                    so.payment_method = 'DOKUInstallment'
                        AND (SELECT 
                            SUBSTRING_INDEX(SUBSTRING_INDEX(raw_response, '</BANK>', 1), '<BANK>', - 1)
                        FROM
                            bob_live.payment_dokuinstallment_response
                        WHERE
                            fk_sales_order = bsoi.fk_sales_order
                        GROUP BY fk_sales_order) LIKE '%Mandiri%'
                        AND (SELECT 
                            tenor
                        FROM
                            bob_live.sales_order_instalment
                        WHERE
                            order_nr = so.order_nr
                        GROUP BY order_nr) = 6
                THEN
                    11
                WHEN
                    so.payment_method = 'DOKUInstallment'
                        AND (SELECT 
                            SUBSTRING_INDEX(SUBSTRING_INDEX(raw_response, '</BANK>', 1), '<BANK>', - 1)
                        FROM
                            bob_live.payment_dokuinstallment_response
                        WHERE
                            fk_sales_order = bsoi.fk_sales_order
                        GROUP BY fk_sales_order) LIKE '%Mandiri%'
                        AND (SELECT 
                            tenor
                        FROM
                            bob_live.sales_order_instalment
                        WHERE
                            order_nr = so.order_nr
                        GROUP BY order_nr) = 12
                THEN
                    12
                WHEN
                    so.payment_method = 'DOKUInstallment'
                        AND (SELECT 
                            SUBSTRING_INDEX(SUBSTRING_INDEX(raw_response, '</BANK>', 1), '<BANK>', - 1)
                        FROM
                            bob_live.payment_dokuinstallment_response
                        WHERE
                            fk_sales_order = bsoi.fk_sales_order
                        GROUP BY fk_sales_order) LIKE '%BNI%'
                        AND (SELECT 
                            tenor
                        FROM
                            bob_live.sales_order_instalment
                        WHERE
                            order_nr = so.order_nr
                        GROUP BY order_nr) = 3
                THEN
                    13
                WHEN
                    so.payment_method = 'DOKUInstallment'
                        AND (SELECT 
                            SUBSTRING_INDEX(SUBSTRING_INDEX(raw_response, '</BANK>', 1), '<BANK>', - 1)
                        FROM
                            bob_live.payment_dokuinstallment_response
                        WHERE
                            fk_sales_order = bsoi.fk_sales_order
                        GROUP BY fk_sales_order) LIKE '%BNI%'
                        AND (SELECT 
                            tenor
                        FROM
                            bob_live.sales_order_instalment
                        WHERE
                            order_nr = so.order_nr
                        GROUP BY order_nr) = 6
                THEN
                    14
                WHEN
                    so.payment_method = 'DOKUInstallment'
                        AND (SELECT 
                            SUBSTRING_INDEX(SUBSTRING_INDEX(raw_response, '</BANK>', 1), '<BANK>', - 1)
                        FROM
                            bob_live.payment_dokuinstallment_response
                        WHERE
                            fk_sales_order = bsoi.fk_sales_order
                        GROUP BY fk_sales_order) LIKE '%BNI%'
                        AND (SELECT 
                            tenor
                        FROM
                            bob_live.sales_order_instalment
                        WHERE
                            order_nr = so.order_nr
                        GROUP BY order_nr) = 12
                THEN
                    15
                WHEN so.payment_method = 'DOKUInstallment' THEN 16
                WHEN so.payment_method = 'BCA_Bank_Transfer' THEN 17
                WHEN so.payment_method = 'KlikBCA_Payment' THEN 18
                WHEN so.payment_method = 'BNI_Virtual_Account' THEN 19
            END 'payment_cost_logic'
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
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_package_dispatching_history pdh ON pck.id_package = pdh.fk_package
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package_dispatching = pd.id_package_dispatching
                AND tracking_number IS NOT NULL)
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp0 ON pdh.fk_shipment_provider = sp0.id_shipment_provider
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_supplier osup ON soi.bob_id_supplier = osup.bob_id_supplier
    LEFT JOIN oms_live.oms_pickup_provider_type ppt ON osup.fk_pickup_provider_type = ppt.id_pickup_provider_type
    LEFT JOIN oms_live.wms_inventory inv ON pi.fk_inventory = inv.id_inventory
    LEFT JOIN oms_live.ims_purchase_order_item poi ON inv.fk_purchase_order_item = poi.id_purchase_order_item
    LEFT JOIN bob_live.sales_order_item bsoi ON soi.bob_id_sales_order_item = bsoi.id_sales_order_item
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN screport.seller lsc_sel ON sup.id_supplier = lsc_sel.src_id
    LEFT JOIN asc_live.seller asc_sel ON sup.id_supplier = asc_sel.src_id
    GROUP BY soi.id_sales_order_item) result) result
    GROUP BY payment_cost_logic , payment_method) result