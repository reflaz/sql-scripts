/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss Parameter Setup

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/
USE scgl;

SET @extractstart = '2016-11-01';
SET @extractend = '2016-11-08';
SET @subsidized_weight = 2;
SET @new_paid = '183,4442,4444,4445,4446,4448,4449,4450,4451,4452,4453,4454,4455,4456,4457,4458,4459,4460,4462,4463,4464,4465,4466,4467,4468,4469,4470,17232,4471,4472,4473,4474,4475,4476,4477,4478,4480,4481,4483,4484,4485,4487,4488,4489,4490,4491,4492,4493,4494,4495,4563,4564,4565,4566,4567,4569,4570,4571,4572,4573,4574,4575,4576,17235,4590,4598,4625,4626,4627,4629,4630,4631,4633,4634,4635,4636,4637,4638,17237,4639,4641,4642,4643,17236,4644,4645,4646,4647,4648,4697,4698,4699,4700,4701,4702,4703,4704,4705,4706,4707,4708,4709,4710,4711,4712,4714,4715,4716,4796,4799,17241,4810,4811,4883,4884,4885,4886,4888,4889,4890,4891,4892,4893,4894,4895,4896,4897,4898,4899,4900,4901,4902,4903,4980,4981,4982,4983,4984,4985,4988,4989,4990,4991,4992,4993,4994,4995,4996,4997,4998,4999,5000,5001,5002,5003,5004,5005,5006,5057,5058,5059,5060,5061,5062,5063,5064,5065,5066,5067,5068,5069,5070,5071,5072,17244,5073,183,4442,4444,4445,4446,4448,4449,4450,4451,4452,4453,4454,4455,4456,4457,4458,4459,4460,4462,4463,4464,4465,4466,4467,4468,4469,4470,17232,4471,4472,4473,4474,4475,4476,4477,4478,4480,4481,4483,4484,4485,4487,4488,4489,4490,4491,4492,4493,4494,4495,4563,4564,4565,4566,4567,4569,4570,4571,4572,4573,4574,4575,4576,17235,4590,4598,4625,4626,4627,4629,4630,4631,4633,4634,4635,4636,4637,4638,17237,4639,4641,4642,4643,17236,4644,4645,4646,4647,4648,4697,4698,4699,4700,4701,4702,4703,4704,4705,4706,4707,4708,4709,4710,4711,4712,4714,4715,4716,4796,4799,17241,4810,4811,4883,4884,4885,4886,4888,4889,4890,4891,4892,4893,4894,4895,4896,4897,4898,4899,4900,4901,4902,4903,4980,4981,4982,4983,4984,4985,4988,4989,4990,4991,4992,4993,4994,4995,4996,4997,4998,4999,5000,5001,5002,5003,5004,5005,5006,5057,5058,5059,5060,5061,5062,5063,5064,5065,5066,5067,5068,5069,5070,5071,5072,17244,5073,183,4442,4444,4445,4446,4448,4449,4450,4451,4452,4453,4454,4455,4456,4457,4458,4459,4460,4462,4463,4464,4465,4466,4467,4468,4469,4470,17232,4471,4472,4473,4474,4475,4476,4477,4478,4480,4481,4483,4484,4485,4487,4488,4489,4490,4491,4492,4493,4494,4495,4563,4564,4565,4566,4567,4569,4570,4571,4572,4573,4574,4575,4576,17235,4590,4598,4625,4626,4627,4629,4630,4631,4633,4634,4635,4636,4637,4638,17237,4639,4641,4642,4643,17236,4644,4645,4646,4647,4648,4697,4698,4699,4700,4701,4702,4703,4704,4705,4706,4707,4708,4709,4710,4711,4712,4714,4715,4716,4796,4799,17241,4810,4811,4883,4884,4885,4886,4888,4889,4890,4891,4892,4893,4894,4895,4896,4897,4898,4899,4900,4901,4902,4903,4980,4981,4982,4983,4984,4985,4988,4989,4990,4991,4992,4993,4994,4995,4996,4997,4998,4999,5000,5001,5002,5003,5004,5005,5006,5057,5058,5059,5060,5061,5062,5063,5064,5065,5066,5067,5068,5069,5070,5071,5072,17244,5073,1656,1657,1658,1659,1660,1661,1668,1662,17480,1663,1664,1665,1666,1667,1669,1729,1730,1731,17483,1732,1733,1734,1735,1736,1737,1738,1739,1740,1741,1742,1743,1744,1745,1746,3688,3689,3690,3691,3692,3693,3694,3695,3696,3697,3698,3699,3700,3701,3702,3703,3704,5107,5108,17246,17245,5109,5111,17247,5112,5113,5115,5116,5124,5125,17249,5126,5128,5129,5130,4718,4719,4720,4721,4722,4723,4724,4725,17240,4726,4727,4728,4729,4730,4731,4732,4733,4734,4735,4905,4906,4907,4908,4909,4910,4911,4912,4913,4914,4915,4916,4917,4918,4919,4920,4921,4922,4923,4924,4925,4926,4927,4928,17242,4929,4930,4931,4932,4933,4934,4935,5362,5363,5364,5365,17494,5366,5367,5368,5369,5370,5371,5372,5373,5374,5375,5376,5377,5378,5379,5380,5381,5382,5657,5658,5659,5660,5661,5662,5663,5664,5665,5666,5667,17502,5668,5669,5670,17501,5671,5672,5673,5674,5675,5676,5677,5678,5679,5680,5681,5682,5683,5748,5749,5750,5751,5752,5753,5754,5755,5756,5757,5758,5759,5760,5761,5762,5763,5764,5765,5766,5767,5768,5769,5770,5771,5772,5773,5774,5775,5776,5777,5778,5779,5780,5781,5782,5783,5784,5785,5786,6003,6004,6005,6006,6007,6008,6009,6010,6011,6012,6013,6014,6015,6016,6017,6018,6019,6020,17376,6021,6022,6023,6024,6025,6026,6027,6028,6029,6030,6031,6032,6033,6686,6687,6688,6689,6690,6691,6692,6693,6694,6695,6696,6697,6698,6699,6700,6701,6702,6703,7060,7061,17353,7062,7063,7064,7097,7098,7099,7100,7101,7102,7103,1656,1657,1658,1659,1660,1661,1668,1662,17480,1663,1664,1665,1666,1667,1669,1729,1730,1731,17483,1732,1733,1734,1735,1736,1737,1738,1739,1740,1741,1742,1743,1744,1745,1746,3688,3689,3690,3691,3692,3693,3694,3695,3696,3697,3698,3699,3700,3701,3702,3703,3704,5107,5108,17246,17245,5109,5111,17247,5112,5113,5115,5116,5124,5125,17249,5126,5128,5129,5130,4718,4719,4720,4721,4722,4723,4724,4725,17240,4726,4727,4728,4729,4730,4731,4732,4733,4734,4735,4905,4906,4907,4908,4909,4910,4911,4912,4913,4914,4915,4916,4917,4918,4919,4920,4921,4922,4923,4924,4925,4926,4927,4928,17242,4929,4930,4931,4932,4933,4934,4935,5362,5363,5364,5365,17494,5366,5367,5368,5369,5370,5371,5372,5373,5374,5375,5376,5377,5378,5379,5380,5381,5382,5657,5658,5659,5660,5661,5662,5663,5664,5665,5666,5667,17502,5668,5669,5670,17501,5671,5672,5673,5674,5675,5676,5677,5678,5679,5680,5681,5682,5683,5748,5749,5750,5751,5752,5753,5754,5755,5756,5757,5758,5759,5760,5761,5762,5763,5764,5765,5766,5767,5768,5769,5770,5771,5772,5773,5774,5775,5776,5777,5778,5779,5780,5781,5782,5783,5784,5785,5786,6003,6004,6005,6006,6007,6008,6009,6010,6011,6012,6013,6014,6015,6016,6017,6018,6019,6020,17376,6021,6022,6023,6024,6025,6026,6027,6028,6029,6030,6031,6032,6033,6686,6687,6688,6689,6690,6691,6692,6693,6694,6695,6696,6697,6698,6699,6700,6701,6702,6703,7060,7061,17353,7062,7063,7064,7097,7098,7099,7100,7101,7102,7103,1656,1657,1658,1659,1660,1661,1668,1662,17480,1663,1664,1665,1666,1667,1669,1729,1730,1731,17483,1732,1733,1734,1735,1736,1737,1738,1739,1740,1741,1742,1743,1744,1745,1746,3688,3689,3690,3691,3692,3693,3694,3695,3696,3697,3698,3699,3700,3701,3702,3703,3704,5107,5108,17246,17245,5109,5111,17247,5112,5113,5115,5116,5124,5125,17249,5126,5128,5129,5130,4718,4719,4720,4721,4722,4723,4724,4725,17240,4726,4727,4728,4729,4730,4731,4732,4733,4734,4735,4905,4906,4907,4908,4909,4910,4911,4912,4913,4914,4915,4916,4917,4918,4919,4920,4921,4922,4923,4924,4925,4926,4927,4928,17242,4929,4930,4931,4932,4933,4934,4935,5362,5363,5364,5365,17494,5366,5367,5368,5369,5370,5371,5372,5373,5374,5375,5376,5377,5378,5379,5380,5381,5382,5657,5658,5659,5660,5661,5662,5663,5664,5665,5666,5667,17502,5668,5669,5670,17501,5671,5672,5673,5674,5675,5676,5677,5678,5679,5680,5681,5682,5683,5748,5749,5750,5751,5752,5753,5754,5755,5756,5757,5758,5759,5760,5761,5762,5763,5764,5765,5766,5767,5768,5769,5770,5771,5772,5773,5774,5775,5776,5777,5778,5779,5780,5781,5782,5783,5784,5785,5786,6003,6004,6005,6006,6007,6008,6009,6010,6011,6012,6013,6014,6015,6016,6017,6018,6019,6020,17376,6021,6022,6023,6024,6025,6026,6027,6028,6029,6030,6031,6032,6033,6686,6687,6688,6689,6690,6691,6692,6693,6694,6695,6696,6697,6698,6699,6700,6701,6702,6703,7060,7061,17353,7062,7063,7064,7097,7098,7099,7100,7101,7102,7103';
SET @half_subs = '6721,6720,6719,6718,6717,6716,6715,6714,6713,6712,6711,6710,6709,6708,6707,6706,6705,6684,6683,6682,6681,6680,6679,6678,6677,6676,6675,6674,6673,6117,6116,6115,6114,6113,17379,17380,6112,6111,6110,6109,6108,6107,6106,6105,6104,6103,6102,6101,6100,6099,6098,6097,6096,6095,6094,6093,6092,6091,6090,6089,6088,6087,6086,6085,6084,6083,6082,6081,6080,6079,6078,6001,6000,5999,5998,5997,5996,5995,5994,5993,5992,17375,5991,5990,5989,5988,5987,5986,5985,5984,5983,5982,5981,5980,5979,5978,5977,5976,5975,5974,5973,5972,5861,5860,5859,5858,5857,5856,5855,5854,5853,5852,5851,5850,5849,5848,5847,5846,5845,5844,5843,5842,5841,5840,5839,5838,5837,5836,5835,5834,5833,5832,5831,5830,5829,5828,5827,5826,5825,5824,5823,5822,5821,5820,5819,5818,5817,5816,5815,17386,17387,6333,6332,6331,6330,6329,6320,6319,6318,6317,6316,6315,6314,6312,6311,6310,6309,6308,6307,6306,6305,6304,17383,6303,2072,2071,2070,17229,2069,2068,2067,2066,2065,2064,2063,2062,2061,981,980,979,978,977,976,975,17347,974,973,972,971,981,980,979,978,977,976,975,17347,974,973,972,971,981,980,790,789,788,787,786,785,784,783,782,781,17370,780,779,778,777,776,775,6721,6720,6719,6718,6717,6716,6715,6714,6713,6712,6711,6710,6709,6708,6707,6706,6705,6684,6683,6682,6681,6680,6679,6678,6677,6676,6675,6674,6673,6117,6116,6115,6114,6113,17379,17380,6112,6111,6110,6109,6108,6107,6106,6105,6104,6103,6102,6101,6100,6099,6098,6097,6096,6095,6094,6093,6092,6091,6090,6089,6088,6087,6086,6085,6084,6083,6082,6081,6080,6079,6078,6001,6000,5999,5998,5997,5996,5995,5994,5993,5992,17375,5991,5990,5989,5988,5987,5986,5985,5984,5983,5982,5981,5980,5979,5978,5977,5976,5975,5974,5973,5972,5861,5860,5859,5858,5857,5856,5855,5854,5853,5852,5851,5850,5849,5848,5847,5846,5845,5844,5843,5842,5841,5840,5839,5838,5837,5836,5835,5834,5833,5832,5831,5830,5829,5828,5827,5826,5825,5824,5823,5822,5821,5820,5819,5818,5817,5816,5815,17386,17387,6333,6332,6331,6330,6329,6320,6319,6318,6317,6316,6315,6314,6312,6311,6310,6309,6308,6307,6306,6305,6304,17383,6303,2072,2071,2070,17229,2069,2068,2067,2066,2065,2064,2063,2062,2061,979,978,977,976,975,17347,974,973,972,971,1845,1844,1843,1842,1841,1840,1839,1838,1837,1836,1835,1834,1833,1832,1845,1844,790,789,788,787,786,785,784,783,782,781,17370,780,779,778,777,776,775,6721,6720,6719,6718,6717,6716,6715,6714,6713,6712,6711,6710,6709,6708,6707,6706,6705,6684,6683,6682,6681,6680,6679,6678,6677,6676,6675,6674,6673,6117,6116,6115,6114,6113,17379,17380,6112,6111,6110,6109,6108,6107,6106,6105,6104,6103,6102,6101,6100,6099,6098,6097,6096,6095,6094,6093,6092,6091,6090,6089,6088,6087,6086,6085,6084,6083,6082,6081,6080,6079,6078,6001,6000,5999,5998,5997,5996,5995,5994,5993,5992,17375,5991,5990,5989,5988,5987,5986,5985,5984,5983,5982,5981,5980,5979,5978,5977,5976,5975,5974,5973,5972,5861,5860,5859,5858,5857,5856,5855,5854,5853,5852,5851,5850,5849,5848,5847,5846,5845,5844,5843,5842,5841,5840,5839,5838,5837,5836,5835,5834,5833,5832,5831,5830,5829,5828,5827,5826,5825,5824,5823,5822,5821,5820,5819,5818,5817,5816,5815,17386,17387,6333,6332,6331,6330,6329,6320,6319,6318,6317,6316,6315,6314,6312,6311,6310,6309,6308,6307,6306,6305,6304,17383,6303,2072,2071,2070,17229,2069,2068,2067,2066,2065,2064,2063,2062,2061,1843,1842,1841,1840,1839,1838,1837,1836,1835,1834,1833,1832,1845,1844,1843,1842,1841,1840,1839,1838,1837,1836,1835,1834,1833,1832,790,789,788,787,786,785,784,783,782,781,17370,780,779,778,777,776,775';
SET @covered_by_lex = '7119,6270,6254,6704,6230,6189,5603,4936,5490,5415,6672,4543,6654,5234,5221,5155,3950,3729,6363,6345,6338,6334,7126,6321,6645,6636,6625,6614,6607,1831,5117,544,970,774,2060,5716,5074,5710,6988,6980,6722';
SET @mixed_city = '175,4441,4461,4482,4562,4577,4624,4696,4789,4805,4882,4979,5055';

