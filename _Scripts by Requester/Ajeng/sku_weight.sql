SELECT 
    sup.name,
    sup.type,
    sel.tax_class,
    sel.short_code,
    cs.sku,
    cc.name,
    cs.status,
    cso.status_source,
    cc.status 'status_config',
    IF(cspu.length * cspu.width * cspu.height IS NOT NULL
            OR cspu.weight IS NOT NULL,
        IFNULL(cspu.length, 0),
        IFNULL(cc.package_length, 0)) 'length',
    IF(cspu.length * cspu.width * cspu.height IS NOT NULL
            OR cspu.weight IS NOT NULL,
        IFNULL(cspu.width, 0),
        IFNULL(cc.package_width, 0)) 'width',
    IF(cspu.length * cspu.width * cspu.height IS NOT NULL
            OR cspu.weight IS NOT NULL,
        IFNULL(cspu.height, 0),
        IFNULL(cc.package_height, 0)) 'height',
    IF(cspu.length * cspu.width * cspu.height IS NOT NULL
            OR cspu.weight IS NOT NULL,
        IFNULL(cspu.weight, 0),
        IFNULL(cc.package_weight, 0)) 'weight'
FROM
    bob_live.catalog_simple cs
        LEFT JOIN
    bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
        LEFT JOIN
    bob_live.catalog_simple_package_unit cspu ON cspu.fk_catalog_simple = cs.id_catalog_simple
        LEFT JOIN
    bob_live.catalog_source cso ON cs.id_catalog_simple = cso.fk_catalog_simple
        LEFT JOIN
    bob_live.supplier sup ON cso.fk_supplier = sup.id_supplier
        LEFT JOIN
    screport.seller sel ON sup.id_supplier = sel.src_id
WHERE
    cs.status = 'active'