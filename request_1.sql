-- Список всех продаж с указанием товарных позиций, их наименования и категории
SELECT
	so.id,
	pp.product_name,
	pc.name,
	so.amount,
	so.status,
	so.created_date
FROM
	public.sale_order AS so
LEFT JOIN sale_order_line AS sol ON so.id = sol.sale_order_id
LEFT JOIN product AS pp ON sol.product_id = pp.id
LEFT JOIN product_category AS pc ON pp.category_id = pc.id;