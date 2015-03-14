BEGIN TRANSACTION
    CREATE TABLE #Fact
    (
        Id INT,
        SomeVal CHAR(1)
    );

    INSERT INTO dbo.#Fact
    (
        Id,
        SomeVal
    )
    VALUES
    (0,''),
    (1, 'A'),
    (2, 'B'),
    (3, 'A'),
    (4, '');

    CREATE TABLE #tmp
    (
        Id INT
    );

    INSERT INTO dbo.#tmp
    (
        Id
    )
    SELECT
        Id
    FROM #Fact
    WHERE
        SomeVal = '';

    UPDATE f
    SET
        SomeVal = 'C'
    FROM #Fact f
        INNER JOIN #tmp t
            ON f.Id = t.Id;
 
    SELECT
        Id
    FROM #tmp;
ROLLBACK TRANSACTION