SET @vip = 'ID100SO,ID100WE,ID100S4,ID102NU,ID10WHB,ID105JA,ID103RE,ID101DD,ID102N5,ID104B7,ID1015U,ID10BHK,ID1011D,ID1028A,ID10BUC,ID10EI3,ID101BP,ID10690,ID101MG,ID100SW,ID102X8,ID101AL,ID100PX,ID107Z3,ID102MO,ID107DI,ID103VC,ID1042T,ID101F1,ID108DX,ID10BC7,ID101WX,ID10W2Y,ID1017M,ID10BZ8,ID10846,ID10NN6,ID1011Z,ID10HTC,ID1017N,ID101E5,ID1018F,ID101PX,ID1042V,ID108XO,ID102P3,ID1028C,ID102T9,ID102GY,ID100NA,ID10F2A,ID101AZ,ID1056B,ID101SU,ID10TXL,ID102P5,ID10AUL,ID100S0,ID101ON,ID10211,ID10519,ID101EU,ID102DC,ID10BLS,ID10828,ID1011S,ID1038E,ID101EP,ID104WS,ID101J3,ID103KC,ID104PT,ID10SF7,ID10EJW,ID109ZM,ID10378,ID10B6H,ID10RN5,ID111GP,ID1045Y,ID102T2,ID1016W,ID10BN6,ID101HG,ID1022U,ID10KJU,ID1014A,ID1019J,ID103PE,ID101UX,ID100N7,ID100S5,ID108RU,ID106NU,ID100UZ,ID101EX,ID108L5,ID100M3,ID100SY,ID100X8,ID101C6,ID101W4,ID101X3,ID101Z7,ID10293,ID102RM,ID103GU,ID103UJ,ID1044G,ID1044R,ID1048X,ID104DB,ID105UR,ID10797,ID107V2,ID10HX4,ID10IW3,ID100R6,ID101DR,ID101GK,ID101JY,ID102YG,ID102Z4,ID103H4,ID103OU,ID103YX,ID10421,ID104CE,ID104CU,ID108BM,ID10B49,ID10T30,ID102S5,ID100UV,ID101DB,ID101WO,ID102EP,ID102KW,ID102TN,ID104BF,ID104XZ,ID1064A,ID107GC,ID107I0,ID108IB,ID10A5S,ID10BPB,ID10P1F,ID10TYU,ID100X2,ID1024C,ID102BM,ID102T5,ID102TJ,ID102WK,ID1035K,ID103EN,ID107VL,ID10CLY,ID10DHV,ID10OXM,ID101VC,ID10RCZ,ID103NB,ID102RH,ID108FM,ID102GM,ID103KN,ID10EUP,ID10726,ID101WN,ID102MJ,ID1077X,ID101SO,ID101ZE,ID101UN,ID10HSA,ID109OI,ID10296,ID10357,ID10CWZ,ID110K6,ID10YHW,ID109R0,ID10EWL,ID10UUM,ID10346,ID116FL,ID115X7,ID116CS,ID115Y6,ID116CT,ID115X6,ID1161U,ID1187N,ID1091B,ID117LK,ID10315,ID102VV,ID119RL,ID10RT0,ID10T3O,ID102C1,ID101XF,ID102WW,ID10V2I,ID1090Z,ID1014V,ID112DT,ID10BN0,ID105JJ,ID10118,ID108T6,ID101CU,ID100VP,ID10YOS,ID110UP,ID1017B,ID104OP,ID114WJ,ID102ZW,ID10NRA,ID101MC,ID11A95';
SET @rsp = 'ID115X3,ID116ZD,ID1172K,ID115TZ,ID117MG,ID116LM,ID116YX,ID115XX,ID117GP,ID116YU,ID116WW,ID10XGT,ID1175N,ID117E3,ID117D8,ID117DW,ID1163P,ID117LF,ID116XH,ID115X0,ID116ZT,ID117BB,ID117MB,ID11731,ID1179C,ID117NI,ID117HD,ID117DF,ID115U0,ID11822,ID1176G,ID117LP,ID1176B,ID117MW,ID117MZ,ID1172I,ID117LV,ID116BL,ID11737,ID116P9,ID1172H,ID10VCZ,ID117KN,ID1177N,ID116HI,ID11868,ID117C2,ID117N9,ID117E4,ID116WI,ID11760,ID117YK,ID117W1,ID117SA,ID116MN,ID117CF,ID1175W,ID118JJ,ID117BX,ID116V7,ID116DF,ID116PB,ID118DF,ID116UC,ID116RY,ID118GV,ID116L2,ID117ER,ID116YV,ID116WJ,ID11732,ID117KJ,ID1177A,ID117CH,ID117DL,ID117EK,ID1175V,ID1172L,ID117RP,ID117OJ,ID117Z2,ID118CJ,ID1163S,ID118B2,ID1186G,ID11833,ID118DI,ID102KG,ID115XS,ID116MY,ID11762,ID1179S,ID10I1J,ID117MD,ID117EN,ID117EO,ID117OF,ID11886,ID118DV,ID117OL,ID118EY,ID118EZ,ID118N5,ID118OE,ID117NB,ID117NO,ID1182D,ID118NA,ID1181V,ID1186T,ID119SZ,ID119VA,ID119SK,ID119Z8,ID119YH,ID119WN,ID119SH,ID119XN,ID11AEB,ID11AEC,ID11AIE,ID11AE3,ID11AB2,ID111TZ,ID119YX,ID11ACN,ID11AAR,ID11AB0,ID11ACM,ID119M8,ID11AEM,ID11ARF,ID11A4W,ID11BD6,ID11AD8,ID11B63,ID11BAL,ID118LW,ID11B79,ID11BH1,ID11B9T,ID11BDK,ID11B7U,ID11BB5,ID11BE3,ID11ATO,ID11C78,ID11BXA,ID11CTM,ID11CXN,ID11D6Y';

