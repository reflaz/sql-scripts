SET @extractstart = '2017-02-01'; -- Start_Date
SET @extractend = '2017-03-01';-- End_Date + D1

SELECT 
    bank,
    tenor,
    SUM(from_customer) 'from_customer',
    mdr_rate,
    SUM(mdr) 'mdr'
FROM
    (SELECT 
        so.order_nr,
            soi.id_sales_order_item,
            so.payment_method,
            soish.created_at AS ovip_date,
            soi.paid_price,
            soi.shipping_surcharge,
            soi.shipping_amount,
            ins.tenor,
            (IFNULL(soi.paid_price, 0) + IFNULL(soi.shipping_surcharge, 0) + IFNULL(soi.shipping_amount, 0)) 'from_customer',
            CASE
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%mandiri%' THEN 'MANDIRI'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bni%' THEN 'BNI'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bank negara indonesia%' THEN 'BNI'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%ANZ%' THEN 'ANZ'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BII%' THEN 'BII'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Internasional Indonesia%' THEN 'BII'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BRI%' THEN 'BRI'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Rakyat Indonesia%' THEN 'BRI'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%CIMB%' THEN 'CIMB'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Citibank%' THEN 'CITIBANK'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Danamon%' THEN 'DANAMON'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%HSBC%' THEN 'HSBC'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%OCBC%' THEN 'OCBC'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Permata%' THEN 'PERMATA'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Standard Chartered%' THEN 'STANDARD CHARTERED'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%UOB%' THEN 'UOB'
                WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Bukopin%' THEN 'BUKOPIN'
                ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1)
            END 'bank',
            CASE
                WHEN
                    ins.tenor = 3
                THEN
                    CASE
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%mandiri%' THEN '2.50%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bni%' THEN '1.35%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bank negara indonesia%' THEN '1.35%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%ANZ%' THEN '2.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BII%' THEN '3.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Internasional Indonesia%' THEN '3.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BRI%' THEN '2.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Rakyat Indonesia%' THEN '2.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%CIMB%' THEN '2.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Citibank%' THEN '1.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Danamon%' THEN '1.30%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%HSBC%' THEN '3.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%OCBC%' THEN '2.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Permata%' THEN '2.50%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Standard Chartered%' THEN '2.50%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%UOB%' THEN '1.30%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Bukopin%' THEN '2.00%'
                        ELSE 0
                    END
                WHEN
                    ins.tenor = 6
                THEN
                    CASE
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%mandiri%' THEN '4.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bni%' THEN '2.35%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bank negara indonesia%' THEN '2.35%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%ANZ%' THEN '3.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BII%' THEN '4.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Internasional Indonesia%' THEN '4.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BRI%' THEN '2.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Rakyat Indonesia%' THEN '2.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%CIMB%' THEN '4.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Citibank%' THEN '3.50%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Danamon%' THEN '2.30%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%HSBC%' THEN '4.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%OCBC%' THEN '3.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Permata%' THEN '4.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Standard Chartered%' THEN '2.50%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%UOB%' THEN '2.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Bukopin%' THEN '3.00%'
                        ELSE 0
                    END
                WHEN
                    ins.tenor = 12
                THEN
                    CASE
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%mandiri%' THEN '6.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bni%' THEN '4.35%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bank negara indonesia%' THEN '4.35%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%ANZ%' THEN '5.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BII%' THEN '5.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Internasional Indonesia%' THEN '5.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BRI%' THEN '2.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Rakyat Indonesia%' THEN '2.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%CIMB%' THEN '6.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Citibank%' THEN '5.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Danamon%' THEN '4.20%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%HSBC%' THEN '4.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%OCBC%' THEN '4.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Permata%' THEN '6.00%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Standard Chartered%' THEN '4.50%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%UOB%' THEN '3.50%'
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Bukopin%' THEN '4.00%'
                        ELSE 0
                    END
                ELSE 0
            END 'mdr_rate',
            IFNULL(CASE
                WHEN
                    ins.tenor = 3
                THEN
                    CASE
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%mandiri%' THEN 2.5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bni%' THEN 1.35 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bank negara indonesia%' THEN 1.35 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%ANZ%' THEN 2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BII%' THEN 3 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Internasional Indonesia%' THEN 3 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BRI%' THEN 2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Rakyat Indonesia%' THEN 2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%CIMB%' THEN 2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Citibank%' THEN 1 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Danamon%' THEN 1.3 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%HSBC%' THEN 3 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%OCBC%' THEN 2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Permata%' THEN 2.5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Standard Chartered%' THEN 2.5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%UOB%' THEN 1.3 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Bukopin%' THEN 2 / 100
                        ELSE 0
                    END
                WHEN
                    ins.tenor = 6
                THEN
                    CASE
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%mandiri%' THEN 4 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bni%' THEN 2.35 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bank negara indonesia%' THEN 2.35 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%ANZ%' THEN 3 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BII%' THEN 4 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Internasional Indonesia%' THEN 4 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BRI%' THEN 2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Rakyat Indonesia%' THEN 2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%CIMB%' THEN 4 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Citibank%' THEN 3.5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Danamon%' THEN 2.3 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%HSBC%' THEN 4 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%OCBC%' THEN 3 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Permata%' THEN 4 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Standard Chartered%' THEN 2.5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%UOB%' THEN 2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Bukopin%' THEN 3 / 100
                        ELSE 0
                    END
                WHEN
                    ins.tenor = 12
                THEN
                    CASE
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%mandiri%' THEN 6 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bni%' THEN 4.35 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%bank negara indonesia%' THEN 4.35 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%ANZ%' THEN 5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BII%' THEN 5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Internasional Indonesia%' THEN 5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%BRI%' THEN 2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Rakyat Indonesia%' THEN 2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%CIMB%' THEN 6 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Citibank%' THEN 5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Danamon%' THEN 4.2 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%HSBC%' THEN 4 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%OCBC%' THEN 4 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Permata%' THEN 6 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Standard Chartered%' THEN 4.5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%UOB%' THEN 3.5 / 100
                        WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(pdr.raw_response, '</BANK>', 1), '<BANK>', - 1) LIKE '%Bukopin%' THEN 4 / 100
                        ELSE 0
                    END
                ELSE 0
            END, 0) * (IFNULL(soi.paid_price, 0) + IFNULL(soi.shipping_surcharge, 0) + IFNULL(soi.shipping_amount, 0)) 'mdr'
    FROM
        (SELECT 
        id_sales_order, order_nr, payment_method
    FROM
        oms_live.ims_sales_order
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
    HAVING payment_method IN ('DOKUInstallment')) so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 69
    LEFT JOIN bob_live.sales_order_item bsoi ON soi.bob_id_sales_order_item = bsoi.id_sales_order_item
    LEFT JOIN bob_live.sales_order_instalment ins ON so.order_nr = ins.order_nr
    LEFT JOIN bob_live.payment_dokuinstallment_response pdr ON bsoi.fk_sales_order = pdr.fk_sales_order
    GROUP BY soi.id_sales_order_item
    HAVING ovip_date IS NOT NULL) result
GROUP BY bank , tenor