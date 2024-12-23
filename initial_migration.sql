-----------------------------------------
-- 1. Создаем новую БД
-----------------------------------------
CREATE DATABASE xyz;
\c xyz

BEGIN;
-----------------------------------------
-- 2. Создаем таблицы
-----------------------------------------

-- Сотрудники компании (3НФ)
CREATE TABLE company_user (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    report_to INT,

    FOREIGN KEY (report_to) REFERENCES company_user(id)
);
COMMENT ON TABLE "company_user" IS 'Сотрудники компании';

-- Партнеры компании - покупатели (3НФ)
CREATE TABLE partner (
    id SERIAL PRIMARY KEY,
    partner_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    type VARCHAR(20) CHECK (type IN ('физлицо', 'юрлицо'))
);
COMMENT ON TABLE partner IS 'Партнеры компании - покупатели';

-- Склады (3НФ)
CREATE TABLE location (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(100) CHECK(TYPE IN ('Внутренни', 'Покупатель', 'Поставщик'))
);
COMMENT ON TABLE location IS 'Склады, ';

-- Категории товаров (3НФ)
CREATE TABLE product_category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
COMMENT ON TABLE product_category IS 'Категории товаров';

-- Каналы продаж (3НФ)
CREATE TABLE sale_channel (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
COMMENT ON TABLE sale_channel IS 'Каналы продаж';

-- Товары (3НФ)
CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    article VARCHAR(50) UNIQUE NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    category_id INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (category_id) REFERENCES product_category(id)
);
COMMENT ON TABLE product IS 'Содержит информацию о товарах';


-- Заказы продаж (3НФ)
CREATE TABLE sale_order (
    id SERIAL PRIMARY KEY,
    partner_id INT,
    user_id INT,
    sale_channel_id INT,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (partner_id) REFERENCES partner(id),
    FOREIGN KEY (user_id) REFERENCES company_user(id),
    FOREIGN KEY (sale_channel_id) REFERENCES sale_channel(id)
);
COMMENT ON TABLE sale_order IS 'Заказы продаж';

-- Товарные позиции в заказе (3НФ)
CREATE TABLE sale_order_line (
    id SERIAL PRIMARY KEY,
    sale_order_id INT,
    product_id INT,
    qty INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (sale_order_id) REFERENCES sale_order(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);
COMMENT ON TABLE sale_order_line IS 'Товары в заказе';

-- Движение и отгрузки товаров (3НФ)
CREATE TABLE stock_move (
    id SERIAL PRIMARY KEY,
    sale_order_id INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    from_location INT,
    to_location INT,

    FOREIGN KEY (from_location) REFERENCES location(id),
    FOREIGN KEY (to_location) REFERENCES location(id),
    FOREIGN KEY (sale_order_id) REFERENCES sale_order(id),
    FOREIGN KEY (user_id) REFERENCES company_user(id)
);
COMMENT ON TABLE stock_move IS 'Отгрузки товаров';

-- Товарные позиции в перемещениях (3НФ)
CREATE TABLE stock_move_line (
    id SERIAL PRIMARY KEY,
    stock_move_id INT,
    product_id INT,
    qty INT NOT NULL,

    FOREIGN KEY (stock_move_id) REFERENCES stock_move(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);
COMMENT ON TABLE stock_move_line IS 'Товарные позиции в перемещениях';


-----------------------------------------
-- 3. Создаем функции и триггеры 
-----------------------------------------

-- Автоматически обновляет статус заказа (sale_order.status) на "Завершен", 
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



-- Триггер для таблицы partner, который автоматически проверяет корректность email 
-- адреса и телефонного номера при вставке или обновлении данных. 
-- Если формат некорректен, триггер выбрасывает ошибку.
CREATE OR REPLACE FUNCTION validate_partner_data()
RETURNS TRIGGER AS $$
BEGIN
    -- Проверяем формат email
    IF NEW.email IS NOT NULL AND NOT NEW.email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
        RAISE EXCEPTION 'Некорректный email адрес: %', NEW.email;
    END IF;

    -- Проверяем формат телефона
    IF NEW.phone IS NOT NULL AND NOT NEW.phone ~ '^\+\d{1,3}-\d{3}-\d{3}-\d{4}$' THEN
        RAISE EXCEPTION 'Некорректный номер телефона: %', NEW.phone;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_validate_partner_data
BEFORE INSERT OR UPDATE ON partner
FOR EACH ROW
EXECUTE FUNCTION validate_partner_data();

COMMIT;

