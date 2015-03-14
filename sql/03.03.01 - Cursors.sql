--Problem description:  for each value in Temp1, get a comma-separated list of values in Temp2.
CREATE TABLE #Temp1
(
	Id INT,
	Value CHAR(1)
);

CREATE TABLE #Temp2
(
	Id INT,
	Temp1Id INT,
	Value CHAR(1)
);

INSERT INTO #Temp1(Id, Value) VALUES (1, 'A'), (2, 'B'), (3, 'C'), (4, 'D');
INSERT INTO #Temp2(Id, Temp1Id, Value) VALUES(1, 1, 'Z'), (2, 1, 'Y'), (3, 2, 'X'), (4, 1, 'W'), (5, 2, 'V');



--Step 1:  the cursor version
DECLARE
	@Temp1_Id INT,
	@Temp1_Value CHAR(1),
	@Temp2_Id INT,
	@Temp2_Temp1Id INT,
	@Temp2_Value CHAR(1);

DECLARE @TempValues TABLE
(
	Id INT,
	Value CHAR(1),
	Temp2Values VARCHAR(20)
);

DECLARE
	@Temp2ValuesString VARCHAR(20);

DECLARE c1 CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR
	SELECT
		Id,
		Value
	FROM #Temp1
	ORDER BY
		Id;

OPEN c1;
FETCH c1 INTO @Temp1_Id, @Temp1_Value;

WHILE (@@FETCH_STATUS = 0)
BEGIN
	SET @Temp2ValuesString = '';

	DECLARE c2 CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR
		SELECT
			Id,
			Temp1Id,
			Value
		FROM #Temp2
		WHERE
			Temp1Id = @Temp1_Id
		ORDER BY
			Id;

	OPEN c2;
	FETCH c2 INTO @Temp2_Id, @Temp2_Temp1Id, @Temp2_Value;

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @Temp2ValuesString = @Temp2ValuesString + @Temp2_Value + ',';

		FETCH c2 INTO @Temp2_Id, @Temp2_Temp1Id, @Temp2_Value;
	END

	CLOSE c2;
	DEALLOCATE c2;

	--Remove the final comma
	IF (LEN(@Temp2ValuesString) > 0)
	BEGIN
		SET @Temp2ValuesString = SUBSTRING(@Temp2ValuesString, 1, LEN(@Temp2ValuesString) - 1);
	END

	INSERT INTO @TempValues
	(
		Id,
		Value,
		Temp2Values
	)
	VALUES
	(
		@Temp1_Id,
		@Temp1_Value,
		@Temp2ValuesString
	)
	
	FETCH c1 INTO @Temp1_Id, @Temp1_Value;
END

CLOSE c1;
DEALLOCATE c1;

SELECT
	Id,
	Value,
	Temp2Values
FROM @TempValues;

--Step 2:  the set-based version
SELECT
	t1.Id,
	t1.Value,
	ISNULL
	(
		STUFF
		(
			(
				SELECT
					',' + t2.Value
				FROM #Temp2 t2
				WHERE
					t2.Temp1Id = t1.Id
				ORDER BY
					t2.Id
				FOR XML PATH('')
			), 1, 1, ''
		), ''
	) AS Temp2Values
FROM
	#Temp1 t1
ORDER BY
	t1.Id;

--Simple is better than complex.
--Complex is better than complicated.