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

## Why a 20% cap?

Margin by exact discount level (margin = profit / sales):

| Discount | Order lines | Margin |
|---|---|---|
| 0% | 4,798 | 30.0% |
| 10% | 94 | 17.0% |
| 15% | 52 | 5.0% |
| 20% | 3,657 | 12.0% |
| 30% | 227 | -10.0% |
| 32% | 27 | -16.0% |
| 40% | 206 | -20.0% |
| 45% | 11 | -46.0% |
| 50% | 66 | -35.0% |
| 60% | 138 | -90.0% |
| 70% | 418 | -99.0% |
| 80% | 300 | -180.0% |

20% is the highest discount level where order lines still earn a margin (12.0% across 3,657 lines, 37% of all lines). Every level from 30% up loses money. The data has no discount levels between 20% and 30%, so 20% is the highest level observed to be profitable, not a precisely estimated break-even.

## Where the deep-discount loss sits

The eight worst sub-categories among the 1,393 order lines with discounts above 20%:

| Sub-category | Deep-discount lines | Profit | Share of net loss |
|---|---|---|---|
| Binders | 613 | -38,510 | 28% |
| Tables | 176 | -30,698 | 23% |
| Machines | 53 | -29,555 | 22% |
| Bookcases | 70 | -11,098 | 8% |
| Appliances | 67 | -8,630 | 6% |
| Chairs | 158 | -6,737 | 5% |
| Phones | 109 | -6,386 | 5% |
| Furnishings | 138 | -5,945 | 4% |

Binders, Tables and Machines hold about 73% of the net loss from deep discounts. Only 32 of the 1,393 deep-discount lines (2%) made a profit, worth 3,139 in total, so a blanket cap gives up very little.

## Recommendation
Cap discounts at 20% unless a manager approves an exception. Start with Binders, Tables and Machines, which hold about 73% of the loss from deep discounts. Review Supplies pricing separately.

## Next step: test the cap before rolling it out

The what-if range is an estimate. To measure the real effect, pilot the cap in one region for 8 weeks and compare it with a similar region left unchanged.
- **Success measure:** profit per order.
- **Guardrails:** number of orders, average order size and customer return rate. If orders fall by more than the what-if range allows, stop the pilot.
- **Exceptions:** only 2% of deep-discount lines made a profit, so exceptions should be rare and cheap to review.

## Files
| File | Description |
|---|---|
| `requirements_doc.pdf` | Business Requirements Document with user stories |
| `queries.sql` | SQL queries used in the analysis |
| `Superstore.pbix` | Power BI dashboard file |
| `dashboard_screenshot (2).png` | Screenshot of the dashboard |

## Author
Swati Pandita | [LinkedIn](https://www.linkedin.com/in/swati-pandita-315b83342)
