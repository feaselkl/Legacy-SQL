SELECT
    ISNULL(BasicID, 0) BasicID, JDate,krc.CustomerID,ISNULL(krc.SearchProviderID, 0) SearchProviderID,ISNULL(NULLIF(STCategoryID, '-1'), '0')
STCategoryID,
                krc.EventTypeID,
    CAST(JDate AS DATETIME) CreateDate,
    DATEPART(MONTH, CAST(JDate AS DATETIME)) CreateMonth,
DATEPART(YEAR, CAST(JDate AS DATETIME)) CreateYear, Keyword, NULLIF(PageID, 0) PageID,
    CASE
        WHEN BasicID > 0 THEN 1
        ELSE 0 END Paid,
    CAST(MAX(ISNULL(s.SearchProviderID, 0)) AS BIT) AllowsCampaigns,
    SUM
    (ISNULL(Conversions
    , 0)) AS Orders,  SUM(ISNULL
    (Hits, 0)) PixelHits,
        SUM(ISNULL(Clicks, 0)) Clicks,
    SUM(
        ISNULL(Impressions,
0)) AS Impressions,
    CAST(CASE SUM(ISNULL(Impressions, 0)) WHEN 0 THEN SUM(ISNULL(WeightedRank, 0)) ELSE SUM(ISNULL(WeightedRank, 0) * ISNULL(Impressions, 0)) / SUM(ISNULL(Impressions, 0)) END AS MONEY) WeightedRank,
    SUM(CASE WHEN BasicID > 0 THEN 1 ELSE 0 END) AS AdCount,
    BINARY_CHECKSUM(krc.CustomerID, ISNULL(BasicID, 0), ISNULL(NULLIF(STCategoryID, '-1'), '0')) AS CheckSumID,
    RateAdjustmentCustomRuleID,
    SUM(ISNULL(EstimatedCost, 0)) AS EstimatedCost,
    SUM(ISNULL(EstimatedClicks, 0)) AS EstimatedClicks,
    SUM(CASE WHEN ISNULL(et.ParentEventTypeID, 0) = 3 
    THEN krc.Revenue ELSE 0 END) AS [OrderRevenue],
    SUM(
    CASE WHEN
    ISNULL(et.ParentEventTypeID, 0) = 3 
    THEN
    krc.Conversions ELSE 0 
    END) AS [OrderCount],
    SUM(CASE WHEN ISNULL(et.ParentEventTypeID, 0) = 4 
                THEN
        krc.Revenue 
                ELSE 0 
            END)
    [EventValue],
    SUM(CASE WHEN ISNULL(et.ParentEventTypeID, 0) = 4 THEN krc.Conversions ELSE 0 END) AS [EventCount]
FROM SomeTable krc INNER JOIN SomeOtherTable c2a ON krc.CustomerID = c2a.CustomerID AND c2a.EligibleForGC = 0
    LEFT OUTER JOIN
    (SELECT s.CustomerID, s.SearchProvider, s.SearchProviderID
        FROM SomeThirdTable c
            CROSS APPLY SomeFunction(c.CustomerID) s
        WHERE
            s.CustomerID = c.CustomerID AND NOT (s.SearchProviderID = 62 OR s.ChannelID = 3 OR (s.SearchProviderID = 2 AND c.CustomerID IN (SELECT pa.CustomerID FROM SomeFourthTable pa
            WHERE
                            pa.SearchProviderID = 2
                            AND pa.IsActive = 1 AND pa.Version <> 'EWS' AND s.CustomerID = pa.CustomerID
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

/*
There are several formatting problems with this code.
Let’s enumerate the problems, from top to bottom:

1)  Multiple attributes on one row.  EX:  row #2 has 5 attributes.
2)  Aliases not delimited.  You can do [Alias] = [column details],
	or you can do [column details] AS [Alias].  Pick one and stick with it.
3)  Attributes not table-specified.  Neither BasicID nor JDate has
	the appropriate table specified.  This makes maintenance harder.
4)  Inconsistent spacing.  Tabstop levels let us visualize the procedure.
	We can see, for example, if we accidentally jump out of an IF block
	without closing it.
5)  Inconsistent parentheses and spacing for operations.  Problem with
	lines 12-14, then 14-15, then 16-19.  34-39 combines #5 with #2.
6)  The correlated subquery looks terrible:  parentheses don't line up;
	it's hard to tell that there are nested sub-queries; multiple attributes
	on line 43; multiple filters on line 50; inconsistent indentation.
7)  GROUP BY clause uses spaces to indent & the rest of the query uses tabs.
	Different tools display tabs vs spaces differently.
	To see in SSMS:  Edit --> Advanced --> View White Space
*/