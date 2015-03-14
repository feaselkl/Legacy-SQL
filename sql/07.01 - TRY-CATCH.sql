CREATE PROCEDURE dbo.GetFraction
    @Divisor INT = 5
AS
 
SELECT
    1.0 / @Divisor AS Quotient;
GO

--Test that our procedure works as expected
EXEC dbo.GetFraction
    @Divisor = 5;

--Now try to divide by zero
EXEC dbo.GetFraction
    @Divisor = 0;

--Problem:  where does that error go?
--Might boil up to the application, but what if this was
--deep in a SQL Agent Job?  What if the app squelches errors?

--New version which handles TRY-CATCH better
ALTER PROCEDURE dbo.GetFraction
    @Divisor INT = 5
AS
 
BEGIN TRY
    SELECT
        1.0 / @Divisor AS Quotient;
END TRY
BEGIN CATCH
    DECLARE
        @ErrorMessage NVARCHAR(4000);
 
    SELECT
        @ErrorMessage = ERROR_MESSAGE();
 
    THROW 50000, @ErrorMessage, 1;
END CATCH
GO

--NOTE:  we still aren't logging the data...yet.

--Clean up when we're done.
DROP PROCEDURE dbo.GetFraction;