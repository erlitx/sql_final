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
