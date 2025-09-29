use Players

--1.1.1 Ranking Window Functions:
--ROW_NUMBER:
SELECT
    nickname,
    COUNT(*) AS achievements_count,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS row_num
FROM lr2.Player
JOIN dbo.Achievement ON lr2.Player.achievements = dbo.Achievement.id
GROUP BY nickname
ORDER BY achievements_count DESC;

--1.1.2 Offset Window Functions:
SELECT
    nickname,
    count_money,
    LAG(count_money) OVER (ORDER BY count_money) AS prev_money
FROM lr2.Player
ORDER BY count_money;

--1.1.3 Aggregate Window Functions:
SELECT
    team_name,
    AVG(rating) OVER (PARTITION BY team_name) AS avg_rating,
    MAX(rating) OVER (PARTITION BY team_name) AS max_rating,
    MIN(rating) OVER (PARTITION BY team_name) AS min_rating
FROM lr2.Team
ORDER BY team_name;

--1.2 PIVOT:
SELECT *
FROM (
    SELECT team_name, rating
    FROM lr2.Team
) AS SourceTable
PIVOT (
    AVG(rating) FOR team_name IN ([Fire Dragons], [Thunder Wolves], [Ice Phoenixes], [Rock Avengers])
) AS PivotTable;

--1.3 UNPIVOT:
SELECT team_name, team_rating
FROM (
    SELECT [Fire Dragons], [Thunder Wolves], [Ice Phoenixes], [Rock Avengers]
    FROM (
        SELECT team_name, rating
        FROM lr2.Team
    ) AS SourceTable
    PIVOT (
        AVG(rating) FOR team_name IN ([Fire Dragons], [Thunder Wolves], [Ice Phoenixes], [Rock Avengers])
    ) AS PivotTable
) AS UnpivotSource
UNPIVOT (
    team_rating FOR team_name IN ([Fire Dragons], [Thunder Wolves], [Ice Phoenixes], [Rock Avengers])
) AS UnpivotTable;

--1.4. GROUPING SETS:
SELECT
    team_name,
    achievements,
    COUNT(*) AS achievement_count
FROM lr2.Team
JOIN lr2.Player ON lr2.Team.id = lr2.Player.team_id
JOIN dbo.Achievement ON lr2.Player.achievements = dbo.Achievement.id
GROUP BY GROUPING SETS ((team_name, achievements), ());

--1.5. CUBE:
SELECT
    team_name,
    achievements,
    COUNT(*) AS achievement_count
FROM lr2.Team
JOIN lr2.Player ON lr2.Team.id = lr2.Player.team_id
JOIN dbo.Achievement ON lr2.Player.achievements = dbo.Achievement.id
GROUP BY CUBE (team_name, achievements);

--1.6. ROLLUP:
SELECT
    team_name,
    achievements,
    COUNT(*) AS achievement_count
FROM lr2.Team
JOIN lr2.Player ON lr2.Team.id = lr2.Player.team_id
JOIN dbo.Achievement ON lr2.Player.achievements = dbo.Achievement.id
GROUP BY ROLLUP (team_name, achievements);

--1.7. GROUPING():
SELECT
    team_name,
    achievements,
    GROUPING(team_name) AS team_name_grouping,
    GROUPING(achievements) AS achievement_grouping,
    COUNT(*) AS achievement_count
FROM lr2.Team
JOIN lr2.Player ON lr2.Team.id = lr2.Player.team_id
JOIN dbo.Achievement ON lr2.Player.achievements = dbo.Achievement.id
GROUP BY team_name, achievements WITH CUBE;

--1.8. GROUPING_ID():
SELECT
    team_name,
    achievements,
    GROUPING_ID(team_name, achievements) AS grouping_id,
    COUNT(*) AS achievement_count
FROM lr2.Team
JOIN lr2.Player ON lr2.Team.id = lr2.Player.team_id
JOIN dbo.Achievement ON lr2.Player.achievements = dbo.Achievement.id
GROUP BY team_name, achievements WITH CUBE;

--1.9.1. INSERT VALUES:
INSERT INTO dbo.Thing (name, price, [type])
VALUES ('New Item', 200, 'Accessory');

--1.9.4. SELECT INTO:
SELECT
    nickname,
    things,
    achievements,
    [level],
    count_money,
    team_id
INTO lr2.NewPlayerTable
FROM lr2.Player
WHERE team_id = 1;

--1.10.1. $identity:
SET IDENTITY_INSERT dbo.Thing ON;

INSERT INTO dbo.Thing (id, name, price, [type])
VALUES (100, 'Special Item', 300, 'Weapon');

SET IDENTITY_INSERT dbo.Thing OFF;

