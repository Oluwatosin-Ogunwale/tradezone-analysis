# 🛒 TradeZone E-Commerce Performance Analysis
### Growth, Seller Operations & Conversion Intelligence
A comprehensive SQL-based analysis of a Nigerian e-commerce platform, focused on identifying growth opportunities, operational inefficiencies, and data quality issues to drive strategic decision-making.

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white) 
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=sql&logoColor=white)


**Prepared by:** Oluwatosin Ogunwale &nbsp;|&nbsp; **Period:** 2023 – 2024 &nbsp;|&nbsp;

---

## 📌 Table of Contents
## Table of Contents
- [Project Overview](#project-overview)
- [Business Context](#business-context)
- [Objectives](#objectives)
- [Tools & Methodology](#tools--methodology)
- [Key Finding 1 - Customer Conversion](#key-finding-1---customer-conversion)
- [Key Finding 2 - Volume-Driven Growth](#key-finding-2---volume-driven-growth)
- [Key Finding 3 - Revenue vs Speed Leaders](#key-finding-3---revenue-vs-speed-leaders)
- [Recommendations](#recommendations)
- [Data Quality Notes](#data-quality-notes)
- [What the Data Cannot Tell Us](#what-the-data-cannot-tell-us)
- [Conclusions](#conclusions)
- [Repository Structure](#repository-structure)

---

## Project Overview

This project is an independent analyst memo produced for **TradeZone**, a multi-city Nigerian e-commerce platform, covering performance data across **2023 and 2024**. The analysis was conducted to surface growth risks, operational inefficiencies, and data quality issues ahead of the **2025 planning cycle.**

### At a Glance

| | | | | | |
|---|---|---|---|---|---|
| **₦984.7M** | **5 Cities** | **11 Categories** | **280 Products** | **90 Sellers** | **425 Customers** |
| Total Revenue | Markets Served | Product Categories | All Active | All Active | New in 2024 |

---

## Business Context

TradeZone recorded impressive revenue growth from 2023 to 2024. However, beneath the headline numbers, the data revealed three structural concerns that required urgent attention before 2025 planning:

- A significant portion of newly acquired customers were not converting to first purchases quickly
- Revenue growth was being powered entirely by order volume with no secondary engine of higher spend or repeat purchases
- Seller performance was highly uneven, with speed and revenue excellence concentrated in almost entirely different seller groups

This memo was addressed to the **Head of Growth** and **Head of Seller Operations** as the two teams best positioned to act on the findings.

---

## Objectives

- ✅ Assess first-30-day customer conversion rates across all five states
- ✅ Understand the nature and sustainability of TradeZone's revenue growth
- ✅ Identify the relationship between seller fulfilment speed and revenue generation
- ✅ Document and transparently handle data quality issues affecting revenue integrity
- ✅ Deliver quantified, actionable recommendations with traceable data sources

---

## Tools & Methodology

| Tool / Technique | Purpose |
|-----------------|---------|
| SQL | Data extraction, conversion rate calculation, seller performance ranking, revenue aggregation |
| Analyst Memo Format | Structured business communication of findings to non-technical leadership |
| Data Quality Auditing | Identification, documentation, and transparent handling of NULL prices and order mismatches |

---

## Key Finding 1 - Customer Conversion

### First-30-Day Conversion Rates by State

New customer conversion within the first 30 days remains critically low across all five states — ranging from **31% in Kano to 49% in Lagos.**

| State | New Customers | Converted Within 30 Days | Conversion Rate |
|-------|--------------|--------------------------|-----------------|
| Lagos | 146 | 72 | 49.32% |
| FCT | 92 | 38 | 41.30% |
| Rivers | 66 | 28 | 42.42% |
| Oyo | 63 | 21 | 33.33% |
| Kano | 58 | 18 | 31.03% |
| **Total** | **425** | **177** | **41.65% avg** |

### What This Means

**51–69% of newly acquired customers are not making their first purchase within 30 days.** This suggests significant friction in onboarding, product discovery, or initial trust  particularly in Kano and Oyo where fewer than 1 in 3 new customers converts quickly.

### Business Impact of Fixing This

A **10 percentage point improvement** in the platform average conversion rate (from 41.65% to ~52%) across the 2024 cohort of 425 customers represents approximately **42 additional first purchases** and at the current average order value of ~₦250,000, that is approximately **₦10.5 million in incremental revenue** from customers already acquired.

> 💡 **This is recoverable revenue that requires no new customer acquisition spend.**

---

## Key Finding 2 - Volume-Driven Growth

### The Growth Numbers

| Period | Orders | Revenue | YoY Growth |
|--------|--------|---------|------------|
| Q1 2023 | 22 | - | Baseline |
| Q1 2024 | 342 | - | **+1,544%** |

Total revenue across 2023–2024: **₦984.7 million**
Average Order Value range: **₦250,000 - ₦360,000** (relatively stable)

### What This Means

TradeZone's growth is being driven almost entirely by **higher customer acquisition and order volume** not by customers spending more per order or returning to purchase again. The Average Order Value remained stable, meaning no meaningful upselling or premium positioning is working.

### Why This Is a Risk

This creates a **single-engine growth model.** If customer acquisition slows due to increased competition, rising marketing costs, or market saturation revenue growth will slow proportionally because there is currently:

- No repeat purchase engine
- No upselling behaviour in the data
- No evidence of increasing spend per customer over time

> ⚠️ **Impressive growth built on a fragile foundation. The platform needs a second engine.**

---

## Key Finding 3 - Revenue vs Speed Leaders

### The Overlap Problem

Only **3 sellers** appear in both the top 10 revenue list and the top 10 fastest fulfilment list:
- SportsCentral NG
- VogueNG
- WellnessHub NG

This means **7 of the top 10 revenue sellers are slow** and **7 of the top 10 fastest sellers are low revenue.**

### Ratings Tell the Real Story

| Group | Average Rating |
|-------|---------------|
| Top 10 Revenue Sellers | 4.0 or above |
| Fast Fulfilment Sellers (selected) | As low as 1.85 (GadgetKing NG) and 2.50 (AgriMart NG) |

### What This Means

Customers are tolerating longer delivery times from sellers who deliver quality. They are **not** rewarding fast-but-poor-quality sellers with repeat purchases or higher spend. **Speed alone does not drive revenue on the TradeZone platform.**

> 💡 **Quality drives revenue. Speed without quality is commercially worthless on this platform.**

---

##  Recommendations

### Recommendation 1 - Launch a 30-Day First Purchase Activation Programme

**Owner:** Head of Growth

**Action:** Design and deploy a structured onboarding sequence targeting all newly registered customers who have not made a purchase within **7 days of sign-up.** This should include:

- A time-limited first-purchase incentive (e.g. a ₦2,000 voucher valid for 14 days)
- Personalised product recommendations based on registration state
- A simplified product discovery experience on first login

**Expected Outcome (60–90 days):**
Increase 30-day conversion rate from **41.65% to at least 55%** - representing approximately **42 additional first purchases and ₦10.5 million in incremental revenue** at current average order value.

*Traceable to: Finding 1 - conversion rate data by state*

---

### Recommendation 2 - Introduce a Seller Performance Improvement Programme

**Owner:** Head of Seller Operations

**Action:**
- Identify all active sellers with an average customer rating **below 3.5**
- Initiate a structured improvement programme including a mandatory quality audit, coaching on listing accuracy and packaging standards, and a **90-day performance window** to reach a minimum 3.8 rating or face reduced platform visibility
- Benchmark the top 20 fastest fulfilment sellers and document their practices to share with high-revenue sellers as a speed improvement guide

**Expected Outcome (60–90 days):**
- Elimination of sub-3.0 rated sellers from high-visibility placements
- Measurable improvement in platform average rating
- Identification of at least **5 sellers who improve both fulfilment speed and rating** to qualify for a combined performance tier

*Traceable to: Finding 3 - seller revenue and fulfilment data*

---

## Data Quality Notes

> This section documents every data quality issue encountered, the decision made, and the risk if that decision was wrong. Transparency in data quality is non-negotiable in professional analysis.

### Issue 1 - Missing Product Prices (4 Products, 97 Order Items)

**What was found:** Four products (PROD0104, PROD0088, PROD0205, PROD0245) across the Home and Garden, Food and Beverages, and Books and Stationery categories had no `unit_price` recorded in the products table. These products were ordered, resulting in **97 order items with NULL unit prices and NULL line totals.**

**Decision:** Exclude unrecoverable NULL-price order items from all revenue calculations rather than imputing values, to avoid introducing inaccurate revenue figures.

**Risk if wrong:** If these 97 items had significant transaction values, total platform revenue and category-level revenue figures are **understated.** The true revenue impact cannot be quantified without the missing price data. A data entry audit of these four products is recommended.

---

### Issue 2 - Order Amount Mismatches (9.09% of Orders)

**What was found:** Approximately **9.09% of orders** showed a difference greater than ₦10 between the recorded `total_amount` in the orders table and the sum of line items in the order_items table.

**Decision:** Flag mismatched orders using an `amount_mismatch` column and retain them in the dataset, using `total_amount` as the authoritative revenue figure since it represents what was actually charged to the customer.

**Risk if wrong:** If `total_amount` was itself incorrectly recorded, revenue figures could be overstated or understated. A **reconciliation against the payments table** is recommended to validate which figure is authoritative before the 2025 planning cycle.

---

## What the Data Cannot Tell Us

Leadership is likely to ask: **Which marketing channels are driving the highest-quality customers — those who convert fastest and spend the most over time?**

The current dataset has **no acquisition channel data.** We know when a customer signed up and where they are located, but we cannot determine whether they came from paid social, organic search, referral, influencer promotion, or offline channels.

This means we cannot currently calculate:
- Channel-level customer acquisition cost
- Channel-level conversion rate
- Channel-level lifetime value

**Additional data requested:** A `customer_acquisition` table linking each `customer_id` to their source channel, campaign identifier, and acquisition cost. With this data, the recommendation in Finding 1 becomes significantly more targeted  budget can be redirected toward the channels producing the highest 30-day conversion rates rather than applying a blanket onboarding intervention.

---

## Conclusions

TradeZone enters 2025 with genuine commercial momentum — ₦984.7 million in revenue, 280 active products, 90 active sellers, and a Q1 2024 that delivered 1,544% year-over-year order growth. These are not small numbers for a multi-city Nigerian platform.

But this analysis exists precisely because impressive headline figures can mask structural problems that compound quietly until they become crises. Three such problems are now visible in the data.

The first is a conversion gap. More than half of all newly acquired customers in 2024 did not make a first purchase within 30 days. This is not a small inefficiency, it means the platform is paying to acquire customers it is then **failing to activate**. The ₦10.5 million in recoverable incremental revenue identified in this analysis is already paid for. It simply needs to be unlocked through better onboarding.

The second is a growth engine risk. Every naira of TradeZone's 2024 revenue growth came from more orders, not better orders. When a business grows only by acquiring more customers, it becomes entirely dependent on the continuation of that acquisition. There is no cushion. Building repeat purchase behaviour and upsell capability into the platform before acquisition growth plateaus is not optional, it is a strategic necessity.

The third is a seller quality imbalance. The fastest sellers are not the best sellers, and the best sellers are not the fastest. This gap has a ceiling, customers will eventually lose patience with slow delivery even from high-quality sellers, and fast-but-poor-quality sellers will never build the repeat purchase loyalty the platform needs. Closing this gap through the Seller Performance Improvement Programme is the most operationally achievable of the three recommendations and should be started immediately.

> **TradeZone does not have a growth problem. It has a growth quality problem. The platform is acquiring well but activating poorly, growing fast but not deeply, and serving customers quickly in some areas while failing them quietly in others. All three are fixable. This memo shows where to start.**

---

## Repository Structure

```
tradezone-analysis/
  ├── README.md                           ← You are here
  ├── data/
  │    └── tradezone_dataset.xlsx         ← Dataset used for analysis
  ├── Part 1.sql                          ← complete cleaning script
  ├── queries/
  │    └── tradezone_queries.sql          ← SQL queries used to answer business question
  ├── report/
  │    └── Analyst_Memo.pdf               ← Full analyst memo
  └── cleaned_dump.sql                   ← clean database backup
```

---
## How to Run

1. Restore `cleaned_dump.sql` into PostgreSQL
2. Run queries from the `queries/` folder

## Challenges & Solutions

- **Challenge**: Missing unit prices in 97 order items → **Solution**: Implemented category-median imputation with proper flagging for transparency.
- **Challenge**: Invalid review ratings → **Solution**: Created `invalid_rating` flag and excluded them from all calculations.
- **Challenge**: Date type inconsistencies → **Solution**: Added derived `payment_date_only` column while preserving original timestamp.

## 👤 About the Analyst

**Oluwatosin Ogunwale** — Data Analyst | SQL · Excel · Power BI | Tech & Finance

- 📧 oluwatosinogunwale35@gmail.com
- 💼 https://linkedin.com/in/oluwatosin-ogunwale
- 🐙 https://github.com/Oluwatosin-ogunwale
- 🌐 https://oluwatosin-ogunwale.github.io

---

*This project was produced as part of a personal data analytics portfolio. All findings and recommendations are based solely on the dataset provided and are intended to demonstrate analytical thinking, data quality awareness, and structured business communication.*