SELECT 
    id_region,
    region,
    id_city,
    city_name,
    city,
    weight_bucket,
    shipment_scheme,
    campaign,
    zone_type,
    IF(FIND_IN_SET(id_city, @mixed_city),
        'Mixed City',
        city_flag) 'new_zone_type',
    IF(FIND_IN_SET(id_city, @covered_by_lex),
        'Covered',
        'Not Covered') 'covered_by_lex',
    MAX(shipment_cost_discount) 'lel_discount',
    COUNT(DISTINCT order_nr) 'count_so',
    COUNT(bob_id_sales_order_item) 'count_soi',
    COUNT(DISTINCT id_package_dispatching) 'count_package',
    SUM(unit_price) 'total_unit_price',
    SUM(paid_price) 'total_paid_price',
    SUM(shipping_amount) 'total_shipping_amount',
    SUM(shipping_surcharge) 'total_shipping_surcharge',
    SUM(shipping_fee_to_customer) 'total_shipping_fee_to_cust',
    SUM(marketplace_commission_fee) 'total_marketplace_commission_fee',
    SUM(coupon_money_value) 'total_coupon_money_value',
    SUM(cart_rule_discount) 'total_cart_rule_discount',
    SUM(shipment_fee_mp_seller) 'total_shipment_fee_mp_seller',
    SUM(total_insurance_fee) 'total_insurance_fee',
    SUM(total_shipment_fee_mp_seller) 'total_shipment_fee_mp_seller',
    SUM(total_shipment_cost) 'total_shipment_cost',
    SUM(total_pickup_cost) 'total_pickup_cost',
    SUM(total_insurance_charge) 'total_insurance_charge',
    SUM(total_delivery_cost) 'total_delivery_cost',
    SUM(total_delivery_cost) / COUNT(DISTINCT id_package_dispatching) 'total_delivery_cost_per_package',
    SUM(total_delivery_cost) / SUM(paid_price) 'total_delivery_cost_to_paid_price',
    SUM(gain_loss) 'total_gain_loss',
    SUM(to_be_shipment_fee_mp_seller) 'to_be_shipment_fee_mp_seller',
    SUM(to_be_shipping_fee_to_cust) 'to_be_shipping_fee_to_cust',
    SUM(to_be_delivery_cost) 'to_be_delivery_cost',
    SUM(to_be_gain_loss) 'to_be_gain_loss',
    SUM(impact_to_ebitda) 'impact_to_ebitda'
