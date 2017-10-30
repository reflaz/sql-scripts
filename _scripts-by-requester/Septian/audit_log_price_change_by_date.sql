SELECT 
    *
FROM
    asc_live.audit_log -- asc_live.audit_log_30
WHERE
    FROM_UNIXTIME(request_time / 1000) >= '2017-01-01'
        AND FROM_UNIXTIME(request_time / 1000) < '2017-03-01'
        AND audit_event IN ('special_price_change' , 'price_change')
        AND seller_id = 60055
        -- AND user_id = 85133