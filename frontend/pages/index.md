# Malaysian Labour Market

Monthly employment data from the Department of Statistics Malaysia (DOSM).
```sql unemployment
SELECT * FROM openmalaysia.mart_unemployment_trend
ORDER BY date
```

<LineChart 
    data={unemployment} 
    x="month_label" 
    y={["unemployment_rate", "participation_rate", "unemployment_monthly_change"]}
    title="Rates (%)"
/>

<LineChart 
    data={unemployment} 
    x="month_label" 
    y={["labour_force", "unemployed_labour_force"]}
    title="Labour Force (thousands)"
/>

{#if unemployment.length > 0}
The unemployment rate as of **{unemployment[unemployment.length - 1].month_label}** is **{unemployment[unemployment.length - 1].unemployment_rate}%**.

{/if}
