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

SET SQL_SAFE_UPDATES = 0;

UPDATE campaign_tracker 
SET 
    end_date = CASE
        WHEN
            end_date < start_date
                OR end_date IS NULL
        THEN
            '9999-12-31 23:59:59'
        ELSE DATE_FORMAT(end_date, '%Y-%m-%d 23:59:59')
    END;
        
UPDATE anondb_calculate ac
        LEFT JOIN
    free_zone fz ON ac.id_district = fz.id_district
        AND fz.active = 1
        LEFT JOIN
    zone_type zt ON (IFNULL(fz.fk_zone_type, ac.fk_zone_type)) = zt.id_zone_type 
SET 
    ac.fk_zone_type = IFNULL(fz.fk_zone_type, 0),
    ac.zone_type = zt.zone_type;

UPDATE anondb_calculate 
SET 
    fk_shipment_scheme = CASE
        WHEN tax_class = 'international' THEN 5
        WHEN delivery_type = 'digital' THEN 0
        WHEN
            first_shipment_provider = 'Digital Delivery'
                OR last_shipment_provider = 'Digital Delivery'
        THEN
            0
        WHEN
            delivery_type IN ('express' , 'nextday', 'sameday')
                AND last_shipment_provider LIKE '%Go-Jek%'
        THEN
            7
        WHEN is_marketplace = 0 THEN 3
        WHEN shipping_type = 'warehouse' THEN 4
        WHEN
            first_shipment_provider = 'Acommerce'
                AND last_shipment_provider = 'Acommerce'
        THEN
            1
        WHEN
            payment_method <> 'CashOnDelivery'
                AND first_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                AND last_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
        THEN
            1
        ELSE 2
    END;
    
UPDATE anondb_calculate ac
        LEFT JOIN
    shipment_scheme ss ON ac.fk_shipment_scheme = ss.id_shipment_scheme
        LEFT JOIN
    rate_card_scheme rcs ON ss.fk_rate_card_scheme = rcs.id_rate_card_scheme
        LEFT JOIN
    rate_card rc ON ac.id_district = rc.id_district
        AND ac.origin = rc.origin
        AND ss.fk_rate_card_scheme = rc.fk_rate_card_scheme 
