-- Считаем остатки товаров на внутренних складах исходя из движения товара по таблицам
-- stock_move and stock_move_line
-- У нас нет отдельной таблицы с остатками, они считаются динамически исходя из движения товаров
SELECT
	loc.id AS location_id,
	sml.product_id,
	SUM(
            CASE
                WHEN sm.to_location = loc.id THEN sml.qty -- Если товар поступил на склад
                WHEN sm.from_location = loc.id THEN -sml.qty -- Если товар ушел со склада
                ELSE 0
            END
        )::integer AS stock_qty
	-- Приведение результата к integer
FROM
	stock_move sm
JOIN
        stock_move_line sml ON
	sm.id = sml.stock_move_id
JOIN
        LOCATION loc ON
	loc.id IN (sm.from_location, sm.to_location)
WHERE
	loc.type = 'Внутренний'
	-- Учитываем только внутренние склады
GROUP BY
	loc.id,
	sml.product_id
HAVING
	SUM(
            CASE
                WHEN sm.to_location = loc.id THEN sml.qty
                WHEN sm.from_location = loc.id THEN -sml.qty
                ELSE 0
            END
        ) <> 0; -- Исключаем склады с нулевым остатком