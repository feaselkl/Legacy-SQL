--Create the fact table
CREATE TABLE #Fact
(
    ReportDate INT NOT NULL,
    UseSource1 BIT NOT NULL,
    ClickSource1 INT NULL,
    ClickSource2 INT NULL,
    CostSource1 DECIMAL(23, 4) NULL,
    CostSource2 DECIMAL(23, 4) NULL,
    OrderCount INT NULL,
    OrderRevenue DECIMAL(23, 4) NULL,
    ProductCost DECIMAL(23, 4) NULL
);
 
INSERT INTO dbo.#Fact
(
    ReportDate,
    UseSource1,
    ClickSource1,
    ClickSource2,
    CostSource1,
    CostSource2,
    OrderCount,
    OrderRevenue,
    ProductCost
)
VALUES
(20150101, 1, 25, NULL, 285.86, NULL, 18, 1349.56, 187.39),
(20150102, 0, 25, 6, 285.86, 8.36, 3, 98.72, 75.14),
(20150103, 1, 16, NULL, 28.38, NULL, 1, 9.99, 5.42),
(20150104, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(20150105, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(20150106, 1, 108, NULL, 39.80, NULL, 12, 2475.02, 918.60),
(20150107, 0, NULL, 85, NULL, 85.00, 67, 428.77, 206.13);

--Query the fact table
SELECT
    SUM(CASE WHEN f.UseSource1 = 1 THEN ISNULL(f.ClickSource1, 0) ELSE ISNULL(f.ClickSource2, 0) END) AS Clicks,
    SUM(ISNULL(f.OrderCount, 0)) AS OrderCount,
    SUM(ISNULL(f.OrderRevenue, 0)) AS OrderRevenue,
    SUM(ISNULL(f.ProductCost, 0)) AS ProductCost,
    SUM(CASE WHEN f.UseSource1 = 1 THEN ISNULL(f.CostSource1, 0) ELSE ISNULL(f.CostSource2, 0) END) AS Cost,
    CAST
    (
        CASE
            WHEN SUM(CASE WHEN f.UseSource1 = 1 THEN ISNULL(f.ClickSource1, 0) ELSE ISNULL(f.ClickSource2, 0) END) = 0 THEN 0.0
            WHEN SUM(ISNULL(f.OrderCount, 0)) = 0 THEN 0.0
            WHEN SUM(ISNULL(f.OrderCount, 0)) > SUM(CASE WHEN f.UseSource1 = 1 THEN ISNULL(f.ClickSource1, 0) ELSE ISNULL(f.ClickSource2, 0) END) THEN 1.0
            ELSE 1.0 * SUM(ISNULL(f.OrderCount, 0)) / SUM(CASE WHEN f.UseSource1 = 1 THEN ISNULL(f.ClickSource1, 0) ELSE ISNULL(f.ClickSource2, 0) END)
        END AS DECIMAL(19, 4)
    ) AS ConversionRate,
    SUM(ISNULL(f.OrderRevenue, 0) - (ISNULL(f.ProductCost, 0) + CASE WHEN f.UseSource1 = 1 THEN ISNULL(f.CostSource1, 0) ELSE ISNULL(f.CostSource2, 0) END)) AS NetMargin,
    CASE
        WHEN SUM(CASE WHEN f.UseSource1 = 1 THEN ISNULL(f.CostSource1, 0) ELSE ISNULL(f.CostSource2, 0) END) = 0 THEN
            CASE
                WHEN SUM(ISNULL(f.OrderRevenue, 0)) = 0 THEN 0.0
                ELSE 1.0
            END
        ELSE SUM(ISNULL(f.OrderRevenue, 0)) / SUM(CASE WHEN f.UseSource1 = 1 THEN ISNULL(f.CostSource1, 0) ELSE ISNULL(f.CostSource2, 0) END)
    END AS ReturnOnAdSpend
FROM dbo.#Fact f
WHERE
    f.ReportDate BETWEEN 20150101 AND 20150107;