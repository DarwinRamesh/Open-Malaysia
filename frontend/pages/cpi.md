# Malaysian CPI Headline

Monthly data CPI ( Consumer Price Index ) for the 13 main groups of goods and services.
```sql cpi
SELECT 
    date, 
    division, 
    index 
FROM openmalaysia.mart_cpi_headline
ORDER BY date ASC
```

<LineChart 
    data={cpi} 
    x=date 
    y=index 
    series=division 
/>