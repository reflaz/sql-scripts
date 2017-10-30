SET @extractstart = '2015-12-27';
SET @extractend = '2016-07-13';
SET @sku = 'XI619ELAA1VHRTANID-3464623,SA850ELATGGPANID-754490,XI619ELAA4EH9IANID-8629295,IN848ELBCH8QANID-1243298,IN848ELBERX1ANID-1359166,IN848ELCHKE0ANID-2982992,IN848ELCHKF3ANID-2983031,ME826ELAA3CO1FANID-6389457,XI619ELAA31H8LANID-5710568,XI619ELAA37G9JANID-6087022,XI619ELAA3AGYWANID-6255562,XI619ELAA3AP7AANID-6268442,XI619ELAA3EQ1AANID-6509263,XI619ELAA3F5SSANID-6531957,XI619ELAA3G7PPANID-6587495,XI619ELAA3GLFJANID-6608781,XI619ELAA3GLZ4ANID-6609552,XI619ELAA3GN34ANID-6611401,XI619ELAA3MQZ2ANID-6982935,XI619ELAA3RUZJANID-7261616,IO763OTAK517ANID-524254,KO406ELAWGLUANID-923097,HI451ELAE2T2ANID-224276,DE773HBACMRBANID-143257,CH273ELAA3AHDDANID-6256172';

