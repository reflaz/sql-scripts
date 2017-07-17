/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Master Account Charge and Gain Loss LocalDB Calculate
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/
SET @newfreedst = '4444,4445,4446,4448,4449,4450,4451,4452,4453,4454,4455,4456,4457,4458,4459,4460,4462,4464,4465,4466,4467,4468,4469,4470,4471,4472,4473,4474,4475,4476,4477,4478,4480,4481,4483,4484,4486,4487,4488,4489,4490,4491,4492,4493,4494,4495,4563,4564,4565,4566,4569,4570,4571,4572,4573,4574,4575,4576,4625,4626,4627,4629,4630,4631,4633,4634,4635,4636,4637,4639,4641,4642,4643,4644,4645,4646,4647,4650,4651,4652,4653,4654,4656,4657,4658,4659,4660,4661,4662,4697,4698,4699,4700,4701,4702,4703,4704,4705,4706,4707,4709,4710,4711,4712,4713,4714,4715,4716,4828,4829,4830,4831,4832,4833,4834,4835,4836,4837,4838,4839,4840,4841,4842,4843,4845,4846,4847,4848,4849,4850,4851,4852,4853,4854,4856,4857,4858,4859,4860,4861,4862,4863,4865,4866,4868,4870,4871,4872,4873,4874,4875,4876,4878,4880,4883,4884,4885,4886,4888,4889,4890,4891,4892,4893,4894,4895,4896,4897,4899,4900,4901,4902,4903,4937,4938,4939,4940,4941,4942,4943,4944,4945,4946,4948,4949,4950,4951,4952,4953,4954,4980,4981,4982,4983,4984,4985,4988,4989,4990,4991,4992,4993,4994,4995,4996,4997,4998,4999,5000,5001,5002,5003,5005,5006,5057,5058,5059,5060,5061,5062,5063,5064,5065,5066,5067,5068,5069,5070,5071,5073,5258,5259,5260,5261,5262,5263,5264,5265,5266,5267,5268,5269,5270,5271,5272,5273,5274,7120,7121,7125,17232,17236,17237,17238,17241,17244,5362,5363,5364,5365,5366,5367,5368,5369,5370,5371,5372,5373,5374,5375,5376,5377,5378,5379,5380,5381,5382,5416,5417,5418,5419,5420,5421,5422,5423,5424,5425,5426,5427,5428,5429,5430,5431,5432,5433,5434,5435,5436,5437,5438,5439,5440,5441,5657,5658,5659,5660,5661,5662,5663,5664,5665,5666,5667,5668,5669,5670,5671,5672,5673,5674,5675,5676,5677,5678,5679,5680,5681,5682,5683,5815,5816,5817,5818,5819,5820,5821,5822,5823,5824,5825,5826,5827,5828,5829,5830,5831,5832,5833,5834,5835,5836,5837,5838,5839,5840,5841,5842,5843,5844,5845,5846,5847,5848,5849,5850,5851,5852,5853,5854,5855,5856,5857,5858,5859,5860,5861,5972,5973,5974,5975,5976,5977,5978,5979,5980,5981,5982,5983,5984,5985,5986,5987,5988,5989,5990,5991,5992,5993,5994,5995,5996,5997,5998,5999,6000,6001,6003,6004,6005,6006,6007,6008,6009,6010,6011,6012,6013,6014,6015,6016,6017,6018,6019,6020,6021,6022,6023,6024,6025,6026,6027,6028,6029,6030,6031,6032,6033,6078,6079,6080,6081,6082,6083,6084,6085,6086,6087,6088,6089,6090,6091,6092,6093,6094,6095,6096,6097,6098,6099,6100,6101,6102,6103,6104,6105,6106,6107,6108,6109,6110,6111,6112,6113,6114,6115,6116,6117,6335,6336,6337,7060,7061,7062,7063,7064,17353,17375,17376,17379,17380,17388,17494,17496,17501,17502';

USE macgl;

