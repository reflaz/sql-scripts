/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Recon COD AR List
 
Prepared by		: Michael Julius
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    *
FROM
    (SELECT 
        IF(shipment_provider = incoming_shipment_provider
                AND package_number = incoming_package_number
                AND tracking_number = incoming_tracking_number
                AND total_paid_by_customer = incoming_total_paid_by_customer, 'RECON', 'NOT RECON') AS recon_status,
            id_shipment_provider,
            shipment_provider,
            order_nr,
            bob_id_sales_order_item,
            package_number,
            tracking_number,
            item_name,
            last_status,
            last_status_date,
            delivered_date,
            paid_price,
            shipping_amount,
            shipping_surcharge,
            total_paid_by_customer,
            incoming_shipment_provider,
            incoming_package_number,
            incoming_tracking_number,
            incoming_doc_date,
            incoming_paid_price,
            incoming_shipping_amount,
            incoming_shipping_surcharge,
            incoming_total_paid_by_customer,
            IF(shipment_provider = incoming_shipment_provider, 'RECON', 'NOT RECON') AS shipment_provider_remarks,
            IF(package_number = incoming_package_number, 'RECON', 'NOT RECON') AS package_number_remarks,
            IF(tracking_number = incoming_tracking_number, 'RECON', 'NOT RECON') AS tracking_number_remarks,
            IF(total_paid_by_customer - incoming_total_paid_by_customer > 100, 'NOT RECON', 'RECON') AS paid_by_customer_remarks
    FROM
        (SELECT 
			pop.id_shipment_provider,
			pop.shipment_provider,
            pop.order_nr,
            pop.bob_id_sales_order_item,
            pop.package_number,
            pop.tracking_number,
            pop.item_name,
            pop.last_status,
            pop.last_status_date,
            pop.delivered_date,
            pop.paid_price,
            pop.shipping_amount,
            pop.shipping_surcharge,
            pop.total_paid_by_customer,
            inc.package_number AS incoming_package_number,
            inc.tracking_number AS incoming_tracking_number,
            inc.paid_price AS incoming_paid_price,
            inc.unit_price AS incoming_unit_price,
            inc.shipping_amount AS incoming_shipping_amount,
            inc.shipping_surcharge AS incoming_shipping_surcharge,
            (inc.paid_price + inc.shipping_amount + inc.shipping_surcharge) AS incoming_total_paid_by_customer,
            inc.shippingprovider AS incoming_shipment_provider,
            inc.doc_date AS incoming_doc_date
    FROM
        cod_ar_recon.ar_population pop
    INNER JOIN cod_ar_recon.incoming_ar inc ON pop.bob_id_sales_order_item = inc.bob_id_sales_order_item) fin) result
