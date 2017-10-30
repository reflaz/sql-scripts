SET @kab_banyumas = '5683,5682,5681,5680,5679,5678,5677,5676,5675,5674,5673,5672,5671,17501,5670,5669,5668,17502,5667,5666,5665,5664,5663,5662,5661,5660,5659,5658,5657';
SET @kab_cirebon = '6117,6116,6115,6114,6113,17379,17380,6112,6111,6110,6109,6108,6107,6106,6105,6104,6103,6102,6101,6100,6099,6098,6097,6096,6095,6094,6093,6092,6091,6090,6089,6088,6087,6086,6085,6084,6083,6082,6081,6080,6079,6078';
SET @kab_indramayu = '6033,6032,6031,6030,6029,6028,6027,6026,6025,6024,6023,6022,6021,17376,6020,6019,6018,6017,6016,6015,6014,6013,6012,6011,6010,6009,6008,6007,6006,6005,6004,6003';
SET @kab_karawang = '6001,6000,5999,5998,5997,5996,5995,5994,5993,5992,17375,5991,5990,5989,5988,5987,5986,5985,5984,5983,5982,5981,5980,5979,5978,5977,5976,5975,5974,5973,5972';
SET @kab_klaten = '5441,5440,5439,5438,5437,5436,5435,5434,5433,5432,5431,5430,5429,5428,17496,5427,5426,5425,5424,5423,5422,5421,5420,5419,5418,5417,5416';
SET @kab_pati = '5382,5381,5380,5379,5378,5377,5376,5375,5374,5373,5372,5371,5370,5369,5368,5367,5366,17494,5365,5364,5363,5362';
SET @kab_sukabumi = '5861,5860,5859,5858,5857,5856,5855,5854,5853,5852,5851,5850,5849,5848,5847,5846,5845,5844,5843,5842,5841,5840,5839,5838,5837,5836,5835,5834,5833,5832,5831,5830,5829,5828,5827,5826,5825,5824,5823,5822,5821,5820,5819,5818,5817,5816,5815';
SET @kota_cimahi = '17388,6337,6336,6335';
SET @kota_pangkal_pinang = '7064,7063,7062,17353,7061,7060';

SET @all_dist = '5683,5682,5681,5680,5679,5678,5677,5676,5675,5674,5673,5672,5671,17501,5670,5669,5668,17502,5667,5666,5665,5664,5663,5662,5661,5660,5659,5658,5657,6117,6116,6115,6114,6113,17379,17380,6112,6111,6110,6109,6108,6107,6106,6105,6104,6103,6102,6101,6100,6099,6098,6097,6096,6095,6094,6093,6092,6091,6090,6089,6088,6087,6086,6085,6084,6083,6082,6081,6080,6079,6078,6033,6032,6031,6030,6029,6028,6027,6026,6025,6024,6023,6022,6021,17376,6020,6019,6018,6017,6016,6015,6014,6013,6012,6011,6010,6009,6008,6007,6006,6005,6004,6003,6001,6000,5999,5998,5997,5996,5995,5994,5993,5992,17375,5991,5990,5989,5988,5987,5986,5985,5984,5983,5982,5981,5980,5979,5978,5977,5976,5975,5974,5973,5972,5441,5440,5439,5438,5437,5436,5435,5434,5433,5432,5431,5430,5429,5428,17496,5427,5426,5425,5424,5423,5422,5421,5420,5419,5418,5417,5416,5382,5381,5380,5379,5378,5377,5376,5375,5374,5373,5372,5371,5370,5369,5368,5367,5366,17494,5365,5364,5363,5362,5861,5860,5859,5858,5857,5856,5855,5854,5853,5852,5851,5850,5849,5848,5847,5846,5845,5844,5843,5842,5841,5840,5839,5838,5837,5836,5835,5834,5833,5832,5831,5830,5829,5828,5827,5826,5825,5824,5823,5822,5821,5820,5819,5818,5817,5816,5815,17388,6337,6336,6335,7064,7063,7062,17353,7061,7060';


SELECT 
    threshold_remarks,
    COUNT(bob_id_sales_order_item) 'count_soi',
    SUM(unit_price) 'total_unit_price',
    SUM(paid_price) 'total_paid_price',
    SUM(shipping_charge) 'total_shipping_charge'
FROM
    (SELECT 
        city,
            bob_id_sales_order_item,
            unit_price,
            paid_price,
            shipping_charge,
            CASE
                WHEN FIND_IN_SET(fk_customer_address_region, @kab_banyumas) AND formula_weight >= 2 THEN 'Equal or higher than threshold'
				WHEN FIND_IN_SET(fk_customer_address_region, @kab_cirebon) AND formula_weight >= 2 THEN 'Equal or higher than threshold'
				WHEN FIND_IN_SET(fk_customer_address_region, @kab_indramayu) AND formula_weight >= 2 THEN 'Equal or higher than threshold'
				WHEN FIND_IN_SET(fk_customer_address_region, @kab_karawang) AND formula_weight >= 2 THEN 'Equal or higher than threshold'
				WHEN FIND_IN_SET(fk_customer_address_region, @kab_klaten) AND formula_weight >= 2 THEN 'Equal or higher than threshold'
				WHEN FIND_IN_SET(fk_customer_address_region, @kab_pati) AND formula_weight >= 1 THEN 'Equal or higher than threshold'
				WHEN FIND_IN_SET(fk_customer_address_region, @kab_sukabumi) AND formula_weight >= 2 THEN 'Equal or higher than threshold'
				WHEN FIND_IN_SET(fk_customer_address_region, @kota_cimahi) AND formula_weight >= 2 THEN 'Equal or higher than threshold'
				WHEN FIND_IN_SET(fk_customer_address_region, @kota_pangkal_pinang) AND formula_weight >= 1 THEN 'Equal or higher than threshold'
                ELSE 'Below threshold'
            END 'threshold_remarks'
    FROM
        (SELECT 
        so.id_sales_order,
            city,
            soi.bob_id_sales_order_item,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount + soi.shipping_surcharge 'shipping_charge',
            so.fk_customer_address_region,
            GREATEST(IFNULL(CASE
                WHEN
                    cspu.weight > 0
                        OR (cspu.length * cspu.width * cspu.height) > 0
                THEN
                    cspu.weight
                ELSE cc.package_weight
            END, 0), IFNULL(CASE
                WHEN
                    cspu.weight > 0
                        OR (cspu.length * cspu.width * cspu.height) > 0
                THEN
                    (cspu.length * cspu.width * cspu.height) / 6000
                ELSE cc.package_length * cc.package_width * cc.package_height / 6000
            END, 0)) 'formula_weight',
            CASE
                WHEN soish.created_at IS NULL THEN 0
                WHEN sel.tax_class = 1 THEN 0
                WHEN soi.delivery_type = 'digital' THEN 0
                WHEN sp.shipment_provider_name = 'Digital Delivery' THEN 0
                ELSE 1
            END 'pass'
    FROM
        (SELECT 
        so.id_sales_order,
            city.name 'city',
            soa.fk_customer_address_region
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dist ON soa.fk_customer_address_region = dist.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region city ON dist.fk_customer_address_region = city.id_customer_address_region
    WHERE
        so.created_at >= '2016-07-01'
            AND so.created_at < '2016-08-01'
            AND FIND_IN_SET(soa.fk_customer_address_region, @all_dist)) so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cs.id_catalog_simple = cspu.fk_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller sel ON sup.id_supplier = sel.src_id
    GROUP BY bob_id_sales_order_item
    HAVING pass = 1) result) result
GROUP BY threshold_remarks