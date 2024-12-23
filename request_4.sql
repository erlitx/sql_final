--Задача: Найти общий объем продаж (сумму заказов) для каждого партнера.
WITH partner_sales AS (
    SELECT 
        so.partner_id,
        SUM(so.amount) AS total_sales
    FROM sale_order so
    GROUP BY so.partner_id
)
SELECT 
    p.partner_name,
    ps.total_sales
FROM partner_sales ps
JOIN partner p ON ps.partner_id = p.id;
