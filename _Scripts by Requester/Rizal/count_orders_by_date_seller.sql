SET @extractstart = '2016-12-12';
SET @extractend = '2016-12-13';

SET @seller = '1720,3260,6698,8280,9088,12693,13126,13162,14781,15224,15617,17548,17952,19014,24294,30602,32500,41774,45142,53997,54829,55061,55534,55914,56694,58270,61818';


SELECT 
    bob_id_supplier,
    short_code,
    seller_name,
    COUNT(DISTINCT order_nr) 'count_so',
    SUM(nmv) 'sum_nmv',
    COUNT(bob_id_sales_order_item) 'count_soi'
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            soi.bob_id_supplier,
            sel.short_code,
            sup.name 'seller_name',
            IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value / 1.1, 0), 0) 'nmv'
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
            AND FIND_IN_SET(bob_id_supplier, @seller)) result
GROUP BY bob_id_supplier