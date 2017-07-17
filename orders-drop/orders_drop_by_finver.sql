SET @extractstart = '2016-12-01';
SET @extractend = '2017-01-01';

SET @cutoff = '2017-01-03';

SELECT 
    *
FROM
    (SELECT 
        so.payment_method,
            COUNT(DISTINCT so.order_nr) 'count_so',
            COUNT(DISTINCT IF(verified.created_at IS NOT NULL, so.order_nr, NULL)) 'count_so_finver',
            COUNT(DISTINCT IF(failed.created_at IS NOT NULL, so.order_nr, NULL)) 'count_so_finfail',
            COUNT(DISTINCT IF(failed.created_at IS NOT NULL, so.order_nr, NULL)) / COUNT(DISTINCT so.order_nr) 'drop_rate',
            -- SUM(IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value / 1.1, 0), 0)) 'total_nmv',
            -- SUM(IF(verified.created_at IS NOT NULL, IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value / 1.1, 0), 0), 0)) 'total_nmv_finver',
            -- SUM(IF(failed.created_at IS NOT NULL, IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value / 1.1, 0), 0), 0)) 'total_nmv_finfail'
            SUM(IFNULL(soi.paid_price,0)) 'total_nmv',
            SUM(IF(verified.created_at IS NOT NULL, IFNULL(soi.paid_price,0), 0)) 'total_nmv_finver',
            SUM(IF(failed.created_at IS NOT NULL, IFNULL(soi.paid_price, 0), 0)) 'total_nmv_finfail'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history failed ON soi.id_sales_order_item = failed.fk_sales_order_item
        AND failed.fk_sales_order_item_status = 66
        AND failed.created_at < @cutoff
    LEFT JOIN oms_live.ims_sales_order_item_status_history verified ON soi.id_sales_order_item = verified.fk_sales_order_item
        AND verified.fk_sales_order_item_status = 67
        AND verified.created_at < @cutoff
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND (verified.created_at IS NOT NULL
            OR failed.created_at IS NOT NULL)
    GROUP BY so.payment_method) result