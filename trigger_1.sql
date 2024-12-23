-- Задача: Автоматически обновлять статус заказа (sale_order.status) на "Завершен", 
-- если была создана запись в таблице stock_move и stock_move_line, где отгружены все позиции 
-- заказа (sale_order_line).


CREATE OR REPLACE FUNCTION update_order_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверяем, отгружены ли все позиции заказа
    IF (
        SELECT COUNT(*) 
        FROM sale_order_line sol
        WHERE sol.sale_order_id = (
            SELECT sm.sale_order_id
            FROM stock_move sm
            WHERE sm.id = NEW.stock_move_id
        )
        AND NOT EXISTS (
            SELECT 1
            FROM stock_move_line sml
            WHERE sml.stock_move_id = NEW.stock_move_id
              AND sml.product_id = sol.product_id
              AND sml.qty >= sol.qty
        )
    ) = 0 THEN
        -- Если все позиции отгружены, обновляем статус заказа
        UPDATE sale_order
        SET status = 'Завершен'
        WHERE id = (
            SELECT sm.sale_order_id
            FROM stock_move sm
            WHERE sm.id = NEW.stock_move_id
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_stock_move_line_insert
AFTER INSERT ON stock_move_line
FOR EACH ROW
EXECUTE FUNCTION update_order_status();
