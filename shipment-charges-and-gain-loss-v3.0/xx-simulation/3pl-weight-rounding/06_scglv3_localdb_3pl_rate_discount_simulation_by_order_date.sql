/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Threshold Tracker
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-07-01';
SET @extractend = '2017-08-01';-- This MUST be D + 1

SELECT 
    city,
    SUM(current_pickup_cost) 'current_pickup_cost',
    SUM(to_be_pickup_cost) 'to_be_pickup_cost',
    SUM(current_shipping_cost) 'current_shipping_cost',
    SUM(to_be_shipping_cost) 'to_be_shipping_cost'
FROM
    (SELECT 
        ac.order_nr,
            ac.bob_id_sales_order_item,
            ac.payment_method,
            SUM(ac.unit_price) 'unit_price',
            SUM(ac.paid_price) 'paid_price',
            SUM(ac.shipping_amount) 'shipping_amount',
            SUM(ac.shipping_surcharge) 'shipping_surcharge',
            ac.bob_id_supplier,
            ac.seller_name,
            ac.seller_type,
            ac.order_date,
            ac.first_shipped_date,
            ac.delivered_date,
            ac.not_delivered_date,
            ac.pickup_provider_type,
            ac.id_package_dispatching,
            ac.first_shipment_provider,
            ac.last_shipment_provider,
            ac.origin,
            zm.id_city,
            zm.city 'city',
            ac.id_district,
            ac.zone_type,
            ac.shipment_scheme,
            ac.rate_card_scheme,
            ac.campaign,
            ac.qty_ps,
            ac.formula_weight_3pl_ps,
            ac.chargeable_weight_3pl_ps 'current_chargeable_weight_3pl_ps',
            aet.chargeable_weight_3pl 'to_be_chargeable_weight_3pl_ps',
            ac.pickup_cost_rate,
            ac.pickup_cost_discount_rate,
            ac.delivery_cost_rate 'current_delivery_cost_rate,',
            aet.delivery_cost_rate 'to_be_delivery_cost_rate,',
            ac.delivery_cost_discount_rate 'current_delivery_cost_discount_rate',
            aet.delivery_cost_discount_rate 'to_be_delivery_cost_discount_rate',
            SUM(ac.pickup_cost_item + ac.pickup_cost_discount_item + ac.pickup_cost_vat_item) 'current_pickup_cost',
            aet.pickup_cost + aet.pickup_cost_discount + aet.pickup_cost_vat 'to_be_pickup_cost',
            SUM(ac.delivery_cost_item + ac.delivery_cost_discount_item + ac.delivery_cost_vat_item) 'current_shipping_cost',
            aet.delivery_cost + aet.delivery_cost_discount + aet.delivery_cost_vat 'to_be_shipping_cost'
    FROM
        anondb_calculate ac
    LEFT JOIN anondb_extract_temp aet ON aet.order_nr = ac.order_nr
        AND aet.bob_id_supplier = ac.bob_id_supplier
        AND IFNULL(aet.id_package_dispatching, 1) = IFNULL(ac.id_package_dispatching, 1)
    LEFT JOIN zone_mapping zm ON ac.id_district = zm.id_district
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) >= zm.start_date
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) <= zm.end_date
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.rate_card_scheme = 'LEL'
            AND ac.delivery_cost_discount_rate = 0.4
    GROUP BY ac.order_nr , ac.bob_id_supplier , ac.id_package_dispatching) result
GROUP BY id_city