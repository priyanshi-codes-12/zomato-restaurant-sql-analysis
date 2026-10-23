# Zomato Bangalore Restaurant Analysis (SQL & Data Engineering)

An end-to-end data analysis project exploring market saturation, dining preferences, pricing structures, and top-performing outlets across 12,000+ restaurant listings in Bangalore using PostgreSQL and Python.

---

## 📌 Project Architecture & Pipeline
1. **Data Cleaning & Wrangling (Python/Pandas):** 
   - Handled non-standard null values, stripped text noise, and extracted numeric metrics (e.g., converting ratings from strings like `'4.1/5'` to numeric `FLOAT`).
   - Cleaned currency separators and resolved UTF-8/encoding artifacts in establishment names.
2. **Relational Ingestion (PostgreSQL):** 
   - Structured schema definition with primary types and loaded clean data into PostgreSQL using pgAdmin 4.
3. **Exploratory Data Analysis (SQL):** 
   - Formulated business questions targeting market density, delivery dynamics, tier classification, locality rankings, and individual cuisine performance.

---

## 🔍 Key Business Inquiries & Findings

### 1. Geographic Saturation & Pricing Sweet Spot
* **Insight:** Tech hubs lead city-wide dining infrastructure. Whitefield (824 outlets) and BTM Layout represent the highest restaurant concentration, with average dinner pricing hovering between ₹450 and ₹550.

### 2. Digital Channels: Online Ordering Impact
* **Insight:** Outlets offering online delivery generate **~47% more customer votes/reviews** compared to dine-in-only establishments, maintaining consistent customer satisfaction (~3.58 avg rating).

### 3. Price Tier Distribution
* **Insight:** The Bangalore food service market is heavily skewed toward affordability:
  * **Budget (< ₹400):** ~45% of market share.
  * **Mid-Range (₹401 - ₹800):** ~46% of market share.
  * **Premium (> ₹800):** Under 10% of total outlets.

### 4. Locality Leaders & Performance Ranking
* **Methodology:** Implemented `DENSE_RANK() OVER (PARTITION BY location ORDER BY rate DESC, votes DESC)` to surface top-rated outlets per major neighborhood (Whitefield, BTM, Indiranagar, HSR) while capping minimum review thresholds (votes $\ge 50$) to eliminate sampling bias.

### 5. Cuisine Saturation vs. High-Margin Opportunities
* **Methodology:** Handled multivalued attributes by breaking comma-separated cuisine lists into normalized rows via PostgreSQL's `LATERAL string_to_table()`.
* **Insight:**
  * **Red Ocean:** North Indian (4,923 listings) and Chinese (3,522 listings) dominate volume but plateau at ~3.55 average rating.
  * **High-Margin Niche:** Continental (avg cost ₹964, rating 3.89) and Specialty Cafes (avg cost ₹614, rating 3.82) show higher customer satisfaction and willingness to pay.

---

## 🛠️ Tech Stack & SQL Concepts Used
* **Database:** PostgreSQL (pgAdmin 4)
* **SQL Skills:** Common Table Expressions (CTEs), Window Functions (`DENSE_RANK`), Array/String Unnesting (`LATERAL string_to_table`), Conditional Bucketing (`CASE WHEN`), Data Aggregations & Grouping.
* **Pre-processing:** Python, Pandas.
