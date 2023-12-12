SELECT *
FROM international_breweries;
-- No language column in the table, so i will alter and add new language --
ALTER TABLE international_breweries 
ADD language VARCHAR(50);
UPDATE international_breweries 
SET language = CASE 
    WHEN COUNTRIES IN ('Nigeria', 'Ghana', 'Senegal') THEN 'Anglophone'
    ELSE 'Francophone'
END; 

-- select everything from the table -- 
SELECT *
FROM international_breweries;

-- PROFIT ANALYSIS --

-- Within the space of the last three years, what was the profit worth of the breweries, inclusive of the anglophone and the francophone territories --
SELECT sum(profit) AS totalprofit
FROM international_breweries
WHERE years >= 2017 and years <=2019;

-- Compare the total profit between these two territories in order for the territory manager, Mr. Stone made a strategic decision that will aid profit maximization in 2020.
SELECT sum(profit) as totalprofit, language as territories
FROM international_breweries
GROUP BY language;

-- Country that generated the highest profit in 2019
SELECT Countries AS countries, sum(profit) As totalprofit
FROM international_breweries
WHERE years = 2019
GROUP BY countries
ORDER BY totalprofit DESC
LIMIT 1;

-- Help him find the year with the highest profit --
SELECT years AS year, sum(profit) AS totalprofit
FROM international_breweries
GROUP BY years
ORDER BY totalprofit DESC
LIMIT 1;

-- Which month in the three years was the least profit generated?
SELECT years, months, sum(profit) AS totalprofit
FROM international_breweries
GROUP BY years, months
ORDER BY totalprofit
LIMIT 1;

-- What was the minimum profit in the month of December 2018?
SELECT MIN(profit) AS minprofit
FROM international_breweries
WHERE years = 2018 AND months = 'December';

-- Compare the profit in percentage for each of the month in 2019
SELECT months, SUM(profit) * 100 / (SELECT SUM(PROFIT) FROM international_breweries WHERE YEARS = 2019) AS ProfitPercentage
FROM international_breweries
WHERE years = 2019
GROUP BY months;

-- Which particular brand generated the highest profit in Senegal?
SELECT brands as brand, sum(profit) as totalprofit
FROM international_breweries
WHERE countries = 'senegal'
GROUP BY brands
ORDER BY totalprofit
LIMIT 1;

-- BRAND ANALYSIS
-- Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries
SELECT brands, sum(quantity) AS totalquantity
FROM international_breweries
WHERE years >=2018 AND years <=2019 
AND language = 'francophone'
GROUP BY brands
ORDER BY totalquantity DESC
LIMIT 3;

-- Find out the top two choice of consumer brands in Ghana
SELECT brands, sum(quantity) AS totalquantity
FROM international_breweries
WHERE countries = 'Ghana'
GROUP BY brands
ORDER BY totalquantity DESC
LIMIT 2;

-- Find out the details of beers consumed in the past three years in the most oil rich country in West Africa
SELECT brands, sum(quantity) AS totalquantity
FROM international_breweries
WHERE years >= 2017 AND years <= 2019
AND countries = 'Nigeria'
GROUP BY brands
ORDER BY totalquantity DESC;

-- Favorites malt brand in Anglophone region between 2018 and 2019
SELECT brands, sum(quantity) AS totalquantity
FROM international_breweries
WHERE language = 'Anglophone'
AND years between 2018 AND 2019
AND brands like '%Malt%'
GROUP BY brands
ORDER BY totalquantity;

-- Which brands sold the highest in 2019 in Nigeria?
SELECT brands, sum(quantity) as totalquantity
FROM international_breweries
WHERE countries = 'Nigeria'
AND Years = 2019
GROUP BY brands
ORDER BY totalquantity DESC;

-- Favorites brand in South South region in Nigeria
SELECT brands, sum(quantity) AS totalquantity
FROM international_breweries
WHERE countries = 'Nigeria'
AND region = 'southsouth'
GROUP BY brands
ORDER BY totalquantity DESC
LIMIT 1;

-- Beer consumption in Nigeria
SELECT sum(quantity) AS totalquantity
FROM international_breweries
WHERE countries = 'Nigeria';

-- Level of consumption of Budweiser in the regions in Nigeria
SELECT region, SUM(quantity) AS totalquantity
FROM international_breweries
WHERE COUNTRIES = 'Nigeria'
AND brands = 'Budweiser'
GROUP BY region;

-- Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)
SELECT region, SUM(quantity) AS totalquantity
FROM international_breweries
WHERE COUNTRIES = 'Nigeria'
AND brands = 'Budweiser'
AND years = 2019
GROUP BY region;

-- GEO-LOCATION ANALYSIS
-- Country with the highest consumption of beer.
SELECT countries, sum(quantity) as Totalquantity
FROM international_breweries
GROUP BY countries
ORDER BY Totalquantity DESC
LIMIT 1;

-- Highest sales personnel of Budweiser in Senegal
SELECT sales_rep, sum(quantity) AS totalquantity
FROM international_breweries
WHERE countries = 'Senegal' AND brands = 'Budweiser'
GROUP BY sales_rep
ORDER BY totalquantity DESC
LIMIT 1;

-- Country with the highest profit of the fourth quarter in 2019
SELECT countries, sum(profit) AS totalprofit
FROM international_breweries
WHERE months in ('october', 'november', 'december') AND years = 2019
GROUP BY countries
ORDER BY totalprofit
LIMIT 1;
