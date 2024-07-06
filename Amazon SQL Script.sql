use Sales;
select * from Amazon;

-- adding the month column
-- the month column store the month name on which the purchase is made.

alter table Amazon
add column monthname varchar(50);

update Amazon
set monthname=monthname(date);

 -- adding Time of Day Column 
 
 alter table Amazon
 add column timeofday varchar(50);
 
 update Amazon
 set timeofday =
 case
 when time between 5 and 11 then 'Morning'
 when time between 12 and 16 then 'Afternoon'
 when time between 17 and 20 then 'Evening'
 else 'Night'
 end;
 
 -- adding Day Column
 
 alter table Amazon
 add column dayname varchar(30);
 
 update Amazon
 set dayname=dayname(date);

-- Exploratary data Analysis

-- 1. Count of distinct cities in the dataset
select count(distinct city) from Amazon;

-- 2. Corresponding Branch and City
select branch,city from Amazon
group by branch,city
order by branch;

-- 3. count of distinct product lines
select count('Product line') as Product_line_count
from Amazon;

-- 4. payment method occurs most frequently

select Payment,count(*)as frequency
from Amazon
group by Payment
order by frequency desc
limit 1;

-- 5. Product line with highest sales 

select 'Product line', sum(Total) as TotalSales
from Amazon
group by 'Product line'
order by TotalSales desc
limit 1; 

-- 6. Revenue generated each month

select monthname,SUM(Total) AS Revenue
from (
    SELECT SUBSTRING(Date, INSTR(Date, '-') + 1) AS monthname,Total
    FROM Amazon
) AS MonthlyRevenue
GROUP BY monthname
ORDER BY STR_TO_DATE(CONCAT('01-', monthname), '%d-%M') ASC;

-- 7. Month with the peak cost of goods sold (COGS)

select monthname,MAX(TotalCOGS) AS PeakCOGS
from (
    SELECT 
        SUBSTRING(Date, INSTR(Date, '-') + 1) AS monthname,
        SUM(cogs) AS TotalCOGS
    FROM Amazon
    GROUP BY monthname
) AS MonthlyCOGS
GROUP BY monthname
ORDER BY PeakCOGS DESC
LIMIT 1;

-- 8. Product line generating the highest revenue

select 'Product line', sum(Total) as TotalRevenue
from Amazon
group by 'Product line'
order by TotalRevenue desc
limit 1;

-- 9. City with the highest revenue

select City, sum(Total) as TotalRevenue
from Amazon
group by City
order by TotalRevenue desc
limit 1;

-- 10. Product line with the highest Value Added Tax (VAT)

select 'Product line', sum(`Tax 5%`) as TotalVAT
from Amazon
group by 'Product line'
order by TotalVAT desc
limit 1;

-- 11. Sales categorization for each product line as "Good" or "Bad" based on sales performance

select 'Product line', 
case when Total > (select avg(Total) from Amazon) then 'Good' else 'bad' end as SalesPerson
from Amazon;

-- 12. Branch exceeding the average number of products sold

select branch
from (
select branch, avg(quantity) as AvgQuantity
from Amazon
group by branch
) as AvgQuantityByBranch
where AvgQuantity > (select avg(quantity) from Amazon);

-- 13. Most frequently associated product line for each gender

select Gender, 'Product line', count(*) as frequency
from Amazon
group by Gender, 'Product line'
order by frequency desc;

-- 14. Average rating for each product line

select 'Product line', avg(rating) as AvgRating
from Amazon
group by 'Product line';

-- 15. Sales occurrences for each time of day on every weekday

SELECT dayname, timeofday, COUNT(*) AS sales_occurrences
FROM Amazon
GROUP BY dayname, timeofday
ORDER BY FIELD(dayname, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),timeofday;

-- 16. Customer type contributing the highest revenue

SELECT 'Customer type', SUM(Total) AS TotalRevenue
FROM Amazon
GROUP BY 'Customer type'
ORDER BY TotalRevenue DESC
LIMIT 1;

-- 17. City with the highest VAT percentage

SELECT City, SUM(`Tax 5%`) / SUM(cogs) * 100 AS VATPercentage
FROM Amazon
GROUP BY City
ORDER BY VATPercentage DESC
LIMIT 1;

-- 18. Customer type with the highest VAT payments

SELECT 'Customer type', SUM(`Tax 5%`) AS TotalVAT
FROM Amazon
GROUP BY 'Customer type'
ORDER BY TotalVAT DESC
LIMIT 1;

-- 19. Count of distinct customer types

SELECT COUNT(DISTINCT 'Customer type') AS DistinctCustomerTypes
FROM Amazon;

-- 20. Count of distinct payment methods

SELECT COUNT(DISTINCT Payment) AS DistinctPaymentMethods
FROM Amazon;

-- 21. Most frequent customer type

SELECT 'Customer type', COUNT(*) AS Frequency
FROM Amazon
GROUP BY 'Customer type'
ORDER BY Frequency DESC
LIMIT 1;

-- 22. Customer type with the highest purchase frequency

SELECT 'Customer type', COUNT(*) AS PurchaseFrequency
FROM Amazon
GROUP BY 'Customer type'
ORDER BY PurchaseFrequency DESC
LIMIT 1;

-- 23. Predominant gender among customers

SELECT Gender, COUNT(*) AS Frequency
FROM Amazon
GROUP BY Gender
ORDER BY Frequency DESC
LIMIT 1;

-- 24. Distribution of genders within each branch

SELECT Branch, Gender, COUNT(*) AS Frequency
FROM Amazon
GROUP BY Branch, Gender
ORDER BY Branch, Frequency DESC;

-- 25. the time of day when customers provide the most ratings.

SELECT timeofday, COUNT(*) AS rating_count
FROM Amazon
GROUP BY timeofday
ORDER BY rating_count DESC
LIMIT 1;

-- 26. the time of day with the highest customer ratings for each branch.

SELECT Branch, timeofday, AVG(Rating) AS avg_rating
FROM Amazon
GROUP BY Branch, timeofday
ORDER BY avg_rating DESC
LIMIT 1;

-- 27. the day of the week with the highest average ratings.

SELECT dayname, AVG(Rating) AS avg_rating
FROM Amazon
GROUP BY dayname
ORDER BY avg_rating DESC
LIMIT 1;

-- 28. the day of the week with the highest average ratings for each branch.

SELECT Branch, dayname, AVG(Rating) AS avg_rating
FROM Amazon
GROUP BY Branch, dayname
ORDER BY avg_rating DESC
LIMIT 1;




