CREATE DATABASE financial_analysis;
USE financial_analysis;

CREATE TABLE transactions (
date DATETIME,
client_id INT,
card_id INT,
amount FLOAT,
transaction_type VARCHAR (20),
merchant_city VARCHAR (100),
merchant_state VARCHAR (100),
mcc INT,
use_chip VARCHAR (50),
month VARCHAR (10),
year INT,
category TEXT,
category_group VARCHAR(50)
);
DROP TABLE transactions;
SELECT COUNT(*) FROM transactions_clean;

ALTER TABLE transactions_clean
ADD COLUMN transaction_id INT auto_increment PRIMARY KEY;

/*BALANCE FINANCIERO*/ 

SELECT 
    transaction_type,
    SUM(amount) AS total_amount,
    COUNT(*) AS num_transactions
FROM transactions_clean
GROUP BY transaction_type;

/*GASTOS POR CATEGORIAS*/

SELECT
	category_group,
    SUM(amount) AS total_amount
FROM transactions_clean
WHERE transaction_type = "Expense"
GROUP BY category_group
ORDER BY total_amount DESC; 

/* CATEGORIAS CON MAS GASTOS*/

SELECT
	category_group,
    ROUND(SUM(amount),2) AS total_amount
FROM transactions_clean
WHERE transaction_type = "Expense"
GROUP BY category_group
ORDER BY total_amount DESC;

/*METODOS DE PAGO*/
SELECT
	use_chip,
    COUNT(*) AS num_transactions,
    SUM(amount) AS total_amount
FROM transactions_clean
GROUP BY use_chip;

/* COMPORTAMIENTOS DE PAGO*/

SELECT
	use_chip,
    COUNT(*) AS num_transactions,
    ROUND(AVG(amount),2) AS avg_transaction
FROM transactions_clean
GROUP BY use_chip;

/*EVOLUCION TEMPORAL*/

SELECT
	month,
    SUM(amount) AS total_amount
FROM transactions_clean
GROUP BY month
ORDER BY month;

/* TENDENCIA TEMPORAL*/

SELECT
	month,
    ROUND(SUM(amount),2) AS total_amount
FROM transactions_clean
GROUP BY month
ORDER BY month;

/*TOP CLIENTES*/

SELECT
	client_id,
    category_group,
    COUNT(*) AS num_transactions,
    ROUND(ABS(SUM(amount)),2) AS total_spent
FROM transactions_clean
WHERE transaction_type = "Expense"
GROUP BY client_id, category_group
ORDER BY total_spent DESC
LIMIT 10;

/*CIUDADES CON MAS ACTIVIDAD*/

SELECT
	merchant_city,
    COUNT(*) AS num_transactions
FROM transactions_clean
GROUP BY merchant_city
ORDER BY num_transactions DESC
LIMIT 10;