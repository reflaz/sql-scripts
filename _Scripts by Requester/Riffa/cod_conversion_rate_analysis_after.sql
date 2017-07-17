SET @extractstart = '2016-06-01';
SET @extractend = '2016-09-01';

SELECT 
    short_code 'Seller ID',
    name 'Seller Name',
    enable_cod 'COD Enabled',
    order_nr 'Order No.',
    bob_id_sales_order_item 'BOB SOI',
    paid_price 'Paid Price',
    payment_method 'Payment Method',
    created_at 'Order Created Date',
    delivered_date 'Delivered Update Date'
FROM
    (SELECT 
        sel.short_code,
            sel.name,
            ss.enable_cod,
            so.order_nr,
            soi.bob_id_sales_order_item,
            soi.paid_price,
            so.payment_method,
            so.created_at,
            CASE
				WHEN soi.bob_id_supplier  = '2077' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4709' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '7590' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '9703' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4777' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4719' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '11238' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4369' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '6012' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '6346' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '35441' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4862' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '10786' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2389' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '20042' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2439' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '5030' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '7377' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3423' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2768' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '10678' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '7374' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '20841' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '44072' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '37391' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1706' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '22056' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '33607' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2742' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2199' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3439' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '16632' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '38078' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '37536' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2502' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2537' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '21825' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '33481' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '32830' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '14280' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '23195' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1128' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '34832' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '13976' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '32494' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '12851' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '38163' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4520' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '7418' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1382' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '11077' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '47570' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '6531' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1481' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1596' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3578' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '42857' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '17496' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1941' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3857' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2855' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '14096' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '16550' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2479' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3284' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '6350' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '27864' THEN IF(so.created_at >= '2016-06-01' AND so.created_at < '2016-07-01', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '37792' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4264' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3435' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '46441' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '32304' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '35484' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1062' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '10256' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '12524' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '29290' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '38876' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '5108' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3418' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '916' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4188' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2006' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4998' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '10944' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '25194' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1747' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '10540' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2422' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3382' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '18190' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1805' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4274' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '5334' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '13624' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1691' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3453' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4255' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4661' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '5300' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '30675' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1122' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2857' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '9646' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2287' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51143' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50942' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50946' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51172' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51401' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51402' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51104' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51213' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51254' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51157' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51530' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51403' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51404' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51255' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1136' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51202' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51163' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51268' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '46949' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '42776' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51481' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51252' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51281' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51340' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '13477' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51344' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51337' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51168' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50306' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '48559' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49573' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51516' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51906' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51399' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51457' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51486' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51462' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51422' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51583' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51582' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51581' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51500' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '29146' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51694' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51553' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51700' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51562' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51699' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '9508' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51689' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '11278' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51576' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51687' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51727' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51409' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51410' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51412' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51537' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51671' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50854' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1045' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49153' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49562' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49468' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '44729' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49739' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49636' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50295' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50630' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3166' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50014' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50332' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50673' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50771' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50672' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3834' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '16852' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '20748' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '23541' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '37453' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '48345' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50289' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '17930' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '1707' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50842' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51540' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50122' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51428' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50895' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '4457' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '13017' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '13018' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50976' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51140' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51164' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '42074' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '47406' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51484' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50274' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50294' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '11883' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '48960' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50815' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51196' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51165' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '10102' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51740' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51774' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51773' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51739' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51437' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51385' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51487' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51492' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51491' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51458' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51564' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51692' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51702' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51485' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51552' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51341' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51111' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '48706' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50123' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50127' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50161' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50302' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50279' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50124' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50126' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '32382' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3312' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '43581' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50151' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52089' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52140' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52092' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52094' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52090' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52074' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52199' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52192' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52077' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52062' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52193' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52179' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52187' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52188' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52148' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52147' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52195' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52167' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52207' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52073' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52220' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52218' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52222' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52221' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52185' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52170' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51833' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52099' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52098' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52131' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52104' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52112' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52200' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49720' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49699' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49691' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51623' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52245' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52265' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52035' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49234' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '48404' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '48351' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '22104' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51913' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51656' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '11071' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52224' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52300' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52298' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52293' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52247' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52256' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '2348' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '45883' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '30161' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51362' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52083' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52153' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52130' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51655' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51872' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52236' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51792' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51028' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52231' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52254' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52233' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51777' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51887' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51885' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51920' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52182' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '21324' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '25111' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '32642' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '41816' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '46345' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '6082' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '41462' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52385' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52318' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52381' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52321' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52302' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '49216' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51944' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '47087' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '7348' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '48894' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '48873' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51541' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52461' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52463' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52466' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52471' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52460' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '47676' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52475' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52507' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52468' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52486' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52362' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52425' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52422' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52421' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52481' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52513' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52464' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52506' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52448' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52432' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '3449' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '48879' THEN IF(so.created_at >= '2016-07-01' AND so.created_at < '2016-07-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '6005' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '36883' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52943' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '53198' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '51637' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '53173' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52666' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '52846' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '50825' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54391' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54416' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54395' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54399' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54560' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54400' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54401' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54441' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54255' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54513' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54567' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54629' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54628' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54698' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54710' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54681' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54507' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54645' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54625' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54699' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54694' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54715' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54831' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54862' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '47881' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54678' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54891' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54727' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54180' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54462' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54212' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '54960' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
				WHEN soi.bob_id_supplier  = '11935' THEN IF(so.created_at >= '2016-08-01' AND so.created_at < '2016-08-31', soish.created_at, NULL)
            END 'delivered_date'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_shop ss ON sup.id_supplier = ss.fk_supplier
    LEFT JOIN screport.seller sel ON soi.bob_id_supplier = sel.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND soi.bob_id_supplier IN ('2077',
'4709',
'7590',
'9703',
'4777',
'4719',
'11238',
'4369',
'6012',
'6346',
'35441',
'4862',
'10786',
'2389',
'20042',
'2439',
'5030',
'7377',
'3423',
'2768',
'10678',
'7374',
'20841',
'44072',
'37391',
'1706',
'22056',
'33607',
'2742',
'2199',
'3439',
'16632',
'38078',
'37536',
'2502',
'2537',
'21825',
'33481',
'32830',
'14280',
'23195',
'1128',
'34832',
'13976',
'32494',
'12851',
'38163',
'4520',
'7418',
'1382',
'11077',
'47570',
'6531',
'1481',
'1596',
'3578',
'42857',
'17496',
'1941',
'3857',
'2855',
'14096',
'16550',
'2479',
'3284',
'6350',
'27864',
'37792',
'4264',
'3435',
'46441',
'32304',
'35484',
'1062',
'10256',
'12524',
'29290',
'38876',
'5108',
'3418',
'916',
'4188',
'2006',
'4998',
'10944',
'25194',
'1747',
'10540',
'2422',
'3382',
'18190',
'1805',
'4274',
'5334',
'13624',
'1691',
'3453',
'4255',
'4661',
'5300',
'30675',
'1122',
'2857',
'9646',
'2287',
'51143',
'50942',
'50946',
'51172',
'51401',
'51402',
'51104',
'51213',
'51254',
'51157',
'51530',
'51403',
'51404',
'51255',
'1136',
'51202',
'51163',
'51268',
'46949',
'42776',
'51481',
'51252',
'51281',
'51340',
'13477',
'51344',
'51337',
'51168',
'50306',
'48559',
'49573',
'51516',
'51906',
'51399',
'51457',
'51486',
'51462',
'51422',
'51583',
'51582',
'51581',
'51500',
'29146',
'51694',
'51553',
'51700',
'51562',
'51699',
'9508',
'51689',
'11278',
'51576',
'51687',
'51727',
'51409',
'51410',
'51412',
'51537',
'51671',
'50854',
'1045',
'49153',
'49562',
'49468',
'44729',
'49739',
'49636',
'50295',
'50630',
'3166',
'50014',
'50332',
'50673',
'50771',
'50672',
'3834',
'16852',
'20748',
'23541',
'37453',
'48345',
'50289',
'17930',
'1707',
'50842',
'51540',
'50122',
'51428',
'50895',
'4457',
'13017',
'13018',
'50976',
'51140',
'51164',
'42074',
'47406',
'51484',
'50274',
'50294',
'11883',
'48960',
'50815',
'51196',
'51165',
'10102',
'51740',
'51774',
'51773',
'51739',
'51437',
'51385',
'51487',
'51492',
'51491',
'51458',
'51564',
'51692',
'51702',
'51485',
'51552',
'51341',
'51111',
'48706',
'50123',
'50127',
'50161',
'50302',
'50279',
'50124',
'50126',
'32382',
'3312',
'43581',
'50151',
'52089',
'52140',
'52092',
'52094',
'52090',
'52074',
'52199',
'52192',
'52077',
'52062',
'52193',
'52179',
'52187',
'52188',
'52148',
'52147',
'52195',
'52167',
'52207',
'52073',
'52220',
'52218',
'52222',
'52221',
'52185',
'52170',
'51833',
'52099',
'52098',
'52131',
'52104',
'52112',
'52200',
'49720',
'49699',
'49691',
'51623',
'52245',
'52265',
'52035',
'49234',
'48404',
'48351',
'22104',
'51913',
'51656',
'11071',
'52224',
'52300',
'52298',
'52293',
'52247',
'52256',
'2348',
'45883',
'30161',
'51362',
'52083',
'52153',
'52130',
'51655',
'51872',
'52236',
'51792',
'51028',
'52231',
'52254',
'52233',
'51777',
'51887',
'51885',
'51920',
'52182',
'21324',
'25111',
'32642',
'41816',
'46345',
'6082',
'41462',
'52385',
'52318',
'52381',
'52321',
'52302',
'49216',
'51944',
'47087',
'7348',
'48894',
'48873',
'51541',
'52461',
'52463',
'52466',
'52471',
'52460',
'47676',
'52475',
'52507',
'52468',
'52486',
'52362',
'52425',
'52422',
'52421',
'52481',
'52513',
'52464',
'52506',
'52448',
'52432',
'3449',
'48879',
'6005',
'36883',
'52943',
'53198',
'51637',
'53173',
'52666',
'52846',
'50825',
'54391',
'54416',
'54395',
'54399',
'54560',
'54400',
'54401',
'54441',
'54255',
'54513',
'54567',
'54629',
'54628',
'54698',
'54710',
'54681',
'54507',
'54645',
'54625',
'54699',
'54694',
'54715',
'54831',
'54862',
'47881',
'54678',
'54891',
'54727',
'54180',
'54462',
'54212',
'54960',
'11935')
    HAVING delivered_date IS NOT NULL) result