# Verified queries of REALPLUS.GOLD.REALPLUS_BUSINESS

Written for Cortex Analyst: `FROM <logical table>` and logical column names. They are the reference logic for
the question; to run one, swap each logical table for its base view (catalog.md) and each logical name for its
`expr`, or ask the same thing through SEMANTIC_VIEW().

## active_inventory_by_borough

Q: How many sales and rentals are on the market by borough?

```sql
SELECT borough, listing_type, COUNT_IF(is_on_market) AS active_listings FROM listings WHERE is_on_market GROUP BY borough, listing_type ORDER BY active_listings DESC
```

## median_rent_by_bedrooms_manhattan

Q: What is the median asking rent by bedrooms in Manhattan?

```sql
SELECT bedroom_band, MEDIAN(asking_price) AS median_asking_rent FROM listings WHERE is_on_market AND listing_type = 'Rental' AND borough = 'Manhattan' AND asking_price BETWEEN 500 AND 100000 GROUP BY bedroom_band ORDER BY bedroom_band
```

## closed_sales_by_month

Q: How many sales closed per month in 2025 and at what median price?

```sql
SELECT closing_month, COUNT(*) AS closed_deals, MEDIAN(CASE WHEN closing_price > 0 AND NOT is_non_market_sale AND NOT is_bulk_building_sale THEN closing_price END) AS median_closing_price FROM listings WHERE status = 'Closed' AND listing_type = 'Sale' AND closing_year = 2025 GROUP BY closing_month ORDER BY closing_month
```

## price_cuts_by_month

Q: How many price cuts were there per month and how big were they?

```sql
SELECT change_month, change, COUNT(*) AS price_cuts, MEDIAN(CASE WHEN change_pct < 0 THEN change_pct END) AS median_cut_pct FROM price_changes WHERE NOT is_repeat AND change IN ('Price cut', 'Rent cut') AND change_month IS NOT NULL GROUP BY change_month, change ORDER BY change_month
```

## agents_by_company

Q: How many agents does each brokerage company have?

```sql
SELECT company_name, COUNT(agent_id) AS agents FROM agents WHERE NOT is_deleted GROUP BY company_name ORDER BY agents DESC
```

## most_viewed_listings_portal

Q: Which listings were viewed most in the customer portal?

```sql
SELECT l.listing_id, l.address, l.unit, l.neighborhood, l.listing_type, SUM(e.views) AS portal_views FROM listing_engagement AS e LEFT JOIN listings AS l ON e.listing_id = l.listing_id GROUP BY l.listing_id, l.address, l.unit, l.neighborhood, l.listing_type ORDER BY portal_views DESC LIMIT 20
```

## top_sales_near_brooklyn_supreme_court

Q: Show the 10 most expensive sales on the market near the Brooklyn Supreme Court

```sql
SELECT l.address, l.unit, l.neighborhood, l.bedrooms, MAX(l.asking_price) AS asking_price, MIN(n.place_name) AS place_name, MIN(n.distance_m) AS distance_m, MIN(n.walk_minutes) AS walk_minutes FROM nearby_places AS n JOIN listings AS l ON n.listing_id = l.listing_id WHERE n.place_category = 'Courthouse' AND n.place_name ILIKE '%Supreme And Surrogate%' AND l.is_on_market AND l.listing_type = 'Sale' AND l.asking_price BETWEEN 10000 AND 200000000 GROUP BY l.address, l.unit, l.neighborhood, l.bedrooms ORDER BY asking_price DESC LIMIT 10
```

## rent_by_subway_walk_brooklyn

Q: What is the median asking rent for 2BR in Brooklyn within 5 minutes walk of the subway versus farther?

```sql
SELECT CASE WHEN ll.nearest_subway_walk_minutes <= 5 THEN '5 min or less' ELSE 'more than 5 min or no station within 1 km' END AS subway_walk, COUNT(*) AS active_listings, MEDIAN(l.asking_price) AS median_asking_rent FROM listings AS l JOIN listing_locations AS ll ON l.listing_id = ll.listing_id WHERE l.is_on_market AND l.listing_type = 'Rental' AND l.bedrooms = 2 AND l.borough = 'Brooklyn' AND l.asking_price BETWEEN 500 AND 100000 GROUP BY subway_walk ORDER BY subway_walk
```

## closed_sales_near_subway_station

Q: How many sales closed in 2025 within 10 minutes walk of the Bedford Av station and at what median price?

```sql
SELECT COUNT(DISTINCT n.listing_id) AS closed_deals, MEDIAN(CASE WHEN l.closing_price > 0 AND NOT l.is_non_market_sale AND NOT l.is_bulk_building_sale THEN l.closing_price END) AS median_closing_price FROM nearby_places AS n JOIN listings AS l ON n.listing_id = l.listing_id WHERE n.place_category = 'Subway station' AND n.place_name ILIKE 'Bedford Av%' AND n.walk_minutes <= 10 AND l.status = 'Closed' AND l.listing_type = 'Sale' AND l.closing_year = 2025
```
