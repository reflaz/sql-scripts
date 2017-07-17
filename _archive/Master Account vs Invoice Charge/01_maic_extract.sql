/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Master Account vs Invoice Charge Data Extract
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Insert formatted Tracking Number in >> WHERE tracking_number IN () << part of the script
				  - You can format the parameter in excel using this formula: ="'"&Column&"'," --> change Column accordingly
                  - Copy and paste the formatted parameter
                  - Delete the last comma (,)
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    *
FROM
    (SELECT 
        order_nr 'Nomor Order',
            sc_sales_order_item 'SC Sales Order Item',
            id_supplier 'Seller ID',
            short_code 'SC Seller ID',
            name 'Seller Name',
            type 'Seller Type',
            tax_class 'Tax Class',
            SUM(unit_price) 'Unit Price',
            SUM(shipping_surcharge) 'Shipping Surcharge',
            last_status 'Last Status',
            created_at 'Created Date',
            shipped_date 'Shipped Date',
            tracking_number 'Tracking Number',
            first_tracking_number 'First Tracking Number',
            first_shipment_provider_name 'First Shipment Provider',
            COUNT(bob_id_sales_order_item) 'Qty',
            sku 'SKU',
            SUM(value) 'Charged to Seller',
            origin 'Origin',
            city 'Destination',
            length 'length',
            width 'width',
            height 'height',
            SUM(weight) 'Product Weight',
            SUM(volumetric_weight) 'Volumetric Weight',
            IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)) 'System Weight',
            IF(SUM(weight) > SUM(volumetric_weight), IF(SUM(weight) < 1, 1, IF(MOD(SUM(weight), 1) <= 0.3, FLOOR(SUM(weight)), CEIL(SUM(weight)))), IF(SUM(volumetric_weight) < 1, 1, IF(MOD(SUM(volumetric_weight), 1) <= 0.3, FLOOR(SUM(volumetric_weight)), CEIL(SUM(volumetric_weight))))) 'Formula Weight',
            MIN(weight_remarks) 'Weight Remarks'
    FROM
        (SELECT 
        *,
            ROUND(length * width * height / 6000, 3) 'volumetric_weight',
            IF(length * width * height / 6000 <= 0.17
                AND weight <= 0.17, 'Contains Item Weight <= 0.17', NULL) 'weight_remarks'
    FROM
        (SELECT 
        so.order_nr,
            so.created_at,
            soi.bob_id_sales_order_item,
            scsoi.id_sales_order_item 'sc_sales_order_item',
            soi.unit_price,
            soi.shipping_surcharge,
            soi.sku,
            sois.name 'last_status',
            soish.created_at 'shipped_date',
            pck.id_package,
            _pdh.tracking_number,
            pdh.tracking_number 'first_tracking_number',
            sp.shipment_provider_name 'first_shipment_provider_name',
            sfom.origin 'origin',
            soa.city,
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.length, 0), IFNULL(cc.package_length, 0)) 'length',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.width, 0), IFNULL(cc.package_width, 0)) 'width',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.height, 0), IFNULL(cc.package_height, 0)) 'height',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.weight, 0), IFNULL(cc.package_weight, 0)) 'weight',
            sup.id_supplier,
            sup.name,
            sup.type,
            sel.short_code,
            IFNULL(sel.tax_class, sup.tax_class) 'tax_class',
            SUM(IFNULL(tr.value, 0)) 'value'
    FROM
        (SELECT 
        *
    FROM
        oms_live.oms_package_dispatching_history
    WHERE
        tracking_number IN ('MPDS-349598848-4667' , 'MPDS-392434848-1055', 'MPDS-333864848-7784', 'MPDS-339214848-2565', 'MPDS-347627848-1741', 'MPDS-342826848-7811', 'MPDS-374184848-9853', 'MPDS-339214848-6911', 'MPDS-361836848-3855', 'MPDS-321524848-5442')
    GROUP BY fk_package) _pdh
    LEFT JOIN oms_live.oms_package pck ON _pdh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 5)
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.oms_package_dispatching_history pdh ON pck.id_package = pdh.fk_package
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = pck.id_package
                AND tracking_number IS NOT NULL)
    LEFT JOIN oms_live.oms_shipment_provider sp ON pdh.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cspu.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MIN(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND fk_country_region IS NOT NULL)
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country_region = sfom.fk_country_region
        AND sfom.id_shipping_fee_origin_mapping = (SELECT 
            MAX(id_shipping_fee_origin_mapping)
        FROM
            bob_live.shipping_fee_origin_mapping
        WHERE
            fk_country_region = sa.fk_country_region)
    LEFT JOIN screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN screport.transaction tr ON scsoi.id_sales_order_item = tr.ref
        AND tr.fk_transaction_type = 7
    LEFT JOIN screport.seller sel ON scsoi.fk_seller = sel.id_seller
    GROUP BY soi.bob_id_sales_order_item) result) result
    GROUP BY order_nr , id_supplier , tracking_number) result;