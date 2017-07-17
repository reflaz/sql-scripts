SET @extractstart = '2016-12-12';
SET @extractend = '2016-12-31';

SET @seller = '61818,58270,56694,55914,55534,55061,54829,53997,45142,41774,32500,30602,24294,19014,17952,17548,15617,15224,14781,13162,13126,12693,9088,8280,6698,3260,1720';


SELECT 
    *
FROM
    (SELECT 
        soi.bob_id_supplier,
            sel.short_code,
            sel.name 'seller_name',
            so.order_nr,
            soi.bob_id_sales_order_item,
            soi.unit_price,
            IF(so.fk_voucher_type = 3, soi.coupon_money_value, NULL) 'coupon_money_value',
            IF(so.fk_voucher_type = 3, coupon_code, NULL) 'coupon_code'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND FIND_IN_SET(bob_id_supplier, @seller)
            AND so.fk_voucher_type = 3
    GROUP BY bob_id_sales_order_item) result