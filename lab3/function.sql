--function
CREATE OR REPLACE FUNCTION person_in_loc(location_name TEXT)
RETURNS TABLE(name VARCHAR(20), birthday DATE)
AS $$
BEGIN
    RETURN QUERY
    (SELECT p.name, p.birthday
    FROM location AS l
    JOIN person_characteristics AS pc ON l.id = pc.location
    JOIN person AS p ON p.id = pc.id
    WHERE l.name = location_name);

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Такой локации не существует либо в ней никого нет';
    END IF;
END;
$$ LANGUAGE plpgsql;




--trigger
CREATE TABLE IF NOT EXISTS person_characteristics_history (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL,
    action VARCHAR(10) NOT NULL,
    person INT REFERENCES person(id),
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    current_action INT REFERENCES action(id),
    location INT REFERENCES location(id),
    anomalies INT REFERENCES anomaly(id)
);

CREATE OR REPLACE FUNCTION log_person_characteristics_change() RETURNS TRIGGER AS $$
DECLARE
    timestamp TIMESTAMP DEFAULT NOW(); 
BEGIN
    INSERT INTO person_characteristics_history (timestamp, action, id, person, gender, current_action, location, anomalies)
    VALUES (timestamp, TG_OP, OLD.id, OLD.person, OLD.gender, OLD.current_action, OLD.location, OLD.anomalies);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER person_characteristics_change_trigger
BEFORE UPDATE ON person_characteristics
FOR EACH ROW
EXECUTE FUNCTION log_person_characteristics_change();

--dop
SELECT 
    tablename AS TableName,
    reltuples AS RowCount,
    COUNT(*) AS ColumnCount
FROM 
    pg_tables
JOIN 
    pg_class ON pg_tables.tablename = pg_class.relname
JOIN 
    pg_attribute ON pg_class.oid = pg_attribute.attrelid
WHERE 
    schemaname = 's367970'
GROUP BY 
    tablename, reltuples
ORDER BY 
    COUNT(*) DESC
LIMIT 1;










