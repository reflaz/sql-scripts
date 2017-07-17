/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Koinworks Data by Seller Center ID
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Insert formatted Seller's SC ID in 'sel.short_code' part of the script. You can format the ID in excel using
				  this formula: ="'"&<Column>&"','" --> change <Column> accordingly
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @end_period = DATE_FORMAT(IF(DAY(NOW()) > 15, DATE_ADD(NOW(), INTERVAL 1 MONTH), NOW()), '%Y-%m-01');
SET @period_1 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_2 = DATE_FORMAT(DATE_SUB(@period_1, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_3 = DATE_FORMAT(DATE_SUB(@period_2, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_4 = DATE_FORMAT(DATE_SUB(@period_3, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_5 = DATE_FORMAT(DATE_SUB(@period_4, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_6 = DATE_FORMAT(DATE_SUB(@period_5, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_7 = DATE_FORMAT(DATE_SUB(@period_6, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_8 = DATE_FORMAT(DATE_SUB(@period_7, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_9 = DATE_FORMAT(DATE_SUB(@period_8, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_10 = DATE_FORMAT(DATE_SUB(@period_9, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_11 = DATE_FORMAT(DATE_SUB(@period_10, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_12 = DATE_FORMAT(DATE_SUB(@period_11, INTERVAL 1 MONTH), '%Y-%m-01');

SELECT '12' AS 'period', @period_12 AS 'beginning_date'
UNION ALL SELECT '11' AS 'period', @period_11
UNION ALL SELECT '10' AS 'period', @period_10
UNION ALL SELECT '09' AS 'period', @period_9
UNION ALL SELECT '08' AS 'period', @period_8
UNION ALL SELECT '07' AS 'period', @period_7
UNION ALL SELECT '06' AS 'period', @period_6
UNION ALL SELECT '05' AS 'period', @period_5
UNION ALL SELECT '04' AS 'period', @period_4
UNION ALL SELECT '03' AS 'period', @period_3
UNION ALL SELECT '02' AS 'period', @period_2
UNION ALL SELECT '01' AS 'period', @period_1
UNION ALL SELECT 'end_period' AS 'period', @end_period;

SELECT 
    *
FROM
    (SELECT 
        result.name 'shop_name',
            result.owner_name 'owner_name',
            result.contact_name 'name_of_pic',
            result.contact_phone 'pic_contact_number',
            result.street 'address',
            result.city 'city',
            result.root_categories 'root_categories',
            sel.email 'email_address',
            sel.short_code 'seller_center_id',
            result.bank_account_nr 'bank_account_no',
            result.bank_account_bank 'bank_name',
            result.joined_date 'joined_date_as_merchant',
            SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_12',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_11',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_10',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_09',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_08',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_07',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_06',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_05',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_04',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_03',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_02',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_01',
            SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_12',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_11',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_10',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_09',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_08',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_07',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_06',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_05',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_04',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_03',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_02',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_01',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, tr.value, NULL), NULL)) 'item_count_12',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, tr.value, NULL), NULL)) 'item_count_11',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, tr.value, NULL), NULL)) 'item_count_10',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, tr.value, NULL), NULL)) 'item_count_09',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, tr.value, NULL), NULL)) 'item_count_08',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, tr.value, NULL), NULL)) 'item_count_07',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, tr.value, NULL), NULL)) 'item_count_06',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, tr.value, NULL), NULL)) 'item_count_05',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, tr.value, NULL), NULL)) 'item_count_04',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, tr.value, NULL), NULL)) 'item_count_03',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, tr.value, NULL), NULL)) 'item_count_02',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, tr.value, NULL), NULL)) 'item_count_01',
            result.number_of_sku 'number_of_sku'
    FROM
        (SELECT 
        result.*,
            MIN(bsoi.created_at) 'joined_date',
            (SELECT 
                    phone
                FROM
                    oms_live.ims_supplier_history
                WHERE
                    bob_id_supplier = result.id_supplier
                        AND changed_at IS NOT NULL
                HAVING MAX(changed_at)) 'contact_phone'
    FROM
        (SELECT 
        result.*,
            GROUP_CONCAT(result.name_en
                SEPARATOR '; ') 'root_categories'
    FROM
        (SELECT 
        sup.id_supplier,
            sup.name,
            MIN(IF(sa.address_type = 'standard', sa.contact_name, NULL)) 'owner_name',
            MIN(IF(sa.address_type = 'customercare', sa.contact_name, NULL)) 'contact_name',
            osa.street,
            osa.city,
            cca_1.name_en,
            sup.bank_account_nr,
            sup.bank_account_bank,
            (SELECT 
                    COUNT(id_catalog_product)
                FROM
                    screport.seller sel
                LEFT JOIN screport.catalog_product cp ON cp.fk_seller = sel.id_seller
                LEFT JOIN screport.catalog_category cc ON cp.primary_category = cc.id_catalog_category
                WHERE
                    sel.name = sup.name
                        AND cp.status = 'active') 'number_of_sku'
    FROM
        screport.seller sel
    LEFT JOIN bob_live.supplier sup ON sel.name = sup.name
    LEFT JOIN bob_live.catalog_source cs ON sup.id_supplier = cs.fk_supplier
        AND cs.status_source = 'active'
    LEFT JOIN bob_live.catalog_simple csi ON cs.fk_catalog_simple = csi.id_catalog_simple
        AND csi.status = 'active'
    LEFT JOIN bob_live.catalog_config cc ON csi.fk_catalog_config = cc.id_catalog_config
    LEFT JOIN bob_live.catalog_category cca ON cc.primary_category = cca.id_catalog_category
    LEFT JOIN bob_live.catalog_category cca_1 ON cca.lft >= cca_1.lft
        AND cca.rgt <= cca_1.rgt
        AND cca_1.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            bob_live.catalog_category
        WHERE
            lft <= cca.lft AND rgt >= cca.rgt
                AND id_catalog_category <> 1
        LIMIT 0 , 1)
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
    LEFT JOIN oms_live.ims_supplier_address osa ON sa.id_supplier_address = osa.bob_id_supplier_address
    WHERE
        sel.short_code IN ('ID1063H',
'ID109WE',
'ID10YYS',
'ID1043T',
'ID10PGF',
'ID10HSR',
'ID108IB',
'ID110X2',
'ID101HB',
'ID105YV')
    GROUP BY sup.id_supplier , cca_1.id_catalog_category) result
    GROUP BY result.id_supplier) result
    LEFT JOIN bob_live.sales_order_item bsoi ON result.id_supplier = bsoi.fk_supplier
    GROUP BY result.id_supplier) result
    LEFT JOIN screport.seller sel ON result.name = sel.name
    LEFT JOIN screport.transaction tr ON sel.id_seller = tr.fk_seller
    GROUP BY sel.id_seller) result