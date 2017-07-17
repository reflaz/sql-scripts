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
SET @new_paid = '1655,1728,3687,3939,4717,4904,5106,5110,5114,5123,5127,5361,5656,5747,6002,6685,7059,7096';
SET @half_subs = '774,970,1831,2060,3950,5814,5971,6077,6302,6313,6328,6604,6672,6704,6856,6886,6915,6951,7002,7009';
SET @covered_by_lex = '7119,6270,6254,6704,6230,6189,5603,4936,5490,5415,6672,4543,6654,5234,5221,5155,3950,3729,6363,6345,6338,6334,7126,6321,6645,6636,6625,6614,6607,1831,5117,544,970,774,2060,5716,5074,5710,6988,6980,6722';

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
    city_flag 'new_zone_type',
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
            IF(ac.fk_campaign IN (2 , 3), (ac.rounded_weight_non_bulky * 2500) + total_insurance_fee, ac.total_shipment_fee_mp_seller) 'to_be_shipment_fee_mp_seller',
            CASE
                WHEN FIND_IN_SET(rc.id_city, @half_subs) THEN 'Half Subsidized City'
                WHEN FIND_IN_SET(rc.id_city, @new_paid) THEN 'New Paid City'
                ELSE ac.zone_type
            END 'city_flag',
            IFNULL(rc.id_region, 0) 'id_region',
            IFNULL(rc.region, 'NA') 'region',
            IFNULL(rc.id_city, 0) 'id_city',
            IFNULL(rc.city, 'NA') 'city_name',
            IFNULL(rc.shipment_cost_rate, 0) 'jne_published_rate',
            CASE
                WHEN
                    ac.fk_zone_type = 0
                        OR FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                THEN
                    CASE
                        WHEN ac.formula_weight <= 0.17 THEN 0
                        WHEN
                            ac.rounded_weight <= @subsidized_weight
                                AND FIND_IN_SET(rc.id_city, @half_subs)
                        THEN
                            IFNULL(rc.shipment_cost_rate / 2, 0)
                        WHEN ac.rounded_weight <= @subsidized_weight THEN IFNULL(rc.shipment_cost_rate - 7000, 0)
                        ELSE IFNULL(rc.shipment_cost_rate, 0)
                    END
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END 'new_rate',
            CASE
                WHEN
                    FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END 'to_be_charged_weight_to_cust',
            (CASE
                WHEN
                    ac.fk_zone_type = 0
                        OR FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                THEN
                    CASE
                        WHEN ac.formula_weight <= 0.17 THEN 0
                        WHEN
                            ac.rounded_weight <= @subsidized_weight
                                AND FIND_IN_SET(rc.id_city, @half_subs)
                        THEN
                            IFNULL(rc.shipment_cost_rate / 2, 0)
                        WHEN ac.rounded_weight <= @subsidized_weight THEN IFNULL(rc.shipment_cost_rate - 7000, 0)
                        ELSE IFNULL(rc.shipment_cost_rate, 0)
                    END
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END * CASE
                WHEN
                    FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END) + CASE
                WHEN ac.fk_zone_type = 0 THEN 0
                WHEN FIND_IN_SET(rc.id_city, @new_paid) THEN 0
                WHEN FIND_IN_SET(rc.id_city, @half_subs) THEN 0
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
            shipment_fee_mp_seller_rate 'to_be_shipment_rate_mp_seller',
            total_shipment_fee_mp_seller 'to_be_shipment_fee_mp_seller',
            CASE
                WHEN FIND_IN_SET(rc.id_city, @half_subs) THEN 'Half Subsidized City'
                WHEN FIND_IN_SET(rc.id_city, @new_paid) THEN 'New Paid City'
                ELSE ac.zone_type
            END 'city_flag',
            IFNULL(rc.id_region, 0) 'id_region',
            IFNULL(rc.region, 'NA') 'region',
            IFNULL(rc.id_city, 0) 'id_city',
            IFNULL(rc.city, 'NA') 'city_name',
            IFNULL(rc.shipment_cost_rate, 0) 'jne_published_rate',
            CASE
                WHEN
                    ac.fk_zone_type = 0
                        OR FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                THEN
                    CASE
                        WHEN ac.formula_weight <= 0.17 THEN 0
                        WHEN
                            ac.rounded_weight <= @subsidized_weight
                                AND FIND_IN_SET(rc.id_city, @half_subs)
                        THEN
                            IFNULL(rc.shipment_cost_rate / 2, 0)
                        WHEN ac.rounded_weight <= @subsidized_weight THEN IFNULL(rc.shipment_cost_rate - 7000, 0)
                        ELSE IFNULL(rc.shipment_cost_rate, 0)
                    END
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END 'new_rate',
            CASE
                WHEN
                    FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END 'to_be_charged_weight_to_cust',
            (CASE
                WHEN
                    ac.fk_zone_type = 0
                        OR FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                THEN
                    CASE
                        WHEN ac.formula_weight <= 0.17 THEN 0
                        WHEN
                            ac.rounded_weight <= @subsidized_weight
                                AND FIND_IN_SET(rc.id_city, @half_subs)
                        THEN
                            IFNULL(rc.shipment_cost_rate / 2, 0)
                        WHEN ac.rounded_weight <= @subsidized_weight THEN IFNULL(rc.shipment_cost_rate - 7000, 0)
                        ELSE IFNULL(rc.shipment_cost_rate, 0)
                    END
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END * CASE
                WHEN
                    FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END) + CASE
                WHEN ac.fk_zone_type = 0 THEN 0
                WHEN FIND_IN_SET(rc.id_city, @new_paid) THEN 0
                WHEN FIND_IN_SET(rc.id_city, @half_subs) THEN 0
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
            shipment_fee_mp_seller_rate 'to_be_shipment_rate_mp_seller',
            total_shipment_fee_mp_seller 'to_be_shipment_fee_mp_seller',
            CASE
                WHEN FIND_IN_SET(rc.id_city, @half_subs) THEN 'Half Subsidized City'
                WHEN FIND_IN_SET(rc.id_city, @new_paid) THEN 'New Paid City'
                ELSE ac.zone_type
            END 'city_flag',
            IFNULL(rc.id_region, 0) 'id_region',
            IFNULL(rc.region, 'NA') 'region',
            IFNULL(rc.id_city, 0) 'id_city',
            IFNULL(rc.city, 'NA') 'city_name',
            IFNULL(rc.shipment_cost_rate, 0) 'jne_published_rate',
            CASE
                WHEN
                    ac.fk_zone_type = 0
                        OR FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                THEN
                    CASE
                        WHEN ac.formula_weight <= 0.17 THEN 0
                        WHEN
                            ac.rounded_weight <= @subsidized_weight
                                AND FIND_IN_SET(rc.id_city, @half_subs)
                        THEN
                            IFNULL(rc.shipment_cost_rate / 2, 0)
                        WHEN ac.rounded_weight <= @subsidized_weight THEN IFNULL(rc.shipment_cost_rate - 7000, 0)
                        ELSE IFNULL(rc.shipment_cost_rate, 0)
                    END
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END 'new_rate',
            CASE
                WHEN
                    FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END 'to_be_charged_weight_to_cust',
            ((CASE
                WHEN
                    ac.fk_zone_type = 0
                        OR FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                THEN
                    CASE
                        WHEN ac.formula_weight <= 0.17 THEN 0
                        WHEN
                            ac.rounded_weight <= @subsidized_weight
                                AND FIND_IN_SET(rc.id_city, @half_subs)
                        THEN
                            IFNULL(rc.shipment_cost_rate / 2, 0)
                        WHEN ac.rounded_weight <= @subsidized_weight THEN IFNULL(rc.shipment_cost_rate - 7000, 0)
                        ELSE IFNULL(rc.shipment_cost_rate, 0)
                    END
                ELSE IFNULL(rc.shipment_cost_rate, 0)
            END * CASE
                WHEN
                    FIND_IN_SET(rc.id_city, @half_subs)
                        OR FIND_IN_SET(rc.id_city, @new_paid)
                        OR ac.fk_zone_type = 0
                THEN
                    IFNULL(ac.rounded_weight, 0)
                WHEN ac.rounded_weight > @subsidized_weight THEN IFNULL(ac.rounded_weight - @subsidized_weight, 0)
                ELSE 0
            END) + CASE
                WHEN ac.fk_zone_type = 0 THEN 0
                WHEN FIND_IN_SET(rc.id_city, @new_paid) THEN 0
                WHEN FIND_IN_SET(rc.id_city, @half_subs) THEN 0
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
    WHERE
        ac.fk_shipment_scheme = 3) retail) result
GROUP BY id_city , weight_bucket