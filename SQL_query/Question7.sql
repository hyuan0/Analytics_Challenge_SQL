/*
    Question 7) Find the country with the highest average gdp_per_capita for each continent for all years. 

*/

-- CTE which returns average gdp_per_capita for each country and their ranking within thier continent
WITH ranking_cte AS (
    SELECT 
        cont.continent_name,
        coun.country_code,
        coun.country_name,
        AVG(pc.gdp_per_capita) AS avg_gdp,
        RANK() OVER (
            PARTITION BY cont.continent_name
            ORDER BY AVG(pc.gdp_per_capita) DESC) AS ranking
    FROM per_capita pc 
        JOIN continent_map cm ON pc.country_code = cm.country_code
        JOIN continents cont ON cm.continent_code = cont.continent_code
        JOIN countries coun ON cm.country_code = coun.country_code
    GROUP BY cont.continent_name, coun.country_code, coun.country_name
)

-- Retrieves highest avg_gdp country of each continent
SELECT 
    continent_name,
    country_code,
    country_name,
    CONCAT('$', ROUND(CAST(avg_gdp AS DECIMAL), 2)) AS avg_gdp
FROM ranking_cte
WHERE ranking = 1

/*
-- Results:
continent_name  country_code    country_name    avg_gdp
Africa	        GNQ	    Equatorial Guinea	$17955.72
Asia	        QAT	    Qatar	            $70567.96
Europe	        MCO	    Monaco	            $151421.89
North America	BMU	    Bermuda	            $84634.83
Oceania	        AUS	    Australia	        $46147.45
South America	CHL	    Chile	            $10781.71
*/