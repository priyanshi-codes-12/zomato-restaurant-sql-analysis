DROP TABLE IF EXISTS restaurants;

CREATE TABLE restaurants (
    name TEXT,
    online_order VARCHAR(10),
    book_table VARCHAR(10),
    rate NUMERIC(3, 1),
    votes INT,
    location TEXT,
    rest_type TEXT,
    cuisines TEXT,
    cost_for_two NUMERIC(10, 2),
    listed_in_type TEXT,
    listed_in_city TEXT
);
SELECT * FROM restaurants LIMIT 10;

-- 1 Location-wise Outlets, Average Rating & Cost
SELECT location, COUNT(*) AS total_rest_in_location, ROUND(AVG(cost_for_two),2) as avg_cost_two_in_location FROM restaurants
GROUP BY location
ORDER BY total_rest_in_location DESC
LIMIT 10;

-- 2 Channel Impact: Online Order vs Direct Dining
SELECT online_order, COUNT(*) AS total_restaurants,
    ROUND(AVG(rate), 2) AS avg_rating,
    ROUND(AVG(votes), 0) AS avg_votes
FROM restaurants
GROUP BY online_order;

-- 3 Price Segment Categorization (CASE WHEN)
SELECT 
    CASE 
        WHEN cost_for_two < 400 THEN 'Budget (< 400)'
        WHEN cost_for_two BETWEEN 400 AND 800 THEN 'Mid-Range (400-800)'
        WHEN cost_for_two > 800 THEN 'Premium (> 800)'
        ELSE 'Unspecified'
    END AS price_segment,
    COUNT(*) AS total_restaurants,
    ROUND(AVG(rate), 2) AS avg_rating
FROM restaurants
WHERE cost_for_two IS NOT NULL
GROUP BY 
    CASE 
        WHEN cost_for_two < 400 THEN 'Budget (< 400)'
        WHEN cost_for_two BETWEEN 400 AND 800 THEN 'Mid-Range (400-800)'
        WHEN cost_for_two > 800 THEN 'Premium (> 800)'
        ELSE 'Unspecified'
    END
ORDER BY total_restaurants DESC;

-- 4.1
SELECT 
        name,
        location,
        rate,
        votes,
        cost_for_two,
        DENSE_RANK() OVER (
            PARTITION BY location 
            ORDER BY rate DESC, votes DESC -- High rating first, then lowest votes
        ) AS gem_rank
    FROM restaurants
    WHERE rate IS NOT NULL 
      AND votes BETWEEN 50 AND 300;
	  
-- 4 Top Rated per Tech-Hub (Window Functions & DENSE_RANK)
WITH hidden_gems AS (
    SELECT 
        name,
        location,
        rate,
        votes,
        cost_for_two,
        DENSE_RANK() OVER (
            PARTITION BY location 
            ORDER BY rate DESC, votes ASC
        ) AS gem_rank
    FROM restaurants
    WHERE rate IS NOT NULL 
      AND votes BETWEEN 50 AND 300
)
SELECT 
    location,
    gem_rank,
    name,
    rate,
    votes,
    cost_for_two
FROM hidden_gems
WHERE gem_rank <= 3
  AND location IN ('Whitefield', 'BTM', 'Indiranagar', 'HSR')
ORDER BY location, gem_rank;


-- 5 Cuisine Saturation & Opportunity (String Unnesting)

WITH individual_cuisines AS (
    SELECT 
        TRIM(cuisine) AS single_cuisine,
        rate,
        cost_for_two
    FROM restaurants,
    LATERAL string_to_table(cuisines, ',') AS cuisine
    WHERE cuisines IS NOT NULL
)
SELECT 
    single_cuisine,
    COUNT(*) AS total_outlets,
    ROUND(AVG(rate), 2) AS avg_rating,
    ROUND(AVG(cost_for_two), 2) AS avg_cost
FROM individual_cuisines
WHERE single_cuisine <> ''
GROUP BY single_cuisine
ORDER BY total_outlets DESC
LIMIT 10;