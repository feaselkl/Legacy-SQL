/* Demo 1:  APPROX_COUNT_DISTINCT */
-- Requires SQL Server 2019

DROP TABLE IF EXISTS dbo.LargeTable;
GO
CREATE TABLE dbo.LargeTable
(
	Id INT IDENTITY(1,1) NOT NULL,
	SomeIntColumn INT NOT NULL,
	CONSTRAINT [PK_LargeTable] PRIMARY KEY CLUSTERED(Id)
);
GO

INSERT INTO dbo.LargeTable
(
	SomeIntColumn
)
SELECT TOP(40000000)
	checksum(newid())
FROM sys.all_columns c1
	CROSS JOIN sys.all_columns c2
GO

SELECT
    COUNT(DISTINCT SomeIntColumn) AS UniqueValues
FROM dbo.LargeTable;

SELECT
    APPROX_COUNT_DISTINCT(SomeIntColumn) AS UniqueValues
FROM dbo.LargeTable;
GO
