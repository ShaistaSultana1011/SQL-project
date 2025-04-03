SELECT * FROM projectcapstone.amazon;

select * from projectcapstone.amazon
where 
`Invoice ID`  is  null
or 
Branch is   null
or
City is  null
or 
`Customer type` is null
or
Gender is   null
or
`Product line` is null
or
`Unit price` is  null
or
Quantity is  null
or
`Tax 5%` is  null
or
Total is  null
or
 Date is  null
 or
 Time is  null
 or
 payment is null
 or
 cogs is  null
 or
`gross margin percentage` is  null
 or
`gross income` is  null
or 
Rating is null;

ALTER TABLE projectcapstone.amazon
ADD COLUMN timeofday VARCHAR(20);

UPDATE projectcapstone.amazon
SET timeofday = CASE
    WHEN HOUR(Time) BETWEEN 0 AND 11 THEN 'Morning'
    WHEN HOUR(Time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN HOUR(Time) BETWEEN 18 AND 23 THEN 'Evening'
    ELSE 'Unknown'
END;

ALTER TABLE projectcapstone.amazon
ADD COLUMN dayname VARCHAR(3);

UPDATE projectcapstone.amazon
SET dayname = CASE
    WHEN DAYOFWEEK(Date) = 1 THEN 'Sun'
    WHEN DAYOFWEEK(Date) = 2 THEN 'Mon'
    WHEN DAYOFWEEK(Date) = 3 THEN 'Tue'
    WHEN DAYOFWEEK(Date) = 4 THEN 'Wed'
    WHEN DAYOFWEEK(Date) = 5 THEN 'Thu'
    WHEN DAYOFWEEK(Date) = 6 THEN 'Fri'
    WHEN DAYOFWEEK(Date) = 7 THEN 'Sat'
    ELSE 'Unknown'
END;

ALTER TABLE projectcapstone.amazon
ADD COLUMN monthname VARCHAR(3);

UPDATE projectcapstone.amazon
SET monthname = CASE
    WHEN MONTH(Date) = 1 THEN 'Jan'
    WHEN MONTH(Date) = 2 THEN 'Feb'
    WHEN MONTH(Date) = 3 THEN 'Mar'
    WHEN MONTH(Date) = 4 THEN 'Apr'
    WHEN MONTH(Date) = 5 THEN 'May'
    WHEN MONTH(Date) = 6 THEN 'Jun'
    WHEN MONTH(Date) = 7 THEN 'Jul'
    WHEN MONTH(Date) = 8 THEN 'Aug'
    WHEN MONTH(Date) = 9 THEN 'Sep'
    WHEN MONTH(Date) = 10 THEN 'Oct'
    WHEN MONTH(Date) = 11 THEN 'Nov'
    WHEN MONTH(Date) = 12 THEN 'Dec'
    ELSE 'Unknown'
END;

#Q1.What is the count of distinct cities in the dataset?

SELECT COUNT(DISTINCT City) AS distinct_city_count
FROM projectcapstone.amazon;

#Q2.For each branch, what is the corresponding city?

SELECT Branch, City
FROM projectcapstone.amazon
GROUP BY Branch, City;

#Q3.What is the count of distinct product lines in the dataset?

SELECT COUNT(DISTINCT `Product line`) AS distinct_product_line_count
FROM projectcapstone.amazon;

#Q4.Which payment method occurs most frequently?
SELECT payment, COUNT(*) AS frequency
FROM projectcapstone.amazon
GROUP BY payment
ORDER BY frequency DESC
LIMIT 1;

#Q5.Which product line has the highest sales?
SELECT `Product line`, SUM(Total) AS total_sales
FROM projectcapstone.amazon
GROUP BY `Product line`
ORDER BY total_sales DESC
LIMIT 1;


#Q6.How much revenue is generated each month?
SELECT monthname, SUM(Total) AS total_revenue
FROM projectcapstone.amazon
GROUP BY monthname
ORDER BY monthname;

#Q7.In which month did the cost of goods sold reach its peak?
SELECT monthname, SUM(cogs) AS total_cogs
FROM projectcapstone.amazon
GROUP BY monthname
ORDER BY total_cogs DESC
LIMIT 1;


#Q8.Which product line generated the highest revenue?
SELECT `Product line`, SUM(Total) AS total_revenue
FROM projectcapstone.amazon
GROUP BY `Product line`
ORDER BY total_revenue DESC
LIMIT 1;

#Q9.In which city was the highest revenue recorded?
SELECT City, SUM(Total) AS total_revenue
FROM projectcapstone.amazon
GROUP BY City
ORDER BY total_revenue DESC
LIMIT 1;

#Q10.Which product line incurred the highest Value Added Tax?

SELECT `Product line`, SUM(`tax 5%`) AS total_vat
FROM projectcapstone.amazon
GROUP BY `Product line`
ORDER BY total_vat DESC
LIMIT 1;



#Q11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
ALTER TABLE projectcapstone.amazon
ADD COLUMN sales_status VARCHAR(4);

SELECT 
    `Product line`,
    SUM(Total) AS total_sales,
    CASE 
        WHEN SUM(Total) > (SELECT AVG(Total) FROM projectcapstone.amazon) THEN 'Good'
        ELSE 'Bad'
    END AS sales_performance
FROM projectcapstone.amazon
GROUP BY `Product line`;


#Q12.Identify the branch that exceeded the average number of products sold.

SELECT Branch, SUM(Quantity) AS total_quantity_sold
FROM projectcapstone.amazon
GROUP BY Branch
HAVING SUM(Quantity) > (
    SELECT AVG(Quantity)
    FROM projectcapstone.amazon
);



#Q13.Which product line is most frequently associated with each gender?
SELECT Gender, `Product line`, COUNT(*) AS frequency
FROM projectcapstone.amazon
GROUP BY Gender, `Product line`
ORDER BY Gender, frequency DESC;


#Q14.Calculate the average rating for each product line.
SELECT `Product line`, AVG(Rating) AS average_rating
FROM projectcapstone.amazon
GROUP BY `Product line`;


#Q15.Count the sales occurrences for each time of day on every weekday.
SELECT 
    DAYNAME(Date) AS day_of_week,
    CASE
        WHEN HOUR(Time) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN HOUR(Time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(Time) BETWEEN 18 AND 23 THEN 'Evening'
    END AS time_of_day,
    COUNT(*) AS sales_occurrences
FROM projectcapstone.amazon
GROUP BY day_of_week, time_of_day
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
         FIELD(time_of_day, 'Morning', 'Afternoon', 'Evening');

	

#Q16.Identify the customer type contributing the highest revenue.
SELECT `Customer type`, SUM(Total) AS total_revenue
FROM projectcapstone.amazon
GROUP BY `Customer type`
ORDER BY total_revenue DESC
LIMIT 1;

#Q17.Determine the city with the highest VAT percentage.
SELECT City, MAX(`tax 5%`) AS highest_vat_percentage
FROM projectcapstone.amazon
GROUP BY City
ORDER BY highest_vat_percentage DESC
LIMIT 1;


#Q18.Identify the customer type with the highest VAT payments.
SELECT `Customer type`, SUM(`tax 5%`) AS total_vat_payments
FROM projectcapstone.amazon
GROUP BY `Customer type`
ORDER BY total_vat_payments DESC
LIMIT 1;




#Q19.What is the count of distinct customer types in the dataset?
SELECT COUNT(DISTINCT `Customer type`) AS distinct_customer_types
FROM projectcapstone.amazon;



#Q20.What is the count of distinct payment methods in the dataset?
SELECT COUNT(DISTINCT payment) AS distinct_payment_methods
FROM projectcapstone.amazon;



#Q21.Which customer type occurs most frequently?
SELECT `Customer type`, COUNT(*) AS frequency
FROM projectcapstone.amazon
GROUP BY `Customer type`
ORDER BY frequency DESC
LIMIT 1;



#Q22.Identify the customer type with the highest purchase frequency.
SELECT `Customer type`, COUNT(*) AS purchase_frequency
FROM projectcapstone.amazon
GROUP BY `Customer type`
ORDER BY purchase_frequency DESC
LIMIT 1;


#Q23.Determine the predominant gender among customers.

SELECT Gender, COUNT(*) AS gender_frequency
FROM projectcapstone.amazon
GROUP BY Gender
ORDER BY gender_frequency DESC
LIMIT 1;



#Q24.Examine the distribution of genders within each branch.

SELECT Branch, Gender, COUNT(*) AS gender_distribution
FROM projectcapstone.amazon
GROUP BY Branch, Gender
ORDER BY Branch, gender_distribution DESC;



#Q25.Identify the time of day when customers provide the most ratings.
SELECT 
    CASE
        WHEN HOUR(Time) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN HOUR(Time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(Time) BETWEEN 18 AND 23 THEN 'Evening'
    END AS time_of_day,
    COUNT(Rating) AS ratings_count
FROM projectcapstone.amazon
WHERE Rating IS NOT NULL
GROUP BY time_of_day
ORDER BY ratings_count DESC
LIMIT 1;



#Q26.Determine the time of day with the highest customer ratings for each branch
WITH Branch_Rating_Count AS (
    SELECT 
        Branch,
        CASE
            WHEN HOUR(Time) BETWEEN 0 AND 11 THEN 'Morning'
            WHEN HOUR(Time) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN HOUR(Time) BETWEEN 18 AND 23 THEN 'Evening'
        END AS time_of_day,
        COUNT(Rating) AS ratings_count,
        ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY COUNT(Rating) DESC) AS row_num
    FROM projectcapstone.amazon
    WHERE Rating IS NOT NULL
    GROUP BY Branch, time_of_day
)
SELECT Branch, time_of_day, ratings_count
FROM Branch_Rating_Count
WHERE row_num = 1;



#Q27.Identify the day of the week with the highest average ratings.
SELECT 
    DAYNAME(Date) AS day_of_week,
    AVG(Rating) AS average_rating
FROM projectcapstone.amazon
WHERE Rating IS NOT NULL
GROUP BY day_of_week
ORDER BY average_rating DESC
LIMIT 1;


#Q28.Determine the day of the week with the highest average ratings for each branch.

WITH Branch_Day_Rating AS (
    SELECT 
        Branch,
        DAYNAME(Date) AS day_of_week,
        AVG(Rating) AS average_rating,
        ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY AVG(Rating) DESC) AS row_num
    FROM projectcapstone.amazon
    WHERE Rating IS NOT NULL
    GROUP BY Branch, day_of_week
)
SELECT Branch, day_of_week, average_rating
FROM Branch_Day_Rating
WHERE row_num = 1;
























