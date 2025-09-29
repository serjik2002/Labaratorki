use Players
go
-- Приклад 1.1.1: Self-contained subquery (single-valued)
SELECT *
FROM lr2.Player
WHERE [level] = (SELECT MAX([level]) FROM lr2.Player);

-- Приклад 1.1.2: Self-contained subquery (multivalued) з оператором IN
SELECT *
FROM lr2.Player
WHERE [level] IN (10,11,12,13,14,15);

-- Приклад 1.1.2: Self-contained subquery (multivalued) з оператором SOME
SELECT *
FROM lr2.Player
WHERE count_money > SOME (SELECT AVG(count_money) FROM lr2.Player);

SELECT *
FROM lr2.Player p
WHERE count_money > SOME (SELECT AVG(count_money) FROM lr2.Player WHERE team_id = p.team_id);

-- Приклад 1.2.2: Корельований підзапит (multivalued) з оператором IN
SELECT *
FROM lr2.Team t
WHERE t.id IN (SELECT id FROM lr2.Player p WHERE p.count_money > 1000 AND p.team_id = t.id);

-- Приклад 1.2.2: Корельований підзапит (multivalued) з оператором SOME
SELECT *
FROM lr2.Player p
WHERE [level] > SOME (SELECT [level] FROM lr2.Player WHERE team_id = p.team_id);

-- Приклад 1.2.2: Корельований підзапит (multivalued) з оператором ALL
SELECT *
FROM lr2.Team t
WHERE t.id = ALL (SELECT team_id FROM lr2.Player p WHERE p.[level] > 5 AND p.team_id = t.id);

-- Приклад 1.3.1: Використання EXISTS для знаходження записів, для яких існують підзапити
SELECT *
FROM lr2.Player p
WHERE EXISTS (
    SELECT 1
    FROM lr2.Team t
    WHERE t.id = p.team_id AND t.team_name = 'Fire Dragons'
);

-- Приклад 1.3.2: Використання EXISTS для знаходження записів, які не мають підзапитів
SELECT *
FROM lr2.Team t
WHERE NOT EXISTS (
    SELECT 1
    FROM lr2.Player p
    WHERE p.team_id = t.id
);

-- Приклад 1.3.3: Використання EXISTS для перевірки наявності певного запису в підзапиті
SELECT *
FROM lr2.Team t
WHERE EXISTS (
    SELECT 1
    FROM lr2.Player p
    WHERE p.team_id = t.id AND p.count_money > 10000
);

-- Приклад 1.4.1: Nested Derived Tables: Вкладена похідна таблиця для обчислення середнього рівня гравців команд
SELECT *, avg_level
FROM (
    SELECT t.team_name, AVG(p.[level]) AS avg_level
    FROM lr2.Team t
    INNER JOIN lr2.Player p ON t.id = p.team_id
    GROUP BY t.team_name
) AS TeamLevel
WHERE avg_level > 5;

-- Приклад 1.4.2: Використання похідної таблиці для обчислення рейтингу та кількості гравців у команді
SELECT TeamRating.team_name, TeamRating.avg_level, TeamPlayerCount.player_count
FROM (
    SELECT t.team_name, AVG(p.[level]) AS avg_level
    FROM lr2.Team t
    INNER JOIN lr2.Player p ON t.id = p.team_id
    GROUP BY t.team_name
) AS TeamRating
INNER JOIN (
    SELECT t.team_name, COUNT(p.id) AS player_count
    FROM lr2.Team t
    INNER JOIN lr2.Player p ON t.id = p.team_id
    GROUP BY t.team_name
) AS TeamPlayerCount ON TeamRating.team_name = TeamPlayerCount.team_name;

-- Приклад 1.5.1: Використання двох CTE для обчислення середнього рейтингу та кількості гравців в командах
WITH TeamRating AS (
    SELECT t.team_name, AVG(p.[level]) AS avg_level
    FROM lr2.Team t
    INNER JOIN lr2.Player p ON t.id = p.team_id
    GROUP BY t.team_name
),
TeamPlayerCount AS (
    SELECT t.team_name, COUNT(p.id) AS player_count
    FROM lr2.Team t
    INNER JOIN lr2.Player p ON t.id = p.team_id
    GROUP BY t.team_name
)
SELECT TeamRating.team_name, TeamRating.avg_level, TeamPlayerCount.player_count
FROM TeamRating
INNER JOIN TeamPlayerCount ON TeamRating.team_name = TeamPlayerCount.team_name;

-- Приклад 1.5.2: Використання того самого CTE двічі для отримання даних про гравців та команди
WITH TeamPlayerInfo AS (
    SELECT p.nickname, p.[level], t.team_name
    FROM lr2.Player p
    INNER JOIN lr2.Team t ON p.team_id = t.id
)
SELECT tpi1.nickname AS player1, tpi2.nickname AS player2
FROM TeamPlayerInfo tpi1
JOIN TeamPlayerInfo tpi2 ON tpi1.team_name = tpi2.team_name
WHERE tpi1.nickname < tpi2.nickname;

-- Приклад 1.5.3: Рекурсивний CTE для побудови ієрархії команд та їх керівників
WITH RecursiveTeamHierarchy AS (
    SELECT id, team_name, NULL AS leader_id, 0 AS [level]
    FROM lr2.Team
    WHERE id NOT IN (SELECT DISTINCT team FROM lr2.Teamleader)

    UNION ALL

    SELECT t.id, t.team_name, tl.player AS leader_id, rth.[level] + 1
    FROM lr2.Team t
    JOIN lr2.Teamleader tl ON t.id = tl.team
    JOIN RecursiveTeamHierarchy rth ON tl.player = rth.id
)
SELECT id, team_name, leader_id, [level]
FROM RecursiveTeamHierarchy
ORDER BY [level], id;

-- Приклад 1.6: Створення перегляду з опціями ENCRYPTION, SCHEMABINDING та CHECK OPTION для гравців у команді
CREATE VIEW lr2.TeamPlayersView
WITH SCHEMABINDING
AS
SELECT
    p.nickname AS PlayerName,
    t.team_name AS TeamName
FROM lr2.Player p
INNER JOIN lr2.Team t ON p.team_id = t.id
WHERE p.level > 5

-- Приклад 1.7: Створення inline функції звітності, яка повертає таблицю зі списком гравців у команді
CREATE FUNCTION dbo.GetPlayersInTeam (@teamId INT)
RETURNS TABLE
AS
RETURN (
    SELECT p.nickname, p.[level]
    FROM lr2.Player p
    WHERE p.team_id = @teamId
);
-- Використання функції
SELECT * FROM dbo.GetPlayersInTeam(1);

-- Приклад 1.8.1: Використання CROSS APPLY для отримання даних гравців та їх команд
SELECT p.nickname, t.team_name
FROM lr2.Player p
CROSS APPLY (
    SELECT team_name
    FROM lr2.Team t
    WHERE t.id = p.team_id
) AS t;

-- Приклад 1.8.2: Використання OUTER APPLY для отримання даних гравців та їх команд, включаючи гравців без команд
SELECT p.nickname, t.team_name
FROM lr2.Player p
OUTER APPLY (
    SELECT team_name
    FROM lr2.Team t
    WHERE t.id = p.team_id
) AS t;