SET 
    ac.shipment_scheme = ss.shipment_scheme,
    ac.fk_rate_card_scheme = rcs.id_rate_card_scheme,
    ac.rate_card_scheme = rcs.rate_card_scheme,
    ac.shipment_fee_mp_seller_rate = CASE
        WHEN ac.fk_shipment_scheme = 0 THEN 0
        WHEN ac.fk_shipment_scheme = 1 THEN 7000
        WHEN
            ac.fk_shipment_scheme = 2
                AND ac.pickup_provider_type = 'LEX'
        THEN
            6464
        WHEN ac.fk_shipment_scheme = 2 THEN 7000
        WHEN ac.fk_shipment_scheme = 3 THEN 0
        WHEN
            ac.fk_shipment_scheme = 4
                AND ac.pickup_provider_type = 'LEX'
        THEN
            6464
        WHEN ac.fk_shipment_scheme = 4 THEN 7000
        WHEN ac.fk_shipment_scheme = 5 THEN 0
        WHEN ac.fk_shipment_scheme = 6 THEN 0
        WHEN
            ac.fk_shipment_scheme = 7
        THEN
            CASE
                WHEN ac.is_marketplace = 0 THEN 0
                ELSE 7000
            END
    END,
    ac.shipment_cost_rate = CASE
        WHEN ac.fk_shipment_scheme = 7 THEN 15000
        ELSE IFNULL(rc.shipment_cost_rate, 0)
    END,
    ac.shipment_cost_discount = IFNULL(rc.shipment_cost_discount, 0),
    ac.shipment_cost_vat = CASE
        WHEN ac.fk_shipment_scheme = 0 THEN 0
        WHEN ac.fk_shipment_scheme = 1 THEN 0
        WHEN ac.fk_shipment_scheme = 2 THEN 0.01
        WHEN ac.fk_shipment_scheme = 3 THEN 0
        WHEN ac.fk_shipment_scheme = 4 THEN 0.01
        WHEN ac.fk_shipment_scheme = 5 THEN 0
        WHEN ac.fk_shipment_scheme = 6 THEN 0
        WHEN ac.fk_shipment_scheme = 7 THEN 0
    END,
    ac.pickup_cost = CASE
        WHEN ac.fk_shipment_scheme = 0 THEN 0
        WHEN ac.fk_shipment_scheme = 1 THEN 0
        WHEN
            ac.fk_shipment_scheme = 2
                AND (ac.pickup_provider_type = 'LEX'
                OR ac.first_shipment_provider LIKE '%LEX%')
        THEN
            1500
        WHEN ac.fk_shipment_scheme = 2 THEN 0
        WHEN ac.fk_shipment_scheme = 3 THEN 0
        WHEN ac.fk_shipment_scheme = 4 THEN 0
        WHEN ac.fk_shipment_scheme = 5 THEN 0
        WHEN ac.fk_shipment_scheme = 6 THEN 0
        WHEN ac.fk_shipment_scheme = 7 THEN 0
    END,
    ac.pickup_cost_discount = CASE
        WHEN ac.fk_shipment_scheme = 0 THEN 0
        WHEN ac.fk_shipment_scheme = 1 THEN 0
        WHEN
            ac.fk_shipment_scheme = 2
                AND (ac.pickup_provider_type = 'LEX'
                OR ac.first_shipment_provider LIKE '%LEX%')
        THEN
            0.2
        WHEN ac.fk_shipment_scheme = 2 THEN 0
        WHEN ac.fk_shipment_scheme = 3 THEN 0
        WHEN ac.fk_shipment_scheme = 4 THEN 0
        WHEN ac.fk_shipment_scheme = 5 THEN 0
        WHEN ac.fk_shipment_scheme = 6 THEN 0
        WHEN ac.fk_shipment_scheme = 7 THEN 0
    END,
    ac.pickup_cost_vat = CASE
        WHEN ac.fk_shipment_scheme = 0 THEN 0
        WHEN ac.fk_shipment_scheme = 1 THEN 0
        WHEN
            ac.fk_shipment_scheme = 2
                AND (ac.pickup_provider_type = 'LEX'
                OR ac.first_shipment_provider LIKE '%LEX%')
        THEN
            0.01
        WHEN ac.fk_shipment_scheme = 2 THEN 0
        WHEN ac.fk_shipment_scheme = 3 THEN 0
        WHEN ac.fk_shipment_scheme = 4 THEN 0
        WHEN ac.fk_shipment_scheme = 5 THEN 0
        WHEN ac.fk_shipment_scheme = 6 THEN 0
        WHEN ac.fk_shipment_scheme = 7 THEN 0
    END,
    ac.insurance_rate = CASE
        WHEN ac.fk_shipment_scheme = 0 THEN 0
        WHEN ac.fk_shipment_scheme = 1 THEN 0
        WHEN ac.fk_shipment_scheme = 2 THEN 0.0025
        WHEN ac.fk_shipment_scheme = 3 THEN 0.0025
        WHEN ac.fk_shipment_scheme = 4 THEN 0.0025
        WHEN ac.fk_shipment_scheme = 5 THEN 0
        WHEN ac.fk_shipment_scheme = 6 THEN 0
        WHEN ac.fk_shipment_scheme = 7 THEN 0
    END,
    ac.insurance_vat = CASE
        WHEN ac.fk_shipment_scheme = 0 THEN 0
        WHEN ac.fk_shipment_scheme = 1 THEN 0
        WHEN ac.fk_shipment_scheme = 2 THEN 0.1
        WHEN ac.fk_shipment_scheme = 3 THEN 0
        WHEN ac.fk_shipment_scheme = 4 THEN 0.1
        WHEN ac.fk_shipment_scheme = 5 THEN 0
        WHEN ac.fk_shipment_scheme = 6 THEN 0
        WHEN ac.fk_shipment_scheme = 7 THEN 0
    END
;

UPDATE anondb_calculate ce
        JOIN
    campaign_tracker ct ON ce.bob_id_supplier = ct.bob_id_supplier
        AND ce.first_shipped_date >= ct.start_date
        AND ce.first_shipped_date <= ct.end_date
        AND ct.fk_campaign = 1 
SET 
    ce.fk_campaign = ct.fk_campaign
WHERE
    ce.seller_type = 'merchant'
        AND ce.fk_shipment_scheme IN (2 , 4);
    
UPDATE anondb_calculate ce
        JOIN
    campaign_tracker ct ON ce.bob_id_supplier = ct.bob_id_supplier
        AND ce.first_shipped_date >= ct.start_date
        AND ce.first_shipped_date <= ct.end_date
        AND ct.fk_campaign NOT IN (1 , 4) 
SET 
    ce.fk_campaign = ct.fk_campaign