SELECT 
    sku 'SKU',
    CASE
        WHEN sku = 'XI619ELAA1VHRTANID-3464623' THEN '2016-03-01'
        WHEN sku = 'SA850ELATGGPANID-754490' THEN '2016-03-08'
        WHEN sku = 'XI619ELAA4EH9IANID-8629295' THEN '2016-04-02'
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-03-01'
        WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-03-01'
        WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-03-01'
        WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-03-01'
        WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-01-30'
        WHEN sku = 'XI619ELAA31H8LANID-5710568' THEN '2016-01-01'
        WHEN sku = 'XI619ELAA37G9JANID-6087022' THEN '2016-01-01'
        WHEN sku = 'XI619ELAA3AGYWANID-6255562' THEN '2015-12-27'
        WHEN sku = 'XI619ELAA3AP7AANID-6268442' THEN '2015-12-27'
        WHEN sku = 'XI619ELAA3EQ1AANID-6509263' THEN '2015-12-27'
        WHEN sku = 'XI619ELAA3F5SSANID-6531957' THEN '2016-01-01'
        WHEN sku = 'XI619ELAA3G7PPANID-6587495' THEN '2015-12-27'
        WHEN sku = 'XI619ELAA3GLFJANID-6608781' THEN '2016-01-01'
        WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' THEN '2015-12-27'
        WHEN sku = 'XI619ELAA3GN34ANID-6611401' THEN '2016-01-01'
        WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' THEN '2016-03-01'
        WHEN sku = 'XI619ELAA3RUZJANID-7261616' THEN '2016-03-01'
        WHEN sku = 'IO763OTAK517ANID-524254' THEN '2016-02-24'
        WHEN sku = 'KO406ELAWGLUANID-923097' THEN '2016-03-01'
        WHEN sku = 'HI451ELAE2T2ANID-224276' THEN '2016-01-14'
        WHEN sku = 'DE773HBACMRBANID-143257' THEN '2016-03-08'
        WHEN sku = 'CH273ELAA3AHDDANID-6256172' THEN '2016-02-06'
    END 'Start Date',
    CASE
        WHEN sku = 'XI619ELAA1VHRTANID-3464623' THEN '2016-03-07'
        WHEN sku = 'SA850ELATGGPANID-754490' THEN '2016-03-11'
        WHEN sku = 'XI619ELAA4EH9IANID-8629295' THEN '2016-04-30'
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-03-30'
        WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-03-30'
        WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-03-30'
        WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-03-30'
        WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-03-30'
        WHEN sku = 'XI619ELAA31H8LANID-5710568' THEN '2016-02-12'
        WHEN sku = 'XI619ELAA37G9JANID-6087022' THEN '2016-02-12'
        WHEN sku = 'XI619ELAA3AGYWANID-6255562' THEN '2016-02-12'
        WHEN sku = 'XI619ELAA3AP7AANID-6268442' THEN '2016-02-12'
        WHEN sku = 'XI619ELAA3EQ1AANID-6509263' THEN '2016-02-12'
        WHEN sku = 'XI619ELAA3F5SSANID-6531957' THEN '2016-02-12'
        WHEN sku = 'XI619ELAA3G7PPANID-6587495' THEN '2016-02-12'
        WHEN sku = 'XI619ELAA3GLFJANID-6608781' THEN '2016-02-12'
        WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' THEN '2016-02-12'
        WHEN sku = 'XI619ELAA3GN34ANID-6611401' THEN '2016-02-12'
        WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' THEN '2016-03-30'
        WHEN sku = 'XI619ELAA3RUZJANID-7261616' THEN '2016-03-30'
        WHEN sku = 'IO763OTAK517ANID-524254' THEN '2016-03-07'
        WHEN sku = 'KO406ELAWGLUANID-923097' THEN '2016-03-30'
        WHEN sku = 'HI451ELAE2T2ANID-224276' THEN '2016-03-07'
        WHEN sku = 'DE773HBACMRBANID-143257' THEN '2016-03-11'
        WHEN sku = 'CH273ELAA3AHDDANID-6256172' THEN '2016-02-29'
    END 'End Date',
    COUNT(CASE
        WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-01' AND created_at <= '2016-03-07' THEN sku
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-08' AND created_at <= '2016-03-11' THEN sku
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-04-02' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN sku
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN sku
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN sku
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN sku
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-01-30' AND created_at <= '2016-03-30' THEN sku
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN sku
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN sku
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN sku
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-02-24' AND created_at <= '2016-03-07' THEN sku
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN sku
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-01-14' AND created_at <= '2016-03-07' THEN sku
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-08' AND created_at <= '2016-03-11' THEN sku
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-02-06' AND created_at <= '2016-02-29' THEN sku
        ELSE NULL
    END) 'Count of Item Ordered',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-01' AND created_at <= '2016-03-07' THEN cart_rule_discount
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-08' AND created_at <= '2016-03-11' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-04-02' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN cart_rule_discount
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-01-30' AND created_at <= '2016-03-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN cart_rule_discount
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-02-24' AND created_at <= '2016-03-07' THEN cart_rule_discount
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN cart_rule_discount
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-01-14' AND created_at <= '2016-03-07' THEN cart_rule_discount
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-08' AND created_at <= '2016-03-11' THEN cart_rule_discount
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-02-06' AND created_at <= '2016-02-29' THEN cart_rule_discount
        ELSE 0
    END) 'Cart Rule',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-01' AND created_at <= '2016-03-07' THEN coupon_money_value
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-08' AND created_at <= '2016-03-11' THEN coupon_money_value
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-04-02' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN coupon_money_value
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN coupon_money_value
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-01-30' AND created_at <= '2016-03-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN coupon_money_value
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-02-24' AND created_at <= '2016-03-07' THEN coupon_money_value
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN coupon_money_value
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-01-14' AND created_at <= '2016-03-07' THEN coupon_money_value
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-08' AND created_at <= '2016-03-11' THEN coupon_money_value
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-02-06' AND created_at <= '2016-02-29' THEN coupon_money_value
        ELSE 0
    END) 'Marketing Voucher (Coupon)',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-01' AND created_at <= '2016-03-07' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-08' AND created_at <= '2016-03-11' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-04-02' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-01-30' AND created_at <= '2016-03-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-02-24' AND created_at <= '2016-03-07' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-01-14' AND created_at <= '2016-03-07' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-08' AND created_at <= '2016-03-11' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-02-06' AND created_at <= '2016-02-29' THEN (paid_price + shipping_surcharge)
        ELSE 0
    END) 'NMV',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-01' AND created_at <= '2016-03-07' THEN marketplace_commission_fee
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-08' AND created_at <= '2016-03-11' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-04-02' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN marketplace_commission_fee
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-01-30' AND created_at <= '2016-03-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2015-12-27' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-01-01' AND created_at <= '2016-02-12' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN marketplace_commission_fee
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-02-24' AND created_at <= '2016-03-07' THEN marketplace_commission_fee
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-03-01' AND created_at <= '2016-03-30' THEN marketplace_commission_fee
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-01-14' AND created_at <= '2016-03-07' THEN marketplace_commission_fee
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-08' AND created_at <= '2016-03-11' THEN marketplace_commission_fee
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-02-06' AND created_at <= '2016-02-29' THEN marketplace_commission_fee
        ELSE 0
    END) 'Commission',
    CASE
        WHEN sku = 'XI619ELAA1VHRTANID-3464623' THEN '2016-03-08'
        WHEN sku = 'SA850ELATGGPANID-754490' THEN '2016-03-15'
        WHEN sku = 'XI619ELAA4EH9IANID-8629295' THEN '2016-05-03'
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-04-01'
        WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-04-01'
        WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-04-01'
        WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-04-01'
        WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-04-01'
        WHEN sku = 'XI619ELAA31H8LANID-5710568' THEN '2016-02-13'
        WHEN sku = 'XI619ELAA37G9JANID-6087022' THEN '2016-02-13'
        WHEN sku = 'XI619ELAA3AGYWANID-6255562' THEN '2016-02-13'
        WHEN sku = 'XI619ELAA3AP7AANID-6268442' THEN '2016-02-13'
        WHEN sku = 'XI619ELAA3EQ1AANID-6509263' THEN '2016-02-13'
        WHEN sku = 'XI619ELAA3F5SSANID-6531957' THEN '2016-02-13'
        WHEN sku = 'XI619ELAA3G7PPANID-6587495' THEN '2016-02-13'
        WHEN sku = 'XI619ELAA3GLFJANID-6608781' THEN '2016-02-13'
        WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' THEN '2016-02-13'
        WHEN sku = 'XI619ELAA3GN34ANID-6611401' THEN '2016-02-13'
        WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' THEN '2016-04-01'
        WHEN sku = 'XI619ELAA3RUZJANID-7261616' THEN '2016-04-01'
        WHEN sku = 'IO763OTAK517ANID-524254' THEN '2016-03-08'
        WHEN sku = 'KO406ELAWGLUANID-923097' THEN '2016-04-01'
        WHEN sku = 'HI451ELAE2T2ANID-224276' THEN '2016-03-08'
        WHEN sku = 'DE773HBACMRBANID-143257' THEN '2016-03-15'
        WHEN sku = 'CH273ELAA3AHDDANID-6256172' THEN '2016-03-08'
    END 'Start Date',
    CASE
        WHEN sku = 'XI619ELAA1VHRTANID-3464623' THEN '2016-03-14'
        WHEN sku = 'SA850ELATGGPANID-754490' THEN '2016-03-18'
        WHEN sku = 'XI619ELAA4EH9IANID-8629295' THEN '2016-05-31'
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-04-30'
        WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-04-30'
        WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-04-30'
        WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-04-30'
        WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-05-31'
        WHEN sku = 'XI619ELAA31H8LANID-5710568' THEN '2016-04-30'
        WHEN sku = 'XI619ELAA37G9JANID-6087022' THEN '2016-04-30'
        WHEN sku = 'XI619ELAA3AGYWANID-6255562' THEN '2016-03-31'
        WHEN sku = 'XI619ELAA3AP7AANID-6268442' THEN '2016-03-31'
        WHEN sku = 'XI619ELAA3EQ1AANID-6509263' THEN '2016-03-31'
        WHEN sku = 'XI619ELAA3F5SSANID-6531957' THEN '2016-04-30'
        WHEN sku = 'XI619ELAA3G7PPANID-6587495' THEN '2016-03-31'
        WHEN sku = 'XI619ELAA3GLFJANID-6608781' THEN '2016-04-30'
        WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' THEN '2016-03-31'
        WHEN sku = 'XI619ELAA3GN34ANID-6611401' THEN '2016-04-30'
        WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' THEN '2016-04-30'
        WHEN sku = 'XI619ELAA3RUZJANID-7261616' THEN '2016-04-30'
        WHEN sku = 'IO763OTAK517ANID-524254' THEN '2016-03-20'
        WHEN sku = 'KO406ELAWGLUANID-923097' THEN '2016-04-30'
        WHEN sku = 'HI451ELAE2T2ANID-224276' THEN '2016-04-30'
        WHEN sku = 'DE773HBACMRBANID-143257' THEN '2016-03-18'
        WHEN sku = 'CH273ELAA3AHDDANID-6256172' THEN '2016-03-31'
    END 'End Date',
    COUNT(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-08' AND created_at <= '2016-03-14' THEN sku
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-15' AND created_at <= '2016-03-18' THEN sku
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-05-03' AND created_at <= '2016-05-31' THEN sku
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-04-01' AND created_at <= '2016-05-31' THEN sku
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN sku
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN sku
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN sku
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN sku
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN sku
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-03-08' AND created_at <= '2016-03-20' THEN sku
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-03-08' AND created_at <= '2016-04-30' THEN sku
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-15' AND created_at <= '2016-03-18' THEN sku
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-03-08' AND created_at <= '2016-03-31' THEN sku
        ELSE NULL
    END) 'Count of Item Ordered',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-08' AND created_at <= '2016-03-14' THEN cart_rule_discount
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-15' AND created_at <= '2016-03-18' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-05-03' AND created_at <= '2016-05-31' THEN cart_rule_discount
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-04-01' AND created_at <= '2016-05-31' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-03-08' AND created_at <= '2016-03-20' THEN cart_rule_discount
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-03-08' AND created_at <= '2016-04-30' THEN cart_rule_discount
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-15' AND created_at <= '2016-03-18' THEN cart_rule_discount
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-03-08' AND created_at <= '2016-03-31' THEN cart_rule_discount
        ELSE 0
    END) 'Cart Rule',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-08' AND created_at <= '2016-03-14' THEN coupon_money_value
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-15' AND created_at <= '2016-03-18' THEN coupon_money_value
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-05-03' AND created_at <= '2016-05-31' THEN coupon_money_value
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-04-01' AND created_at <= '2016-05-31' THEN coupon_money_value
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-03-08' AND created_at <= '2016-03-20' THEN coupon_money_value
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-03-08' AND created_at <= '2016-04-30' THEN coupon_money_value
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-15' AND created_at <= '2016-03-18' THEN coupon_money_value
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-03-08' AND created_at <= '2016-03-31' THEN coupon_money_value
        ELSE 0
    END) 'Marketing Voucher (Coupon)',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-08' AND created_at <= '2016-03-14' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-15' AND created_at <= '2016-03-18' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-05-03' AND created_at <= '2016-05-31' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-04-01' AND created_at <= '2016-05-31' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-03-08' AND created_at <= '2016-03-20' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-03-08' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-15' AND created_at <= '2016-03-18' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-03-08' AND created_at <= '2016-03-31' THEN (paid_price + shipping_surcharge)
        ELSE 0
    END) 'NMV',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-08' AND created_at <= '2016-03-14' THEN marketplace_commission_fee
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-15' AND created_at <= '2016-03-18' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-05-03' AND created_at <= '2016-05-31' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-04-01' AND created_at <= '2016-05-31' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2016-02-13' AND created_at <= '2016-03-31' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-02-13' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-03-08' AND created_at <= '2016-03-20' THEN marketplace_commission_fee
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-04-01' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-03-08' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-15' AND created_at <= '2016-03-18' THEN marketplace_commission_fee
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-03-08' AND created_at <= '2016-03-31' THEN marketplace_commission_fee
        ELSE 0
    END) 'Commission',
    CASE
        WHEN sku = 'XI619ELAA1VHRTANID-3464623' THEN '2016-03-15'
        WHEN sku = 'SA850ELATGGPANID-754490' THEN '2016-03-22'
        WHEN sku = 'XI619ELAA4EH9IANID-8629295' THEN '2016-06-02'
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-05-01'
        WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-05-01'
        WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-05-01'
        WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-05-01'
        WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-06-01'
        WHEN sku = 'XI619ELAA31H8LANID-5710568' THEN '2016-05-01'
        WHEN sku = 'XI619ELAA37G9JANID-6087022' THEN '2016-05-01'
        WHEN sku = 'XI619ELAA3AGYWANID-6255562' THEN '2016-04-13'
        WHEN sku = 'XI619ELAA3AP7AANID-6268442' THEN '2016-04-13'
        WHEN sku = 'XI619ELAA3EQ1AANID-6509263' THEN '2016-04-13'
        WHEN sku = 'XI619ELAA3F5SSANID-6531957' THEN '2016-05-01'
        WHEN sku = 'XI619ELAA3G7PPANID-6587495' THEN '2016-04-13'
        WHEN sku = 'XI619ELAA3GLFJANID-6608781' THEN '2016-05-01'
        WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' THEN '2016-04-13'
        WHEN sku = 'XI619ELAA3GN34ANID-6611401' THEN '2016-05-01'
        WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' THEN '2016-05-01'
        WHEN sku = 'XI619ELAA3RUZJANID-7261616' THEN '2016-05-01'
        WHEN sku = 'IO763OTAK517ANID-524254' THEN '2016-03-21'
        WHEN sku = 'KO406ELAWGLUANID-923097' THEN '2016-05-01'
        WHEN sku = 'HI451ELAE2T2ANID-224276' THEN '2016-05-01'
        WHEN sku = 'DE773HBACMRBANID-143257' THEN '2016-03-22'
        WHEN sku = 'CH273ELAA3AHDDANID-6256172' THEN '2016-04-07'
    END 'Start Date',
    CASE
        WHEN sku = 'XI619ELAA1VHRTANID-3464623' THEN '2016-03-21'
        WHEN sku = 'SA850ELATGGPANID-754490' THEN '2016-03-25'
        WHEN sku = 'XI619ELAA4EH9IANID-8629295' THEN '2016-06-30'
        WHEN sku = 'IN848ELBCH8QANID-1243298' THEN '2016-05-30'
        WHEN sku = 'IN848ELBERX1ANID-1359166' THEN '2016-05-30'
        WHEN sku = 'IN848ELCHKE0ANID-2982992' THEN '2016-05-30'
        WHEN sku = 'IN848ELCHKF3ANID-2983031' THEN '2016-05-30'
        WHEN sku = 'ME826ELAA3CO1FANID-6389457' THEN '2016-06-30'
        WHEN sku = 'XI619ELAA31H8LANID-5710568' THEN '2016-07-13'
        WHEN sku = 'XI619ELAA37G9JANID-6087022' THEN '2016-07-13'
        WHEN sku = 'XI619ELAA3AGYWANID-6255562' THEN '2016-05-30'
        WHEN sku = 'XI619ELAA3AP7AANID-6268442' THEN '2016-05-30'
        WHEN sku = 'XI619ELAA3EQ1AANID-6509263' THEN '2016-05-30'
        WHEN sku = 'XI619ELAA3F5SSANID-6531957' THEN '2016-07-13'
        WHEN sku = 'XI619ELAA3G7PPANID-6587495' THEN '2016-05-30'
        WHEN sku = 'XI619ELAA3GLFJANID-6608781' THEN '2016-07-13'
        WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' THEN '2016-05-30'
        WHEN sku = 'XI619ELAA3GN34ANID-6611401' THEN '2016-07-13'
        WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' THEN '2016-05-30'
        WHEN sku = 'XI619ELAA3RUZJANID-7261616' THEN '2016-05-30'
        WHEN sku = 'IO763OTAK517ANID-524254' THEN '2016-04-02'
        WHEN sku = 'KO406ELAWGLUANID-923097' THEN '2016-05-30'
        WHEN sku = 'HI451ELAE2T2ANID-224276' THEN '2016-06-23'
        WHEN sku = 'DE773HBACMRBANID-143257' THEN '2016-03-25'
        WHEN sku = 'CH273ELAA3AHDDANID-6256172' THEN '2016-04-30'
    END 'End Date',
    COUNT(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-15' AND created_at <= '2016-03-21' THEN sku
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-22' AND created_at <= '2016-03-25' THEN sku
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-06-02' AND created_at <= '2016-06-30' THEN sku
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-06-01' AND created_at <= '2016-06-30' THEN sku
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN sku
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN sku
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN sku
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN sku
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN sku
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-03-21' AND created_at <= '2016-04-02' THEN sku
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN sku
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-05-01' AND created_at <= '2016-06-23' THEN sku
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-22' AND created_at <= '2016-03-25' THEN sku
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-04-07' AND created_at <= '2016-04-30' THEN sku
        ELSE NULL
    END) 'Count of Item Ordered',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-15' AND created_at <= '2016-03-21' THEN cart_rule_discount
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-22' AND created_at <= '2016-03-25' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-06-02' AND created_at <= '2016-06-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-06-01' AND created_at <= '2016-06-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-03-21' AND created_at <= '2016-04-02' THEN cart_rule_discount
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN cart_rule_discount
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-05-01' AND created_at <= '2016-06-23' THEN cart_rule_discount
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-22' AND created_at <= '2016-03-25' THEN cart_rule_discount
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-04-07' AND created_at <= '2016-04-30' THEN cart_rule_discount
        ELSE 0
    END) 'Cart Rule',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-15' AND created_at <= '2016-03-21' THEN coupon_money_value
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-22' AND created_at <= '2016-03-25' THEN coupon_money_value
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-06-02' AND created_at <= '2016-06-30' THEN coupon_money_value
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-06-01' AND created_at <= '2016-06-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN coupon_money_value
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-03-21' AND created_at <= '2016-04-02' THEN coupon_money_value
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN coupon_money_value
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-05-01' AND created_at <= '2016-06-23' THEN coupon_money_value
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-22' AND created_at <= '2016-03-25' THEN coupon_money_value
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-04-07' AND created_at <= '2016-04-30' THEN coupon_money_value
        ELSE 0
    END) 'Marketing Voucher (Coupon)',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-15' AND created_at <= '2016-03-21' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-22' AND created_at <= '2016-03-25' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-06-02' AND created_at <= '2016-06-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-06-01' AND created_at <= '2016-06-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-03-21' AND created_at <= '2016-04-02' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-05-01' AND created_at <= '2016-06-23' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-22' AND created_at <= '2016-03-25' THEN (paid_price + shipping_surcharge)
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-04-07' AND created_at <= '2016-04-30' THEN (paid_price + shipping_surcharge)
        ELSE 0
    END) 'NMV',
    SUM(CASE
		WHEN sku = 'XI619ELAA1VHRTANID-3464623' AND created_at >= '2016-03-15' AND created_at <= '2016-03-21' THEN marketplace_commission_fee
		WHEN sku = 'SA850ELATGGPANID-754490' AND created_at >= '2016-03-22' AND created_at <= '2016-03-25' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA4EH9IANID-8629295' AND created_at >= '2016-06-02' AND created_at <= '2016-06-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELBCH8QANID-1243298' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELBERX1ANID-1359166' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKE0ANID-2982992' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'IN848ELCHKF3ANID-2983031' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'ME826ELAA3CO1FANID-6389457' AND created_at >= '2016-06-01' AND created_at <= '2016-06-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA31H8LANID-5710568' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA37G9JANID-6087022' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3AGYWANID-6255562' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3AP7AANID-6268442' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3EQ1AANID-6509263' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3F5SSANID-6531957' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3G7PPANID-6587495' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3GLFJANID-6608781' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3GLZ4ANID-6609552' AND created_at >= '2016-04-13' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3GN34ANID-6611401' AND created_at >= '2016-05-01' AND created_at <= '2016-07-13' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3MQZ2ANID-6982935' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'XI619ELAA3RUZJANID-7261616' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'IO763OTAK517ANID-524254' AND created_at >= '2016-03-21' AND created_at <= '2016-04-02' THEN marketplace_commission_fee
		WHEN sku = 'KO406ELAWGLUANID-923097' AND created_at >= '2016-05-01' AND created_at <= '2016-05-30' THEN marketplace_commission_fee
		WHEN sku = 'HI451ELAE2T2ANID-224276' AND created_at >= '2016-05-01' AND created_at <= '2016-06-23' THEN marketplace_commission_fee
		WHEN sku = 'DE773HBACMRBANID-143257' AND created_at >= '2016-03-22' AND created_at <= '2016-03-25' THEN marketplace_commission_fee
		WHEN sku = 'CH273ELAA3AHDDANID-6256172' AND created_at >= '2016-04-07' AND created_at <= '2016-04-30' THEN marketplace_commission_fee
        ELSE 0
    END) 'Commission'
FROM
    (SELECT 
        soi.sku,
            soi.created_at,
            soish.created_at 'shipped_at',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_surcharge,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            soi.marketplace_commission_fee
    FROM
        oms_live.ims_sales_order_item soi
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 5)
    WHERE
        soi.created_at >= @extractstart
            AND soi.created_at < @extractend
            AND FIND_IN_SET(soi.sku, @sku)) result
GROUP BY sku