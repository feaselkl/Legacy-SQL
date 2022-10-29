/* Demo 1:  use DATE */
--Actually available in SQL Server 2008 and later.
SELECT
    DATEADD(DAY, 0, DATEDIFF(DAY, 0, GETUTCDATE()));

SELECT
    CAST(GETUTCDATE() AS DATE);

--Casting to a DATE type is easier to read, easier to understand,
--and harder to get wrong.  Just make sure your calling code
--handles DATE types correctly!



/* Demo 2:  use CONCAT */
SELECT
    'This is a string.  ' +
    ISNULL(NULL, '') +
    CAST(12 AS VARCHAR(50)) +
    '   .....   ' +
    CAST(31.884 AS VARCHAR(50)) +
    'Some other string.  ';

SELECT
    CONCAT
    (
        'This is a string.  ',
        NULL,
        12,
        '   .....   ',
        31.884,
        'Some other string.  '
    );

--CONCAT takes care of NULL values, converting numeric values,
--and several other string concatenation problems.


/* Demo 3:  Running Totals */
--REQUIRES SQL Server 2012 or later!
USE [TSQLV6]
GO

--Query to show what we're dealing with:
SELECT
	o.orderid,
	o.custid,
	o.empid,
	o.orderdate,
	od.productid,
	od.unitprice,
	od.qty
FROM Sales.Orders o
	INNER JOIN Sales.OrderDetails od
		ON od.orderid = o.orderid
WHERE
	o.orderid IN (10252, 10418)
ORDER BY
	o.orderid,
	od.productid;

--Cursor version
CREATE TABLE #x
(
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    LineTotal MONEY NOT NULL,
    RunningTotal MONEY NULL
);
ALTER TABLE #x ADD CONSTRAINT [PK_x] PRIMARY KEY CLUSTERED(OrderID, ProductID);

INSERT INTO #x
(
    OrderID,
    ProductID,
    LineTotal
)
SELECT
	o.orderid,
	od.productid,
	od.unitprice * od.qty
FROM Sales.Orders o
	INNER JOIN Sales.OrderDetails od
		ON od.orderid = o.orderid
WHERE
	o.orderid IN (10252, 10418)
ORDER BY
	o.orderid,
	od.productid;

DECLARE
    @CurrentOrderID INT = 0,
    @OrderID INT,
    @ProductID INT,
    @LineTotal MONEY,
    @RunningTotal MONEY = 0;

DECLARE c CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR
    SELECT
        OrderID,
        ProductID,
        Linetotal
    FROM #x
    ORDER BY
        OrderID,
        ProductID;

OPEN c;

FETCH c INTO @OrderID, @ProductID, @LineTotal;

WHILE (@@FETCH_STATUS = 0)
BEGIN
    IF (@CurrentOrderID <> @OrderID)
    BEGIN
        SET @RunningTotal = @LineTotal;
        SET @CurrentOrderID = @OrderID;
    END
    ELSE
    BEGIN
        SET @RunningTotal = @RunningTotal + @LineTotal;
    END

    UPDATE #x
    SET RunningTotal = @RunningTotal
    WHERE
        OrderID = @OrderID
        AND ProductID = @ProductID;

    FETCH c INTO @OrderID, @ProductID, @LineTotal;
END

CLOSE c;
DEALLOCATE c;

SELECT
    OrderID,
    ProductID,
    LineTotal,
    RunningTotal
FROM #x;

DROP TABLE #x;
GO


--Self-Join
SELECT
    od.orderid AS OrderID,
	od.productid AS ProductID,
	od.qty * od.unitprice AS LineTotal,
	SUM(od2.qty * od2.unitprice) AS RunningTotal
FROM Sales.OrderDetails od
    LEFT OUTER JOIN Sales.OrderDetails od2
        ON od.orderid = od2.orderid
        AND od2.productid <= od.productid
WHERE
	od.orderid IN (10252, 10418)
GROUP BY
    od.orderid,
	od.productid,
	od.qty * od.unitprice
ORDER BY
    OrderID,
    ProductID;


--SQL Server 2012 version:
SELECT
    od.orderid AS OrderID,
	od.productid AS ProductID,
	od.qty * od.unitprice AS LineTotal,
	SUM(od.qty * od.unitprice) OVER
		(
			PARTITION BY od.orderid
			ORDER BY od.productid
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		) AS RunningTotal
FROM Sales.OrderDetails od
WHERE
	od.orderid IN (10252, 10418)
ORDER BY
    OrderID,
    ProductID;
GO

/* Demo 4:  TRY_*** */
SELECT CAST(12 AS DECIMAL(12,2)) AS ValidCast;
SELECT CAST('12' AS DECIMAL(12,2)) AS AnotherValidCast;
SELECT CAST('UH-OH' AS DECIMAL(12,2)) AS InvalidCast;

SELECT TRY_CAST('UH-OH' AS DECIMAL(12,2)) AS InvalidCastReturnsNull;
SELECT TRY_CONVERT(DECIMAL(12,2), 'UH-OH') AS InvalidConvertReturnsNull;

-- TRY_CAST() and TRY_CONVERT() are just as fast as CAST() and CONVERT()
-- but are NULL-safe.  TRY_PARSE() is much slower but does support neat functionality.

SELECT
    TRY_PARSE('01/13/2019' AS DATE USING 'en-us') AS January13US,
    TRY_PARSE('01/13/2019' AS DATE USING 'fr-fr') AS Smarch1FR;