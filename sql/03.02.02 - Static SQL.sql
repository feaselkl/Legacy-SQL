DECLARE
    @SomeVar INT = 6; -- input parameter

BEGIN TRY
    SELECT
        SomeColumn,
        SomeOtherColumn
    FROM SomeTable
    WHERE
        Something = CASE WHEN @SomeVar = 8 THEN 38 ELSE Something END;
END TRY
BEGIN CATCH
    PRINT 'Error!';
END CATCH