/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Simple-Config-Seller Package Weight Comparison

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
SET @extractend = '2017-08-01';-- This MUST be D + 1

SELECT 
    bu,
    selweight_con_sim_diff_flag,
    tplweight_con_sim_diff_flag,
    selcharge_con_sim_diff_flag,
    pickupost_con_sim_diff_flag,
    delivcost_con_sim_diff_flag,
    subsidy_con_sim_diff_flag,
    selweight_sel_sim_diff_flag,
    tplweight_sel_sim_diff_flag,
    selcharge_sel_sim_diff_flag,
    pickupost_sel_sim_diff_flag,
    delivcost_sel_sim_diff_flag,
    subsidy_sel_sim_diff_flag,
    selweight_sel_con_diff_flag,
    tplweight_sel_con_diff_flag,
    selcharge_sel_con_diff_flag,
    pickupost_sel_con_diff_flag,
    delivcost_sel_con_diff_flag,
    subsidy_sel_con_diff_flag,
    SUM(qty_ps) 'qty',
    
    SUM(chargeable_weight_seller_ps_sim) 'chargeable_weight_seller_ps_sim',
	SUM(chargeable_weight_3pl_ps_sim) 'chargeable_weight_3pl_ps_sim',
	SUM(shipment_fee_mp_seller_item_sim) 'shipment_fee_mp_seller_item_sim',
	SUM(pickup_cost_item_sim) 'pickup_cost_item_sim',
	SUM(delivery_cost_item_sim) 'delivery_cost_item_sim',
	SUM(subsidy_item_sim) 'subsidy_item_sim',
	SUM(chargeable_weight_seller_ps_con) 'chargeable_weight_seller_ps_con',
	SUM(chargeable_weight_3pl_ps_con) 'chargeable_weight_3pl_ps_con',
	SUM(shipment_fee_mp_seller_item_con) 'shipment_fee_mp_seller_item_con',
	SUM(pickup_cost_item_con) 'pickup_cost_item_con',
	SUM(delivery_cost_item_con) 'delivery_cost_item_con',
	SUM(subsidy_item_con) 'subsidy_item_con',
	SUM(chargeable_weight_seller_ps_sel) 'chargeable_weight_seller_ps_sel',
	SUM(chargeable_weight_3pl_ps_sel) 'chargeable_weight_3pl_ps_sel',
	SUM(shipment_fee_mp_seller_item_sel) 'shipment_fee_mp_seller_item_sel',
	SUM(pickup_cost_item_sel) 'pickup_cost_item_sel',
	SUM(delivery_cost_item_sel) 'delivery_cost_item_sel',
	SUM(subsidy_item_sel) 'subsidy_item_sel',
    
    SUM(selweight_con_sim_diff) 'selweight_con_sim_diff',
    SUM(tplweight_con_sim_diff) 'tplweight_con_sim_diff',
    SUM(selcharge_con_sim_diff) 'selcharge_con_sim_diff',
    SUM(pickupost_con_sim_diff) 'pickupost_con_sim_diff',
    SUM(delivcost_con_sim_diff) 'delivcost_con_sim_diff',
    SUM(subsidy_con_sim_diff) 'subsidy_con_sim_diff',
    SUM(selweight_sel_sim_diff) 'selweight_sel_sim_diff',
    SUM(tplweight_sel_sim_diff) 'tplweight_sel_sim_diff',
    SUM(selcharge_sel_sim_diff) 'selcharge_sel_sim_diff',
    SUM(pickupost_sel_sim_diff) 'pickupost_sel_sim_diff',
    SUM(delivcost_sel_sim_diff) 'delivcost_sel_sim_diff',
    SUM(subsidy_sel_sim_diff) 'subsidy_sel_sim_diff',
    SUM(selweight_sel_con_diff) 'selweight_sel_con_diff',
    SUM(tplweight_sel_con_diff) 'tplweight_sel_con_diff',
    SUM(selcharge_sel_con_diff) 'selcharge_sel_con_diff',
    SUM(pickupost_sel_con_diff) 'pickupost_sel_con_diff',
    SUM(delivcost_sel_con_diff) 'delivcost_sel_con_diff',
    SUM(subsidy_sel_con_diff) 'subsidy_sel_con_diff'
