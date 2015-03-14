CREATE PROCEDURE dbo.TestProcedure
@SomeValue INT = 25, --Code always passes in 25
@Person VARCHAR(30) = 'Bob'
AS

IF (@SomeValue <> 25)
BEGIN
    THROW 50000, 'Value must be 25!', 1;
END
 
IF (@SomeValue = 20)
BEGIN
    SELECT 'OK' AS Result;
END
 
IF (@SomeValue = 21)
BEGIN
    SELECT 'OK' AS Result;
END
 
SELECT
    @Person AS Person,
    --'Something' AS Result
    @SomeValue AS Value;
 
--IF (@Person = 'Melinda')
--BEGIN
--  DECLARE
--      @var1 INT,
--      @var2 INT,
--      @var3 INT;
 
---- This code needs to run every time!!!
--  INSERT INTO dbo.SomeTable
--  (
--      val
--  )
--  VALUES
--  (
--      @SomeValue
--  );
 
--  SELECT
--      @var1 = v1,
--      @var2 = v2,
--      @var3 = v3
--  FROM Someplace
--  WHERE
--      Something = 29;
--END
 
IF (1 = 0)
BEGIN
    THROW 50000, 'Boolean logic has been invalidated!', 1;
END
 
SELECT
    1
FROM Something
WHERE
    1 = 0;

/* Final tally:
- 6-9 is a safety mechanism and should remain in the code base.
- 11-14 and 16-19 are logically impossible.
- Line 23 is commented out; it should be deleted.
- 26-41 and 43-50 are commented out; delete them.
- 52-55 and 57-61 are logically impossible.*/

--The new and improved version:
CREATE PROCEDURE dbo.TestProcedure
@SomeValue INT = 25, --Code always passes in 25
@Person VARCHAR(30) = 'Bob'
AS
 
IF (@SomeValue <> 25)
BEGIN
    THROW 50000, 'Value must be 25!', 1;
END
 
SELECT
    @Person AS Person,
    @SomeValue AS Value;