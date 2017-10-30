/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Reimbursement Extract v2.0
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 2.0
Changes made	: - 2.0 Automate date based on extract date

Instructions	: Run the query on any date. The result should be shipping data for last week shipment reimbursement. After the
				  result extracted, please check if the period is correct!
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'

SET @extractstart = '2016-05-01';
SET @extractend = NOW();
SET @vipsellers = 'ID101SU,ID10B6H,ID10378,ID1038E,ID10BLS,ID109ZM,ID101PX,ID10NN6,ID10BC7,ID101MG,ID102X8,ID10519,ID10HTC,ID10DK7,ID10211,ID101F1,ID1028C,ID107Z3,ID10F2A,ID10690,ID101BP,ID102P3,ID100SO,ID108XO,ID102MO,ID101AZ,ID102P5,ID10EJW,ID102NU,ID103KC,ID10SF7,ID10TXL,ID10BHK,ID100S0,ID102GY,ID1056B,ID10AUM,ID10AUL,ID105JA,ID104PT,ID100NA,ID104IT,ID1028A,ID1011D,ID101J3,ID101AL,ID1017N,ID1017M,ID10BUC,ID10WHB,ID102N5,ID10846,ID1011Z,ID100WE,ID1018F,ID103RE,ID102LG,ID108DX,ID1011S,ID101EU,ID104B7,ID107DI,ID101DD,ID101EP,ID10EI3,ID102T9,ID10RN5,ID1042V,ID111GP,ID10BZ8,ID1042T,ID101E5,ID101WX,ID102DC,ID10W2Y,ID100SW,ID10828,ID101ON,ID103VC,ID1015U,ID104WS,ID100PX,ID100S4';

SELECT 
    *, length * width * height / 6000 'volumetric_weight'
FROM
    (SELECT 
        soi.bob_id_sales_order_item 'bob_id_sales_order_item',
            scsoi.id_sales_order_item 'sc_id_sales_order_item',
            so.order_nr 'order_nr',
            so.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            soi.unit_price 'unit_price',
            soi.paid_price 'paid_price',
            soi.shipping_surcharge 'shipping_surcharge',
            soi.sku 'sku',
            pd.id_package_dispatching 'id_package_dispatching',
            pd.tracking_number 'tracking_number',
            sp.shipment_provider_name 'shipment_provider',
            sfom.origin 'origin',
            IF(reg.id_customer_address_region IS NOT NULL, reg.id_customer_address_region, IF(cty.id_customer_address_region IS NOT NULL, cty.id_customer_address_region, dst.id_customer_address_region)) 'id_region',
            IF(reg.id_customer_address_region IS NOT NULL, reg.name, IF(cty.id_customer_address_region IS NOT NULL, cty.name, dst.name)) 'region',
            IF(reg.id_customer_address_region IS NOT NULL, cty.id_customer_address_region, dst.id_customer_address_region) 'id_city',
            IF(reg.id_customer_address_region IS NOT NULL, cty.name, dst.name) 'city',
            IF(reg.id_customer_address_region IS NOT NULL, dst.id_customer_address_region, NULL) 'id_district',
            IF(reg.id_customer_address_region IS NOT NULL, dst.name, NULL) 'district',
            sel.short_code 'sc_seller_id',
            sup.name 'seller_name',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.length, 0), IFNULL(cc.package_length, 0)) 'length',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.width, 0), IFNULL(cc.package_width, 0)) 'width',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.height, 0), IFNULL(cc.package_height, 0)) 'height',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.weight, 0), IFNULL(cc.package_weight, 0)) 'weight'
    FROM
        (SELECT 
        *
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6
    GROUP BY fk_package) ps
    LEFT JOIN oms_live.oms_package pck ON ps.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region cty ON dst.fk_customer_address_region = cty.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region reg ON cty.fk_customer_address_region = reg.id_customer_address_region
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cspu.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.fk_country_region IS NOT NULL
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country_region = sfom.fk_country_region
    LEFT JOIN screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN screport.seller sel ON scsoi.fk_seller = sel.id_seller
    WHERE
        so.created_at >= '2016-05-01'
            AND FIND_IN_SET(sel.short_code, @vipsellers)
            AND sfom.origin IS NOT NULL
    GROUP BY soi.id_sales_order_item) result