/* Demo 1:  CREATE OR ALTER */
--REQUIRES SQL Server 2016 or later!

USE [TSQLV6]
GO

CREATE OR ALTER PROCEDURE dbo.ExecuteSomething
(
@InputParameter INT
)
AS
    SELECT @InputParameter AS Result;
GO

EXEC dbo.ExecuteSomething @InputParameter = 42;
GO

CREATE OR ALTER PROCEDURE dbo.ExecuteSomething
(
@InputParameter NVARCHAR(50)
)
AS
    SELECT @InputParameter AS Result;
GO

EXEC dbo.ExecuteSomething @InputParameter = N'42';
GO

/* Demo 2:  DROP IF EXISTS */
DROP PROCEDURE IF EXISTS dbo.ExecuteSomething;
DROP TABLE IF EXISTS dbo.SomeMissingTable;
DROP VIEW IF EXISTS dbo.SomeMissingView;

/* Demo 3:  STRING_SPLIT() */
DECLARE
    @InputString NVARCHAR(4000) = N'123,456,789,Cat,Dog,Fish,782437,18.46,Something with a space.';

SELECT *
FROM
    STRING_SPLIT(@InputString, N',')
GO
