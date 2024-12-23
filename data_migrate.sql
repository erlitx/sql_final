
-- Вставка данных в таблицу company_user (3НФ)
INSERT INTO company_user (id, user_name, report_to) VALUES
(1, 'Иван Иванов', NULL), -- Главный босс
(2, 'Пётр Петров', 1),
(3, 'Александр Сидоров', 1),
(4, 'Мария Смирнова', 2),
(5, 'Екатерина Орлова', 2),
(6, 'Дмитрий Кузнецов', 3),
(7, 'Ольга Ковалева', 3),
(8, 'Сергей Васильев', 4),
(9, 'Наталья Фёдорова', 4),
(10, 'Анна Семёнова', 5);

-- Вставка данных в таблицу partner (3НФ)
INSERT INTO partner (partner_name, email, phone, type) VALUES
('ООО Альфа', 'info@alfa.com', '+7-900-123-4567', 'юрлицо'),
('ИП Петров', 'petrov@business.ru', '+7-901-234-5678', 'физлицо'),
('ЗАО Бета', 'contact@beta.org', '+7-902-345-6789', 'юрлицо'),
('Иван Иванов', 'ivanov@mail.ru', '+7-903-456-7890', 'физлицо'),
('Мария Смирнова', 'm.smirnova@mail.ru', '+7-904-567-8901', 'физлицо'),
('ООО Гамма', 'sales@gamma.com', '+7-905-678-9012', 'юрлицо'),
('ИП Сидоров', 'sidrov@shop.biz', '+7-906-789-0123', 'физлицо'),
('ЗАО Дельта', 'info@delta.com', '+7-907-890-1234', 'юрлицо'),
('ООО Эпсилон', 'contact@epsilon.ru', '+7-908-901-2345', 'юрлицо'),
('ИП Орлова', 'orlova@mail.com', '+7-909-012-3456', 'физлицо');


-- Вставка данных в таблицу product_category
INSERT INTO product_category (name) VALUES
('Электроника'),
('Бытовая техника'),
('Одежда'),
('Обувь'),
('Мебель'),
('Игрушки'),
('Спорттовары'),
('Канцелярия'),
('Продукты питания'),
('Косметика');

-- Вставка данных в таблицу product
INSERT INTO product (article, product_name, category_id) VALUES
('A001', 'Смартфон X', 1),
('A002', 'Ноутбук Y', 1),
('B001', 'Холодильник Z', 2),
('C001', 'Куртка зимняя', 3),
('C002', 'Футболка летняя', 3),
('D001', 'Кроссовки спортивные', 4),
('E001', 'Шкаф деревянный', 5),
('F001', 'Машинка для детей', 6),
('G001', 'Велосипед горный', 7),
('H001', 'Тетрадь А4', 8);

-- Вставка данных в таблицу sale_channel
INSERT INTO sale_channel (name) VALUES
('онлайн-магазин'),
('WB'),
('OZON'),
('оффлайн-магазин');

-- Вставка данных в таблицу location
INSERT INTO location (name, type) VALUES
('Склад Москва', 'Внутренний'),
('Склад Спб', 'Внутренний'),
('Склад Покупателя А', 'Покупатель'),
('Склад Поставщика Б', 'Поставщик');

-- Обновлённая вставка данных в таблицу sale_order с датами
INSERT INTO sale_order (partner_id, user_id, sale_channel_id, amount, status, created_date) VALUES
(1, 2, 1, 50000.00, 'Открыт', '2024-01-01 10:00:00'),
(2, 3, 2, 12000.00, 'Завершен', '2024-01-02 11:30:00'),
(3, 4, 3, 34000.00, 'Ожидает оплаты', '2024-01-03 12:45:00'),
(4, 5, 4, 2700.00, 'Отменен', '2024-01-04 14:15:00'),
(5, 6, 1, 8000.00, 'Завершен', '2024-01-05 09:00:00'),
(6, 7, 2, 9500.00, 'Открыт', '2024-01-06 16:20:00'),
(7, 8, 3, 5600.00, 'Завершен', '2024-01-07 13:40:00'),
(8, 9, 4, 12300.00, 'Открыт', '2024-01-08 17:00:00'),
(9, 10, 1, 7800.00, 'Ожидает отгрузки', '2024-01-09 10:30:00'),
(10, 1, 2, 43000.00, 'Завершен', '2024-01-10 15:45:00');

-- Обновлённая вставка данных в таблицу stock_move с датами
INSERT INTO stock_move (sale_order_id, user_id, timestamp) VALUES
(1, 2, '2024-01-01 15:00:00'),
(2, 3, '2024-01-02 16:00:00'),
(3, 4, '2024-01-03 17:00:00'),
(4, 5, '2024-01-04 18:00:00'),
(5, 6, '2024-01-05 19:00:00'),
(6, 7, '2024-01-06 20:00:00'),
(7, 8, '2024-01-07 21:00:00'),
(8, 9, '2024-01-08 22:00:00'),
(9, 10, '2024-01-09 23:00:00'),
(10, 1, '2024-01-10 08:00:00');

-- Вставка данных в таблицу sale_order_line
INSERT INTO sale_order_line (sale_order_id, product_id, qty, unit_price) VALUES
(1, 1, 2, 25000.00),
(2, 2, 1, 12000.00),
(3, 3, 1, 34000.00),
(4, 4, 1, 2700.00),
(5, 5, 4, 2000.00),
(6, 6, 2, 4750.00),
(7, 7, 1, 5600.00),
(8, 8, 2, 6150.00),
(9, 9, 3, 2600.00),
(10, 10, 10, 4300.00);

-- Вставка данных в таблицу stock_move_line
INSERT INTO stock_move_line (stock_move_id, product_id, qty) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 4),
(6, 6, 2),
(7, 7, 1),
(8, 8, 2),
(9, 9, 3),
(10, 10, 10);
