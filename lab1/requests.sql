SELECT p.name, a.name
FROM person AS p
JOIN person_characteristics AS pc ON p.id = pc.person
JOIN anomaly_person_chars AS apc ON pc.id = apc.person
JOIN anomaly AS a ON apc.anomaly = a.id;


SELECT ast.name AS action_name, loc.name AS location_name
FROM action AS a
JOIN action_stats AS ast ON a.action = ast.id
JOIN person_characteristics AS pc ON a.id = pc.current_action
JOIN location AS loc ON pc.location = loc.id;

SELECT p.name, COUNT(apc.anomaly) AS anomaly_count
FROM person AS p
LEFT JOIN person_characteristics AS pc ON p.id = pc.person
LEFT JOIN anomaly_person_chars AS apc ON pc.id = apc.person
GROUP BY p.name;

SELECT p.name, COUNT(apc.anomaly) AS anomaly_count
FROM person AS p
LEFT JOIN person_characteristics AS pc ON p.id = pc.person
LEFT JOIN anomaly_person_chars AS apc ON pc.id = apc.person
GROUP BY p.name
HAVING COUNT(apc.anomaly) > 2;

SELECT p.name, COUNT(apc.anomaly) AS anomaly_count
FROM person AS p
LEFT JOIN person_characteristics AS pc ON p.id = pc.person
LEFT JOIN anomaly_person_chars AS apc ON pc.id = apc.person
WHERE p.birthday < current_date - interval '20 years'
GROUP BY p.name;