--1.10.2. @@IDENTITY:
INSERT INTO lr2.Player (nickname, things, achievements, [level], count_money, team_id)
VALUES ('NewPlayer', 1, 2, 4, 1000, 1);

SELECT @@IDENTITY AS 'LastIdentity';

--1.10.3. SCOPE_IDENTITY():
INSERT INTO lr2.Player (nickname, things, achievements, [level], count_money, team_id)
VALUES ('NewPlayer1234', 1, 2, 4, 1000, 1);

SELECT SCOPE_IDENTITY() AS 'LastIdentity';

--1.10.4. IDENT_CURRENT():
SELECT IDENT_CURRENT('dbo.Thing') AS 'CurrentIdentity';

--1.11. CREATE SEQUENCE:
CREATE SEQUENCE lr2.PlayerSequence
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 100
    CACHE 10;

--1.12.1. sys.sequences view:
SELECT
    name,
    object_id,
    schema_id,
    start_value,
    increment,
    minimum_value,
    maximum_value,
    current_value
FROM sys.sequences;

--1.13. DELETE:
DELETE FROM lr2.Player
WHERE [level] < 3;

--1.14. TRUNCATE:
TRUNCATE TABLE dbo.Thing;

--1.15. UPDATE:
UPDATE lr2.Player
SET count_money = count_money + 1000
WHERE team_id = 1;

--1.16. MERGE:
MERGE INTO lr2.Player AS Target
USING dbo.Thing AS Source
ON Target.things = Source.id
WHEN MATCHED THEN
    UPDATE SET
        Target.achievements = 1,
        Target.[level] = 3,
        Target.count_money = 500,
        Target.team_id = 1;

MERGE INTO lr2.Player AS Target
USING dbo.Thing AS Source
ON Target.things = Source.id
WHEN MATCHED AND Target.[level] < 5 THEN
    UPDATE SET Target.[level] = Target.[level] + 1;

MERGE INTO lr2.Player AS Target
USING dbo.Thing AS Source
ON Target.things = Source.id
WHEN NOT MATCHED BY SOURCE AND Target.nickname = 'JohnDoe' THEN
    DELETE

OUTPUT $action, Inserted.*, Deleted.*;

--1.17. INSERT ... OUTPUT:
DECLARE @InsertedRecords TABLE (
    id INT,
    name VARCHAR(30),
    price INT,
    [type] VARCHAR(20)
);

INSERT INTO dbo.Thing (name, price, [type])
OUTPUT INSERTED.id, INSERTED.name, INSERTED.price, INSERTED.[type] INTO @InsertedRecords
VALUES ('NewThing2', 200, 'NewType');

-- 1.18. DELETE ... OUTPUT:
SELECT * FROM @InsertedRecords;

DECLARE @DeletedRecords TABLE (
    id INT,
    nickname VARCHAR(30),
    things INT,
    achievements INT,
    [level] INT,
    count_money INT,
    team_id INT
);

DELETE FROM lr2.Player
OUTPUT DELETED.id, DELETED.nickname, DELETED.things, DELETED.achievements, DELETED.[level], DELETED.count_money, DELETED.team_id INTO @DeletedRecords
WHERE nickname = 'JohnDoe';

-- 1.19. UPDATE ... OUTPUT:
SELECT * FROM @DeletedRecords;
DECLARE @UpdatedRecords TABLE (
    id INT,
    nickname VARCHAR(30),
    things INT,
    achievements INT,
    [level] INT,
    count_money INT,
    team_id INT
);

UPDATE lr2.Player
SET [level] = [level] + 1
OUTPUT INSERTED.id, INSERTED.nickname, INSERTED.things, INSERTED.achievements, INSERTED.[level], INSERTED.count_money, INSERTED.team_id INTO @UpdatedRecords
WHERE nickname = 'JaneDoe';

--1.20. MERGE ... OUTPUT:
SELECT * FROM @UpdatedRecords;

DECLARE @MergedRecords TABLE (
    ActionTaken NVARCHAR(10),
    id INT,
    nickname VARCHAR(30),
    things INT,
    achievements INT,
    [level] INT,
    count_money INT,
    team_id INT
);

MERGE INTO lr2.Player AS Target
USING dbo.Thing AS Source
ON Target.things = Source.id
WHEN MATCHED THEN
    UPDATE SET Target.achievements = 1
WHEN NOT MATCHED THEN
    INSERT (nickname, things, achievements, [level], count_money, team_id)
    VALUES ('NewPlayer777', Source.id, 1, 3, 500, 1)
OUTPUT $action, INSERTED.* INTO @MergedRecords;

-- Retrieve the merged records
SELECT * FROM @MergedRecords;