USE refrain_live;

SELECT 
    *
FROM
    (SELECT 
        mct1.bob_id_supplier,
            mct1.short_code,
            mct1.seller_name,
            GROUP_CONCAT(DISTINCT mct2.fk_campaign
                SEPARATOR ', ') 'multiple_campaign',
            COUNT(mct2.bob_id_supplier) 'count_id_supplier'
    FROM
        map_campaign_tracker mct1
    LEFT JOIN map_campaign_tracker mct2 ON mct1.bob_id_supplier = mct2.bob_id_supplier
        AND mct1.id_campaign_tracker <> mct2.id_campaign_tracker
        AND mct2.fk_campaign NOT IN (1,3)
        AND ((mct1.start_date <= mct2.start_date AND mct1.end_date >= mct2.start_date AND mct1.end_date <= mct2.end_date)
			OR (mct1.end_date >= mct2.end_date AND mct1.start_date >= mct2.start_date AND mct1.start_date <= mct2.end_date)
            OR (mct1.start_date <= mct2.start_date AND mct1.start_date <= mct2.end_date AND mct1.end_date >= mct2.end_date)
            OR (mct1.end_date >= mct2.start_date AND mct1.start_date <= mct2.end_date AND mct1.end_date >= mct2.end_date))
		WHERE mct1.fk_campaign NOT IN (1,3)
    GROUP BY mct1.bob_id_supplier
    HAVING count_id_supplier > 1
    ORDER BY multiple_campaign) mct