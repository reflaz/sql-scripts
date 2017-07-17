/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Customer Payment Details (BCA BT) by BOB SOI
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Go to your excel file
				  - Format the parameters in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameters
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    so.order_nr, soi.id_sales_order_item, custname 'payer_name'
FROM
    bob_live.sales_order_item soi
        LEFT JOIN
    bob_live.sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    bob_live.payment_bca_bank_transfer_response pbr ON so.order_nr = pbr.orderNr
		LEFT JOIN
	asc_live.sales_order aso ON so.id_sales_order = aso.src_id
WHERE
    soi.id_sales_order_item IN ()