-- 5: GEO performance
CREATE TABLE summary_geo_performance AS
SELECT
    countries.CountryName,
    cities.CityName,
    SUM(sales.TotalPrice) AS Revenue,
    SUM(sales.Quantity) AS TotalQuantity,
    COUNT(DISTINCT sales.TransactionNumber) AS TransactionCount,
    ROUND(SUM(sales.TotalPrice) / COUNT(DISTINCT sales.TransactionNumber), 2) AS AOV
FROM sales
JOIN customers ON sales.CustomerID = customers.CustomerID
JOIN cities ON customers.CityID = cities.CityID
JOIN countries ON cities.CountryID = countries.CountryID
GROUP BY countries.CountryName, cities.CityName;