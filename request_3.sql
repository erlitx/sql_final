-- Задача: Найти общее количество товаров, проданных через каждый канал продаж, и их общую сумму.
SELECT 
    sc.name AS sale_channel_name,
    (
        SELECT SUM(sol.qty)
        FROM sale_order_line sol
        JOIN sale_order so ON sol.sale_order_id = so.id
        WHERE so.sale_channel_id = sc.id
    ) AS total_qty_sold,
    (
        SELECT SUM(sol.qty * sol.unit_price)
        FROM sale_order_line sol
        JOIN sale_order so ON sol.sale_order_id = so.id
        WHERE so.sale_channel_id = sc.id
    ) AS total_sales_amount
FROM sale_channel sc;
