--Central location for handling SQL errors.
CREATE TABLE [dbo].[ErrorLog]
(
    [DatabaseName] [NVARCHAR](128) NULL,
    [SchemaName] [NVARCHAR](128) NULL,
    [ProcedureName] [NVARCHAR](128) NULL,
    [ErrorLine] [INT] NULL,
    [ErrorMessage] [NVARCHAR](4000) NULL,
    [LogDateGMT] [DATETIME] NOT NULL,
    [ParameterList] [XML] NULL
);

--Re-create our procedure with superior error handling capabilities
IF (OBJECT_ID('dbo.GetFraction') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE dbo.GetFraction AS SELECT 1 AS Stub;');
END
GO
 
ALTER PROCEDURE dbo.GetFraction
    @Divisor INT = 5
AS
 
BEGIN TRY
    SELECT
        1.0 / @Divisor AS Quotient;
END TRY
BEGIN CATCH
    DECLARE
        @DatabaseName NVARCHAR(128),
        @CallingProcedureName NVARCHAR(128),
        @CallingSchemaName NVARCHAR(128),
        @ErrorLine INT,
        @ErrorMessage NVARCHAR(4000),
        @ParameterList XML,
        @ErrorNumber INT;
 
    SELECT
        @DatabaseName = DB_NAME(),
        @CallingProcedureName = OBJECT_NAME(@@PROCID),
        @CallingSchemaName = OBJECT_SCHEMA_NAME(@@PROCID),
        @ErrorLine = ERROR_LINE(),
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorNumber = ERROR_NUMBER();
 
    SET @ParameterList =
    (
        SELECT
            @Divisor AS [@Divisor]
        FOR XML PATH ('ParameterList'), ROOT ('Root'), ELEMENTS XSINIL
    );
 
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
 
    THROW;
END CATCH
GO

--Know that we'll handle an exception here
EXEC dbo.GetFraction
    @Divisor = 0;

--Find our exception
SELECT
    el.DatabaseName,
    el.SchemaName,
    el.ProcedureName,
    el.ErrorLine,
    el.ErrorMessage,
    el.LogDateGMT,
    sqlXML.value('@Divisor', 'int') AS Divisor,
    el.ParameterList,
FROM dbo.ErrorLog el
    CROSS APPLY el.ParameterList.nodes('//Root/ParameterList') p(sqlXML)
WHERE
    el.ProcedureName = 'GetFraction';

--Clean up:
DROP TABLE dbo.ErrorLog;
DROP PROCEDURE dbo.GetFraction;