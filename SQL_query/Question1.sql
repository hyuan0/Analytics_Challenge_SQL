/*
    Question 1) Data Integrity Checking & Cleanup

    -- Part 1:
    - Alphabetically list all of the country codes in the continent_map table that appear more than once. 
        Display any values where country_code is null as country_code = FOO and make this row appear first in the list, 
        even though it should alphabetically sort to the middle. 

    -- Part 2:
    - For all countries that have multiple rows in the continent_map table, delete all multiple records leaving only the 1 record 
        per country. The record that you keep should be the first one when sorted by the continent_code alphabetically ascending. 
        Provide the query/ies and explanation of step(s) that you follow to delete these records.
*/

     -- Part 1: --

    -- Replacing empty country_code with NULL
    UPDATE continent_map
    SET country_code = NULL
    WHERE country_code = '';

    -- Displaying duplicate country codes with 'FOO' on top
    SELECT 
        COALESCE(country_code, 'FOO')
    FROM continent_map
    GROUP BY country_code
    HAVING COUNT(*) > 1
    ORDER BY country_code NULLS FIRST;

    /*
    -- Results for Part 1:
    country_code:
    FOO
    ARM
    AZE
    CYP
    GEO
    KAZ
    RUS
    TUR
    UMI
    */

    -- Part 2: --

    -- Temporary table to sort by contient_code alphabetically when country_code are the same
    CREATE TABLE temp1 AS (
        SELECT 
            country_code,
            continent_code,
            ROW_NUMBER() OVER (
                PARTITION BY country_code
                ORDER BY continent_code) as row_num
        FROM continent_map
    );

    -- Temporary table to retrieve first country_code when sorted by continent_code 
    CREATE TABLE temp2 AS (
        SELECT 
            country_code,
            continent_code
        FROM temp1
        WHERE row_num = 1
        ORDER BY country_code NULLS FIRST
    );

    -- Delete all rows from continent_map table and insert rows from temporary table 
    DELETE FROM continent_map;

    INSERT INTO continent_map 
    SELECT * FROM temp2;

    -- Drop temporary tables
    DROP TABLE temp1;
    DROP TABLE temp2;

    /*
    -- Results for part 2:
    countrY_code    continent_code
    null	AS
    ABW	    NA
    AFG	    AS
    AGO	    AF
    AIA	    NA
    ALA	    EU
    ALB	    EU
    AND	    EU
    ANT	    NA
    ARE	    AS
    ARG	    SA
    ARM	    AF
    ASM	    OC
    ATA	    AN
    ATF	    AN
    ATG	    NA
    AUS	    OC
    AUT	    EU
    AZE	    AS
    .......
    Total rows : 251
    */