SELECT 
    bob_id_supplier,
    sel.short_code,
    sel.name,
    sel.tax_class,
    CASE
        WHEN FIND_IN_SET(sel.short_code, @vip) THEN 'VIP'
        WHEN FIND_IN_SET(sel.short_code, @rsp) THEN 'RSP'
        ELSE ''
    END 'campaign',
    unit_price_aug,
    paid_price_aug,
    shipping_amount_aug,
    shipping_surcharge_aug,
    soi_aug,
    so_aug,
    SUM(IF(cs.created_at < '2016-09-01', 1, 0)) 'total_sku_aug',
    unit_price_sep,
    paid_price_sep,
    shipping_amount_sep,
    shipping_surcharge_sep,
    soi_sep,
    so_sep,
    COUNT(cs.id_catalog_product) 'total_sku_sep'
FROM
    (SELECT 
        soi.bob_id_supplier,
            so.order_nr,
            SUM(IF(so.created_at < '2016-09-01', soi.unit_price, 0)) 'unit_price_aug',
            SUM(IF(so.created_at < '2016-09-01', soi.paid_price, 0)) 'paid_price_aug',
            SUM(IF(so.created_at < '2016-09-01', soi.shipping_amount, 0)) 'shipping_amount_aug',
            SUM(IF(so.created_at < '2016-09-01', soi.shipping_surcharge, 0)) 'shipping_surcharge_aug',
            COUNT(DISTINCT IF(so.created_at < '2016-09-01', so.order_nr, NULL)) 'so_aug',
            SUM(IF(so.created_at < '2016-09-01', 1, 0)) 'soi_aug',
            SUM(IF(so.created_at >= '2016-09-01', soi.unit_price, 0)) 'unit_price_sep',
            SUM(IF(so.created_at >= '2016-09-01', soi.paid_price, 0)) 'paid_price_sep',
            SUM(IF(so.created_at >= '2016-09-01', soi.shipping_amount, 0)) 'shipping_amount_sep',
            SUM(IF(so.created_at >= '2016-09-01', soi.shipping_surcharge, 0)) 'shipping_surcharge_sep',
            SUM(IF(so.created_at >= '2016-09-01', 1, 0)) 'soi_sep',
            COUNT(DISTINCT IF(so.created_at >= '2016-09-01', so.order_nr, NULL)) 'so_sep'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
    WHERE
        so.created_at >= '2016-08-01'
            AND so.created_at < '2016-10-01'
    GROUP BY soi.bob_id_supplier) result
        LEFT JOIN
    screport.seller sel ON result.bob_id_supplier = sel.src_id
        LEFT JOIN
    screport.catalog_product cs ON sel.id_seller = cs.fk_seller
GROUP BY result.bob_id_supplier
HAVING short_code IS NOT NULL