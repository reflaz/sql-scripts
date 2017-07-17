SET @weight_bucket = 0;

SELECT 
    CONCAT(IFNULL(ssc.id_shipment_scheme, 'xx'),
            IFNULL(zt.id_zone_type, 'xx'),
            IFNULL(wb.weight_bucket, 'xx')) formula,
    ssc.shipment_scheme,
    zt.zone_type,
    wb.weight_bucket
FROM
    scgl.shipment_scheme ssc
        CROSS JOIN
    scgl.zone_type zt
        CROSS JOIN
    (SELECT '<= 0.17' AS 'weight_bucket' UNION ALL SELECT '1-2 Kg' UNION ALL SELECT '3 Kg' UNION ALL SELECT '4 Kg' UNION ALL SELECT '5 Kg' UNION ALL SELECT '6 Kg' UNION ALL SELECT '7 Kg' UNION ALL SELECT '8 Kg and above') wb
GROUP BY id_shipment_scheme , id_zone_type , weight_bucket