FROM
    (SELECT 
        *,
            to_be_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - to_be_delivery_cost 'to_be_gain_loss',
            to_be_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - to_be_delivery_cost - gain_loss 'impact_to_ebitda'
    FROM
        (SELECT 
        ac.*,
            ac.total_shipment_fee_mp_seller + ac.shipping_fee_to_customer - ac.total_delivery_cost 'gain_loss',
            ac.total_shipment_fee_mp_seller + ac.shipping_fee_to_customer - ac.total_shipment_cost - ac.total_insurance_charge 'pc1',
            - ac.total_pickup_cost 'pc2',
            0 'pc3',
            CASE
                WHEN formula_weight <= 0.17 THEN '<= 0.17'
                WHEN rounded_weight < 3 THEN '1-2 Kg'
                WHEN rounded_weight < 4 THEN '3 Kg'
                WHEN rounded_weight < 5 THEN '4 Kg'
                WHEN rounded_weight < 6 THEN '5 Kg'
                WHEN rounded_weight < 7 THEN '6 Kg'
                WHEN rounded_weight < 8 THEN '7 Kg'
                ELSE '8 Kg and above'
            END 'weight_bucket',
            IF(ac.fk_campaign IN (2 , 3), 2500, ac.shipment_fee_mp_seller_rate) 'to_be_shipment_rate_mp_seller',
            IF(ac.rounded_weight > 2, 2, IFNULL(rounded_weight, 0)) 'to_be_charged_weight_to_mp_seller',
            ((IF(ac.fk_campaign IN (2 , 3), 2500, ac.shipment_fee_mp_seller_rate) * IF(ac.rounded_weight > 2, 2, IFNULL(rounded_weight, 0))) + total_insurance_fee) 'to_be_shipment_fee_mp_seller',
            CASE
                WHEN FIND_IN_SET(ac.id_district, @half_subs) THEN 'New paid - half price'
                WHEN FIND_IN_SET(ac.id_district, @new_paid) THEN 'New paid - full price'
                WHEN ac.fk_zone_type = 0 THEN 'Old paid district'
                ELSE 'Free district'
            END 'city_flag',
            IFNULL(rc.id_region, 0) 'id_region',
            IFNULL(rc.region, 'NA') 'region',
            IFNULL(rc.id_city, 0) 'id_city',
            IFNULL(rc.city, 'NA') 'city_name',
            IFNULL(rc.shipment_cost_rate, 0) 'jne_published_rate',
            CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(new_rc.shipment_cost_rate, 0)
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END 'new_rate',
            CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END 'to_be_charged_weight_to_cust',
            (CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(new_rc.shipment_cost_rate, 0)
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END * CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END) + CASE
                WHEN FIND_IN_SET(ac.id_district, @new_paid) THEN 0
                WHEN FIND_IN_SET(ac.id_district, @half_subs) THEN 0
                WHEN ac.fk_zone_type = 0 THEN 0
                ELSE IFNULL(ac.shipping_amount, 0)
            END 'to_be_shipping_fee_to_cust',
            IFNULL(CASE
                WHEN fk_shipment_scheme = 1 THEN total_delivery_cost
                ELSE (lel.shipment_cost_rate * (1 - lel.shipment_cost_discount) * (1 + ac.shipment_cost_vat) * ac.rounded_weight) + ac.total_pickup_cost + ac.total_insurance_charge
            END, 0) 'to_be_delivery_cost'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN rate_card rc ON ac.id_district = rc.id_district
        AND ac.origin = rc.origin
        AND rc.fk_rate_card_scheme = 1
    LEFT JOIN rate_card lel ON ac.id_district = lel.id_district
        AND ac.origin = lel.origin
        AND lel.fk_rate_card_scheme = 3
    LEFT JOIN rate_card new_rc ON ac.id_district = new_rc.id_district
        AND ac.origin = new_rc.origin
        AND new_rc.fk_rate_card_scheme = 4
    WHERE
        ac.fk_shipment_scheme IN (2 , 4)) master_account UNION ALL SELECT 
        *,
            to_be_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - to_be_delivery_cost 'to_be_gain_loss',
            to_be_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - to_be_delivery_cost - gain_loss 'impact_to_ebitda'
    FROM
        (SELECT 
        ac.*,
            ac.total_shipment_fee_mp_seller + ac.shipping_fee_to_customer - ac.total_delivery_cost 'gain_loss',
            CASE
                WHEN ac.seller_type = 'supplier' THEN ac.shipping_fee_to_customer
                WHEN ac.fk_zone_type <> 0 THEN ac.shipping_amount
                ELSE 0
            END 'pc1',
            CASE
                WHEN ac.seller_type = 'supplier' THEN ac.total_delivery_cost * - 1
                ELSE 0
            END 'pc2',
            CASE
                WHEN
                    ac.seller_type = 'supplier'
                        OR ac.fk_zone_type = 0
                THEN
                    0
                ELSE ac.total_shipment_fee_mp_seller + ac.shipping_fee_to_customer - ac.total_delivery_cost
            END 'pc3',
            CASE
                WHEN formula_weight <= 0.17 THEN '<= 0.17'
                WHEN rounded_weight < 3 THEN '1-2 Kg'
                WHEN rounded_weight < 4 THEN '3 Kg'
                WHEN rounded_weight < 5 THEN '4 Kg'
                WHEN rounded_weight < 6 THEN '5 Kg'
                WHEN rounded_weight < 7 THEN '6 Kg'
                WHEN rounded_weight < 8 THEN '7 Kg'
                ELSE '8 Kg and above'
            END 'weight_bucket',
            ac.shipment_fee_mp_seller_rate 'to_be_shipment_rate_mp_seller',
            IF(ac.rounded_weight > 2, 2, IFNULL(rounded_weight, 0)) 'to_be_charged_weight_to_mp_seller',
            ((ac.shipment_fee_mp_seller_rate * IF(ac.rounded_weight > 2, 2, IFNULL(rounded_weight, 0)))) 'to_be_shipment_fee_mp_seller',
            CASE
                WHEN FIND_IN_SET(ac.id_district, @half_subs) THEN 'New paid - half price'
                WHEN FIND_IN_SET(ac.id_district, @new_paid) THEN 'New paid - full price'
                WHEN ac.fk_zone_type = 0 THEN 'Old paid district'
                ELSE 'Free district'
            END 'city_flag',
            IFNULL(rc.id_region, 0) 'id_region',
            IFNULL(rc.region, 'NA') 'region',
            IFNULL(rc.id_city, 0) 'id_city',
            IFNULL(rc.city, 'NA') 'city_name',
            IFNULL(rc.shipment_cost_rate, 0) 'jne_published_rate',
            CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(new_rc.shipment_cost_rate, 0)
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END 'new_rate',
            CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END 'to_be_charged_weight_to_cust',
            (CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(new_rc.shipment_cost_rate, 0)
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END * CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END) + CASE
                WHEN FIND_IN_SET(ac.id_district, @new_paid) THEN 0
                WHEN FIND_IN_SET(ac.id_district, @half_subs) THEN 0
                WHEN ac.fk_zone_type = 0 THEN 0
                ELSE IFNULL(ac.shipping_amount, 0)
            END 'to_be_shipping_fee_to_cust',
            IFNULL(CASE
                WHEN fk_shipment_scheme = 1 THEN total_delivery_cost
                ELSE (lel.shipment_cost_rate * (1 - lel.shipment_cost_discount) * (1 + ac.shipment_cost_vat) * ac.rounded_weight) + ac.total_pickup_cost + ac.total_insurance_charge
            END, 0) 'to_be_delivery_cost'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN rate_card rc ON ac.id_district = rc.id_district
        AND ac.origin = rc.origin
        AND rc.fk_rate_card_scheme = 1
    LEFT JOIN rate_card lel ON ac.id_district = lel.id_district
        AND ac.origin = lel.origin
        AND lel.fk_rate_card_scheme = 3
    LEFT JOIN rate_card new_rc ON ac.id_district = new_rc.id_district
        AND ac.origin = new_rc.origin
        AND new_rc.fk_rate_card_scheme = 4
    WHERE
        fk_shipment_scheme = 1) direct_billing UNION ALL SELECT 
        *,
            to_be_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - to_be_delivery_cost 'to_be_gain_loss',
            to_be_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - to_be_delivery_cost - gain_loss 'impact_to_ebitda'
    FROM
        (SELECT 
        ac.*,
            ac.total_shipment_fee_mp_seller + ac.shipping_fee_to_customer - ac.total_delivery_cost 'gain_loss',
            CASE
                WHEN ac.seller_type = 'supplier' THEN ac.shipping_fee_to_customer
                WHEN ac.fk_zone_type <> 0 THEN ac.shipping_amount / 1.1
                ELSE 0
            END 'pc1',
            CASE
                WHEN ac.seller_type = 'supplier' THEN ac.total_delivery_cost * - 1
                ELSE 0
            END 'pc2',
            CASE
                WHEN
                    ac.seller_type = 'supplier'
                        OR ac.fk_zone_type = 0
                THEN
                    0
                ELSE ac.total_shipment_fee_mp_seller + ac.shipping_fee_to_customer - ac.total_delivery_cost
            END 'pc3',
            CASE
                WHEN formula_weight <= 0.17 THEN '<= 0.17'
                WHEN rounded_weight < 3 THEN '1-2 Kg'
                WHEN rounded_weight < 4 THEN '3 Kg'
                WHEN rounded_weight < 5 THEN '4 Kg'
                WHEN rounded_weight < 6 THEN '5 Kg'
                WHEN rounded_weight < 7 THEN '6 Kg'
                WHEN rounded_weight < 8 THEN '7 Kg'
                ELSE '8 Kg and above'
            END 'weight_bucket',
            0 'to_be_shipment_rate_mp_seller',
            0 'to_be_charged_weight_to_mp_seller',
            0 'to_be_shipment_fee_mp_seller',
            CASE
                WHEN FIND_IN_SET(ac.id_district, @half_subs) THEN 'New paid - half price'
                WHEN FIND_IN_SET(ac.id_district, @new_paid) THEN 'New paid - full price'
                WHEN ac.fk_zone_type = 0 THEN 'Old paid district'
                ELSE 'Free district'
            END 'city_flag',
            IFNULL(rc.id_region, 0) 'id_region',
            IFNULL(rc.region, 'NA') 'region',
            IFNULL(rc.id_city, 0) 'id_city',
            IFNULL(rc.city, 'NA') 'city_name',
            IFNULL(rc.shipment_cost_rate, 0) 'jne_published_rate',
            CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(new_rc.shipment_cost_rate, 0)
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END 'new_rate',
            CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END 'to_be_charged_weight_to_cust',
            ((CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(new_rc.shipment_cost_rate, 0)
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END * CASE
                WHEN
                    FIND_IN_SET(ac.id_district, @half_subs)
                        OR FIND_IN_SET(ac.id_district, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END) + CASE
                WHEN FIND_IN_SET(ac.id_district, @new_paid) THEN 0
                WHEN FIND_IN_SET(ac.id_district, @half_subs) THEN 0
                WHEN ac.fk_zone_type = 0 THEN 0
                ELSE IFNULL(ac.shipping_amount, 0)
            END) / 1.1 'to_be_shipping_fee_to_cust',
            IFNULL(CASE
                WHEN fk_shipment_scheme = 1 THEN total_delivery_cost
                ELSE (lel.shipment_cost_rate * (1 - lel.shipment_cost_discount) * (1 + ac.shipment_cost_vat) * ac.rounded_weight) + ac.total_pickup_cost + ac.total_insurance_charge
            END, 0) 'to_be_delivery_cost'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN rate_card rc ON ac.id_district = rc.id_district
        AND ac.origin = rc.origin
        AND rc.fk_rate_card_scheme = 1
    LEFT JOIN rate_card lel ON ac.id_district = lel.id_district
        AND ac.origin = lel.origin
        AND lel.fk_rate_card_scheme = 3
    LEFT JOIN rate_card new_rc ON ac.id_district = new_rc.id_district
        AND ac.origin = new_rc.origin
        AND new_rc.fk_rate_card_scheme = 4
    WHERE
        ac.fk_shipment_scheme = 3) retail) result
GROUP BY id_city