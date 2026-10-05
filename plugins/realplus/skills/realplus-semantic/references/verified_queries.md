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
