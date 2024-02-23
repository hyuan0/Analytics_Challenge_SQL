/*
    Question 2) List the countries ranked 10-12 in each continent by the percent of year-over-year growth descending from 2011 to 2012.

    The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp)

    The list should include the columns:

    - rank
    - continent_name
    - country_code
    - country_name
    - growth_percent

*/

-- Common table expression to retrieve gpd of years 2011 and 2012
WITH gdp_cte AS (
SELECT 
    cm.country_code,
    cm.continent_code,
    COALESCE(pc2011.gdp_per_capita, 0) AS gdp_2011,
    COALESCE(pc2012.gdp_per_capita, 0) AS gdp_2012
FROM continent_map cm
JOIN per_capita pc2011
    ON cm.country_code = pc2011.country_code AND pc2011.year = 2011
LEFT JOIN per_capita pc2012
    ON cm.country_code = pc2012.country_code AND pc2012.year = 2012
),

-- CTE to calculate gdp_per_capita growth percentage of countries and rank them for each continent
growth_perc_ranked_cte AS (
  SELECT 
      country_code,
      continent_code,
      (gdp_2012 - gdp_2011) * 100.0 / gdp_2011 AS growth_perc,
      DENSE_RANK() OVER(
          PARTITION BY continent_code
          ORDER BY (gdp_2012 - gdp_2011) / gdp_2011 DESC ) AS ranks
  FROM gdp_cte
  WHERE gdp_2011 != 0 AND gdp_2012 != 0
)

-- Retrieve necessary columns with country ranks of 10-12 for each continent
SELECT 
	coun.country_name,
    coun.country_code,
    cont.continent_name,
    CONCAT (
        ROUND (CAST(gpr.growth_perc AS DECIMAL)
        ,2)
    ,'%') AS growth_perc,
    gpr.ranks AS rank
FROM growth_perc_ranked_cte gpr
JOIN continents cont ON gpr.continent_code = cont.continent_code
JOIN countries coun ON gpr.country_code = coun.country_code
WHERE gpr.ranks IN (10, 11, 12)
ORDER BY cont.continent_name, gpr.ranks 

/*
-- Results: 
country_name    country_code    continent_name  growth_perc     rank
Rwanda	            RWA	    Africa	        8.73%	10
Guinea	            GIN	    Africa	        8.32%	11
Nigeria	            NGA	    Africa	        8.09%	12
Uzbekistan	        UZB	    Asia	        11.12%	10
Iraq	            IRQ	    Asia	        10.06%	11
Philippines	        PHL	    Asia	        9.73%	12
Montenegro	        MNE	    Europe	        -2.93%	10
Sweden	            SWE	    Europe	        -3.02%	11
Iceland	            ISL	    Europe	        -3.84%	12
Guatemala	        GTM	    North America	2.71%	10
Honduras	        HND	    North America	2.71%	11
Antigua and Barbuda	ATG	    North America	2.52%	12
Fiji	            FJI	    Oceania	        3.29%	10
Tuvalu	            TUV	    Oceania	        1.27%	11
Kiribati	        KIR	    Oceania	        0.04%	12
Argentina	        ARG	    South America	5.67%	10
Paraguay	        PRY	    South America	-3.62%	11
Brazil	            BRA	    South America	-9.83%	12
*/
