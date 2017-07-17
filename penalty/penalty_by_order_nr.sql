/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Penalty

Prepared by		: R Maliangkay
Modified by		: RM
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
    tr.created_at 'entry_date',
    sel.name 'seller_name',
    sel.short_code 'seller_id',
    so.order_nr,
    tr.value 'amount',
    tr.description
FROM
    asc_live.sales_order so
        LEFT JOIN
    asc_live.sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    asc_live.transaction tr ON soi.id_sales_order_item = tr.ref
        LEFT JOIN
    asc_live.seller sel ON tr.fk_seller = sel.id_seller
WHERE
    so.order_nr IN ()
        AND tr.fk_transaction_type IN ('37')
        AND tr.description LIKE '%penalty%'