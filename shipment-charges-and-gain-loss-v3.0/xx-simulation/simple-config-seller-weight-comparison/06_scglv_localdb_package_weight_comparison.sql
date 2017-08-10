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
SET @extractend = '2017-07-02';-- This MUST be D + 1


SELECT 
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
    GROUP BY sim.bob_id_sales_order_item) result
GROUP BY order_nr , id_package_dispatching , bob_id_supplier