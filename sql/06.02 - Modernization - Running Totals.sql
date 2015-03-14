--Demo 3:  Running Totals
--REQUIRES SQL Server 2012 or later!

USE [AdventureWorks2012]
GO

--Query to show what we're dealing with:
SELECT
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    sod.LineTotal
FROM Sales.SalesOrderDetail sod
WHERE
    SalesOrderID IN (43659, 43661)
ORDER BY
    SalesOrderDetailID ASC;

--Cursor version
CREATE TABLE #x
(
    SalesOrderID INT NOT NULL,
    SalesOrderDetailID INT NOT NULL,
    LineTotal MONEY NOT NULL,
    RunningTotal MONEY NULL
);
ALTER TABLE #x ADD CONSTRAINT [PK_x] PRIMARY KEY CLUSTERED(SalesOrderID, SalesOrderDetailID);

INSERT INTO #x
(
    SalesOrderID,
    SalesOrderDetailID,
    LineTotal
)
SELECT
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    sod.LineTotal
FROM Sales.SalesOrderDetail sod
WHERE
    sod.SalesOrderID IN (43659, 43661)
ORDER BY
    sod.SalesOrderID ASC,
    sod.SalesOrderDetailID ASC;

DECLARE
    @SalesOrderID INT,
    @SalesOrderDetailID INT,
    @LineTotal MONEY,
    @RunningTotal MONEY = 0;

DECLARE c CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR
    SELECT
        SalesOrderID,
        SalesOrderDetailID,
        Linetotal
    FROM #x
    ORDER BY
        SalesOrderID,
        SalesOrderDetailID;

OPEN c;

FETCH c INTO @SalesOrderID, @SalesOrderDetailID, @Linetotal;

WHILE (@@FETCH_STATUS = 0)
BEGIN
    SET @RunningTotal = @RunningTotal + @LineTotal;
    UPDATE #x
    SET RunningTotal = @RunningTotal
    WHERE
        SalesOrderID = @SalesOrderID
        AND SalesOrderDetailID = @SalesOrderDetailID;

    FETCH c INTO @SalesOrderID, @SalesOrderDetailID, @Linetotal;
END

CLOSE c;
DEALLOCATE c;

SELECT
    SalesOrderID,
    SalesOrderDetailID,
    LineTotal,
    RunningTotal
FROM #x;

DROP TABLE #x;


--Self-Join
SELECT
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    sod.LineTotal,
    SUM(sod2.LineTotal) AS RunningTotal
FROM Sales.SalesOrderDetail sod
    LEFT OUTER JOIN Sales.SalesOrderDetail sod2
        ON sod2.SalesOrderID = sod.SalesOrderID
        AND sod2.SalesOrderDetailID <= sod.SalesOrderDetailID
WHERE
    sod.SalesOrderID IN (43659, 43661)
GROUP BY
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    sod.LineTotal
ORDER BY
    sod.SalesOrderID,
    sod.SalesOrderDetailID;


--SQL Server 2012 version:
SELECT
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    sod.LineTotal,
    SUM(sod.LineTotal) OVER
        (
            PARTITION BY sod.SalesOrderID
            ORDER BY sod.SalesOrderDetailID
            ROWS UNBOUNDED PRECEDING
        ) AS RunningTotal
FROM Sales.SalesOrderDetail sod
WHERE
    sod.SalesOrderID IN (43659, 43661)
ORDER BY
    sod.SalesOrderID,
    sod.SalesOrderDetailID ASC;