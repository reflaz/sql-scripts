/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipment Provider Extract

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
    id_shipment_provider,
    shipment_provider_name,
    '' AS 'fk_shipment_scheme',
    '' AS 'bulky_item_lower',
    '' AS 'bulky_item_upper',
    '' AS 'volumetric_constant',
    '' AS 'weight_rounding',
    '' AS 'shipment_fee_mp_seller_rate',
    '' AS 'shipment_cost_discount',
    '' AS 'shipment_cost_vat',
    '' AS 'pickup_cost',
    '' AS 'pickup_cost_discount',
    '' AS 'pickup_cost_vat',
    '' AS 'insurance_rate',
    '' AS 'insurance_vat',
    1 AS 'active'
FROM
    oms_live.oms_shipment_provider
WHERE
    id_shipment_provider NOT IN ()
ORDER BY id_shipment_provider;