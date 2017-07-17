SET @weight_bucket = 0;

SELECT 
    CONCAT(IFNULL(fz.id_city, 'xx'),
            IFNULL(zt.id_zone_type, 'xx'),
            IFNULL(wb.weight_bucket, 'xx')) formula,
    fz.region,
    fz.city,
    zt.zone_type,
    wb.weight_bucket
FROM
    scgl.free_zone fz
        CROSS JOIN
    scgl.zone_type zt
        CROSS JOIN
    (SELECT '<= 0.17' AS 'weight_bucket' UNION ALL SELECT '1-2 Kg' UNION ALL SELECT '3 Kg' UNION ALL SELECT '4 Kg' UNION ALL SELECT '5 Kg' UNION ALL SELECT '6 Kg' UNION ALL SELECT '7 Kg' UNION ALL SELECT '8 Kg and above') wb
GROUP BY id_city , id_zone_type , weight_bucket