/*
    6. All in a single query, execute all of the steps below and provide the results as your final answer:

    a. create a single list of all per_capita records for year 2009 that includes columns:
        - continent_name
        - country_code
        - country_name
        - gdp_per_capita

    b. order this list by:
        - continent_name ascending
        - characters 2 through 4 (inclusive) of the country_name descending

    c. create a running total of gdp_per_capita by continent_name

    d. return only the first record from the ordered list for which each continent's running total of gdp_per_capita meets or exceeds $70,000.00 with the following columns:
        - continent_name
        - country_code
        - country_name
        - gdp_per_capita
        - running_total

*/

-- CTE which gives a running total of gdp_per_capita for each continent
WITH running_total AS (
    SELECT 
        cont.continent_name,
        cm.country_code,
        coun.country_name,
        pc.gdp_per_capita,
        SUM(pc.gdp_per_capita) OVER(
            PARTITION BY cont.continent_name
            ORDER BY cont.continent_name, SUBSTRING(coun.country_name, 2, 3) DESC) AS running_total
    FROM per_capita pc 
        JOIN continent_map cm ON pc.country_code = cm.country_code
        JOIN continents cont ON cm.continent_code = cont.continent_code
        JOIN countries coun ON cm.country_code = coun.country_code
    WHERE pc.year = 2009 AND pc.gdp_per_capita IS NOT NULL
    ORDER BY cont.continent_name, SUBSTRING(coun.country_name, 2, 3) DESC
)

-- Returns rows where the running total meets or exceeds 70,000
SELECT 
	continent_name,
    country_code,
    country_name,
    CONCAT('$', ROUND(CAST(gdp_per_capita AS DECIMAL), 2)) AS gdp_per_capita,
    CONCAT('$', ROUND(CAST(running_total AS DECIMAL), 2)) AS running_total
FROM running_total_cte
WHERE running_total > 70000

/*
-- Results: 
continent_name    country_code    country_name    gdp_per_capita    running_total
Africa	    LBY	    Libya	                    $10455.57	    $70227.16
Africa	    LBR	    Liberia	                    $302.28	        $70529.44
Africa	    GHA	    Ghana	                    $1096.53	    $71625.97
Africa	    TCD	    Chad	                    $813.76	        $72439.73
Africa	    EGY	    Egypt, Arab Rep.	        $2461.53	    $74901.26
Africa	    UGA	    Uganda	                    $451.08	        $75352.34
Africa	    SYC	    Seychelles	                $9707.27	    $85059.60
Africa	    LSO	    Lesotho	                    $862.79	        $85922.39
Africa	    KEN	    Kenya	                    $767.87	        $86690.26
Africa	    CAF	    Central African Republic	$464.51	        $87154.78
Africa	    BEN	    Benin	                    $712.62	        $87867.39
Africa	    SEN	    Senegal	                    $1017.97	    $88885.36
Africa	    MRT	    Mauritania	                $860.91	        $96675.24
Africa	    MUS	    Mauritius	                $6928.97	    $96675.24
Africa	    STP	    Sao Tome and Principe	    $1134.11	    $97809.36
Africa	    TZA	    Tanzania	                $504.20	        $98313.56
Africa	    NAM	    Namibia	                    $4133.06	    $102446.62
Africa	    CMR	    Cameroon	                $1102.52	    $103549.14
Africa	    GMB	    Gambia, The	                $553.10	        $105100.68
Africa	    ZMB	    Zambia	                    $998.44	        $105100.68
Africa	    MLI	    Mali	                    $661.13	        $105761.81
Africa	    MWI	    Malawi	                    $345.19	        $106107.00
Africa	    MDG	    Madagascar	                $419.09	        $106526.09
Africa	    GAB	    Gabon	                    $7919.71	    $117970.13
Africa	    CPV	    Cabo Verde	                $3524.33	    $117970.13
Asia	    KWT	    Kuwait	                    $37160.54	    $73591.81
Asia	    RUS	    Russian Federation	        $8615.66	    $82207.47
......
Total rows : 136
*/

