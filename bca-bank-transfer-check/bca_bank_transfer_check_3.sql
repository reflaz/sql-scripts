SELECT 
    MAX(created_at)
FROM
    oms_live.ims_sales_order
WHERE
    created_at >= '2016-11-01'
        AND created_at < '2016-12-01'
        AND payment_method = 'BCA_Virtual_Account'