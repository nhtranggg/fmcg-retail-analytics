-- 2.1: Xếp hạng (Ranking) toàn bộ danh mục sản phẩm dựa trên tổng doanh thu tích lũy
CREATE TABLE summary_product_ranking AS
WITH product_revenue AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(s.TotalPrice) AS Revenue,
        RANK() OVER (ORDER BY SUM(s.TotalPrice) DESC) AS RankDesc,
        RANK() OVER (ORDER BY SUM(s.TotalPrice) ASC) AS RankAsc
    FROM sales s
    JOIN products p ON s.ProductID = p.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT * FROM product_revenue
WHERE RankDesc <= 10 OR RankAsc <= 10
ORDER BY RankDesc;
-- 2.2: Tương quan giữa số lượng bán ra (Quantity) và doanh thu thực
CREATE TABLE summary_qty_vs_revenue AS
SELECT
	p.ProductID,
    p.ProductName,
    SUM(s.TotalPrice) AS Revenue,
    SUM(s.Quantity) AS TotalQuantity
FROM sales s
JOIN products p ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalQuantity DESC;
-- 2.3: Class Performance
CREATE TABLE summary_class_performance AS
SELECT
    p.Class,
    SUM(s.TotalPrice) AS Revenue,
    SUM(s.Quantity) AS TotalQuantity,
    AVG(p.Price) AS AvgPrice
FROM sales s
JOIN products p ON s.ProductID = p.ProductID
GROUP BY p.Class;