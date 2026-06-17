-- 1.1: Tổng doanh thu
CREATE TABLE summary_revenue AS
SELECT SUM(TotalPrice) AS TotalRevenue
FROM sales;
-- 1.2: Doanh thu theo thời gian và danh mục
CREATE TABLE summary_revenue_timeline AS
SELECT 
    YEAR(s.SalesDate) AS Year,
    MONTH(s.SalesDate) AS Month,
    c.CategoryName,
    SUM(s.TotalPrice) AS Revenue
FROM sales s
JOIN products p ON s.ProductID = p.ProductID
JOIN categories c ON p.CategoryID = c.CategoryID
WHERE s.SalesDate IS NOT NULL
GROUP BY YEAR(s.SalesDate), MONTH(s.SalesDate), c.CategoryName
ORDER BY Year, Month;

