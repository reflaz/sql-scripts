SELECT 
    so.order_nr,
    so.created_at 'order_date',
    SUM(soi.coupon_money_value) 'coupon_money_value',
    so.coupon_code,
    srs.name 'voucher_name',
    so.client_type
FROM
    bob_live.sales_order so
        LEFT JOIN
    bob_live.sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    bob_live.sales_rule_apply sra ON so.id_sales_order = sra.fk_sales_order
        LEFT JOIN
    bob_live.sales_rule sr ON sra.fk_sales_rule = sr.id_sales_rule
        LEFT JOIN
    bob_live.sales_rule_set srs ON sr.fk_sales_rule_set = srs.id_sales_rule_set
WHERE
    so.created_at >= '2015-09-01'
        AND so.created_at < '2016-03-01'
        AND so.coupon_code LIKE 'TS%'
GROUP BY order_nr