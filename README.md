# Superstore Sales Analytics: Requirements to Dashboard

**Key insight:** discounts above 20% are 14% of order lines but lose about 135K, and capping them could add up to 219K in profit (best case).

An end-to-end analytics project: business requirements, SQL analysis and an interactive Power BI dashboard, built to find where a retail store loses money.

![Dashboard](dashboard_screenshot%20%282%29.png)

## Business problem
A sales head wants to know which products lose money and whether discounting is hurting profit. Reports were built manually in Excel, which is slow and hard to repeat.

## Dataset
Sample Superstore (Kaggle): 9,994 order lines with Sales, Quantity, Discount and Profit.

## Tools
- SQL (SQLite, DB Browser for SQLite): CTEs, CASE, aggregations, window functions
- Power BI Desktop: data cleaning in Power Query, calculated columns (Discount Band, Year Month), a profit margin measure, KPI cards, charts, a monthly sales and profit trend, a Region slicer and a key insights panel
- Requirements documentation: business requirements, user stories, acceptance criteria

## What I did
1. Wrote a Business Requirements Document with 15 requirements and 4 user stories (`requirements_doc.pdf`).
2. Loaded the data into SQLite and checked Sales, Profit and Discount for missing values.
3. Ran SQL analysis on profit by sub-category, profit by discount band and a what-if discount cap (`queries.sql`).
4. Cleaned the data in Power Query (fixed date formats, set number types) and built the Power BI dashboard.
5. Added a profit margin KPI, a monthly trend chart, a Region filter and a consistent colour scheme, with red used only for losses.
6. Checked that the dashboard figures match the SQL results.

## Key findings
- Total sales are about 2.30M and total profit is about 286.4K (profit margin 12.5%).
- Three sub-categories lose money: Tables (-17,725), Bookcases (-3,473) and Supplies (-1,189), a combined loss of about 22.4K.
- Profit falls as discounts rise:

| Discount band | Order lines | Profit | Margin |
|---|---|---|---|
| 0% | 4,798 | +320,988 | 29.5% |
| 1-20% | 3,803 | +100,785 | 11.9% |
| 21-40% | 460 | -35,817 | -15.3% |
| 40%+ | 933 | -99,559 | -77.4% |

- Order lines with discounts above 20% are about 14% of all lines (1,393 of 9,994) but produce a combined loss of about 135K.
- What-if estimate: capping discounts at 20% would raise profit from 286,397 to about 505,588 (+219,191, or 76.5%) if customers buy the same quantity. This is a best-case estimate, because some customers may buy less at higher prices.
- Supplies loses money at a low average discount (7.7%), so discounting alone does not explain every loss.

## Checks

**Is it just product mix?** No. Inside every category, order lines with discounts above 20% have a much lower margin than lines with discounts of 20% or less (margin = profit / sales):

| Category | Discount 20% or less | Discount above 20% | Gap (points) |
|---|---|---|---|
| Furniture | 13.3% | -27.9% | -41.2 |
| Office Supplies | 25.0% | -119.3% | -144.3 |
| Technology | 25.3% | -26.4% | -51.7 |

**Is the gap real?** The overall margin gap between deep and normal discounts is -59.1 points (95% bootstrap confidence interval -66.6 to -53.0, 1,000 resamples).

**Limit:** this shows an association. Discounts may go to products or customers that were already weak, and the data cannot show why.

## What-if range

The 1,393 order lines with discounts above 20% lose 135,376 today. The cap is modelled by selling them at 20% off a list price back-calculated as Sales / (1 - Discount), with cost scaling with volume.

| Share of volume lost on these lines | Profit change |
|---|---|
| 0% (same volume) | +219,191 |
| 25% | +198,237 |
| 50% | +177,284 |
| 100% (lines not sold at all) | +135,376 |

Profit rises in each of these scenarios because the lines lose money overall. The model ignores other items in the same orders, and it is an estimate, not a measured result. A pilot would test it.

## Recommendation
Cap discounts at 20% unless a manager approves an exception, and review pricing for Tables and Bookcases first. Supplies needs a separate cost and pricing review.

## Files
| File | Description |
|---|---|
| `requirements_doc.pdf` | Business Requirements Document with user stories |
| `queries.sql` | SQL queries used in the analysis |
| `Superstore.pbix` | Power BI dashboard file |
| `dashboard_screenshot (2).png` | Screenshot of the dashboard |

## Author
Swati Pandita | [LinkedIn](https://www.linkedin.com/in/swati-pandita-315b83342)
