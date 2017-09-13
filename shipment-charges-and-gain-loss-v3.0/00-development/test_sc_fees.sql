SELECT * FROM asc_live.transaction_type WHERE description LIKE '%commission%';
SELECT * FROM asc_live.transaction_type WHERE description LIKE '%payment%';
SELECT * FROM asc_live.transaction_type WHERE id_transaction_type IN (16, 15, 3, 4, 142, 8, 7, 143);
SELECT * FROM asc_live.transaction_type WHERE fee_process_type = 'Automatic';
SELECT MIN(created_at) FROM asc_live.transaction;
SELECT MAX(created_at) FROM asc_live.transaction;
SELECT MIN(created_at) FROM asc_live.transaction_archive;
SELECT MAX(created_at) FROM asc_live.transaction_archive;