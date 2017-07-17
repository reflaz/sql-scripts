/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss AnonDB Population Extract

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-12-15';
SET @extractend = '2017-02-05';-- This MUST be D + 1

SET @jakarta = '6606,6605,17231,6653,6652,6651,6650,6649,6648,6647,6646,6644,6643,6642,6641,6640,6639,6638,6637,6635,6634,6633,6632,6631,6630,6629,6628,6627,6626,6624,6623,6622,6621,6620,6619,6618,6617,6616,6615,6613,6612,6611,6610,6609,6608';
SET @bodetabek = '6229,6228,6227,6226,6225,6224,6223,6222,6221,6220,6219,6218,6217,6216,6215,6214,6213,6212,6211,6210,6209,6208,6207,6206,6205,6204,6203,6202,6201,6200,6199,6198,6197,6196,6195,6194,6193,6192,6191,6190,17389,6344,6343,6342,6341,6340,6339,6327,17384,6326,17385,6325,6324,6323,6322,6885,6884,6883,6882,6881,6880,6879,6878,6877,6876,6875,6874,6873,6872,6871,6870,6869,6868,6867,6866,6865,6864,6863,6862,6861,6860,6859,6858,6857,7001,7000,6999,6998,6997,6996,6995,17393,6994,6993,6992,6991,6990,6989,6987,6986,6985,6984,6983,6982,6981,6253,6252,6251,6250,6249,17381,6248,6247,6246,6245,6244,6243,6242,6241,6240,6239,6238,6237,6236,6235,6234,6233,6232,6231,6357,17390,6356,6355,6354,6353,6352,6351,6350,6349,6348,6347,6346';
SET @free = '7125,17315,7124,7123,7122,17316,7121,17317,17318,7120,17319,7130,7129,7128,7127,6979,6978,6977,6976,6975,6974,6973,6972,6971,6970,6969,6968,6967,6966,6965,6964,6963,6962,6961,6960,6959,6958,6957,6956,6955,6954,6953,6952,6950,6949,6948,17392,6947,6946,6945,6944,6943,6942,6941,6940,6939,6938,6937,6936,6935,6934,6933,6932,6931,6930,6929,6928,6927,6926,6925,6924,6923,6922,6921,6920,6919,6918,6917,6916,6914,6913,6912,6911,6910,6909,6908,6907,6906,6905,6904,6903,6902,6901,6900,6899,6898,6897,6896,6895,6894,6893,6892,6891,6890,6889,6888,6887,6885,6884,6883,6882,6881,6880,6879,6878,6877,6876,6875,6874,6873,6872,6871,6870,6869,6868,6867,6866,6865,6864,6863,6862,6861,6860,6859,6858,6857,7017,7016,7015,7014,7013,7012,17394,7011,7010,7008,7007,7006,7005,7004,7003,7001,7000,6999,6998,6997,6996,6995,17393,6994,6993,6992,6991,6990,6989,6987,6986,6985,6984,6983,6982,6981,6671,6670,6669,6668,6667,6666,6665,6664,6663,6662,6661,6660,6659,6658,6657,6656,6655,6736,6735,6734,6733,6732,6731,6730,6729,6728,6727,6726,6725,6724,6723,17212,6606,6605,17231,6653,6652,6651,6650,6649,6648,6647,6646,6644,6643,6642,6641,6640,6639,6638,6637,6635,6634,6633,6632,6631,6630,6629,6628,6627,6626,6624,6623,6622,6621,6620,6619,6618,6617,6616,6615,6613,6612,6611,6610,6609,6608,6301,6300,6299,6298,6297,6296,6295,6294,6293,6292,6291,6290,6289,6288,6287,6286,6285,6284,6283,6282,6281,6280,6279,6278,6277,6276,6275,6274,6273,6272,6271,6269,6268,6267,6266,17382,6265,6264,6263,6262,6261,6260,6259,6258,6257,6256,6255,6253,6252,6251,6250,6249,17381,6248,6247,6246,6245,6244,6243,6242,6241,6240,6239,6238,6237,6236,6235,6234,6233,6232,6231,6229,6228,6227,6226,6225,6224,6223,6222,6221,6220,6219,6218,6217,6216,6215,6214,6213,6212,6211,6210,6209,6208,6207,6206,6205,6204,6203,6202,6201,6200,6199,6198,6197,6196,6195,6194,6193,6192,6191,6190,6393,6392,6391,6390,6389,6388,17391,6387,6386,6385,6384,6383,6382,6381,6380,6379,6378,6377,6376,6375,6374,6373,6372,6371,6370,6369,6368,6367,6366,6365,6364,6357,17390,6356,6355,6354,6353,6352,6351,6350,6349,6348,6347,6346,17389,6344,6343,6342,6341,6340,6339,17388,6337,6336,6335,6327,17384,6326,17385,6325,6324,6323,6322,5441,5440,5439,5438,5437,5436,5435,5434,5433,5432,5431,5430,5429,5428,17496,5427,5426,5425,5424,5423,5422,5421,5420,5419,5418,5417,5416,5274,5273,5272,5271,5270,5269,5268,5267,5266,5265,5264,5263,5262,5261,5260,5259,5258,17493,5257,5256,5732,5731,5730,5729,5728,5727,5726,5725,5724,17506,5723,5722,5721,5720,5719,5718,5717,5715,5714,5713,5712,5711,17505,4954,4953,4952,4951,4950,4949,4948,4947,4946,4945,4944,4943,4942,4941,4940,4939,4938,4937,4881,4880,4879,4878,4877,4876,4875,4874,4873,4872,4871,4870,4869,4868,4867,4866,4865,4864,4863,4862,4861,4860,4859,4858,4857,4856,4854,4853,4852,4851,4850,4849,4848,4847,4846,4845,4844,4843,4842,4841,4840,4839,4838,4837,4836,4835,4834,4833,4832,4831,4830,4829,4828,4662,4661,4660,4659,4658,4657,17238,4656,4655,4654,4653,4652,4651,4650,4561,4560,4559,4558,4557,4556,4555,4554,4553,4552,4551,4550,4549,4548,4547,4546,4545,4544,5122,5121,5120,5119,17248,5118,5105,5104,5103,5102,5101,5100,5099,5098,5097,5096,5095,5094,5093,5092,5091,5090,5089,5088,5087,5086,5085,5084,5083,5082,5081,5080,5079,5078,5077,5076,5075,17211,3742,3741,3740,3739,3738,3737,3736,3735,3734,3733,3732,3731,3730,17443,565,564,563,562,561,560,559,558,557,556,555,554,553,552,551,550,549,548,547,546,545';
SET @halfpaid = '6721,6720,6719,6718,6717,6716,6715,6714,6713,6712,6711,6710,6709,6708,6707,6706,6705,6684,6683,6682,6681,6680,6679,6678,6677,6676,6675,6674,6673,6117,6116,6115,6114,6113,17379,17380,6112,6111,6110,6109,6108,6107,6106,6105,6104,6103,6102,6101,6100,6099,6098,6097,6096,6095,6094,6093,6092,6091,6090,6089,6088,6087,6086,6085,6084,6083,6082,6081,6080,6079,6078,6001,6000,5999,5998,5997,5996,5995,5994,5993,5992,17375,5991,5990,5989,5988,5987,5986,5985,5984,5983,5982,5981,5980,5979,5978,5977,5976,5975,5974,5973,5972,5861,5860,5859,5858,5857,5856,5855,5854,5853,5852,5851,5850,5849,5848,5847,5846,5845,5844,5843,5842,5841,5840,5839,5838,5837,5836,5835,5834,5833,5832,5831,5830,5829,5828,5827,5826,5825,5824,5823,5822,5821,5820,5819,5818,5817,5816,5815,17386,17387,6333,6332,6331,6330,6329,6320,6319,6318,6317,6316,6315,6314,6312,6311,6310,6309,6308,6307,6306,6305,6304,17383,6303,2072,2071,2070,17229,2069,2068,2067,2066,2065,2064,2063,2062,2061,981,980,979,978,977,976,975,17347,974,973,972,971,790,789,788,787,786,785,784,783,782,781,17370,780,779,778,777,776,775,1845,1844,1843,1842,1841,1840,1839,1838,1837,1836,1835,1834,1833,1832,17259,3955,3954,3953,3952,3951';
SET @fullpaid = '7103,7102,7101,7100,7099,7098,7097,7064,7063,7062,17353,7061,7060,6703,6702,6701,6700,6699,6698,6697,6696,6695,6694,6693,6692,6691,6690,6689,6688,6687,6686,6033,6032,6031,6030,6029,6028,6027,6026,6025,6024,6023,6022,6021,17376,6020,6019,6018,6017,6016,6015,6014,6013,6012,6011,6010,6009,6008,6007,6006,6005,6004,6003,5786,5785,5784,5783,5782,5781,5780,5779,5778,5777,5776,5775,5774,5773,5772,5771,5770,5769,5768,5767,5766,5765,5764,5763,5762,5761,5760,5759,5758,5757,5756,5755,5754,5753,5752,5751,5750,5749,5748,5683,5682,5681,5680,5679,5678,5677,5676,5675,5674,5673,5672,5671,17501,5670,5669,5668,17502,5667,5666,5665,5664,5663,5662,5661,5660,5659,5658,5657,5382,5381,5380,5379,5378,5377,5376,5375,5374,5373,5372,5371,5370,5369,5368,5367,5366,17494,5365,5364,5363,5362,4935,4934,4933,4932,4931,4930,4929,17242,4928,4927,4926,4925,4924,4923,4922,4921,4920,4919,4918,4917,4916,4915,4914,4913,4912,4911,4910,4909,4908,4907,4906,4905,4735,4734,4733,4732,4731,4730,4729,4728,4727,4726,17240,4725,4724,4723,4722,4721,4720,4719,4718,5130,5129,5128,5126,17249,5125,5124,5116,5115,5113,5112,17247,5111,5109,17245,17246,5108,5107,3704,3703,3702,3701,3700,3699,3698,3697,3696,3695,3694,3693,3692,3691,3690,3689,3688,1746,1745,1744,1743,1742,1741,1740,1739,1738,1737,1736,1735,1734,1733,1732,17483,1731,1730,1729,1669,1667,1666,1665,1664,1663,17480,1662,1668,1661,1660,1659,1658,1657,1656,5073,17244,5072,5071,5070,5069,5068,5067,5066,5065,5064,5063,5062,5061,5060,5059,5058,5057,5006,5005,5004,5003,5002,5001,5000,4999,4998,4997,4996,4995,4994,4993,4992,4991,4990,4989,4988,4985,4984,4983,4982,4981,4980,4903,4902,4901,4900,4899,4898,4897,4896,4895,4894,4893,4892,4891,4890,4889,4888,4886,4885,4884,4883,4811,4810,17241,4799,4796,4716,4715,4714,4712,4711,4710,4709,4708,4707,4706,4705,4704,4703,4702,4701,4700,4699,4698,4697,4648,4647,4646,4645,4644,17236,4643,4642,4641,4639,17237,4638,4637,4636,4635,4634,4633,4631,4630,4629,4627,4626,4625,4598,4590,17235,4576,4575,4574,4573,4572,4571,4570,4569,4567,4566,4565,4564,4563,4495,4494,4493,4492,4491,4490,4489,4488,4487,4485,4484,4483,4481,4480,4478,4477,4476,4475,4474,4473,4472,4471,17232,4470,4469,4468,4467,4466,4465,4464,4463,4462,4460,4459,4458,4457,4456,4455,4454,4453,4452,4451,4450,4449,4448,4446,4445,4444,4442,3945,17629,3944,3943,3942,3941,3940,183';

