/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Recon Weight Weight Matched 

Prepared by		: Michael Julius

Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/
USE scgl;

SELECT 
    *
FROM
    (SELECT 
        IF(simple_volumetric_weight_before = simple_volumetric_weight_after
                AND simple_weight_before = simple_weight_after
                AND config_volumetric_weight_before = config_volumetric_weight_after
                AND config_weight_before = config_weight_after, 'MATCH', 'NOT MATCH') AS remark,
            bob_id_sales_order_item,
            sku,
            order_nr,
            business_unit,
            order_date,
            first_shipped_date,
            delivered_date,
            not_delivered_date,
            bob_id_supplier,
            seller_name,
            seller_type,
            tax_class,
            unit_price,
            paid_price,
            shipping_amount,
            shipping_surcharge,
            simple_volumetric_weight_before,
            simple_weight_before,
            config_volumetric_weight_before,
            config_weight_before,
            chargeable_weight_before,
            simple_volumetric_weight_after,
            simple_weight_after,
            config_volumetric_weight_after,
            config_weight_after,
            chargeable_weight_after,
            level1,
            level2,
            level3,
            level4
    FROM
        (SELECT 
        b.*,
            (IFNULL(a.simple_length, 0) * IFNULL(a.simple_width, 0) * IFNULL(a.simple_height, 0)) / 6000 AS simple_volumetric_weight_after,
            IFNULL(a.simple_weight, 0) AS simple_weight_after,
            (IFNULL(a.config_length, 0) * IFNULL(a.config_width, 0) * IFNULL(a.config_height, 0)) / 6000 AS config_volumetric_weight_after,
            IFNULL(a.config_weight, 0) AS config_weight_after,
            GREATEST(IFNULL(CASE
                WHEN
                    a.simple_weight > 0
                        OR (a.simple_length * a.simple_width * a.simple_height) > 0
                THEN
                    a.simple_weight
                ELSE a.config_weight
            END, 0), IFNULL(CASE
                WHEN
                    a.simple_weight > 0
                        OR (a.simple_length * a.simple_width * a.simple_height) > 0
                THEN
                    (a.simple_length * a.simple_width * a.simple_height) / 6000
                ELSE a.config_length * a.config_width * a.config_height / 6000
            END, 0)) 'chargeable_weight_after',
            ct.level1,
            ct.level2,
            ct.level3,
            ct.level4
    FROM
        (SELECT 
        *,
            (IFNULL(simple_length, 0) * IFNULL(simple_width, 0) * IFNULL(simple_height, 0)) / 6000 AS simple_volumetric_weight_before,
            IFNULL(simple_weight, 0) AS simple_weight_before,
            (IFNULL(config_length, 0) * IFNULL(config_width, 0) * IFNULL(config_height, 0)) / 6000 AS config_volumetric_weight_before,
            IFNULL(config_weight, 0) AS config_weight_before,
            GREATEST(IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    simple_weight
                ELSE config_weight
            END, 0), IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END, 0)) 'chargeable_weight_before',
            CASE
                WHEN tax_class = 'international' THEN 'CB'
                WHEN delivery_type = 'digital' THEN 0
                WHEN
                    delivery_type IN ('express' , 'nextday', 'sameday')
                        AND last_shipment_provider LIKE '%Go-Jek%'
                THEN
                    'GO-JEK'
                WHEN is_marketplace = 0 THEN 'RETAIL'
                WHEN shipping_type = 'warehouse' THEN 'FBL'
                WHEN
                    first_shipment_provider = 'Acommerce'
                        AND last_shipment_provider = 'Acommerce'
                THEN
                    'DIRECT BILLING'
                WHEN
                    payment_method <> 'CashOnDelivery'
                        AND first_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                        AND last_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                THEN
                    'DIRECT BILLING'
                ELSE 'MASTER ACCOUNT'
            END 'business_unit'
    FROM
        anondb_extract_before
    HAVING business_unit IN ('DIRECT BILLING' , 'MASTER ACCOUNT', 'GO-JEK', 'RETAIL', 'FBL')) b
    INNER JOIN anondb_extract a ON b.bob_id_sales_order_item = a.bob_id_sales_order_item
    LEFT JOIN category_tree ct ON a.primary_category = ct.lookup_cat_id) fin
    HAVING remark = 'MATCH') result
GROUP BY sku