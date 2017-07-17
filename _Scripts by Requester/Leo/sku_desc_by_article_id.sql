USE bob_live;

SELECT 
    cs.erp_reference 'Article ID',
    cs.sku 'SKU',
    cc.name 'Desctiption'
FROM
    bob_live.catalog_simple cs
        LEFT JOIN
    bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
WHERE
    cs.erp_reference IN ();