SELECT 
    order_nr 'Order Number',
    bob_id_sales_order_item 'Sales Order Item',
    sc_sales_order_item 'SC Sales Order Item',
    sku 'SKU',
    qty 'Qty',
    qty_non_bulky 'Qty Non Bulky',
    seller_id 'Seller ID',
    sc_seller_id 'SC Seller ID',
    seller_name 'Seller Name',
    seller_type 'Seller Type',
    tax_class 'Tax Class',
    total_unit_price 'Total Unit Price',
    total_paid_price 'Total Paid Price',
    total_shipping_amount 'Total Shipping Amount',
    total_shipping_surcharge 'Total Shipping Surcharge',
    total_commission_fee 'Total Commission Fee',
    total_coupon_money_value 'Total Coupon Money Value',
    total_cart_rule_discount 'Total Cart Rule Discount',
    coupon_code 'Coupon Code',
    coupon_type 'Coupon Type',
    cart_rule_display_names 'Cart Rule Display Names',
    last_status 'Last Status',
    order_date 'Order Date',
    first_shipped_date 'First Shipped Date',
    last_shipped_date 'Last Shipped Date',
    delivered_date 'Delivered Date',
    first_tracking_number 'First Tracking Number',
    first_shipment_provider 'First Shipment Provider',
    last_tracking_number 'Last Tracking Number',
    last_shipment_provider 'Last Shipment Provider',
    origin 'Origin',
    city 'City',
    id_district 'District ID',
    zone 'Old Zone',
    new_zone 'New Zone',
    total_weight 'Total Weight',
    total_volumetric_weight 'Total Volumetric Weight',
    total_formula_weight 'Formula Weight',
    total_rounded_weight 'Rounded Weight',
    total_rounded_weight_non_bulky 'Rounded Weight Non Bulky',
    campaign 'Campaign',
    insurance_waived 'Insurance Waived',
    charge_rate 'Charge Rate',
    charge_to_seller 'Charge to Seller',
    insurance_to_seller 'Seller Insurance Fee',
    total_charge_to_seller 'Total Charge to Seller',
    total_sc_shipping_fee 'SC Shipping Fee',
    shipment_rate '3PL Rate',
    shipment_discount_rate '3PL Discount Rate',
    charge_from_3pl '3PL Charge',
    shipment_discount '3PL Charge Discount',
    insurance_from_3pl '3PL Insurance Fee',
    total_charge_from_3pl 'Total 3PL Charge',
    total_charge_to_customer 'Total Charge to Customer',
    total_charge_from_3pl + total_charge_to_customer + total_charge_to_seller 'Shipment Gain Loss',
    total_charge_to_seller + total_charge_to_customer 'PC1',
    CASE
        WHEN zone = 'Free Zone' THEN ((7000 * total_rounded_weight_non_bulky) - insurance_from_3pl) * - 1
        WHEN zone = 'Paid Zone' THEN total_charge_from_3pl
        ELSE 0
    END 'PC2',
    CASE
        WHEN zone = 'Free Zone' THEN total_charge_from_3pl + (7000 * total_rounded_weight_non_bulky) - insurance_from_3pl
        ELSE 0
    END 'PC3'
