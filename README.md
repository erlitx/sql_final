### Сделать первоначальную миграцию
`psql -U postgres -f initial_migration.sql`

Будут созданы таблицы, функции, триггеры


### Вставить тестовые данные

`psql -U postgres -d xyz -f data_migrate.sql`


### Восстановить БД

pg_dump всей базы содержится в файле `backup.sql`


## Описание таблиц и их нормальных форм

### Таблица `company_user` (3НФ)
Содержит информацию о сотрудниках компании.

- **Поля:**
  - `id` (SERIAL, PRIMARY KEY) — Уникальный идентификатор сотрудника.
  - `user_name` (VARCHAR(255), NOT NULL) — Имя сотрудника.
  - `report_to` (INT, FOREIGN KEY) — Идентификатор руководителя сотрудника.
---

### Таблица `partner` (3НФ)
Содержит информацию о партнёрах компании.

- **Поля:**
  - `id` (SERIAL, PRIMARY KEY) — Уникальный идентификатор партнёра.
  - `partner_name` (VARCHAR(255), NOT NULL) — Имя партнёра.
  - `email` (VARCHAR(255)) — Email партнёра.
  - `phone` (VARCHAR(50)) — Телефон партнёра.
  - `type` (VARCHAR(20), CHECK) — Тип партнёра ("физлицо" или "юрлицо").
---

### Таблица `location` (3НФ)
Содержит информацию о складах компании.

- **Поля:**
  - `id` (SERIAL, PRIMARY KEY) — Уникальный идентификатор склада.
  - `name` (VARCHAR(100), NOT NULL) — Название склада.
  - `type` (VARCHAR(100), CHECK) — Тип склада ("Внутренний", "Покупатель", "Поставщик").
---

### Таблица `product_category` (3НФ)
Содержит категории товаров.

- **Поля:**
  - `id` (SERIAL, PRIMARY KEY) — Уникальный идентификатор категории.
  - `name` (VARCHAR(255), NOT NULL) — Название категории.
---

### Таблица `sale_channel` (3НФ)
Содержит каналы продаж.

- **Поля:**
  - `id` (SERIAL, PRIMARY KEY) — Уникальный идентификатор канала продаж.
  - `name` (VARCHAR(255), NOT NULL) — Название канала продаж.
---

### Таблица `product` (3НФ)
Содержит информацию о товарах.

- **Поля:**
  - `id` (SERIAL, PRIMARY KEY) — Уникальный идентификатор товара.
  - `article` (VARCHAR(50), UNIQUE, NOT NULL) — Артикул товара.
  - `product_name` (VARCHAR(255), NOT NULL) — Название товара.
  - `category_id` (INT, FOREIGN KEY) — Идентификатор категории товара.
  - `created_date` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP) — Дата создания записи.
---

### Таблица `sale_order` (3НФ)
Содержит информацию о заказах продаж.

- **Поля:**
  - `id` (SERIAL, PRIMARY KEY) — Уникальный идентификатор заказа.
  - `partner_id` (INT, FOREIGN KEY) — Идентификатор партнёра.
  - `user_id` (INT, FOREIGN KEY) — Идентификатор сотрудника, создавшего заказ.
  - `sale_channel_id` (INT, FOREIGN KEY) — Идентификатор канала продаж.
  - `amount` (DECIMAL(10,2), NOT NULL) — Сумма заказа.
  - `status` (VARCHAR(50)) — Статус заказа.
  - `created_date` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP) — Дата создания заказа.
---

### Таблица `sale_order_line` (3НФ)
Содержит товарные позиции в заказах.

- **Поля:**
  - `id` (SERIAL, PRIMARY KEY) — Уникальный идентификатор товарной позиции.
  - `sale_order_id` (INT, FOREIGN KEY) — Идентификатор заказа.
  - `product_id` (INT, FOREIGN KEY) — Идентификатор товара.
  - `qty` (INT, NOT NULL) — Количество товара.
  - `unit_price` (DECIMAL(10,2), NOT NULL) — Цена за единицу товара.
---

### Таблица `stock_move` (3НФ)
Содержит информацию о движениях товаров.

- **Поля:**
  - `id` (SERIAL, PRIMARY KEY) — Уникальный идентификатор движения.
  - `sale_order_id` (INT, FOREIGN KEY) — Идентификатор заказа.
  - `timestamp` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP) — Время движения.
  - `user_id` (INT, FOREIGN KEY) — Идентификатор сотрудника.
  - `from_location` (INT, FOREIGN KEY) — Исходный склад.
  - `to_location` (INT, FOREIGN KEY) — Целевой склад.
---

### Таблица `stock_move_line` (3НФ)
Содержит товарные позиции в перемещениях.

- **Поля:**
  - `id` (SERIAL, PRIMARY KEY) — Уникальный идентификатор товарной позиции.
  - `stock_move_id` (INT, FOREIGN KEY) — Идентификатор движения.
  - `product_id` (INT, FOREIGN KEY) — Идентификатор товара.
  - `qty` (INT, NOT NULL) — Количество товара.


