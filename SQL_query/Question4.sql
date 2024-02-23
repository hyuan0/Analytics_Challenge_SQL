/*
    Question 4a) What is the count of countries and sum of their related gdp_per_capita values for the year 2007 where the string 'an' (case insensitive) 
    appears anywhere in the country name?

    Question 4b) Repeat question 4a, but this time make the query case sensitive.

*/

    -- 4a Case Insensitive: --
    SELECT 
        COUNT(pc.country_code) AS country_count,
        CONCAT('$',
            ROUND(
                CAST(SUM(pc.gdp_per_capita) AS DECIMAL)
            , 2)
        ) AS total_gdp
    FROM per_capita pc 
    JOIN countries c ON pc.country_code = c.country_code
    WHERE pc.year = 2007 
        AND LOWER(c.country_name) LIKE '%an%'

    /*
    -- Results:
    country_count   total_gdp
    68      $1022936.33
    */

-- 4b Case Sensitive: --
    SELECT 
        COUNT(pc.country_code) AS country_count,
        CONCAT('$',
            ROUND(
                CAST(SUM(pc.gdp_per_capita) AS DECIMAL)
            , 2)
        ) AS total_gdp
    FROM per_capita pc 
    JOIN countries c ON pc.country_code = c.country_code
    WHERE pc.year = 2007 
        AND c.country_name LIKE '%an%'

    /*
    -- Results:
    country_count   total_gdp
    66      $979600.72
    */