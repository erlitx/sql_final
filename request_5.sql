--Задача: Найти общую сумму продаж по каждому пользователю
-- и их ранг (место) по общей сумме продаж среди всех пользователей.

SELECT 
    cu.user_name AS employee_name,
    SUM(so.amount) AS total_sales,
    RANK() OVER (ORDER BY SUM(so.amount) DESC) AS sales_rank
FROM company_user cu
LEFT JOIN sale_order so ON cu.id = so.user_id
GROUP BY cu.id, cu.user_name
ORDER BY sales_rank;
