SET @test = 'I\'m at McDonald!';

SELECT 'Full Text' AS substring_type, @test 'Result' 
UNION ALL SELECT 'SUBSTRING w/ 1 Parameter', SUBSTRING(@test, 1) 
UNION ALL SELECT 'SUBSTRING w/ 2 Parameters', SUBSTRING(@test, 1, 4) 
UNION ALL SELECT 'SUBSTRING w/ 1 Parameter', SUBSTRING(@test, 8) 
UNION ALL SELECT 'SUBSTRING w/ 2 Parameters', SUBSTRING(@test, 8, 8);

SET @test2 = 'This is a test! This is a test for substring index.';

SELECT 'Full Text' AS substring_type, @test2 'Result' 
UNION ALL SELECT 'SUBSTRING w/ 1 Parameter', SUBSTRING_INDEX(@test2, 'a', 1)
UNION ALL SELECT 'SUBSTRING w/ 1 Parameter', SUBSTRING_INDEX(@test2, 'a', 2)
UNION ALL SELECT 'SUBSTRING w/ 1 Parameter', SUBSTRING_INDEX(@test2, 'This', 2)
UNION ALL SELECT 'SUBSTRING w/ 1 Parameter', SUBSTRING_INDEX(@test2, 'i', 1)
UNION ALL SELECT 'SUBSTRING w/ 1 Parameter', SUBSTRING_INDEX(@test2, 'i ', 2)
UNION ALL SELECT 'SUBSTRING w/ 1 Parameter', SUBSTRING_INDEX(@test2, 'a', -2)
UNION ALL SELECT 'SUBSTRING w/ 1 Parameter', SUBSTRING_INDEX(@test2, 'i', -3)
UNION ALL SELECT 'SUBSTRING w/ 2 Parameters', SUBSTRING(@test2, -16, 10)
UNION ALL SELECT 'SUBSTRING w/ 1 Parameter', SUBSTRING_INDEX(SUBSTRING_INDEX(@test2, ' ', -2), ' ', 1);

SELECT name, SUBSTRING_INDEX(SUBSTRING_INDEX(tmp_data, '"bank_account_bank":"', -1), '","', 1) FROM asc_live.seller;

SELECT * FROM asc_live.sales_order_temp;