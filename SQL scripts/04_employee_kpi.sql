-- 4.1: Employee Productivity
CREATE TABLE summary_employee_productivity AS
SELECT
	s.SalesPersonID,
	e.FirstName,
	e.LastName,
	SUM(TotalPrice) AS SalesVolumn,
	COUNT(TransactionNumber) AS InvoiceProcessingVolume
FROM sales s
JOIN employees e ON s.SalesPersonID = e.EmployeeID
GROUP BY s.SalesPersonID, e.FirstName, e.LastName;
-- 4.2: Employee Trend
CREATE TABLE summary_employee_trend AS
SELECT
    s.SalesPersonID,
    e.FirstName,
    e.LastName,
    YEAR(s.SalesDate) AS Year,
    MONTH(s.SalesDate) AS Month,
    SUM(s.TotalPrice) AS MonthlyRevenue,
    COUNT(s.TransactionNumber) AS InvoiceCount
FROM sales s
JOIN employees e ON s.SalesPersonID = e.EmployeeID
WHERE s.SalesDate IS NOT NULL
GROUP BY s.SalesPersonID, e.FirstName, e.LastName, YEAR(s.SalesDate), MONTH(s.SalesDate)
ORDER BY s.SalesPersonID, Year, Month;