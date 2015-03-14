CREATE TABLE #SomeTable
(
    CustomerID INT,
    CreateDateLTz DATETIME
);

INSERT INTO #SomeTable
(
    CustomerID,
    CreateDateLTz
)
VALUES
(1, '2015-06-01 19:23:06'),
(1, '2015-06-01 19:23:07'),
(1, '2015-06-01 14:23:06'),
(1, '2015-06-01 19:43:06'),
(1, '2015-06-01 19:59:59'),
(2, '2015-06-01 20:23:06'),
(2, '2015-06-01 22:23:06');

SELECT
    st.CustomerID,
    DATEADD(HOUR, DATEDIFF(HOUR, 0, st.CreateDateLTz), 0) AS CreateDateLTzRoundedToHour,
    COUNT(1) AS RecordCount
FROM #SomeTable st
GROUP BY
    st.CustomerID,
    DATEADD(HOUR, DATEDIFF(HOUR, 0, st.CreateDateLTz), 0);