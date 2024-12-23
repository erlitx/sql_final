
-- Возвращает список всех подчиненных конкретного сотрудника по его ID
CREATE OR REPLACE FUNCTION get_subordinates(employee_id INT)
RETURNS TABLE(subordinate_id INT, subordinate_name VARCHAR) AS $$
BEGIN
	RETURN QUERY
   SELECT id, user_name
   FROM company_user
   WHERE report_to = employee_id;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM get_subordinates(1);