WHERE
    ce.seller_type = 'merchant'
        AND (ce.fk_shipment_scheme IN (2 , 4)
        OR (ce.fk_shipment_scheme = 7
        AND ce.sc_fee_2 = 0));

UPDATE anondb_calculate ce
        JOIN
    campaign_tracker ct ON ce.bob_id_supplier = ct.bob_id_supplier
        AND ce.first_shipped_date >= ct.start_date
        AND ce.first_shipped_date <= ct.end_date
        AND ct.fk_campaign = 4 
SET 
    ce.fk_campaign = ct.fk_campaign
WHERE
    ce.seller_type = 'merchant'
        AND ce.fk_shipment_scheme IN (2 , 4);
        
UPDATE anondb_calculate ce
        JOIN
    campaign ca ON ce.fk_campaign = ca.id_campaign
        AND ce.first_shipped_date >= ca.start_date
        AND ce.first_shipped_date <= ca.end_date 
SET 
    ce.campaign = ca.campaign,
    ce.shipment_fee_mp_seller_rate = IFNULL(ca.shipment_fee_mp_seller_rate,
            ce.shipment_fee_mp_seller_rate);

UPDATE anondb_calculate ce 
SET 
    shipment_fee_mp_seller = CASE
        WHEN fk_shipment_scheme = 7 THEN rounded_chargeable_weight * shipment_fee_mp_seller_rate
        ELSE rounded_chargeable_weight * shipment_fee_mp_seller_rate
    END,
    ce.sel_ins_fee = CASE
        WHEN fk_shipment_scheme = 3 THEN 0
        WHEN fk_campaign = 3 THEN 0
        WHEN fk_campaign = 1 THEN 0
        ELSE CASE
            WHEN unit_price <= 500000 THEN 0
            ELSE unit_price * insurance_rate
        END
    END,
    sel_ins_fee_vat = insurance_vat * CASE
        WHEN fk_shipment_scheme = 3 THEN 0
        WHEN fk_campaign = 3 THEN 0
        WHEN fk_campaign = 1 THEN 0
        ELSE CASE
            WHEN unit_price <= 500000 THEN 0
            ELSE unit_price * insurance_rate
        END
    END,
    total_insurance_fee = (1 + insurance_vat) * CASE
        WHEN fk_shipment_scheme = 3 THEN 0
        WHEN fk_campaign = 3 THEN 0
        WHEN fk_campaign = 1 THEN 0
        ELSE CASE
            WHEN unit_price <= 500000 THEN 0
            ELSE unit_price * insurance_rate
        END
    END,
    total_shipment_fee_mp_seller = CASE
        WHEN fk_shipment_scheme = 7 THEN shipment_fee_mp_seller_rate
        ELSE (rounded_chargeable_weight * shipment_fee_mp_seller_rate) + ((1 + insurance_vat) * CASE
            WHEN fk_shipment_scheme = 3 THEN 0
            WHEN fk_campaign = 3 THEN 0
            WHEN fk_campaign = 1 THEN 0
            ELSE CASE
                WHEN unit_price <= 500000 THEN 0
                ELSE unit_price * insurance_rate
            END
        END)
    END,
    total_shipment_cost = CASE
        WHEN fk_shipment_scheme = 7 THEN shipment_cost_rate
        ELSE shipment_cost_rate * (1 - shipment_cost_discount) * (1 + shipment_cost_vat) * rounded_weight
    END,
    total_pickup_cost = pickup_cost * (1 - pickup_cost_discount) * (1 + pickup_cost_vat) * rounded_weight,
    sp_ins_charge = CASE
        WHEN unit_price <= 500000 THEN 0
        ELSE unit_price * insurance_rate
    END,
    sp_ins_charge_vat = insurance_vat * CASE
        WHEN unit_price <= 500000 THEN 0
        ELSE unit_price * insurance_rate
    END,
    total_insurance_charge = (1 + insurance_vat) * CASE
        WHEN unit_price <= 500000 THEN 0
        ELSE unit_price * insurance_rate
    END,
    total_delivery_cost = CASE
        WHEN fk_shipment_scheme = 7 THEN shipment_cost_rate
        ELSE (shipment_cost_rate * (1 - shipment_cost_discount) * (1 + shipment_cost_vat) * rounded_weight) + (pickup_cost * (1 - pickup_cost_discount) * (1 + pickup_cost_vat) * rounded_weight) + ((1 + insurance_vat) * CASE
            WHEN unit_price <= 500000 THEN 0
            ELSE unit_price * insurance_rate
        END)
    END
;

SET SQL_SAFE_UPDATES = 1;