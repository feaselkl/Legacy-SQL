/* Demo 1:  CONCAT_WS */
--REQUIRES SQL Server 2017 or later!
SELECT
    CONCAT
    (
        'This is a string.  ',
        NULL,
        12,
        '   .....   ',
        31.884,
        'Some other string.  ' 
    ),
    CONCAT_WS
    (
        ' ||| ',
        'This is a string.  ',
        NULL,
        12,
        '   .....   ',
        31.884,
        'Some other string.  '
    );


/* Demo 2:  TRIM */
DECLARE
    @SomeString NVARCHAR(100) = N'                  This is         my string.                  ';

SELECT
    DATALENGTH(@SomeString) AS StringLength,
    @SomeString;

SELECT
    DATALENGTH(LTRIM(RTRIM(@SomeString))) AS StringLength,
    LTRIM(RTRIM(@SomeString));

SELECT
    DATALENGTH(TRIM(@SomeString)) AS StringLength,
    TRIM(@SomeString);
GO

-- Watch out for tabs, through!
DECLARE
    @SomeString NVARCHAR(100) = N'			          This is         my string.              		  	  ';

SELECT
    DATALENGTH(@SomeString) AS StringLength,
    @SomeString;

SELECT
    DATALENGTH(LTRIM(RTRIM(@SomeString))) AS StringLength,
    LTRIM(RTRIM(@SomeString));

SELECT
    DATALENGTH(TRIM(@SomeString)) AS StringLength,
    TRIM(@SomeString);

SELECT
    DATALENGTH(TRIM(' '+char(9) FROM @SomeString)) AS StringLength,
    TRIM(' '+char(9) FROM @SomeString);
GO

-- Spaces aren't the only things you can trim.
DECLARE
    @SomeString NVARCHAR(100) = N'OKThis is the real string, OK?OK';

SELECT
    TRIM('KO' FROM @SomeString);
GO

/* Demo 3:  TRANSLATE() */
DECLARE
    @SomeInputString NVARCHAR(100) = N'I forget [sometimes] that I should {use parentheses} instead of (square brackets).';

SELECT
    TRANSLATE(@SomeInputString, '[]{}', '()()');
GO

-- Cannot simply miss characters.
DECLARE
    @SomeInputString NVARCHAR(100) = N'I forget [sometimes] that I should {use parentheses} instead of (square brackets).';

SELECT
    TRANSLATE(@SomeInputString, '[]{}', '()');
GO

-- Direct 1:1 comparison with no context.
DECLARE
    @SomeInputString NVARCHAR(100) = N'I forget [sometimes] that I should {use parentheses} instead of (square brackets).';

SELECT
    TRANSLATE(@SomeInputString, '[f]{}', '(c)()');
GO

-- Casing doesn't matter with this collation and limited to same number of chars in input + output
DECLARE
    @SomeInputString NVARCHAR(100) = N'I forget [sometimes] that I should {use parentheses} instead of (square brackets).';

SELECT
    TRANSLATE(@SomeInputString, 'I[]{}', 'U()()');
GO

/* Demo 4:  STRING_AGG() */
CREATE TABLE #States
(
    StateProvinceCode CHAR(2),
    SalesTerritory VARCHAR(20)
);
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('AL', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('AK', 'Far West');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('AZ', 'Southwest');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('AR', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('CA', 'Far West');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('CO', 'Rocky Mountain');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('CT', 'New England');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('DE', 'Mideast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('DC', 'Mideast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('FL', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('GA', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('HI', 'Far West');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('ID', 'Rocky Mountain');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('IL', 'Great Lakes');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('IN', 'Great Lakes');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('IA', 'Plains');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('KS', 'Plains');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('KY', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('LA', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('ME', 'New England');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('MD', 'Mideast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('MA', 'New England');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('MI', 'Great Lakes');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('MN', 'Plains');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('MS', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('MO', 'Plains');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('MT', 'Rocky Mountain');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('NE', 'Plains');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('NV', 'Far West');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('NH', 'New England');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('NJ', 'Mideast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('NM', 'Southwest');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('NY', 'Mideast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('NC', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('ND', 'Plains');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('OH', 'Great Lakes');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('OK', 'Southwest');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('OR', 'Far West');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('PA', 'Mideast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('PR', 'External');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('RI', 'New England');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('SC', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('SD', 'Plains');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('TN', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('TX', 'Southwest');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('UT', 'Rocky Mountain');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('VT', 'New England');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('VI', 'External');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('VA', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('WA', 'Far West');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('WV', 'Southeast');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('WI', 'Great Lakes');
INSERT INTO #States(StateProvinceCode, SalesTerritory) VALUES('WY', 'Rocky Mountain');

SELECT
    SalesTerritory,
    StateProvinceCode
FROM #States s;

SELECT
    SalesTerritory,
    STRING_AGG(StateProvinceCode, ',')  AS StatesList
FROM #States s
GROUP BY
    SalesTerritory;

-- Sorting by state name
SELECT
    SalesTerritory,
    STRING_AGG(StateProvinceCode, ',')
        WITHIN GROUP(ORDER BY StateProvinceCode)  AS StatesList
FROM #States s
GROUP BY
    SalesTerritory;
