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
    *
FROM
    (SELECT 
        sel.name 'shop_name',
            IFNULL(spd.value, sup.bank_account_name) 'owner_name',
            sa.contact_name 'name_of_pic',
            sa.contact_phone 'pic_contact_number',
            osa.street 'address',
            osa.city 'city',
            sel.email 'email_address',
            sel.short_code 'seller_center_id',
            sup.bank_account_nr 'bank_account_no',
            sup.bank_account_bank 'bank_name',
            MIN(ipcr.created_at) 'joined_date_as_merchant',
            SUM(IF(ipcr.created_at >= @period_1
                AND ipcr.created_at < @period_2, ipcr.value, 0)) 'gross_sales_m-12',
            SUM(IF(ipcr.created_at >= @period_2
                AND ipcr.created_at < @period_3, ipcr.value, 0)) 'gross_sales_m-11',
            SUM(IF(ipcr.created_at >= @period_3
                AND ipcr.created_at < @period_4, ipcr.value, 0)) 'gross_sales_m-10',
            SUM(IF(ipcr.created_at >= @period_4
                AND ipcr.created_at < @period_5, ipcr.value, 0)) 'gross_sales_m-09',
            SUM(IF(ipcr.created_at >= @period_5
                AND ipcr.created_at < @period_6, ipcr.value, 0)) 'gross_sales_m-08',
            SUM(IF(ipcr.created_at >= @period_6
                AND ipcr.created_at < @period_7, ipcr.value, 0)) 'gross_sales_m-07',
            SUM(IF(ipcr.created_at >= @period_7
                AND ipcr.created_at < @period_8, ipcr.value, 0)) 'gross_sales_m-06',
            SUM(IF(ipcr.created_at >= @period_8
                AND ipcr.created_at < @period_9, ipcr.value, 0)) 'gross_sales_m-05',
            SUM(IF(ipcr.created_at >= @period_9
                AND ipcr.created_at < @period_10, ipcr.value, 0)) 'gross_sales_m-04',
            SUM(IF(ipcr.created_at >= @period_10
                AND ipcr.created_at < @period_11, ipcr.value, 0)) 'gross_sales_m-03',
            SUM(IF(ipcr.created_at >= @period_11
                AND ipcr.created_at < @period_12, ipcr.value, 0)) 'gross_sales_m-02',
            SUM(IF(ipcr.created_at >= @period_12
                AND ipcr.created_at < @end_period, ipcr.value, 0)) 'gross_sales_m-01',
            COUNT(IF(ipcr.created_at >= @period_1
                AND ipcr.created_at < @period_2, ipcr.value, NULL)) 'item_count_m-12',
            COUNT(IF(ipcr.created_at >= @period_2
                AND ipcr.created_at < @period_3, ipcr.value, NULL)) 'item_count_m-11',
            COUNT(IF(ipcr.created_at >= @period_3
                AND ipcr.created_at < @period_4, ipcr.value, NULL)) 'item_count_m-10',
            COUNT(IF(ipcr.created_at >= @period_4
                AND ipcr.created_at < @period_5, ipcr.value, NULL)) 'item_count_m-09',
            COUNT(IF(ipcr.created_at >= @period_5
                AND ipcr.created_at < @period_6, ipcr.value, NULL)) 'item_count_m-08',
            COUNT(IF(ipcr.created_at >= @period_6
                AND ipcr.created_at < @period_7, ipcr.value, NULL)) 'item_count_m-07',
            COUNT(IF(ipcr.created_at >= @period_7
                AND ipcr.created_at < @period_8, ipcr.value, NULL)) 'item_count_m-06',
            COUNT(IF(ipcr.created_at >= @period_8
                AND ipcr.created_at < @period_9, ipcr.value, NULL)) 'item_count_m-05',
            COUNT(IF(ipcr.created_at >= @period_9
                AND ipcr.created_at < @period_10, ipcr.value, NULL)) 'item_count_m-04',
            COUNT(IF(ipcr.created_at >= @period_10
                AND ipcr.created_at < @period_11, ipcr.value, NULL)) 'item_count_m-03',
            COUNT(IF(ipcr.created_at >= @period_11
                AND ipcr.created_at < @period_12, ipcr.value, NULL)) 'item_count_m-02',
            COUNT(IF(ipcr.created_at >= @period_12
                AND ipcr.created_at < @end_period, ipcr.value, NULL)) 'item_count_m-01'
    FROM
        screport.seller sel
    LEFT JOIN screport.seller_profile_diff spd ON sel.id_seller = spd.fk_seller
        AND spd.fk_field = 1
    LEFT JOIN screport.transaction ipcr ON sel.id_seller = ipcr.fk_seller
        AND fk_transaction_type = 13
    LEFT JOIN bob_live.supplier sup ON sel.name = sup.name
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
    LEFT JOIN oms_live.ims_supplier_address osa ON sa.id_supplier_address = osa.bob_id_supplier_address
    WHERE
        sel.name IN ('Gold Rush Shop' , 'MEDIATECH STORE', 'Mainankayu', 'Bursa BB', 'Channel B')
    GROUP BY sel.id_seller) result