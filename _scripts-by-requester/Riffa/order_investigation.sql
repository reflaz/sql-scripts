SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.created_at,
    bsup.name 'seller_name',
    so.payment_method,
    cus.id_customer 'cust_id',
    cus.email 'cust_email',
    cus.first_name 'cust_name',
    soa.first_name 'cust_order_name',
    soa.address1 'cust_address',
    soa.city 'cust_city',
    bso.payment_method_obs 'cust_pymnt_desc',
    bso.ip 'cust_ip',
    sa.contact_name 'sel_contact',
    sa.street 'sel_address',
    sa.city 'sel_city',
    bsac.merchant_email,
    bsup.bank_account_bank 'sel_bank',
    bsup.bank_account_nr 'sel_bank_acct_nr',
    bsup.bank_account_name 'sel_bank_acct_name',
    bsac.current_login_ip 'sel_ip',
    pd.tracking_number,
    sp.shipment_provider_name
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
        LEFT JOIN
    oms_live.oms_package pck ON pi.fk_package = pck.id_package
        LEFT JOIN
    oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
        LEFT JOIN
    oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
        LEFT JOIN
    oms_live.ims_supplier sup ON soi.bob_id_supplier = sup.bob_id_supplier
        LEFT JOIN
    oms_live.ims_supplier_address sa ON sup.id_supplier = sa.fk_supplier
        LEFT JOIN
    bob_live.sales_order bso ON so.order_nr = bso.order_nr
        LEFT JOIN
    bob_live.supplier bsup ON sup.bob_id_supplier = bsup.id_supplier
        LEFT JOIN
    bob_live.supplier_account bsac ON bsup.id_supplier = bsac.fk_supplier
		LEFT JOIN
	bob_live.customer cus ON bso.fk_customer = cus.id_customer
WHERE
    so.order_nr IN ('327478969')
GROUP BY soi.id_sales_order_item