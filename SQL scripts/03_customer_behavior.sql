-- 3.1: Customer Segmentation
	-- Tìm ngưỡng TotalSpend và PurchaseFrequency
SELECT 
    MIN(TotalSpend), 
    MAX(TotalSpend), 
    AVG(TotalSpend),
    MIN(PurchaseFrequency),
    MAX(PurchaseFrequency),
    AVG(PurchaseFrequency)
FROM (
    SELECT 
        s.CustomerID,
        COUNT(s.SalesID) AS PurchaseFrequency,
        SUM(s.TotalPrice) AS TotalSpend
    FROM sales s
    GROUP BY s.CustomerID
) AS customer_value;
	-- Tạo bảng
CREATE TABLE summary_customer_segmentation AS
WITH customer_value AS (
    SELECT 
        s.CustomerID,
        COUNT(s.SalesID) AS PurchaseFrequency,
        SUM(s.TotalPrice) AS TotalSpend
    FROM sales s
    GROUP BY s.CustomerID
)
SELECT 
    CustomerID,
    TotalSpend,
    PurchaseFrequency,
    CASE 
        WHEN TotalSpend < 20000 THEN 'Low'
        WHEN TotalSpend < 80000 THEN 'Mid'
        ELSE 'High'
    END AS SpendSegment,
    CASE 
        WHEN PurchaseFrequency < 50 THEN 'Low'
        WHEN PurchaseFrequency < 85 THEN 'Mid'
        ELSE 'High'
    END AS FrequencySegment
FROM customer_value;
-- 3.2: Average Order Value - AOV và Basket Size
CREATE TABLE summary_aov_basketsize AS
SELECT
    AVG(OrderRevenue) AS AOV,
    AVG(OrderQuantity) AS AvgBasketSize
FROM (
    SELECT 
        TransactionNumber,
        SUM(TotalPrice) AS OrderRevenue,
        SUM(Quantity) AS OrderQuantity
    FROM sales
    GROUP BY TransactionNumber
) AS order_summary;