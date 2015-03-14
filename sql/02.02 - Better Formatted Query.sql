SELECT
    ISNULL(krc.BasicID, 0) AS BasicID,
    krc.JDate,
    krc.CustomerID,
    ISNULL(krc.SearchProviderID, 0) AS SearchProviderID,
    ISNULL(NULLIF(STCategoryID, '-1'), '0') AS STCategoryID,
    krc.EventTypeID,
    CAST(JDate AS DATETIME) AS CreateDate,
    DATEPART(MONTH, CAST(JDate AS DATETIME)) AS CreateMonth,
    DATEPART(YEAR, CAST(JDate AS DATETIME)) AS CreateYear,
    Keyword,
    NULLIF(PageID, 0) AS PageID,
    CASE
        WHEN BasicID > 0 THEN 1
        ELSE 0
    END AS Paid,
    CAST(MAX(ISNULL(s.SearchProviderID, 0)) AS BIT) AS AllowsCampaigns,
    SUM(ISNULL(Conversions, 0)) AS Orders,
    SUM(ISNULL(Hits, 0)) AS PixelHits,
    SUM(ISNULL(Clicks, 0)) AS Clicks,
    SUM(ISNULL(Impressions, 0)) AS Impressions,
    CAST
    (
        CASE SUM(ISNULL(Impressions, 0))
            WHEN 0 THEN SUM(ISNULL(WeightedRank, 0))
            ELSE SUM(ISNULL(WeightedRank, 0) * ISNULL(Impressions, 0)) / SUM(ISNULL(Impressions, 0))
        END AS MONEY
    ) AS WeightedRank,
    SUM(CASE WHEN BasicID > 0 THEN 1 ELSE 0 END) AS AdCount,
    BINARY_CHECKSUM(krc.CustomerID, ISNULL(BasicID, 0), ISNULL(NULLIF(STCategoryID, '-1'), '0')) AS CheckSumID,
    RateAdjustmentCustomRuleID,
    SUM(ISNULL(EstimatedCost, 0)) AS EstimatedCost,
    SUM(ISNULL(EstimatedClicks, 0)) AS EstimatedClicks,
    SUM(CASE WHEN ISNULL(et.ParentEventTypeID, 0) = 3 THEN krc.Revenue ELSE 0 END) AS [OrderRevenue],
    SUM(CASE WHEN ISNULL(et.ParentEventTypeID, 0) = 3 THEN krc.Conversions ELSE 0 END) AS [OrderCount],
    SUM(CASE WHEN ISNULL(et.ParentEventTypeID, 0) = 4 THEN krc.Revenue ELSE 0 END) AS [EventValue],
    SUM(CASE WHEN ISNULL(et.ParentEventTypeID, 0) = 4 THEN krc.Conversions ELSE 0 END) AS [EventCount]
FROM SomeTable krc
    INNER JOIN SomeOtherTable c2a
        ON krc.CustomerID = c2a.CustomerID
        AND c2a.EligibleForGC = 0
    LEFT OUTER JOIN
    (
        SELECT
            s.CustomerID,
            s.SearchProvider,
            s.SearchProviderID
        FROM SomeThirdTable c
            CROSS APPLY SomeFunction(c.CustomerID) s
        WHERE
            s.CustomerID = c.CustomerID
            AND NOT
            (
                s.SearchProviderID = 62
                OR s.ChannelID = 3
                OR
                (
                    s.SearchProviderID = 2
                    AND c.CustomerID IN
                    (
                        SELECT
                            pa.CustomerID
                        FROM SomeFourthTable pa
                        WHERE
                            pa.SearchProviderID = 2
                            AND pa.IsActive = 1
                            AND pa.Version <> 'EWS'
                            AND s.CustomerID = pa.CustomerID
                    )
                )
            )
    ) s
        ON s.SearchProviderID = krc.SearchProviderID
        AND s.CustomerID = krc.CustomerID
    LEFT OUTER JOIN SomeFifthTable et
        ON et.EventTypeID = krc.EventTypeID
        AND ISNULL(NULLIF(et.CustomerID, 0), krc.CustomerID) = krc.CustomerID
GROUP BY
    BasicID,
    JDate,
    krc.CustomerID,
    ISNULL(krc.SearchProviderID, 0),
    STCategoryID,
    krc.EventTypeID,
    CAST(JDate AS DATETIME),
    DATEPART(MONTH, CAST(JDate AS DATETIME)),
    DATEPART(YEAR, CAST(JDate AS DATETIME)),
    Keyword,
    NULLIF(PageID, 0),
    CASE
        WHEN BasicID > 0 THEN 1
        ELSE 0
    END,
    RateAdjustmentCustomRuleID;