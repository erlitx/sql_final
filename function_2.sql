-- Функция для подсчета общего количества проданных товаров по продукту
CREATE OR REPLACE FUNCTION calculate_total_sales(product_id_input INT)
RETURNS INT AS $$
DECLARE
    total_sales INT;
BEGIN
    SELECT COALESCE(SUM(qty), 0) INTO total_sales
    FROM sale_order_line
    WHERE product_id = product_id_input;

    RETURN total_sales;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM calculate_total_sales(1);