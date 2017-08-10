/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Simple-Config-Seller Weight Comparison

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Pull data from ANON DB using LEL package number
				  - Import LEL and ANON DB data
                  - Run step 4 & 5
				  - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-07-01';
SET @extractend = '2017-07-02';-- This MUST be D + 1

SELECT 
    *,
    subsidy_item_con - subsidy_item_sim 'delcost_con_sim_diff',
    subsidy_item_sel - subsidy_item_sim 'delcost_sel_sim_diff',
    subsidy_item_sel - subsidy_item_con 'delcost_con_sim_diff'
FROM
    (SELECT 
        sim.order_nr,
            sim.bob_id_sales_order_item,
            sim.shipment_scheme,
            sim.unit_price,
            sim.paid_price,
            CASE
                WHEN sim.is_marketplace = 0 THEN IFNULL(sim.shipping_surcharge, 0) / 1.1
                ELSE IFNULL(sim.shipping_surcharge, 0)
            END 'shipping_surcharge',
            CASE
                WHEN sim.is_marketplace = 0 THEN IFNULL(sim.shipping_amount, 0) / 1.1
                ELSE IFNULL(sim.shipping_amount, 0)
            END 'shipping_amount',
            sim.chargeable_weight_seller_ps 'chargeable_weight_seller_ps_sim',
            con.chargeable_weight_seller_ps 'chargeable_weight_seller_ps_con',
            con.chargeable_weight_seller_ps - sim.chargeable_weight_seller_ps 'weight_sel_con_sim_diff',
            IF(ABS(MOD(con.chargeable_weight_seller_ps - sim.chargeable_weight_seller_ps, 1)) > 0.1, 1, 0) 'weight_sel_con_sim_diff_flag',
            sel.chargeable_weight_seller_ps 'chargeable_weight_seller_ps_sel',
            sel.chargeable_weight_seller_ps - sim.chargeable_weight_seller_ps 'weight_sel_sel_sim_diff',
            IF(ABS(MOD(sel.chargeable_weight_seller_ps - sim.chargeable_weight_seller_ps, 1)) > 0.1, 1, 0) 'weight_sel_sel_sim_diff_flag',
            sel.chargeable_weight_seller_ps - con.chargeable_weight_seller_ps 'weight_sel_sel_con_diff',
            IF(ABS(MOD(sel.chargeable_weight_seller_ps - con.chargeable_weight_seller_ps, 1)) > 0.1, 1, 0) 'weight_sel_sel_con_diff_flag',
            sim.chargeable_weight_3pl_ps 'chargeable_weight_3pl_ps_sim',
            con.chargeable_weight_3pl_ps 'chargeable_weight_3pl_ps_con',
            con.chargeable_weight_3pl_ps - sim.chargeable_weight_3pl_ps 'chargeable_weight_3pl_ps_con_sim_diff',
            IF(ABS(MOD(con.chargeable_weight_3pl_ps - sim.chargeable_weight_3pl_ps, 1)) > 0.1, 1, 0) 'chargeable_weight_3pl_ps_con_sim_diff_flag',
            sel.chargeable_weight_3pl_ps 'chargeable_weight_3pl_ps_sel',
            sel.chargeable_weight_3pl_ps - sim.chargeable_weight_3pl_ps 'chargeable_weight_3pl_ps_sel_sim_diff',
            IF(ABS(MOD(sel.chargeable_weight_3pl_ps - sim.chargeable_weight_3pl_ps, 1)) > 0.1, 1, 0) 'chargeable_weight_3pl_ps_sel_sim_diff_flag',
            sel.chargeable_weight_3pl_ps - con.chargeable_weight_3pl_ps 'chargeable_weight_3pl_ps_sel_con_diff',
            IF(ABS(MOD(sel.chargeable_weight_3pl_ps - con.chargeable_weight_3pl_ps, 1)) > 0.1, 1, 0) 'chargeable_weight_3pl_ps_sel_con_diff_flag',
            sim.shipment_fee_mp_seller_flat_rate,
            sim.shipment_fee_mp_seller_rate,
            sim.delivery_cost_rate,
            (sim.insurance_seller_item + sim.insurance_vat_seller_item) 'insurance_seller_item',
            (sim.insurance_3pl_item + sim.insurance_vat_3pl_item) 'insurance_3pl_item',
            sim.shipment_fee_mp_seller_item 'shipment_fee_mp_seller_item_sim',
            con.shipment_fee_mp_seller_item 'shipment_fee_mp_seller_item_con',
            con.shipment_fee_mp_seller_item - sim.shipment_fee_mp_seller_item 'sel_charge_con_sim_diff',
            sel.shipment_fee_mp_seller_item 'shipment_fee_mp_seller_item_sel',
            sel.shipment_fee_mp_seller_item - sim.shipment_fee_mp_seller_item 'sel_charge_sel_sim_diff',
            sel.shipment_fee_mp_seller_item - con.shipment_fee_mp_seller_item 'sel_charge_sel_con_diff',
            (sim.pickup_cost_item + sim.pickup_cost_discount_item + sim.pickup_cost_vat_item) 'pickup_cost_item_sim',
            (con.pickup_cost_item + con.pickup_cost_discount_item + con.pickup_cost_vat_item) 'pickup_cost_item_con',
            (con.pickup_cost_item + con.pickup_cost_discount_item + con.pickup_cost_vat_item) - (sim.pickup_cost_item + sim.pickup_cost_discount_item + sim.pickup_cost_vat_item) 'pickup_con_sim_diff',
            (sel.pickup_cost_item + sel.pickup_cost_discount_item + sel.pickup_cost_vat_item) 'pickup_cost_item_sel',
            (sel.pickup_cost_item + sel.pickup_cost_discount_item + sel.pickup_cost_vat_item) - (sim.pickup_cost_item + sim.pickup_cost_discount_item + sim.pickup_cost_vat_item) 'pickup_sel_sim_diff',
            (sel.pickup_cost_item + sel.pickup_cost_discount_item + sel.pickup_cost_vat_item) - (con.pickup_cost_item + con.pickup_cost_discount_item + con.pickup_cost_vat_item) 'pickup_sel_con_diff',
            (sim.delivery_cost_item + sim.delivery_cost_discount_item + sim.delivery_cost_vat_item) 'delivery_cost_item_sim',
            (con.delivery_cost_item + con.delivery_cost_discount_item + con.delivery_cost_vat_item) 'delivery_cost_item_con',
            (con.delivery_cost_item + con.delivery_cost_discount_item + con.delivery_cost_vat_item) - (sim.delivery_cost_item + sim.delivery_cost_discount_item + sim.delivery_cost_vat_item) 'delcost_con_sim_diff',
            (sel.delivery_cost_item + sel.delivery_cost_discount_item + sel.delivery_cost_vat_item) 'delivery_cost_item_sel',
            (sel.delivery_cost_item + sel.delivery_cost_discount_item + sel.delivery_cost_vat_item) - (sim.delivery_cost_item + sim.delivery_cost_discount_item + sim.delivery_cost_vat_item) 'delcost_sel_sim_diff',
            (sel.delivery_cost_item + sel.delivery_cost_discount_item + sel.delivery_cost_vat_item) - (con.delivery_cost_item + con.delivery_cost_discount_item + con.delivery_cost_vat_item) 'delcost_sel_con_diff',
            CASE
                WHEN sim.is_marketplace = 0 THEN IFNULL(sim.shipping_surcharge, 0) / 1.1
                ELSE IFNULL(sim.shipping_surcharge, 0)
            END + CASE
                WHEN sim.is_marketplace = 0 THEN IFNULL(sim.shipping_amount, 0) / 1.1
                ELSE IFNULL(sim.shipping_amount, 0)
            END + sim.total_shipment_fee_mp_seller_item + sim.total_delivery_cost_item 'subsidy_item_sim',
            CASE
                WHEN con.is_marketplace = 0 THEN IFNULL(con.shipping_surcharge, 0) / 1.1
                ELSE IFNULL(con.shipping_surcharge, 0)
            END + CASE
                WHEN con.is_marketplace = 0 THEN IFNULL(con.shipping_amount, 0) / 1.1
                ELSE IFNULL(con.shipping_amount, 0)
            END + con.total_shipment_fee_mp_seller_item + con.total_delivery_cost_item 'subsidy_item_con',
            CASE
                WHEN sel.is_marketplace = 0 THEN IFNULL(sel.shipping_surcharge, 0) / 1.1
                ELSE IFNULL(sel.shipping_surcharge, 0)
            END + CASE
                WHEN sel.is_marketplace = 0 THEN IFNULL(sel.shipping_amount, 0) / 1.1
                ELSE IFNULL(sel.shipping_amount, 0)
            END + sel.total_shipment_fee_mp_seller_item + sel.total_delivery_cost_item 'subsidy_item_sel',
            CASE
                WHEN sim.chargeable_weight_3pl_ps / sim.qty_ps > 400 THEN 0
                WHEN con.chargeable_weight_3pl_ps / con.qty_ps > 400 THEN 0
                WHEN sel.chargeable_weight_3pl_ps / sel.qty_ps > 400 THEN 0
                WHEN sim.shipping_amount + sim.shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass'
    FROM
        scglv3.anondb_calculate sim
    LEFT JOIN scglv3_qv.anondb_calculate con ON sim.bob_id_sales_order_item = con.bob_id_sales_order_item
    LEFT JOIN scglv3.anondb_calculate_config sel ON con.bob_id_sales_order_item = sel.bob_id_sales_order_item
    WHERE
        sim.order_date >= @extractstart
            AND sim.order_date < @extractend
            AND (sim.seller_type = 'supplier'
            OR sim.tax_class = 'local')
    GROUP BY sim.bob_id_sales_order_item
    HAVING pass = 1) result