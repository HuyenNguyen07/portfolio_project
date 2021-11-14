-- SHOW ALL COLUMNS IN DATA TABLE
SELECT * 
FROM GA_0001



-- FILTER OUT PROJECTS BY CONDITION
SELECT *
FROM GA_0001
WHERE 
  Project in ('Canssandra', 'LA Bee One', 'Galinburg')
  and Ad_type in ('Image Ad', 'Expanded text ad')
  and Date between '2019-06-01' and '2019-07-03'
  and CR > 0.15
ORDER BY Cost



-- REPORT GA CAMPAIGN PERFORMANCE BY PROJECTS (COST,IMPRESSIONS,CLICKS,CONVERSIONS,VIEWS, CR,CTR,CPC,CPM)
WITH Report AS(
  SELECT 
    Project,
    Totalcost = sum(Cost),
    Totalimpressions=sum(impressions),
    TotalClicks=sum(Clicks),
    Totalconversions=sum(Conversions),
    TotalVideo_views=sum(video_views),
    AVGCR = ROUND(AVG(CR),2)
    FROM GA_0001
  GROUP BY Project)
SELECT *,
  CTR = ROUND(ISNULL(Totalconversion/NULLIF(TotalClicks,0),0),2),
  CPC = ROUND(ISNULL(TotalClicks/NULLIF(Totalcost,0),0),2),
  CPM = ROUND(ISNULL(Totalimpressions/NULLIF(Totalcost,0),0),2)
FROM Report



-- CREATE VIEW BY UNION WITH FACEBOOK SAMPLE DATA TABLE
CREATE VIEW ALLCAMPAIGN_VIEW AS
WITH FB_Report AS(
	SELECT 
		*,
		Project =
			CASE 
			WHEN Campaign_ads_name LIKE '%Cassandra%' THEN 'Cassandra'
			WHEN Campaign_ads_name LIKE '%Fox%' THEN 'Fox'
			WHEN Campaign_ads_name LIKE '%Galinburg%' THEN 'Galinburg'
			WHEN Campaign_ads_name LIKE '%LA Bee One%' THEN 'LA Bee One'
			WHEN Campaign_ads_name LIKE '%LA Bee One%' THEN 'LA Bee One'
			WHEN Campaign_ads_name LIKE '%Wolf%' THEN 'Wolf'
			WHEN Campaign_ads_name LIKE '%Funlus Phoenix%' THEN 'Funlus Phoenix'
			WHEN Campaign_ads_name LIKE '%Royal Never Give Up%' THEN 'Royal Never Give Up'
			END
	FROM [Facebook Ads sample data (1)]
	WHERE Campaign_ads_name IS NOT NULL)
SELECT
	Date,
	Project,
	Totalcost = sum(Cost),
	Totalimpressions=sum(impressions),
	TotalClicks=sum(Clicks),
	Totalconversion=sum(Conversions),
	TotalVideo_views=sum(video_views)
FROM GA_0001
GROUP BY Date,Project
UNION
SELECT
	Date,
	Project,
	Totalcost = sum(Cost),
	Totalimpressions = sum(impressions),
	TotalClicks = sum(convert(float,Link_clicks)),
	Totalconversion = sum(convert(float,Conversions)),
	TotalVideo_views = sum(video_view)
FROM FB_Report
GROUP BY Date,Project