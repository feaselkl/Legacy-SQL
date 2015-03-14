DECLARE
    @SomeVar INT = 6; -- input parameter

BEGIN TRY

    DECLARE
        @sql NVARCHAR(MAX) = N'
SELECT
    SomeColumn,
    SomeOtherColumn
FROM SomeTable
WHERE
    1 = 1' + CASE WHEN @SomeVar = 8 THEN N'
    AND Something = 38;';

    EXEC (@sql);
END TRY
BEGIN CATCH
    PRINT 'Error!';
END CATCH