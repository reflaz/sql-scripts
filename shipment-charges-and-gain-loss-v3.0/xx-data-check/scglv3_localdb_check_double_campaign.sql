SET @extractstart = '2017-08-21';

SELECT 
    *
FROM
    (SELECT 
        bob_id_supplier,
            short_code,
            seller_name,
            GROUP_CONCAT(fk_campaign
                SEPARATOR ', ') 'fk_campaign',
            COUNT(bob_id_supplier) 'count_id_supplier'
    FROM
        scglv3.campaign_tracker
    WHERE
        start_date <= @extractstart
            AND end_date > @extractstart
    GROUP BY bob_id_supplier
    HAVING count_id_supplier > 1
    ORDER BY fk_campaign) result;