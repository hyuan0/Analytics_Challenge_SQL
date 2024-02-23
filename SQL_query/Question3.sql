/*
    Question 3) For the year 2012, create a 3 column, 1 row report showing the percent share of gdp_per_capita for the following regions:

    (i) Asia, 
    (ii) Europe, 
    (iii) the Rest of the World. 

    Your result should look something like:

    Asia	Europe	Rest of World
    25.0%	25.0%	50.0%
*/

-- CTE that calculates percentage share of gdp_per_capita for each continent
WITH gdp_perc_continent_cte AS (
	SELECT 
        cm.continent_code,
        ROUND(
            CAST(
                SUM(pc.gdp_per_capita) * 100.0 / (SELECT SUM(gdp_per_capita) 
                                                  FROM per_capita
                                                  WHERE year = 2012) 
            AS DECIMAL)
        , 2) AS gdp_perc
	FROM per_capita pc
	JOIN continent_map cm ON pc.country_code = cm.country_code
	WHERE year = 2012 
    GROUP BY cm.continent_code
)

-- Outputing results in desired format
SELECT 
	CONCAT(
        SUM(CASE WHEN continent_code = 'AS' THEN gdp_perc END) 
     , '%')AS Asia,
    CONCAT(
        SUM(CASE WHEN continent_code = 'EU' THEN gdp_perc END) 
    , '%')AS Europe,
    CONCAT(
        SUM(CASE WHEN continent_code NOT IN ('AS', 'EU') THEN gdp_perc END)
    , '%') AS "Rest of World"
FROM gdp_perc_continent_cte

/*
-- Results:
Asia    Europe  Rest of World
28.33%   42.24%   29.42%
*/
