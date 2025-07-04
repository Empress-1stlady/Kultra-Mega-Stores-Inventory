USE kultra_mega_stores;
SET SQL_SAFE_UPDATES = 0;
SELECT * FROM kms_staging;

--product category with the highest sales
SELECT `Product Category`, SUM(`Sales`) AS `Total Sales`
FROM kms_staging
GROUP BY `Product Category`
ORDER BY `Total Sales` DESC;

---Top 3 regions in terms of sales
SELECT Region, SUM(`Sales`) AS `Total Sales`
FROM kms_staging
GROUP BY Region
ORDER BY `Total Sales` DESC
LIMIT 3;

--- Bottom 3 regions in terms of sales
SELECT Region, SUM(`Sales`) AS `Total Sales`
FROM kms_staging
GROUP BY Region
ORDER BY `Total Sales` ASC
LIMIT 3;

-----Total sales of appliances in Ontario
SELECT  Region, `Product Sub-Category`, SUM(`Sales`) AS `Total Sales`
FROM kms_staging
WHERE `Product Sub-Category` = 'Appliances' AND Region = 'Ontario';

---- bottom 10 customers 
SELECT `Customer Name`, Discount, Province, Region,`Order Priority`, `Order Quantity`, `Ship Mode`, `Shipping Cost`, `Customer Segment`, `Product Category`, `Product Sub-Category`, SUM(Sales) AS `Total Sales`
FROM kms_staging
GROUP BY `Customer Name`, Discount, Province, Region,`Order Priority`, `Order Quantity`, `Ship Mode`, `Shipping Cost`, `Customer Segment`, `Product Category`, `Product Sub-Category`
ORDER BY `Total Sales` ASC
LIMIT 10;

----shipping method with the most shipping cost
SELECT `Ship Mode`, SUM(`Shipping Cost`) AS `Total Shipping Cost`
FROM kms_staging
GROUP BY `Ship Mode`
ORDER BY `Total Shipping Cost` DESC;

----most valuable customers, and what products or services do they typically purchase
SELECT `Customer Name`, `Product Category`, `Product Sub-Category`, SUM(Sales) AS `Total Sales`
FROM kms_staging
GROUP BY `Customer Name`, `Product Category`, `Product Sub-Category`
ORDER BY `Total Sales` DESC
LIMIT 20;

-----small business customer with the highest sales
SELECT `Customer Name`, `Customer Segment`, SUM(`Sales`) AS `Maximum Sales`
FROM kms_staging
WHERE `Customer Segment` = "Small Business"
GROUP BY `Customer Segment`, `Customer Name`
ORDER BY `Maximum Sales` DESC; 

----Corporate Customer who placed the most number of orders in 2009 – 2012
SELECT `Order Date`, `Customer Segment`, `Customer Name`, COUNT(`Order ID`) AS `Total Orders`
FROM kms_staging
WHERE `Customer Segment`= "corporate"
GROUP BY `Customer Segment`, `Order Date`, `Customer Name`
ORDER BY `Total Orders` DESC;

----the most profitable consumer customer
SELECT `Customer Name`, SUM(`Profit`) AS `Total Profit`
FROM kms_staging
WHERE `Customer Segment` = 'Consumer'
GROUP BY `Customer Name`
ORDER BY `Total Profit` DESC;

-----customer that returned items, and their segment
SELECT `Customer Name`, `Customer Segment`, Status FROM kms_staging k
LEFT JOIN order_status_staging o
ON o.`Order ID` = k.`Order ID`
WHERE Status = "Returned"
LIMIT 10;

---Shipping cost according to Order Priority
SELECT `Order Priority`, `Ship Mode`, COUNT(`Order ID`) AS `Total Order Count`,
ROUND(SUM(Sales - Profit), 2) AS `Estimated shipping Cost`,
DATEDIFF(`Ship Date`, `Order Date`) AS `Ship Days`
FROM kms_staging
GROUP BY `Order Priority`, `Ship Mode`, `Ship Days`
ORDER BY  `Estimated shipping Cost` DESC;