SELECT 
    *
FROM
    (SELECT 
        period,
            COUNT(IF(zone_type = 'jabodetabek', bob_id_sales_order_item, NULL)) 'count_soi_jabodetabek',
            COUNT(IF(zone_type = 'other_free', bob_id_sales_order_item, NULL)) 'count_soi_other_free',
            COUNT(IF(zone_type = 'half_paid', bob_id_sales_order_item, NULL)) 'count_soi_half_paid',
            COUNT(IF(zone_type = 'full_paid', bob_id_sales_order_item, NULL)) 'count_soi_full_paid',
            COUNT(IF(zone_type = 'old_paid', bob_id_sales_order_item, NULL)) 'count_soi_old_paid',
            COUNT(bob_id_sales_order_item) 'total_count_soi'
    FROM
        (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            so.created_at,
            verified.created_at 'verified_date',
            CASE
                WHEN
                    FIND_IN_SET(soa.fk_customer_address_region, @jakarta)
                        OR FIND_IN_SET(soa.fk_customer_address_region, @bodetabek)
                THEN
                    'jabodetabek'
                WHEN FIND_IN_SET(soa.fk_customer_address_region, @free) THEN 'other_free'
                WHEN FIND_IN_SET(soa.fk_customer_address_region, @halfpaid) THEN 'half_paid'
                WHEN FIND_IN_SET(soa.fk_customer_address_region, @fullpaid) THEN 'full_paid'
                ELSE 'old_paid'
            END 'zone_type',
            CASE
				WHEN so.created_at >= '2016-12-15' AND so.created_at < '2016-12-22' THEN 'Dec 15 - 21'
                WHEN so.created_at >= '2016-12-22' AND so.created_at < '2016-12-29' THEN 'Dec 22 - 28'
                
                WHEN so.created_at >= '2017-01-01' AND so.created_at < '2017-01-08' THEN 'Jan 1 - 7'
                WHEN so.created_at >= '2017-01-08' AND so.created_at < '2017-01-15' THEN 'Jan 8 - 14'
                WHEN so.created_at >= '2017-01-15' AND so.created_at < '2017-01-22' THEN 'Jan 15 - 21'
                WHEN so.created_at >= '2017-01-22' AND so.created_at < '2017-01-29' THEN 'Jan 22 - 28'
                WHEN so.created_at >= '2017-01-29' AND so.created_at < '2017-02-05' THEN 'Jan 29 - Feb 4'
            END 'period'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    JOIN oms_live.ims_sales_order_item_status_history verified ON soi.id_sales_order_item = verified.fk_sales_order_item
        AND verified.fk_sales_order_item_status = 67
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
    GROUP BY id_sales_order_item) result
    GROUP BY period) result