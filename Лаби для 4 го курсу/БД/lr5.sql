use Players
go
-- ������� 1.1.1: Self-contained subquery (single-valued)
SELECT *
FROM lr2.Player
WHERE [level] = (SELECT MAX([level]) FROM lr2.Player);

-- ������� 1.1.2: Self-contained subquery (multivalued) � ���������� IN
SELECT *
FROM lr2.Player
WHERE [level] IN (10,11,12,13,14,15);

-- ������� 1.1.2: Self-contained subquery (multivalued) � ���������� SOME
SELECT *
FROM lr2.Player
WHERE count_money > SOME (SELECT AVG(count_money) FROM lr2.Player);

SELECT *
FROM lr2.Player p
WHERE count_money > SOME (SELECT AVG(count_money) FROM lr2.Player WHERE team_id = p.team_id);

-- ������� 1.2.2: ������������ ������� (multivalued) � ���������� IN
SELECT *
FROM lr2.Team t
WHERE t.id IN (SELECT id FROM lr2.Player p WHERE p.count_money > 1000 AND p.team_id = t.id);

-- ������� 1.2.2: ������������ ������� (multivalued) � ���������� SOME
SELECT *
FROM lr2.Player p
WHERE [level] > SOME (SELECT [level] FROM lr2.Player WHERE team_id = p.team_id);

-- ������� 1.2.2: ������������ ������� (multivalued) � ���������� ALL
SELECT *
FROM lr2.Team t
WHERE t.id = ALL (SELECT team_id FROM lr2.Player p WHERE p.[level] > 5 AND p.team_id = t.id);

-- ������� 1.3.1: ������������ EXISTS ��� ����������� ������, ��� ���� ������� ��������
SELECT *
FROM lr2.Player p
WHERE EXISTS (
    SELECT 1
    FROM lr2.Team t
    WHERE t.id = p.team_id AND t.team_name = 'Fire Dragons'
);

-- ������� 1.3.2: ������������ EXISTS ��� ����������� ������, �� �� ����� ��������
SELECT *
FROM lr2.Team t
WHERE NOT EXISTS (
    SELECT 1
    FROM lr2.Player p
    WHERE p.team_id = t.id
);

-- ������� 1.3.3: ������������ EXISTS ��� �������� �������� ������� ������ � �������
SELECT *
FROM lr2.Team t
WHERE EXISTS (
    SELECT 1
    FROM lr2.Player p
    WHERE p.team_id = t.id AND p.count_money > 10000
);

-- ������� 1.4.1: Nested Derived Tables: �������� ������� ������� ��� ���������� ���������� ���� ������� ������
SELECT *, avg_level
FROM (
    SELECT t.team_name, AVG(p.[level]) AS avg_level
    FROM lr2.Team t
    INNER JOIN lr2.Player p ON t.id = p.team_id
    GROUP BY t.team_name
) AS TeamLevel
WHERE avg_level > 5;

-- ������� 1.4.2: ������������ ������� ������� ��� ���������� �������� �� ������� ������� � ������
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

-- ������� 1.5.1: ������������ ���� CTE ��� ���������� ���������� �������� �� ������� ������� � ��������
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

-- ������� 1.5.2: ������������ ���� ������ CTE ���� ��� ��������� ����� ��� ������� �� �������
WITH TeamPlayerInfo AS (
    SELECT p.nickname, p.[level], t.team_name
    FROM lr2.Player p
    INNER JOIN lr2.Team t ON p.team_id = t.id
)
SELECT tpi1.nickname AS player1, tpi2.nickname AS player2
FROM TeamPlayerInfo tpi1
JOIN TeamPlayerInfo tpi2 ON tpi1.team_name = tpi2.team_name
WHERE tpi1.nickname < tpi2.nickname;

-- ������� 1.5.3: ����������� CTE ��� �������� �������� ������ �� �� ��������
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

-- ������� 1.6: ��������� ��������� � ������� ENCRYPTION, SCHEMABINDING �� CHECK OPTION ��� ������� � ������
CREATE VIEW lr2.TeamPlayersView
WITH SCHEMABINDING
AS
SELECT
    p.nickname AS PlayerName,
    t.team_name AS TeamName
FROM lr2.Player p
INNER JOIN lr2.Team t ON p.team_id = t.id
WHERE p.level > 5

-- ������� 1.7: ��������� inline ������� �������, ��� ������� ������� � ������� ������� � ������
CREATE FUNCTION dbo.GetPlayersInTeam (@teamId INT)
RETURNS TABLE
AS
RETURN (
    SELECT p.nickname, p.[level]
    FROM lr2.Player p
    WHERE p.team_id = @teamId
);
-- ������������ �������
SELECT * FROM dbo.GetPlayersInTeam(1);

-- ������� 1.8.1: ������������ CROSS APPLY ��� ��������� ����� ������� �� �� ������
SELECT p.nickname, t.team_name
FROM lr2.Player p
CROSS APPLY (
    SELECT team_name
    FROM lr2.Team t
    WHERE t.id = p.team_id
) AS t;

-- ������� 1.8.2: ������������ OUTER APPLY ��� ��������� ����� ������� �� �� ������, ��������� ������� ��� ������
SELECT p.nickname, t.team_name
FROM lr2.Player p
OUTER APPLY (
    SELECT team_name
    FROM lr2.Team t
    WHERE t.id = p.team_id
) AS t;