---
hide_queries: true
---

# Malaysian Labour Market

Monthly employment data from the Department of Statistics Malaysia (DOSM).
```sql unemployment
SELECT 
    date,
    unemployment_rate,
    participation_rate,
    unemployed_labour_force,
    labour_force,
    unemployment_monthly_change
FROM openmalaysia.mart_unemployment_trend
ORDER BY date ASC
```

<LineChart 
    data={unemployment} 
    x="date" 
    y={["unemployment_rate", "participation_rate", "unemployment_monthly_change"]}
    title="Rates (%)"
    sort="true"
    yAxisTitle="Rate"
    xAxisTitle="Date"
/>

<LineChart 
    data={unemployment} 
    x="date" 
    y={["labour_force", "unemployed_labour_force"]}
    title="Labour Force (thousands)"
    sort="true"
    yAxisTitle="Thousands"
    xAxisTitle="Date"
/>

{#if unemployment.length > 0}
The unemployment rate as of **{unemployment[unemployment.length - 1].month_label}** is **{unemployment[unemployment.length - 1].unemployment_rate}%**.

{/if}
