/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Key Metrics Summarization - NMV Summary by Zone Type
 
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

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-03-21';
SET @extractend = '2017-03-22'; -- This MUST be D + 1

-- WARNING! Only change this part whenever there's update!
SET @sku = 'LE629ELAA8PAOBANID-20509497,LE629ELAA8PAOAANID-20509496,EV556ELAA92LI6ANID-21198389,DE826ELAA3828KANID-6119376,DE826ELAA87II4ANID-19584751,DE826ELAA87I8JANID-19584326,DE826ELAA88Q9OANID-19647340,DE826ELAA88Q47ANID-19647115,DE826ELAA88Q9RANID-19647343,DE826ELAA2OXRVANID-4966924,PA302TLAKTDIANID-565308,JB044ELAA43ZNDANID-8011518,JB044ELAA43ZNCANID-8011517,JB044ELAA43ZN8ANID-8011513,HO476HLAQZOJANID-606597,NO457OTAA7QNO5ANID-18724021,MA786HBAA4XMONANID-9830685,BC680ELAA2VJWUANID-5355387,BC680ELAA2SYMZANID-5199301,SH866ELAA4MKP1ANID-9123215,NO749ELAA8CX74ANID-19872544,NO749ELAA8C4VTANID-19828646,AQ641HAAA70E6SANID-17217098,ME421TBAA7L1UWANID-18405126,QL818FAAQVF2ANID-599282,QL818FAAQVF3ANID-599283,NA414OTAA37EICANID-6084412,NA414OTAA562VRANID-10389192,NA414OTAA586NQANID-10515096,HI758ELAA5CPA0ANID-10794767,HI758ELAA5CP9YANID-10794765,XL713VCAA581WKANID-10507004,OV162WNAA8TUMXANID-20740398,MI454HLAA4ITQFANID-8910782,MI454HLAA4ITQEANID-8910781,MI454HLAA4ITQBANID-8910778,MU545FAAA708JNANID-17199948, DE826ELAA87II4ANID-19584751 , DE826ELAA87I8JANID-19584326 , DE826ELAA88Q9OANID-19647340 , DE826ELAA88Q47ANID-19647115 , DE826ELAA88Q9RANID-19647343 ,DE826ELAA3828KANID-6119376,SA848ELAA8C6KQANID-19831650,SA848ELAA8C6KRANID-19831651,UN836ELAA5RBEWANID-11831752,UN836ELAA5RBEOANID-11831744,LO651ELAA6C7POANID-14638481,PU069HAAA96YXXANID-21443768 ,PA302OTAA4C3ADANID-8475807,AI193HBAA2RZEMANID-5143711,PU069HAAA96YXYANID-21443769,KO406ELAA5D7JDANID-10824059,KO406ELCI2QSANID-3018031,LE629ELAA8PAOBANID-20509497,LE629ELAA8PAOAANID-20509496,XI619ELBSLT7ANID-2117370,DA790OTAA5CVJ8ANID-10803498 ,DE826ELAA5B8Y4ANID-10711394,SA848ELAA4BG47ANID-8433843,SA848ELAA39AS6ANID-6186969,HO476HLAA5PGB7ANID-11587488,HO476HLAA5PGB4ANID-11587486,HO476HLAA3SCBVANID-7295614,HO476HLAA5PGB6ANID-11587487,LE629ELAA8PAOAANID-20509496,GO635OTAA4U3ACANID-9622252,LE185FAAA8U2TTANID-20753152,LE185FAAA8U2TTANID-20753153,LE185FAAA8U2TTANID-20753154,LE185FAAA8U2TTANID-20753155,LE185FAAA8U2TTANID-20753156,LE185FAAA8U2TTANID-20753157,LE185FAAA8U2TTANID-20753158,LE185FAAA8U2TTANID-20753159,LE185FAAA8U2TTANID-20753160,LE185FAAA8U2TUANID-20753161,LE185FAAA8U2TUANID-20753163,LE185FAAA8U2TUANID-20753164,LE185FAAA8U2TUANID-20753165,LE185FAAA8U2TUANID-20753166,LE185FAAA8U2TUANID-20753167,LE185FAAA8U2TUANID-20753168,LE185FAAA8U2TUANID-20753169,LE185FAAA8U2TUANID-20753162,MA786HBAA4XOVWANID-9833835';

-- WARNING! DO NOT CHANGE THIS PART, EVER!!
SET @lvl = 0;

SELECT 
    sku,
    COUNT(DISTINCT order_nr) 'count_so',
    COUNT(bob_id_sales_order_item) 'count_soi',
    SUM(nmv) 'total_nmv',
    AVG(unit_price) 'avg_unit_price'
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            soi.sku,
            soi.unit_price,
            IFNULL(soi.paid_price / 1.1, 0) + IFNULL(soi.shipping_surcharge / 1.1, 0) + IFNULL(soi.shipping_amount / 1.1, 0) + IF(so.fk_voucher_type <> 3, IFNULL(soi.coupon_money_value / 1.1, 0), 0) 'nmv'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 67
                AND created_at < @extractend)
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND FIND_IN_SET(soi.sku, @sku)
    GROUP BY soi.bob_id_sales_order_item) result
GROUP BY sku