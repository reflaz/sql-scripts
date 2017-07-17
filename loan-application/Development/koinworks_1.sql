SET @end_period = NOW();
SET @period_1 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 12 MONTH), '%Y-%m-01');
SET @period_2 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 11 MONTH), '%Y-%m-01');
SET @period_3 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 10 MONTH), '%Y-%m-01');
SET @period_4 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 9 MONTH), '%Y-%m-01');
SET @period_5 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 8 MONTH), '%Y-%m-01');
SET @period_6 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 7 MONTH), '%Y-%m-01');
SET @period_7 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 6 MONTH), '%Y-%m-01');
SET @period_8 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 5 MONTH), '%Y-%m-01');
SET @period_9 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 4 MONTH), '%Y-%m-01');
SET @period_10 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 3 MONTH), '%Y-%m-01');
SET @period_11 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 2 MONTH), '%Y-%m-01');
SET @period_12 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 1 MONTH), '%Y-%m-01');

SELECT 
    sel.shop_name,
    sup.bank_account_name 'owner_name',
    sa.contact_name 'name_of_pic',
    sa.contact_phone 'pic_contact_number',
    osa.street 'address',
    osa.city 'city',
    sel.email_address,
    sel.seller_center_id,
    sup.bank_account_nr 'bank_account_no',
    sup.bank_account_bank 'bank_name',
    gross_sales_12,
    gross_sales_11,
    gross_sales_10,
    gross_sales_09,
    gross_sales_08,
    gross_sales_07,
    gross_sales_06,
    gross_sales_05,
    gross_sales_04,
    gross_sales_03,
    gross_sales_02,
    gross_sales_01,
    net_sales_12,
    net_sales_11,
    net_sales_10,
    net_sales_09,
    net_sales_08,
    net_sales_07,
    net_sales_06,
    net_sales_05,
    net_sales_04,
    net_sales_03,
    net_sales_02,
    net_sales_01,
    item_count_12,
    item_count_11,
    item_count_10,
    item_count_09,
    item_count_08,
    item_count_07,
    item_count_06,
    item_count_05,
    item_count_04,
    item_count_03,
    item_count_02,
    item_count_01
FROM
    (SELECT 
        sel.id_seller,
            sel.name 'shop_name',
            sel.email 'email_address',
            sel.short_code 'seller_center_id',
            MIN(tr.created_at) 'joined_date_as_merchant',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_12',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_11',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_10',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_09',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_08',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_07',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_06',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_05',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_04',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_03',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_12, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_02',
            SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_01',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @period_2, tr.value, 0)) 'net_sales_12',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_3, tr.value, 0)) 'net_sales_11',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_4, tr.value, 0)) 'net_sales_10',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_5, tr.value, 0)) 'net_sales_09',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_6, tr.value, 0)) 'net_sales_08',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_7, tr.value, 0)) 'net_sales_07',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_8, tr.value, 0)) 'net_sales_06',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_9, tr.value, 0)) 'net_sales_05',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_10, tr.value, 0)) 'net_sales_04',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_11, tr.value, 0)) 'net_sales_03',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_12, tr.value, 0)) 'net_sales_02',
            SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @end_period, tr.value, 0)) 'net_sales_01',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_1
                AND tr.created_at < @period_2, tr.value, NULL), NULL)) 'item_count_12',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_2
                AND tr.created_at < @period_3, tr.value, NULL), NULL)) 'item_count_11',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_3
                AND tr.created_at < @period_4, tr.value, NULL), NULL)) 'item_count_10',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_4
                AND tr.created_at < @period_5, tr.value, NULL), NULL)) 'item_count_09',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_5
                AND tr.created_at < @period_6, tr.value, NULL), NULL)) 'item_count_08',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_6
                AND tr.created_at < @period_7, tr.value, NULL), NULL)) 'item_count_07',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_7
                AND tr.created_at < @period_8, tr.value, NULL), NULL)) 'item_count_06',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_8
                AND tr.created_at < @period_9, tr.value, NULL), NULL)) 'item_count_05',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_9
                AND tr.created_at < @period_10, tr.value, NULL), NULL)) 'item_count_04',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_10
                AND tr.created_at < @period_11, tr.value, NULL), NULL)) 'item_count_03',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_11
                AND tr.created_at < @period_12, tr.value, NULL), NULL)) 'item_count_02',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_12
                AND tr.created_at < @end_period, tr.value, NULL), NULL)) 'item_count_01'
    FROM
        screport.seller sel
    LEFT JOIN screport.transaction tr ON sel.id_seller = tr.fk_seller
    WHERE
        sel.name IN ('Gold Rush Shop' , 'MEDIATECH STORE', 'Mainankayu', 'Bursa BB', 'Channel B')
    GROUP BY sel.id_seller) sel
        LEFT JOIN
    bob_live.supplier sup ON sel.shop_name = sup.name
        LEFT JOIN
    bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        LEFT JOIN
    oms_live.ims_supplier_address osa ON sa.id_supplier_address = osa.bob_id_supplier_address
GROUP BY sel.id_seller