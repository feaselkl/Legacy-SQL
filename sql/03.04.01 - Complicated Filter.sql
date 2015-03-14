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
    CASE
        WHEN DATEPART(hh, st.CreateDateLTz) = 0 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 00:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 1 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 01:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 2 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 02:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 3 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 03:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 4 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 04:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 5 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 05:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 6 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 06:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 7 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 07:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 8 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 08:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 9 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 09:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 10 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 10:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 11 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 11:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 12 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 12:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 13 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 13:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 14 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 14:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 15 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 15:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 16 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 16:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 17 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 17:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 18 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 18:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 19 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 19:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 20 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 20:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 21 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 21:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 22 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 22:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 23 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 23:00:00' AS DATETIME)
    END AS CreateDateLTz,
    COUNT(1) AS RecordCount
FROM #SomeTable st
GROUP BY
    st.CustomerID,
    CASE
        WHEN DATEPART(hh, st.CreateDateLTz) = 0 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 00:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 1 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 01:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 2 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 02:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 3 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 03:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 4 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 04:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 5 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 05:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 6 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 06:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 7 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 07:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 8 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 08:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 9 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 09:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 10 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 10:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 11 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 11:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 12 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 12:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 13 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 13:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 14 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 14:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 15 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 15:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 16 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 16:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 17 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 17:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 18 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 18:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 19 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 19:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 20 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 20:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 21 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 21:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 22 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 22:00:00' AS DATETIME)
        WHEN DATEPART(hh, st.CreateDateLTz) = 23 THEN CAST(CONVERT(CHAR(10), st.CreateDateLTz, 101) + ' 23:00:00' AS DATETIME)
    END;