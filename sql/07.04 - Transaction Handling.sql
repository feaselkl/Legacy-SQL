IF (OBJECT_ID('dbo.GetFraction') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE dbo.GetFraction AS SELECT 1 AS Stub;');
END
GO
 
ALTER PROCEDURE dbo.GetFraction
    @Divisor INT = 5
AS
 
DECLARE
    @InNestedTransaction BIT;
 
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
 
    IF ( @@TRANCOUNT > 0 )
    BEGIN
        SET @InNestedTransaction = 1;
    END
    ELSE
    BEGIN
        SET @InNestedTransaction = 0;
        BEGIN TRANSACTION;
    END;
 
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
 
    IF ( @InNestedTransaction = 0 AND @@TRANCOUNT > 0 )
    BEGIN
        COMMIT TRANSACTION;
    END;
END TRY
BEGIN CATCH
    IF ( @InNestedTransaction = 0 AND @@TRANCOUNT > 0 )
    BEGIN
        ROLLBACK TRANSACTION;
    END
 
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

--Test the procedure
EXEC dbo.GetFraction @Divisor = 5;

--Start an explicit transaction
BEGIN TRANSACTION
EXEC dbo.GetFraction @Divisor = 5;
SELECT @@TRANCOUNT;
ROLLBACK TRANSACTION