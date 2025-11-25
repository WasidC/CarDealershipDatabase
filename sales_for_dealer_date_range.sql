USE CarDealership;
SELECT *
FROM sales_contracts
WHERE dealership_id = 2
  AND sale_date BETWEEN '2024-01-01' AND '2024-12-31';
