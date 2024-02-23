/*
    Question 5) Find the sum of gpd_per_capita by year and the count of countries for each year that have non-null gdp_per_capita where 
        (i) the year is before 2012 and 
        (ii) the country has a null gdp_per_capita in 2012. Your result should have the columns:

    - year
    - country_count
    - total

*/

    SELECT 
        year,
        COUNT(gdp_per_capita) AS country_count,
        CONCAT('$',
            ROUND(
                CAST(SUM(gdp_per_capita) AS DECIMAL)
            , 2)
        ) AS total
    FROM per_capita 
    WHERE year < 2012 
        AND country_code IN (SELECT country_code
                             FROM per_capita
                             WHERE year = 2012
                             AND gdp_per_capita IS NULL)
    GROUP BY year
    ORDER BY year

/*
-- Results:
year    country_count   total
2004	15      $491203.19
2005	15	    $510734.98
2006	14	    $553689.64
2007	14	    $654508.77
2008	10	    $574016.21
2009	9	    $473103.33
2010	4	    $179750.83
2011	4	    $199152.68
*/