# Diabetes in the Gulf states

How has the share of adults with diabetes changed in the six Gulf states, and how does it compare with Denmark and the world?

**[Open the dashboard](https://claude.ai/artifact/8fies82sCgNvs3SyNFgigX)**

## Findings

| Country | 2011 | 2024 | Change (pp) |
|---|---:|---:|---:|
| Kuwait | 20.7 % | 25.6 % | +4.9 |
| Qatar | 19.8 % | 24.6 % | +4.8 |
| Saudi Arabia | 19.6 % | 23.1 % | +3.5 |
| Bahrain | 19.5 % | 22.1 % | +2.6 |
| United Arab Emirates | 18.8 % | 20.7 % | +1.9 |
| Oman | 10.5 % | 17.0 % | +6.5 |
| World | 8.1 % | 10.8 % | +2.7 |
| Denmark | 5.6 % | 6.4 % | +0.8 |

- About one in four adults in Kuwait and Qatar has diabetes, roughly four times the Danish level.
- All six Gulf states rose between 2011 and 2024.
- Oman has the lowest level of the six but rose fastest. Looking only at 2024 would hide that.

## Data

[Diabetes prevalence](https://ourworldindata.org/grapher/diabetes-prevalence), Our World in Data, originally from the IDF Diabetes Atlas via the World Bank. The figure is the share of adults aged 20–79 with type 1 or type 2 diabetes, age-adjusted so countries with young and old populations can be compared.

## What I did

1. **Loaded** the CSV into a PostgreSQL table in Supabase, after shortening the column names.
2. **Checked the quality** with SQL and found 35 rows that should not be used: impossible 0 % values, identical 12.1 % values for several islands in 2000 (an estimate, not a measurement), and group rows such as "World" mixed in with countries.
3. **Caught an exception:** Kosovo is a real country, but its code starts with `OWID_` like the group rows. A blind rule would have removed it, so the clean data keeps it.
4. **Built a clean view** (`diabetes_clean`, 421 rows) and left the original table untouched, so every removal is documented in SQL.
5. **Analysed** 2011 against 2024 for the Gulf states, Denmark and the world.
6. **Built a dashboard.** A first draft in Looker Studio put the two years on separate axes, which made 2024 look lower than 2011. The final version uses one scale.

All queries are in [`analysis.sql`](analysis.sql).

## Limitations

- The source has only two years (2011 and 2024) for these countries, so this is a before/after comparison, not a yearly trend.
- National averages say nothing about differences within a country, for example between citizens and migrant workers.

## Files

| File | Contents |
|---|---|
| `analysis.sql` | Table creation, quality check, clean view and analysis |
| `diabetes_prevalence.csv` | The full source data (455 rows), with shortened column names |
| `diabetes_gulf_comparison.csv` | The 8 rows used in the dashboard |

## How I worked

I directed an AI assistant to help write the SQL and build the dashboard, and checked each result against the data myself.

**Tools:** PostgreSQL (Supabase), SQL