FROM
    (SELECT 
        *,
            chargeable_weight_seller_ps_con - chargeable_weight_seller_ps_sim 'selweight_con_sim_diff',
            chargeable_weight_3pl_ps_con - chargeable_weight_3pl_ps_sim 'tplweight_con_sim_diff',
            shipment_fee_mp_seller_item_con - shipment_fee_mp_seller_item_sim 'selcharge_con_sim_diff',
            pickup_cost_item_con - pickup_cost_item_sim 'pickupost_con_sim_diff',
            delivery_cost_item_con - delivery_cost_item_sim 'delivcost_con_sim_diff',
            subsidy_item_con - subsidy_item_sim 'subsidy_con_sim_diff',
            chargeable_weight_seller_ps_sel - chargeable_weight_seller_ps_sim 'selweight_sel_sim_diff',
            chargeable_weight_3pl_ps_sel - chargeable_weight_3pl_ps_sim 'tplweight_sel_sim_diff',
            shipment_fee_mp_seller_item_sel - shipment_fee_mp_seller_item_sim 'selcharge_sel_sim_diff',
            pickup_cost_item_sel - pickup_cost_item_sim 'pickupost_sel_sim_diff',
            delivery_cost_item_sel - delivery_cost_item_sim 'delivcost_sel_sim_diff',
            subsidy_item_sel - subsidy_item_sim 'subsidy_sel_sim_diff',
            chargeable_weight_seller_ps_sel - chargeable_weight_seller_ps_con 'selweight_sel_con_diff',
            chargeable_weight_3pl_ps_sel - chargeable_weight_3pl_ps_con 'tplweight_sel_con_diff',
            shipment_fee_mp_seller_item_sel - shipment_fee_mp_seller_item_con 'selcharge_sel_con_diff',
            pickup_cost_item_sel - pickup_cost_item_con 'pickupost_sel_con_diff',
            delivery_cost_item_sel - delivery_cost_item_con 'delivcost_sel_con_diff',
            subsidy_item_sel - subsidy_item_con 'subsidy_sel_con_diff',
            IF(ABS(MOD(chargeable_weight_seller_ps_con - chargeable_weight_seller_ps_sim, 1)) > 0, 1, 0) 'selweight_con_sim_diff_flag',
            IF(ABS(MOD(chargeable_weight_3pl_ps_con - chargeable_weight_3pl_ps_sim, 1)) > 0, 1, 0) 'tplweight_con_sim_diff_flag',
            IF(ABS(MOD(shipment_fee_mp_seller_item_con - shipment_fee_mp_seller_item_sim, 1)) > 0, 1, 0) 'selcharge_con_sim_diff_flag',
            IF(ABS(MOD(pickup_cost_item_con - pickup_cost_item_sim, 1)) > 0, 1, 0) 'pickupost_con_sim_diff_flag',
            IF(ABS(MOD(delivery_cost_item_con - delivery_cost_item_sim, 1)) > 0, 1, 0) 'delivcost_con_sim_diff_flag',
            IF(ABS(MOD(subsidy_item_con - subsidy_item_sim, 1)) > 0, 1, 0) 'subsidy_con_sim_diff_flag',
            IF(ABS(MOD(chargeable_weight_seller_ps_sel - chargeable_weight_seller_ps_sim, 1)) > 0, 1, 0) 'selweight_sel_sim_diff_flag',
            IF(ABS(MOD(chargeable_weight_3pl_ps_sel - chargeable_weight_3pl_ps_sim, 1)) > 0, 1, 0) 'tplweight_sel_sim_diff_flag',
            IF(ABS(MOD(shipment_fee_mp_seller_item_sel - shipment_fee_mp_seller_item_sim, 1)) > 0, 1, 0) 'selcharge_sel_sim_diff_flag',
            IF(ABS(MOD(pickup_cost_item_sel - pickup_cost_item_sim, 1)) > 0, 1, 0) 'pickupost_sel_sim_diff_flag',
            IF(ABS(MOD(delivery_cost_item_sel - delivery_cost_item_sim, 1)) > 0, 1, 0) 'delivcost_sel_sim_diff_flag',
            IF(ABS(MOD(subsidy_item_sel - subsidy_item_sim, 1)) > 0, 1, 0) 'subsidy_sel_sim_diff_flag',
            IF(ABS(MOD(chargeable_weight_seller_ps_sel - chargeable_weight_seller_ps_con, 1)) > 0, 1, 0) 'selweight_sel_con_diff_flag',
            IF(ABS(MOD(chargeable_weight_3pl_ps_sel - chargeable_weight_3pl_ps_con, 1)) > 0, 1, 0) 'tplweight_sel_con_diff_flag',
            IF(ABS(MOD(shipment_fee_mp_seller_item_sel - shipment_fee_mp_seller_item_con, 1)) > 0, 1, 0) 'selcharge_sel_con_diff_flag',
            IF(ABS(MOD(pickup_cost_item_sel - pickup_cost_item_con, 1)) > 0, 1, 0) 'pickupost_sel_con_diff_flag',
            IF(ABS(MOD(delivery_cost_item_sel - delivery_cost_item_con, 1)) > 0, 1, 0) 'delivcost_sel_con_diff_flag',
            IF(ABS(MOD(subsidy_item_sel - subsidy_item_con, 1)) > 0, 1, 0) 'subsidy_sel_con_diff_flag'
    FROM
        (SELECT 
        order_nr,
            bob_id_sales_order_item,
            id_package_dispatching,
            bob_id_supplier,
            bu,
            unit_price,
            paid_price,
            shipping_surcharge,
            shipping_amount,
            qty_ps,
            chargeable_weight_seller_ps_sim,
            chargeable_weight_3pl_ps_sim,
            SUM(shipment_fee_mp_seller_item_sim) 'shipment_fee_mp_seller_item_sim',
            SUM(pickup_cost_item_sim) 'pickup_cost_item_sim',
            SUM(delivery_cost_item_sim) 'delivery_cost_item_sim',
            SUM(subsidy_item_sim) 'subsidy_item_sim',
            chargeable_weight_seller_ps_con,
            chargeable_weight_3pl_ps_con,
            SUM(shipment_fee_mp_seller_item_con) 'shipment_fee_mp_seller_item_con',
            SUM(pickup_cost_item_con) 'pickup_cost_item_con',
            SUM(delivery_cost_item_con) 'delivery_cost_item_con',
            SUM(subsidy_item_con) 'subsidy_item_con',
            chargeable_weight_seller_ps_sel,
            chargeable_weight_3pl_ps_sel,
            SUM(shipment_fee_mp_seller_item_sel) 'shipment_fee_mp_seller_item_sel',
            SUM(pickup_cost_item_sel) 'pickup_cost_item_sel',
            SUM(delivery_cost_item_sel) 'delivery_cost_item_sel',
            SUM(subsidy_item_sel) 'subsidy_item_sel'
    FROM
        (SELECT 
        sim.order_nr,
            sim.bob_id_sales_order_item,
            sim.id_package_dispatching,
            sim.bob_id_supplier,
            sim.is_marketplace,
            sim.tax_class,
            sim.shipment_scheme,
            CASE
                WHEN sim.is_marketplace = 0 THEN 'RETAIL'
                WHEN sim.tax_class = 'international' THEN 'CB'
                WHEN sim.shipment_scheme LIKE '%DIRECT BILLING%' THEN 'DB'
                ELSE 'MA'
            END 'bu',
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
            sim.qty_ps,
            sim.chargeable_weight_seller_ps 'chargeable_weight_seller_ps_sim',
            sim.chargeable_weight_3pl_ps 'chargeable_weight_3pl_ps_sim',
            sim.shipment_fee_mp_seller_item 'shipment_fee_mp_seller_item_sim',
            sim.pickup_cost_item + sim.pickup_cost_discount_item + sim.pickup_cost_vat_item 'pickup_cost_item_sim',
            sim.delivery_cost_item + sim.delivery_cost_discount_item + sim.delivery_cost_vat_item 'delivery_cost_item_sim',
            CASE
                WHEN sim.is_marketplace = 0 THEN IFNULL(sim.shipping_surcharge, 0) / 1.1
                ELSE IFNULL(sim.shipping_surcharge, 0)
            END + CASE
                WHEN sim.is_marketplace = 0 THEN IFNULL(sim.shipping_amount, 0) / 1.1
                ELSE IFNULL(sim.shipping_amount, 0)
            END + sim.total_shipment_fee_mp_seller_item + sim.total_delivery_cost_item 'subsidy_item_sim',
            con.chargeable_weight_seller_ps 'chargeable_weight_seller_ps_con',
            con.chargeable_weight_3pl_ps 'chargeable_weight_3pl_ps_con',
            con.shipment_fee_mp_seller_item 'shipment_fee_mp_seller_item_con',
            con.pickup_cost_item + con.pickup_cost_discount_item + con.pickup_cost_vat_item 'pickup_cost_item_con',
            con.delivery_cost_item + con.delivery_cost_discount_item + con.delivery_cost_vat_item 'delivery_cost_item_con',
            sel.chargeable_weight_seller_ps 'chargeable_weight_seller_ps_sel',
            sel.chargeable_weight_3pl_ps 'chargeable_weight_3pl_ps_sel',
            sel.shipment_fee_mp_seller_item 'shipment_fee_mp_seller_item_sel',
            sel.pickup_cost_item + sel.pickup_cost_discount_item + sel.pickup_cost_vat_item 'pickup_cost_item_sel',
            sel.delivery_cost_item + sel.delivery_cost_discount_item + sel.delivery_cost_vat_item 'delivery_cost_item_sel',
            CASE
                WHEN sel.is_marketplace = 0 THEN IFNULL(sel.shipping_surcharge, 0) / 1.1
                ELSE IFNULL(sel.shipping_surcharge, 0)
            END + CASE
                WHEN sel.is_marketplace = 0 THEN IFNULL(sel.shipping_amount, 0) / 1.1
                ELSE IFNULL(sel.shipping_amount, 0)
            END + sel.total_shipment_fee_mp_seller_item + sel.total_delivery_cost_item 'subsidy_item_sel',
            CASE
                WHEN con.is_marketplace = 0 THEN IFNULL(con.shipping_surcharge, 0) / 1.1
                ELSE IFNULL(con.shipping_surcharge, 0)
            END + CASE
                WHEN con.is_marketplace = 0 THEN IFNULL(con.shipping_amount, 0) / 1.1
                ELSE IFNULL(con.shipping_amount, 0)
            END + con.total_shipment_fee_mp_seller_item + con.total_delivery_cost_item 'subsidy_item_con',
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
    GROUP BY order_nr , id_package_dispatching , bob_id_supplier) result) result
GROUP BY bu , selweight_con_sim_diff_flag , tplweight_con_sim_diff_flag , selcharge_con_sim_diff_flag , pickupost_con_sim_diff_flag , delivcost_con_sim_diff_flag , subsidy_con_sim_diff_flag , selweight_sel_sim_diff_flag , tplweight_sel_sim_diff_flag , selcharge_sel_sim_diff_flag , pickupost_sel_sim_diff_flag , delivcost_sel_sim_diff_flag , subsidy_sel_sim_diff_flag , selweight_sel_con_diff_flag , tplweight_sel_con_diff_flag , selcharge_sel_con_diff_flag , pickupost_sel_con_diff_flag , delivcost_sel_con_diff_flag , subsidy_sel_con_diff_flag;