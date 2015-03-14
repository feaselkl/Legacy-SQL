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

    UPDATE f
    SET
        SomeVal = 'C'
    OUTPUT
        DELETED.Id
    FROM #Fact f
    WHERE
        f.SomeVal = '';
ROLLBACK TRANSACTION