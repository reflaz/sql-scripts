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

SET @weight_decrement = 3;

SELECT 
    *,
    total_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - total_delivery_cost 'to_be_gain_loss',
    total_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - total_delivery_cost - gain_loss 'impact_to_ebitda'
FROM
    (SELECT 
        ac.*,
            ac.total_shipment_fee_mp_seller + ac.shipping_surcharge + ac.shipping_amount - ac.total_delivery_cost 'gain_loss',
            ac.total_shipment_fee_mp_seller + ac.shipping_surcharge + ac.shipping_amount - ac.total_shipment_cost - ac.total_insurance_charge 'pc1',
            - ac.total_pickup_cost 'pc2',
            0 'pc3',
            IFNULL(rc.shipment_cost_rate, 0) 'jne_published_rate',
            IFNULL(ac.rounded_weight - @weight_decrement, 0) 'to_be_charged_weight_to_cust',
            (IFNULL(rc.shipment_cost_rate, 0) * IFNULL(ac.rounded_weight - @weight_decrement, 0)) + ac.shipping_amount 'to_be_shipping_fee_to_cust'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN rate_card rc ON ac.id_district = rc.id_district
        AND ac.origin = rc.origin
        AND rc.fk_rate_card_scheme = 1
    WHERE
        ac.fk_shipment_scheme IN (2 , 4)
            AND ac.seller_type = 'merchant'
            AND ac.fk_zone_type <> 0
            AND ac.rounded_weight > @weight_decrement) master_account 
UNION ALL SELECT 
    *,
    total_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - total_delivery_cost 'to_be_gain_loss',
    total_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - total_delivery_cost - gain_loss 'impact_to_ebitda'
FROM
    (SELECT 
        ac.*,
            ac.total_shipment_fee_mp_seller + ac.shipping_surcharge + ac.shipping_amount - ac.total_delivery_cost 'gain_loss',
            CASE
                WHEN ac.seller_type = 'supplier' THEN ac.shipping_surcharge + ac.shipping_amount
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
                ELSE ac.total_shipment_fee_mp_seller + ac.shipping_surcharge + ac.shipping_amount - ac.total_delivery_cost
            END 'pc3',
            IFNULL(rc.shipment_cost_rate, 0) 'jne_published_rate',
            IFNULL(ac.rounded_weight - @weight_decrement, 0) 'to_be_charged_weight_to_cust',
            (IFNULL(rc.shipment_cost_rate, 0) * IFNULL(ac.rounded_weight - @weight_decrement, 0)) + ac.shipping_amount 'to_be_shipping_fee_to_cust'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN rate_card rc ON ac.id_district = rc.id_district
        AND ac.origin = rc.origin
        AND rc.fk_rate_card_scheme = 1
    WHERE
        fk_shipment_scheme = 1
            AND ac.fk_zone_type <> 0
            AND ac.rounded_weight > @weight_decrement) direct_billing 
UNION ALL SELECT 
    *,
    total_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - total_delivery_cost 'to_be_gain_loss',
    total_shipment_fee_mp_seller + to_be_shipping_fee_to_cust - total_delivery_cost - gain_loss 'impact_to_ebitda'
FROM
    (SELECT 
        ac.*,
            ac.total_shipment_fee_mp_seller + ac.shipping_surcharge + ac.shipping_amount - ac.total_delivery_cost 'gain_loss',
            CASE
                WHEN ac.seller_type = 'supplier' THEN ac.shipping_surcharge + ac.shipping_amount
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
                ELSE ac.total_shipment_fee_mp_seller + ac.shipping_surcharge + ac.shipping_amount - ac.total_delivery_cost
            END 'pc3',
            IFNULL(rc.shipment_cost_rate, 0) 'jne_published_rate',
            IFNULL(ac.rounded_weight - @weight_decrement, 0) 'to_be_charged_weight_to_cust',
            (IFNULL(rc.shipment_cost_rate, 0) * IFNULL(ac.rounded_weight - @weight_decrement, 0)) + ac.shipping_amount 'to_be_shipping_fee_to_cust'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN rate_card rc ON ac.id_district = rc.id_district
        AND ac.origin = rc.origin
        AND rc.fk_rate_card_scheme = 1
    WHERE
        ac.fk_shipment_scheme = 3
            AND ac.fk_zone_type <> 0
            AND ac.rounded_weight > @weight_decrement) retail;