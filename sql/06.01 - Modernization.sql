--Demo 1:  use DATE
SELECT
    DATEADD(DAY, 0, DATEDIFF(DAY, 0, GETUTCDATE()));

SELECT
    CAST(GETUTCDATE() AS DATE);

--Casting to a DATE type is easier to read, easier to understand,
--and harder to get wrong.  Just make sure your calling code
--handles DATE types correctly!



--Demo 2:  use CONCAT
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