FROM
    (SELECT 
        oms.*,
            total_shipping_fee 'total_charge_to_customer',
            charge_rate * total_rounded_weight_non_bulky 'charge_to_seller',
            ins_seller * (1 + ins_seller_vat_rate) 'insurance_to_seller',
            (charge_rate * total_rounded_weight_non_bulky) + (ins_seller * (1 + ins_seller_vat_rate)) 'total_charge_to_seller',
            shipment_rate * total_rounded_weight * - 1 'charge_from_3pl',
            shipment_rate * total_rounded_weight * shipment_discount_rate 'shipment_discount',
            ins_3pl * (1 + ins_3pl_vat_rate) * - 1 'insurance_from_3pl',
            ((shipment_rate * total_rounded_weight * (1 - shipment_discount_rate) * 1.01) + (ins_3pl * (1 + ins_3pl_vat_rate))) * - 1 'total_charge_from_3pl'
    FROM
        (SELECT 
        oms.*,
            CASE
                WHEN oms.total_formula_weight_non_bulky = 0 THEN 0
                WHEN oms.last_shipment_provider LIKE '%JNE%' THEN IF(oms.total_formula_weight_non_bulky < 1, 1, IF(MOD(oms.total_formula_weight_non_bulky, 1) <= 0.3, FLOOR(oms.total_formula_weight_non_bulky), CEIL(oms.total_formula_weight_non_bulky)))
                ELSE CEIL(oms.total_formula_weight_non_bulky)
            END 'total_rounded_weight_non_bulky',
            CASE
                WHEN oms.total_formula_weight = 0 THEN 0
                WHEN oms.last_shipment_provider LIKE '%JNE%' THEN IF(oms.total_formula_weight < 1, 1, IF(MOD(oms.total_formula_weight, 1) <= 0.3, FLOOR(oms.total_formula_weight), CEIL(oms.total_formula_weight)))
                ELSE CEIL(oms.total_formula_weight)
            END 'total_rounded_weight',
            IF(fz.id_district IS NOT NULL, 'Free Zone', 'Paid Zone') 'zone',
            IF(FIND_IN_SET(oms.id_district, @newfreedst), 'New Free District', NULL) 'new_zone',
            IF(vs.seller_id IS NOT NULL
                AND oms.first_shipped_date >= vs.start_date
                AND oms.first_shipped_date < IFNULL(IF(vs.end_date < vs.start_date, NULL, vs.end_date), NOW()), vs.category, NULL) 'campaign',
            CASE
                WHEN
                    vs.category = 'Rising Star Sellers'
                        AND oms.first_shipped_date >= vs.start_date
                        AND oms.first_shipped_date <= IFNULL(IF(vs.end_date < vs.start_date, NULL, vs.end_date), NOW())
                THEN
                    'Yes'
                WHEN
                    iw.seller_id IS NOT NULL
                        AND (oms.first_shipment_provider LIKE '%LEX%'
                        OR oms.first_shipment_provider LIKE '%FBL%')
                        AND oms.first_shipped_date >= iw.start_date
                        AND oms.first_shipped_date <= IFNULL(IF(iw.end_date < iw.start_date, NULL, iw.end_date), NOW())
                        AND oms.total_unit_price < 1000000
                THEN
                    'Yes'
                WHEN
                    vs.category = 'VIP Sellers'
                        AND oms.first_shipped_date >= vs.start_date
                        AND oms.first_shipped_date <= IFNULL(IF(vs.end_date < vs.start_date, NULL, vs.end_date), NOW())
                        AND oms.total_unit_price <= 500000
                THEN
                    'Yes'
                ELSE 'No'
            END 'insurance_waived',
            
            -- CASE
--                 WHEN
--                     iw.seller_id IS NOT NULL
--                         AND (oms.first_shipment_provider LIKE '%LEX%'
--                         OR oms.first_shipment_provider LIKE '%FBL%')
--                         AND oms.first_shipped_date >= iw.start_date
--                         AND oms.first_shipped_date <= IFNULL(IF(iw.end_date < iw.start_date, NULL, iw.end_date), NOW())
--                         AND oms.total_unit_price <= 1000000
--                 THEN
--                     0
--                 WHEN
--                     vs.category = 'Rising Star Sellers'
--                         AND oms.first_shipped_date >= vs.start_date
--                         AND oms.first_shipped_date < IFNULL(IF(vs.end_date < vs.start_date, NULL, vs.end_date), NOW())
--                 THEN
--                     0
--                 WHEN
--                     oms.last_shipment_provider LIKE '%LEX%'
--                 THEN
--                     CASE
--                         WHEN oms.total_unit_price <= 1000000 THEN 2500
--                         ELSE oms.total_unit_price * 0.0025
--                     END
--                 WHEN oms.last_shipment_provider LIKE '%NCS%' THEN (oms.total_paid_price + oms.total_shipping_surcharge) * 0.0025
--                 ELSE CASE
--                     WHEN (oms.total_paid_price + oms.total_shipping_surcharge) <= 1000000 THEN 2500
--                     ELSE (oms.total_paid_price + oms.total_shipping_surcharge) * 0.0025
--                 END
--             END 
            
            0 'ins_seller',
            CASE
                WHEN oms.last_shipment_provider LIKE '%LEX%' THEN 0.1
                WHEN oms.last_shipment_provider LIKE '%REPEX%' THEN 0.1
                WHEN oms.last_shipment_provider LIKE '%NCS%' THEN 0.01
                ELSE 0
            END 'ins_seller_vat_rate',
            
            -- CASE
--                 WHEN
--                     oms.last_shipment_provider LIKE '%LEX%'
--                 THEN
--                     CASE
--                         WHEN
--                             oms.total_unit_price <= 1000000
--                         THEN
--                             CASE
--                                 WHEN
--                                     oms.first_shipped_date >= iw.start_date
--                                         AND oms.first_shipped_date <= IFNULL(IF(iw.end_date < iw.start_date, NULL, iw.end_date), NOW())
--                                 THEN
--                                     0
--                                 ELSE 2500
--                             END
--                         ELSE oms.total_unit_price * 0.0025
--                     END
--                 WHEN oms.last_shipment_provider LIKE '%NCS%' THEN (oms.total_paid_price + oms.total_shipping_surcharge) * 0.0025
--                 ELSE CASE
--                     WHEN (oms.total_paid_price + oms.total_shipping_surcharge) <= 1000000 THEN 2500
--                     ELSE (oms.total_paid_price + oms.total_shipping_surcharge) * 0.0025
--                 END
--             END
            
            0'ins_3pl',
            CASE
                WHEN oms.last_shipment_provider LIKE '%LEX%' THEN 0.1
                WHEN oms.last_shipment_provider LIKE '%REPEX%' THEN 0.1
                WHEN oms.last_shipment_provider LIKE '%NCS%' THEN 0.01
                ELSE 0
            END 'ins_3pl_vat_rate',
            CASE
                WHEN
                    vs.seller_id IS NOT NULL
                        AND oms.first_shipped_date >= vs.start_date
                        AND oms.first_shipped_date < IFNULL(IF(vs.end_date < vs.start_date, NULL, vs.end_date), NOW())
                THEN
                    1000
                WHEN oms.first_shipment_provider LIKE '%LEX%' THEN 6464
                ELSE 7000
            END 'charge_rate',
            IFNULL(jr.rate, 0) 'shipment_rate',
            CASE
                WHEN oms.last_shipment_provider LIKE '%LEX%' THEN 0.2
                WHEN oms.last_shipment_provider LIKE '%JNE%' THEN 0.3
                ELSE 0
            END 'shipment_discount_rate'
    FROM
        (SELECT 
        *,
            COUNT(bob_id_sales_order_item) 'qty',
            SUM(IF(item_rounded_weight > 7, 0, 1)) 'qty_non_bulky',
            SUM(IFNULL(unit_price, 0)) 'total_unit_price',
            SUM(IFNULL(paid_price, 0)) 'total_paid_price',
            SUM(IFNULL(shipping_amount, 0)) 'total_shipping_amount',
            SUM(IFNULL(shipping_surcharge, 0)) 'total_shipping_surcharge',
            SUM(IFNULL(shipping_amount, 0)) + SUM(IFNULL(shipping_surcharge, 0)) 'total_shipping_fee',
            SUM(IFNULL(commission_fee, 0)) 'total_commission_fee',
            SUM(IFNULL(coupon_money_value, 0)) 'total_coupon_money_value',
            SUM(IFNULL(cart_rule_discount, 0)) 'total_cart_rule_discount',
            SUM(IFNULL(sc_shipping_fee, 0)) 'total_sc_shipping_fee',
            SUM(IFNULL(weight, 0)) 'total_weight',
            SUM(IFNULL(volumetric_weight, 0)) 'total_volumetric_weight',
            IF(SUM(IF(item_rounded_weight > 7, 0, IFNULL(weight, 0))) > SUM(IF(item_rounded_weight > 7, 0, IFNULL(volumetric_weight, 0))), SUM(IF(item_rounded_weight > 7, 0, IFNULL(weight, 0))), SUM(IF(item_rounded_weight > 7, 0, IFNULL(volumetric_weight, 0)))) 'total_formula_weight_non_bulky',
            IF(SUM(IFNULL(weight, 0)) > SUM(IFNULL(volumetric_weight, 0)), SUM(IFNULL(weight, 0)), SUM(IFNULL(volumetric_weight, 0))) 'total_formula_weight'
    FROM
        oms
    GROUP BY bob_id_sales_order_item) oms
    LEFT JOIN free_zone fz ON oms.id_district = fz.id_district
    LEFT JOIN insurance_waive iw ON oms.sc_seller_id = iw.seller_id
    LEFT JOIN jne_rate jr ON IF(oms.origin = '', 'DKI Jakarta', oms.origin) = jr.origin
        AND oms.id_district = jr.id_district
    LEFT JOIN vip_seller vs ON oms.sc_seller_id = vs.seller_id) oms) result;