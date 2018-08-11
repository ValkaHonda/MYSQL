DROP PROCEDURE IF EXISTS first_procedure;
DELIMITER ^^
CREATE PROCEDURE first_procedure(IN customer_id INT, IN transfer_sum DECIMAL, OUT is_successful BIT)
BEGIN
	START TRANSACTION;
		UPDATE accounts AS ac
		SET ac.amount = ac.amount - transfer_sum
		WHERE ac.amount >= transfer_sum 
		AND
		ac.customer_id = (SELECT cus.customerID
						 FROM customers AS cus
						 WHERE cus.customerID = customer_id);
		IF(ROW_COUNT()=0)
		THEN 
			SET is_successful = 0;
			ROLLBACK;
		ELSE 
			SET is_successful = 1;
			COMMIT;
		END IF;
END
^^
DELIMITER ;
