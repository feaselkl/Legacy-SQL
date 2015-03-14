CREATE TABLE [dbo].[PerformanceLog]
(
    [DatabaseName] [NVARCHAR](128) NULL,
    [SchemaName] [NVARCHAR](128) NULL,
    [ProcedureName] [NVARCHAR](128) NULL,
    [StartDateGMT] DATETIME2(7) NOT NULL,
    [EndDateGMT] DATETIME2(7) NOT NULL,
    [ParameterList] [XML] NULL,
    [RunTimeInMilliseconds] AS DATEDIFF(MILLISECOND, StartDateGMT, EndDateGMT)
);

IF (OBJECT_ID('dbo.GetFraction') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE dbo.GetFraction AS SELECT 1 AS Stub;');
END
GO
 
ALTER PROCEDURE dbo.GetFraction
    @Divisor INT = 5
AS
 
DECLARE
    @StartDateGMT DATETIME2(7) = SYSUTCDATETIME(),
    @DatabaseName NVARCHAR(128) = DB_NAME(),
    @CallingProcedureName NVARCHAR(128) = OBJECT_NAME(@@PROCID),
    @CallingSchemaName NVARCHAR(128) = OBJECT_SCHEMA_NAME(@@PROCID),
    @ParameterList XML;
 
BEGIN TRY
    SET @ParameterList =
    (
        SELECT
            @Divisor AS [@Divisor]
        FOR XML PATH ('ParameterList'), ROOT ('Root'), ELEMENTS XSINIL
    );

    --Introduce a performance problem under very specific circumstances
    IF (@Divisor = 3)
    BEGIN
        WAITFOR DELAY '00:00:03';
    END
    SELECT
        1.0 / @Divisor AS Quotient;
 
    INSERT INTO dbo.PerformanceLog
    (
        DatabaseName,
        SchemaName,
        ProcedureName,
        StartDateGMT,
        EndDateGMT,
        ParameterList
    )
    VALUES
    (
        @DatabaseName,
        @CallingSchemaName,
        @CallingProcedureName,
        @StartDateGMT,
        SYSUTCDATETIME(),
        @ParameterList
    );
END TRY
BEGIN CATCH
    DECLARE
        @ErrorLine INT,
        @ErrorMessage NVARCHAR(4000),
        @ErrorNumber INT;
 
    SELECT
        @ErrorLine = ERROR_LINE(),
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorNumber = ERROR_NUMBER();
 
    INSERT INTO dbo.ErrorLog
    (
        DatabaseName,
        SchemaName,
        ProcedureName,
        ErrorLine,
        ErrorMessage,
        LogDateGMT,
        ParameterList
    )
    VALUES
    (
        @DatabaseName,
        @CallingSchemaName,
        @CallingProcedureName,
        @ErrorLine,
        @ErrorMessage,
        GETUTCDATE(),
        @ParameterList
    );
 
    THROW 50000, @ErrorMessage, 1;
END CATCH
GO

--Execute a couple of times with fast procedure calls.
EXEC dbo.GetFraction @Divisor = 5;
EXEC dbo.GetFraction @Divisor = 10;
EXEC dbo.GetFraction @Divisor = 15;

--Now execute with a slow call.
EXEC dbo.GetFraction @Divisor = 3;

--Check the performance log for differences.
SELECT
    pl.DatabaseName,
    pl.SchemaName,
    pl.ProcedureName,
    pl.StartDateGMT,
    pl.EndDateGMT,
    pl.RunTimeInMilliseconds,
    sqlXML.value('@Divisor', 'int') AS Divisior,
    pl.ParameterList
FROM PerformanceLog pl
    CROSS APPLY pl.ParameterList.nodes('//Root/ParameterList') p(sqlXML)
WHERE
    pl.ProcedureName = 'GetFraction';

--Clean up:
DROP TABLE dbo.PerformanceLog;
DROP PROCEDURE dbo.GetFraction;
